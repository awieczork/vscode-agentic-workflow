---
name: database-migration
description: Run Prisma database migrations safely with automatic backup and rollback when schema changes need to be applied to development or production databases
license: MIT
compatibility: Requires Node.js, Prisma CLI, and database access configured
metadata:
  author: vscode-agentic-workflow
  version: "1.0.0"
  tags: [database, prisma, migration, devops]
---

# Database Migration

Safely execute Prisma database migrations with backup creation and rollback capability.

## Overview

Use this skill when you need to apply Prisma schema changes to a database. It ensures data safety through pre-migration backups and provides rollback procedures if migration fails.

## Steps

1. **Verify Prerequisites**
   - Confirm Prisma CLI installed: `npx prisma --version`
   - Verify database connection: `npx prisma db pull --force`
   - Check for pending migrations: `npx prisma migrate status`

2. **Create Pre-Migration Backup**
   - Generate timestamped backup: `npx prisma db execute --stdin < backup.sql` or use database-native tools
   - For PostgreSQL: `pg_dump $DATABASE_URL > backup_$(date +%Y%m%d_%H%M%S).sql`
   - For MySQL: `mysqldump` with appropriate credentials
   - Store backup location in environment or note for rollback

3. **Generate Migration**
   - Create migration from schema changes: `npx prisma migrate dev --name {migration_name}`
   - For production: `npx prisma migrate deploy`
   - Review generated SQL in `prisma/migrations/{timestamp}_{name}/migration.sql`

4. **Validate Migration**
   - Verify schema state: `npx prisma migrate status`
   - Regenerate Prisma Client: `npx prisma generate`
   - Run application tests to confirm compatibility

5. **Document Changes**
   - Record migration name, timestamp, and purpose
   - Note any manual data transformations required
   - Update schema documentation if significant changes

## Error Handling

If Prisma CLI not found: Install with `npm install -g prisma` or `npm install prisma --save-dev`.

If database connection fails: Verify `DATABASE_URL` in `.env` file matches database credentials and host.

If migration fails mid-execution:
1. Check error message for constraint violations or data issues
2. Run `npx prisma migrate resolve --rolled-back {migration_name}` to mark as rolled back
3. Restore from backup created in Step 2
4. Fix schema issue and regenerate migration

If backup creation fails: Do NOT proceed with migration. Resolve backup tool access first.

If tests fail after migration: 
1. Restore database from backup
2. Run `npx prisma migrate resolve --rolled-back {migration_name}`
3. Regenerate Prisma Client: `npx prisma generate`

If production migration fails:
1. Do NOT attempt manual fixes on production
2. Restore from backup immediately
3. Test fix in development environment first
4. Re-deploy with corrected migration

## Reference Files

- [Migration Guide](references/migration-guide.md) — Detailed walkthrough with examples and troubleshooting

## Validation

Before marking migration complete:

- [ ] Backup exists and is accessible
- [ ] Migration status shows "applied"
- [ ] Prisma Client regenerated
- [ ] Application tests pass
- [ ] No pending schema drift

## Notes

**Idempotency Warning:** Migrations are NOT idempotent. Running the same migration twice will fail. Always check `npx prisma migrate status` before running.

**Production Safety:** Never run `prisma migrate dev` in production. Use `prisma migrate deploy` only.

**Environment Isolation:** Ensure `DATABASE_URL` points to the correct environment before executing.
