EPIC 1: Migrate On-Prem Oracle Database Objects to OCI (DEV)

Story 1.1: Extract DDL and DML from On-Prem Oracle

Description:
As a database engineer, I want to extract DDL and DML scripts from the on-prem Oracle DB using SQL Developer so that I can prepare them for OCI migration.

Acceptance Criteria:
	•	All table, index, sequence, trigger, and view DDLs extracted
	•	DML for reference/seed data extracted
	•	Scripts are saved in version-controlled repository

⸻

Story 1.2: Clean and Validate DDL/DML Scripts for OCI Compatibility

Description:
As a migration developer, I want to validate and clean DDL/DML scripts to ensure compatibility with OCI Oracle syntax and features.

Acceptance Criteria:
	•	Unsupported features (e.g., specific datatypes, syntax) identified and remediated
	•	DDL and DML scripts are logically ordered
	•	Validation checklist is created and completed

⸻

Story 1.3: Organize Migration Scripts in Executable Order

Description:
As a developer, I want to structure migration scripts by dependency order so that they can be run without errors.

Acceptance Criteria:
	•	Scripts are grouped as: schemas, tables, sequences, indexes, constraints, DML
	•	Execution order documented

⸻

Story 1.4: Run DDL and DML Scripts on OCI DEV

Description:
As a developer, I want to execute migration scripts on the OCI DEV database so that the schema and data are provisioned properly.

Acceptance Criteria:
	•	All DDL scripts executed without errors
	•	All required DML scripts executed
	•	Execution logs captured and stored

⸻

Story 1.5: Create and Execute Object Validation Scripts

Description:
As a tester, I want to run validation scripts that compare object names and row counts between source and target.

Acceptance Criteria:
	•	Oracle SQL script lists all object names and row counts from source
	•	Same script executed on target and results compared
	•	Validation report generated

⸻

Story 1.6: Document Data Migration Plan

Description:
As a project owner, I want to document the migration steps, rollback strategy, and assumptions so that future migrations (UAT/Prod) are repeatable.

Acceptance Criteria:
	•	Runbook includes pre-reqs, script order, validation steps
	•	Rollback plan documented
	•	Stakeholder sign-off received

⸻

EPIC 2: Update Microservice to Connect to OCI Oracle DB

Story 2.1: Update JDBC Connection to Use OCI

Description:
As a developer, I want to modify the application JDBC connection string to point to the OCI DB so that the service can connect to the new database.

Acceptance Criteria:
	•	Connection URL updated (host, port 2484, SID/service)
	•	Verified in properties or environment config
	•	Successfully tested via local app or health check

⸻

Story 2.2: Enable SSL Support for Oracle OCI

Description:
As a developer, I want to configure truststore settings to enable SSL connectivity with OCI Oracle over port 2484.

Acceptance Criteria:
	•	.jks truststore file generated from Oracle RDS CA
	•	Java options include truststore path and password (if needed)
	•	SSL connection tested via app

⸻

Story 2.3: Setup Cloakware for Secure Credential Retrieval

Description:
As a security-conscious developer, I want to fetch database credentials securely from Cloakware so that hardcoding passwords is avoided.

Acceptance Criteria:
	•	Cloakware process ID created for OCI DB
	•	Application updated to retrieve password via Cloakware API
	•	Password fetch tested locally and via IBM Cloud Controller

⸻

Story 2.4: Validate Application Functionality with OCI DB

Description:
As a QA, I want to verify that the microservice interacts correctly with OCI DB via Swagger so that there are no functional regressions.

Acceptance Criteria:
	•	Swagger endpoints load successfully
	•	All DB-backed endpoints tested
	•	Logs show successful queries and no DB connection errors

⸻

(Optional) EPIC 3: Automate OCI Migration

Story 3.1: Script-Based Deployment of DDL/DML

Description:
As a developer, I want to automate the execution of migration scripts so that the deployment can be rerun consistently.

Acceptance Criteria:
	•	Shell or Python script runs migration scripts in order
	•	Includes logging and basic error handling
	•	Script tested against OCI DEV

⸻

Story 3.2: Integrate Migration into CI/CD Pipeline

Description:
As a DevOps engineer, I want to integrate the migration process into the CI/CD pipeline so that migrations are repeatable and trackable.

Acceptance Criteria:
	•	Jenkins (or other) job created for script execution
	•	Build artifacts and logs stored
	•	Basic notifications added (e.g., success/failure)
