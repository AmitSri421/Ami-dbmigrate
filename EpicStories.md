Epic 1: Migrate On-Prem Oracle Database Objects to OCI Oracle Database (DEV Environment)

Task Group: Extraction and Preparation
	•	Extract DDL scripts for tables, indexes, sequences, triggers from on-prem Oracle using SQL Developer
	•	Extract initial DML (seed/reference data) if required
	•	Extract and document source database statistics (object names, row counts)
	•	Clean and validate DDL scripts for OCI compatibility
	•	Organize DDL and DML scripts in the correct migration order
	•	Document differences in features/compatibility (e.g., deprecated data types, syntax changes)

Task Group: OCI DEV Database Setup
	•	Provision OCI DEV Oracle DB (if not already provisioned)
	•	Create required schemas and roles
	•	Run DDL scripts on OCI DB
	•	Run DML scripts on OCI DB
	•	Create indexes, partitions, sequences, constraints

Task Group: Validation
	•	Develop Oracle script to compare object names and row counts between source and target
	•	Validate row counts and object existence post-migration
	•	Run integrity/consistency checks on migrated data (e.g., foreign key references, nulls)

Task Group: Migration Planning
	•	Create a detailed data migration runbook for DEV migration (mapping source to target, script order, validations)
	•	Document rollback strategy and backup checkpoints
	•	Review and sign-off with stakeholders for DEV migration

⸻

Epic 2: Update Microservice Connectivity to OCI Oracle DB

Task Group: Application Configuration
	•	Update JDBC connection strings in Spring Boot application to point to OCI DB
	•	Modify connection pool settings (e.g., HikariCP) for OCI specifics
	•	Configure SSL support (truststore setup, use of port 2484)
	•	Generate truststore (.jks) file and configure Java options accordingly

Task Group: Cloakware Integration
	•	Create new process/user IDs in Cloakware for OCI DB
	•	Update application to fetch DB credentials securely from Cloakware
	•	Test credential fetch using IBM App Cloud Controller deployment

Task Group: Application Testing
	•	Deploy microservice to DEV environment pointing to OCI DB
	•	Perform connectivity check to new database (ping, login, query)
	•	Validate Swagger endpoints for DB-backed APIs
	•	Log review and validation of DB interactions in application logs
	•	Document test results and any fixes/observations

⸻

Optional Epic 3: Automation and CI/CD Support

Task Group: Automation (if planned)
	•	Create shell or Python scripts to automate DDL/DML deployment to OCI
	•	Integrate migration scripts into Jenkins or similar CI/CD pipeline
	•	Set up logging and rollback triggers for automated runs
