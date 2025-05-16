# Oracle Database Migration Plan

This document outlines the phased plan for migrating an Oracle 19c database from on-prem to Oracle Cloud Infrastructure (OCI).

---

## Phase 1: Pre-Migration Preparation

- Validate DBO/schema information for source and target
- Confirm Spring `active profile` (dev / uat / prod) is correctly set
- Verify database connectivity for source and target
- Ensure DB Migrator app is installed and configured
  - Local config setup
  - Server selection for UAT/PROD
- Test UAT password fetch from Secrets Manager
- Prepare README for DB Migrator app deployment

---

## Phase 2: DDL Extraction

- Use Spring Boot DDL Extractor or SQL Developer to extract DDL
- Extract only **CREATE TABLE** statements initially
- Extract and segregate:
  - Indexes
  - Partitions
  - Sequences
- Extract **GRANT** statements per role
- Validate extracted sequences (especially start values) just before applying
- Save outputs into structured folders:
  - `tables/`
  - `indexes/`
  - `partitions/`
  - `grants/`
  - `sequences/`

---

## Phase 3: Target DDL Creation

- Apply **CREATE TABLE** statements on the target
- Apply **GRANT** scripts
- Apply **INDEX** creation scripts
- Apply **PARTITION** creation scripts
- Apply **SEQUENCE** creation scripts (after start value validation)

---

## Phase 4: Application Preparation

- Prepare for application downtime before DML migration
- Disconnect old application from source DB
- Update application DB connection to new (migrated) target
- Redeploy app with updated configuration
- Test application connectivity to new DB after deployment

---

## Phase 5: DML Migration (Data Copy)

- Conduct **pilot migration** with 1–2 small tables
- Execute **full migration** using the DB Migrator app
- Constantly monitor logs during migration
- Upload logs after each migration batch
- After migration:
  - Check logs for errors
  - Verify row counts (AI-based or tool-based comparison)
- Prepare rollback scripts:
  - `TRUNCATE` table scripts
  - `DROP TABLE` scripts

---

## Phase 6: Post-Migration Validation

- Perform **technical validation** of DB schema and data
- Run **row count and checksum comparison** between source and target
- Perform **sanity check** by the SQA team
- Final **sign-off** from tech and QA teams

---

## Phase 7: Documentation & Finalization

- Archive all migration logs and scripts
- Document steps, commands, and configurations in a `README.md`
- Submit final report and confirmation email to stakeholders

---

## Notes

- Drool tables require **separate deployment** using SQL Developer.
- Ensure application is **fully disconnected** before starting migration.
- Wait for all SQLs to **complete before app restart**.
- Deploy DB Migrator locally with CAPAM (change server for UAT/PROD in config).
