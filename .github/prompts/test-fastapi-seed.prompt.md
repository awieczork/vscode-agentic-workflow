---
description: 'Test seed for a Python FastAPI backend project — exercises all artifact types during generation workflow testing'
agent: 'brain'
workflow: 'generation'
---

Follow the [generation workflow](../agent-workflows/generation.workflow.md) with the following seed data.

```yaml
name: "fastapi-backend"
area: "backend-api"
goal: "Build a production-ready FastAPI backend with authentication, database models, and automated testing"
tech:
  - Python 3.12
  - FastAPI
  - PostgreSQL
  - SQLAlchemy
  - pytest
  - Pydantic
  - Alembic
sources:
  - url: "https://fastapi.tiangolo.com/"
    title: "FastAPI Official Documentation"
  - url: "https://docs.sqlalchemy.org/"
    title: "SQLAlchemy Documentation"
  - url: "https://docs.pydantic.dev/"
    title: "Pydantic Documentation"
```

<description>

A FastAPI backend project for a SaaS platform that manages user accounts, authentication (JWT-based), and resource CRUD operations. The API serves a React frontend and a mobile app. Key workflows include user registration with email verification, role-based access control, and paginated resource listing with filtering. The team follows trunk-based development with CI/CD via GitHub Actions. Database migrations use Alembic. Testing requires both unit tests (pytest) and integration tests against a test database. Code quality enforcement includes ruff for linting and mypy for type checking.

</description>
