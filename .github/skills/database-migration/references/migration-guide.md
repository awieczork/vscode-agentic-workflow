# Prisma Migration Guide

Comprehensive guide for database migrations using Prisma ORM.

---

## Prerequisites

### Required Tools

| Tool | Version | Check Command |
|------|---------|---------------|
| Node.js | ≥18.x | `node --version` |
| Prisma CLI | ≥5.x | `npx prisma --version` |
| Database Client | varies | `psql --version` / `mysql --version` |

### Environment Setup

```bash
# Required environment variables
DATABASE_URL="postgresql://user:password@host:5432/dbname"

# Optional for shadow database (recommended for dev)
SHADOW_DATABASE_URL="postgresql://user:password@host:5432/shadow_dbname"
```

---

## Migration Workflows

### Development Workflow

```bash
# 1. Make schema changes in prisma/schema.prisma

# 2. Create and apply migration
npx prisma migrate dev --name descriptive_migration_name

# 3. Verify
npx prisma migrate status
```

**What `migrate dev` does:**
1. Creates migration SQL from schema diff
2. Applies migration to development database
3. Regenerates Prisma Client
4. Triggers generators (if configured)

### Production Workflow

```bash
# 1. Ensure migrations are committed to source control

# 2. Deploy migrations (applies pending only)
npx prisma migrate deploy

# 3. Verify
npx prisma migrate status
```

**Critical Differences:**
| Aspect | `migrate dev` | `migrate deploy` |
|--------|---------------|------------------|
| Creates migrations | Yes | No |
| Resets on drift | Can prompt | Never |
| Safe for production | No | Yes |
| Requires shadow DB | Yes | No |

---

## Backup Strategies

### PostgreSQL Backup

```bash
# Full database backup
pg_dump "$DATABASE_URL" > backup_$(date +%Y%m%d_%H%M%S).sql

# Schema-only backup
pg_dump --schema-only "$DATABASE_URL" > schema_backup.sql

# Specific tables
pg_dump -t users -t orders "$DATABASE_URL" > tables_backup.sql
```

### MySQL Backup

```bash
# Full database backup
mysqldump -h host -u user -p database > backup_$(date +%Y%m%d_%H%M%S).sql

# With routines and triggers
mysqldump --routines --triggers -h host -u user -p database > full_backup.sql
```

### Restore Commands

```bash
# PostgreSQL restore
psql "$DATABASE_URL" < backup_file.sql

# MySQL restore
mysql -h host -u user -p database < backup_file.sql
```

---

## Common Migration Scenarios

### Adding a Required Column

**Problem:** Adding a non-nullable column to a table with existing data.

**Solution:** Two-step migration

```prisma
// Step 1: Add as optional
model User {
  id    Int     @id @default(autoincrement())
  email String?  // Optional first
}
```

```bash
npx prisma migrate dev --name add_email_optional
```

```sql
-- Manual data migration
UPDATE "User" SET email = 'unknown@example.com' WHERE email IS NULL;
```

```prisma
// Step 2: Make required
model User {
  id    Int    @id @default(autoincrement())
  email String  // Now required
}
```

```bash
npx prisma migrate dev --name make_email_required
```

### Renaming a Column

**Problem:** Prisma sees rename as drop + create (data loss).

**Solution:** Custom migration SQL

```bash
# Create empty migration
npx prisma migrate dev --name rename_column --create-only
```

Edit `migration.sql`:
```sql
-- Instead of DROP + ADD, use:
ALTER TABLE "User" RENAME COLUMN "old_name" TO "new_name";
```

```bash
# Apply the edited migration
npx prisma migrate dev
```

### Changing Column Type

**Problem:** Type changes may lose data or fail on incompatible data.

**Solution:** Validate data first

```sql
-- Check for incompatible values before migration
SELECT * FROM "User" WHERE NOT (column_value ~ '^[0-9]+$');
```

Then create migration with explicit USING clause:
```sql
ALTER TABLE "User" 
ALTER COLUMN "age" TYPE INTEGER USING age::integer;
```

---

## Troubleshooting

### Error: Migration Failed to Apply

**Symptoms:**
```
Error: P3006 Migration failed to apply cleanly to the shadow database.
```

**Causes & Solutions:**

1. **Constraint violation in existing data**
   ```bash
   # Check migration status
   npx prisma migrate status
   
   # Mark as rolled back if partially applied
   npx prisma migrate resolve --rolled-back {migration_name}
   ```

2. **Shadow database connection issue**
   ```bash
   # Verify shadow database URL
   echo $SHADOW_DATABASE_URL
   
   # Test connection
   npx prisma db pull --schema=./prisma/shadow.prisma
   ```

### Error: Drift Detected

**Symptoms:**
```
Drift detected: Your database schema is not in sync
```

**Solutions:**

1. **Development:** Reset and re-apply
   ```bash
   npx prisma migrate reset  # WARNING: Deletes all data
   ```

2. **Production:** Baseline the current state
   ```bash
   # Mark current state as baseline
   npx prisma migrate resolve --applied {migration_name}
   ```

### Error: Migration History Diverged

**Symptoms:**
```
The migration history does not match the migration files
```

**Solution:** Reconcile history

```bash
# List applied migrations
npx prisma migrate status

# For each missing migration, mark as applied
npx prisma migrate resolve --applied "migration_name"
```

---

## Best Practices

### Naming Conventions

| Type | Format | Example |
|------|--------|---------|
| Feature addition | `add_{feature}` | `add_user_preferences` |
| Schema modification | `update_{table}_{change}` | `update_user_add_email` |
| Data migration | `migrate_{description}` | `migrate_user_roles` |
| Removal | `remove_{feature}` | `remove_legacy_fields` |

### Pre-Migration Checklist

```
□ Schema changes reviewed by team
□ Backup created and verified
□ Migration tested in staging environment
□ Rollback procedure documented
□ Downtime window scheduled (if needed)
□ Stakeholders notified
```

### Post-Migration Checklist

```
□ Migration status shows "applied"
□ Application health checks pass
□ Key user flows tested
□ Performance metrics stable
□ Backup retained for rollback window (7 days recommended)
```

---

## Rollback Procedures

### Immediate Rollback (Within Minutes)

```bash
# 1. Stop application
pm2 stop all  # or your process manager

# 2. Restore database
psql "$DATABASE_URL" < backup_file.sql

# 3. Mark migration as rolled back
npx prisma migrate resolve --rolled-back {migration_name}

# 4. Regenerate client to match restored schema
npx prisma generate

# 5. Restart application
pm2 start all
```

### Delayed Rollback (Hours/Days Later)

If data has changed since migration:

1. **Create reverse migration** (preferred)
   ```bash
   npx prisma migrate dev --name rollback_{original_migration}
   ```

2. **Point-in-time recovery** (if available)
   - Use database-native PITR features
   - Requires WAL archiving (PostgreSQL) or binary logs (MySQL)

---

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Database Migration

on:
  push:
    branches: [main]
    paths: ['prisma/**']

jobs:
  migrate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run migrations
        run: npx prisma migrate deploy
        env:
          DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

### Safety Gates

```yaml
# Add manual approval for production
jobs:
  migrate-production:
    environment: production  # Requires approval
    needs: [migrate-staging]
    # ... migration steps
```

---

## Sources

- [Prisma Migrate Documentation](https://www.prisma.io/docs/concepts/components/prisma-migrate)
- [Prisma Production Deployment](https://www.prisma.io/docs/guides/deployment/production)
- [PostgreSQL Backup Best Practices](https://www.postgresql.org/docs/current/backup.html)
