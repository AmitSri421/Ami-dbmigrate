EPIC 1: Migrate On-Prem Oracle Database Objects to OCI (DEV)

Story 1.1: Extract DDL and DML from On-Prem Oracle

Update:
Extracted all DDLs (tables, indexes, sequences, triggers, constraints) from SQL Developer using export tools. Also extracted reference DML data (roughly 15 core tables). Verified script consistency and saved everything in a version-controlled folder in Bitbucket. Identified and documented dependencies between objects.

⸻

Story 1.2: Clean and Validate DDL/DML Scripts for OCI Compatibility

Update:
Performed full validation of DDLs — fixed data type mismatches, removed tablespace-specific clauses, and corrected deprecated syntax not supported by OCI. Created a compatibility matrix to track each object and its transformation. Sanitized and modularized scripts for repeatability.

⸻

Story 1.3: Organize Migration Scripts in Executable Order

Update:
Grouped scripts into logical units: schemas, tables, sequences, indexes, constraints, DML. Verified execution order using a dependency map. Created separate folders and README for step-by-step execution. Validated script order by doing a dry run in a local Oracle instance.

⸻

Story 1.4: Run DDL and DML Scripts on OCI DEV

Update:
Connected to OCI DEV using SQL*Plus and ran all DDL scripts successfully with logs captured. No errors in schema creation. Loaded DML into the database; verified row insertions across all tables. Performance optimized large inserts using batch commit and direct path load where possible.

⸻

Story 1.5: Create and Execute Object Validation Scripts

Update:
Developed a dynamic PL/SQL script that queries object names and row counts by schema/table. Ran the script on both on-prem and OCI DEV. Exported results to CSV and compared using a Python diff script. Found 98.5% match; remaining differences were related to empty staging tables and were confirmed as expected.

⸻

Story 1.6: Document Data Migration Plan

Update:
Prepared a detailed migration runbook covering prerequisites, script sequence, rollback checkpoints, validation steps, known issues, and assumptions. Created a flow diagram to show dependencies. Uploaded final doc to Confluence and shared it with the migration team for review and approval.

⸻

EPIC 2: Update Microservice to Connect to OCI Oracle DB

Story 2.1: Update JDBC Connection to Use OCI

Update:
Updated application.properties to point to OCI database hostname and port 2484. Adjusted connection parameters to use service name instead of SID. Verified JDBC URL syntax. Also reviewed pool settings (HikariCP) and adjusted connection timeout, max pool size, and retry intervals based on OCI latency.

⸻

Story 2.2: Enable SSL Support for Oracle OCI

Update:
Downloaded Oracle’s root and intermediate CA certs, generated .jks truststore using keytool, and configured JVM truststore properties. Added SSL-specific parameters in JDBC URL. Ran connectivity test using a standalone Java client and confirmed SSL handshake success.

⸻

Story 2.3: Setup Cloakware for Secure Credential Retrieval

Update:
Requested and received Cloakware credentials for the new OCI DB user. Configured the app to use the new Process ID. Wrote a wrapper to test credential fetch locally. Verified secure fetch in the deployed environment via IBM Cloud Controller and confirmed no hardcoded credentials remain.

⸻

Story 2.4: Validate Application Functionality with OCI DB

Update:
Deployed the microservice to DEV environment pointing to the OCI database. Ran regression tests via Swagger — all read and write operations performed successfully. Reviewed logs to confirm database operations (SELECT, INSERT, UPDATE) are hitting the OCI DB and behaving as expected. Also reviewed metrics on connection pool and memory usage to validate performance.

⸻

EPIC 3: Automate OCI Migration

Story 3.1: Script-Based Deployment of DDL/DML

Update:
Created shell scripts that read DDL/DML files in sequence and execute them using sqlplus. Logs are stored per script. Added validation steps post-execution. Scripts are idempotent where possible and rollback support is added for DML through export backups.

⸻

Story 3.2: Integrate Migration into CI/CD Pipeline

Update:
Set up Jenkins job to trigger migration scripts on OCI DEV. Job parameters include environment, schema, and script path. Included log archive and Slack notifications on success/failure. Dry-run mode added for script verification. This brings the migration process closer to being fully automated and repeatable for UAT and Prod.
