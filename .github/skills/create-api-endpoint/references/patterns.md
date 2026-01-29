# API Endpoint Patterns

Detailed code templates and best practices for creating REST API endpoints with Express, TypeScript, and Zod.

---

## Validation Schema Pattern

```typescript
// src/schemas/user.schema.ts
import { z } from 'zod';

// Request body schema
export const createUserSchema = z.object({
  email: z.string().email('Invalid email format'),
  name: z.string().min(1, 'Name is required').max(100),
  role: z.enum(['admin', 'user', 'guest']).default('user'),
});

// Path params schema
export const userParamsSchema = z.object({
  id: z.string().uuid('Invalid user ID format'),
});

// Query params schema
export const listUsersQuerySchema = z.object({
  page: z.coerce.number().int().positive().default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  search: z.string().optional(),
});

// Type inference exports
export type CreateUserInput = z.infer<typeof createUserSchema>;
export type UserParams = z.infer<typeof userParamsSchema>;
export type ListUsersQuery = z.infer<typeof listUsersQuerySchema>;
```

---

## Validation Middleware Pattern

```typescript
// src/middleware/validate.ts
import { Request, Response, NextFunction } from 'express';
import { AnyZodObject, ZodError } from 'zod';

interface ValidationSchemas {
  body?: AnyZodObject;
  params?: AnyZodObject;
  query?: AnyZodObject;
}

export const validate = (schemas: ValidationSchemas) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      if (schemas.body) {
        req.body = await schemas.body.parseAsync(req.body);
      }
      if (schemas.params) {
        req.params = await schemas.params.parseAsync(req.params);
      }
      if (schemas.query) {
        req.query = await schemas.query.parseAsync(req.query);
      }
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        return res.status(400).json({
          status: 'error',
          message: 'Validation failed',
          errors: error.errors.map((e) => ({
            field: e.path.join('.'),
            message: e.message,
          })),
        });
      }
      next(error);
    }
  };
};
```

---

## Service Layer Pattern

```typescript
// src/services/user.service.ts
import { CreateUserInput, UserParams } from '../schemas/user.schema';
import { AppError } from '../utils/errors';
import { db } from '../db';

export interface User {
  id: string;
  email: string;
  name: string;
  role: string;
  createdAt: Date;
}

export class UserService {
  async create(input: CreateUserInput): Promise<User> {
    // Check for existing user
    const existing = await db.user.findUnique({
      where: { email: input.email },
    });
    
    if (existing) {
      throw new AppError('User with this email already exists', 409);
    }

    // Create user
    const user = await db.user.create({
      data: input,
    });

    return user;
  }

  async findById(params: UserParams): Promise<User> {
    const user = await db.user.findUnique({
      where: { id: params.id },
    });

    if (!user) {
      throw new AppError('User not found', 404);
    }

    return user;
  }

  async list(query: { page: number; limit: number; search?: string }) {
    const skip = (query.page - 1) * query.limit;
    
    const where = query.search
      ? {
          OR: [
            { name: { contains: query.search, mode: 'insensitive' } },
            { email: { contains: query.search, mode: 'insensitive' } },
          ],
        }
      : {};

    const [users, total] = await Promise.all([
      db.user.findMany({
        where,
        skip,
        take: query.limit,
        orderBy: { createdAt: 'desc' },
      }),
      db.user.count({ where }),
    ]);

    return {
      data: users,
      meta: {
        page: query.page,
        limit: query.limit,
        total,
        totalPages: Math.ceil(total / query.limit),
      },
    };
  }
}

export const userService = new UserService();
```

---

## Route Handler Pattern

```typescript
// src/routes/user.routes.ts
import { Router, Request, Response, NextFunction } from 'express';
import { validate } from '../middleware/validate';
import {
  createUserSchema,
  userParamsSchema,
  listUsersQuerySchema,
} from '../schemas/user.schema';
import { userService } from '../services/user.service';

const router = Router();

// POST /api/users - Create user
router.post(
  '/',
  validate({ body: createUserSchema }),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const user = await userService.create(req.body);
      res.status(201).json({
        status: 'success',
        data: user,
      });
    } catch (error) {
      next(error);
    }
  }
);

// GET /api/users/:id - Get user by ID
router.get(
  '/:id',
  validate({ params: userParamsSchema }),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const user = await userService.findById(req.params as any);
      res.json({
        status: 'success',
        data: user,
      });
    } catch (error) {
      next(error);
    }
  }
);

// GET /api/users - List users with pagination
router.get(
  '/',
  validate({ query: listUsersQuerySchema }),
  async (req: Request, res: Response, next: NextFunction) => {
    try {
      const result = await userService.list(req.query as any);
      res.json({
        status: 'success',
        ...result,
      });
    } catch (error) {
      next(error);
    }
  }
);

export default router;
```

---

## Route Registration Pattern

```typescript
// src/routes/index.ts
import { Router } from 'express';
import userRoutes from './user.routes';
// Import other route modules here

const router = Router();

router.use('/users', userRoutes);
// Register other routes here

export default router;
```

---

## Error Handler Pattern

```typescript
// src/utils/errors.ts
export class AppError extends Error {
  constructor(
    message: string,
    public statusCode: number = 500,
    public code?: string
  ) {
    super(message);
    this.name = 'AppError';
    Error.captureStackTrace(this, this.constructor);
  }
}

// src/middleware/errorHandler.ts
import { Request, Response, NextFunction } from 'express';
import { AppError } from '../utils/errors';

export const errorHandler = (
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  if (error instanceof AppError) {
    return res.status(error.statusCode).json({
      status: 'error',
      message: error.message,
      code: error.code,
    });
  }

  // Log unexpected errors
  console.error('Unexpected error:', error);

  return res.status(500).json({
    status: 'error',
    message: 'Internal server error',
  });
};
```

---

## Test Pattern

```typescript
// src/__tests__/user.test.ts
import request from 'supertest';
import { app } from '../app';
import { db } from '../db';

describe('User API', () => {
  beforeEach(async () => {
    await db.user.deleteMany();
  });

  describe('POST /api/users', () => {
    it('should create a user with valid input', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({
          email: 'test@example.com',
          name: 'Test User',
        });

      expect(response.status).toBe(201);
      expect(response.body.status).toBe('success');
      expect(response.body.data.email).toBe('test@example.com');
    });

    it('should return 400 for invalid email', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({
          email: 'invalid-email',
          name: 'Test User',
        });

      expect(response.status).toBe(400);
      expect(response.body.status).toBe('error');
      expect(response.body.errors).toContainEqual(
        expect.objectContaining({ field: 'email' })
      );
    });

    it('should return 400 for missing required fields', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({});

      expect(response.status).toBe(400);
      expect(response.body.errors.length).toBeGreaterThan(0);
    });

    it('should return 409 for duplicate email', async () => {
      await db.user.create({
        data: { email: 'test@example.com', name: 'Existing' },
      });

      const response = await request(app)
        .post('/api/users')
        .send({
          email: 'test@example.com',
          name: 'Duplicate',
        });

      expect(response.status).toBe(409);
    });
  });

  describe('GET /api/users/:id', () => {
    it('should return user by ID', async () => {
      const user = await db.user.create({
        data: { email: 'test@example.com', name: 'Test' },
      });

      const response = await request(app).get(`/api/users/${user.id}`);

      expect(response.status).toBe(200);
      expect(response.body.data.id).toBe(user.id);
    });

    it('should return 404 for non-existent user', async () => {
      const response = await request(app).get(
        '/api/users/00000000-0000-0000-0000-000000000000'
      );

      expect(response.status).toBe(404);
    });

    it('should return 400 for invalid UUID', async () => {
      const response = await request(app).get('/api/users/invalid-id');

      expect(response.status).toBe(400);
    });
  });

  describe('GET /api/users', () => {
    it('should return paginated users', async () => {
      await db.user.createMany({
        data: [
          { email: 'user1@example.com', name: 'User 1' },
          { email: 'user2@example.com', name: 'User 2' },
        ],
      });

      const response = await request(app).get('/api/users?page=1&limit=10');

      expect(response.status).toBe(200);
      expect(response.body.data).toHaveLength(2);
      expect(response.body.meta.total).toBe(2);
    });

    it('should filter users by search term', async () => {
      await db.user.createMany({
        data: [
          { email: 'alice@example.com', name: 'Alice' },
          { email: 'bob@example.com', name: 'Bob' },
        ],
      });

      const response = await request(app).get('/api/users?search=alice');

      expect(response.status).toBe(200);
      expect(response.body.data).toHaveLength(1);
      expect(response.body.data[0].name).toBe('Alice');
    });
  });
});
```

---

## Response Format Standards

### Success Response

```json
{
  "status": "success",
  "data": { /* resource or array */ }
}
```

### Success with Pagination

```json
{
  "status": "success",
  "data": [ /* array of resources */ ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

### Error Response

```json
{
  "status": "error",
  "message": "Human-readable error message",
  "code": "OPTIONAL_ERROR_CODE"
}
```

### Validation Error Response

```json
{
  "status": "error",
  "message": "Validation failed",
  "errors": [
    { "field": "email", "message": "Invalid email format" },
    { "field": "name", "message": "Name is required" }
  ]
}
```

---

## HTTP Status Code Guide

| Status | When to Use |
|--------|-------------|
| 200 | Successful GET, PUT, PATCH |
| 201 | Successful POST (resource created) |
| 204 | Successful DELETE (no content) |
| 400 | Validation error, malformed request |
| 401 | Missing or invalid authentication |
| 403 | Authenticated but not authorized |
| 404 | Resource not found |
| 409 | Conflict (duplicate resource) |
| 422 | Valid syntax but unprocessable |
| 500 | Unexpected server error |

---

## Troubleshooting

### Common Issues

**Zod validation not working:**
- Ensure `validate()` middleware is applied before handler
- Check schema is exported correctly
- Verify request content-type is `application/json`

**Type errors in service layer:**
- Use `z.infer<typeof schema>` for type inference
- Ensure schema matches database model

**Tests failing on database:**
- Run migrations: `npx prisma migrate dev`
- Check test database URL is separate from dev
- Clear test data in `beforeEach`

**Route not found:**
- Verify route is registered in `src/routes/index.ts`
- Check path matches expected pattern
- Ensure middleware order is correct
