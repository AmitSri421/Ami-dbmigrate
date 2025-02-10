# Ami-dbmigrate
| **Phase**   | **Task** | **Duration** |
|------------|---------|-------------|
| **Week 1** | Collect existing database objects, table purposes, dependencies, and indexing details. | 3 days |
|            | Create Oracle script to identify objects and row counts. | 2 days |
| **Week 2** | Create Aurora PostgreSQL script to reconcile objects. | 2 days |
|            | Convert schema using Amazon SCT. | 3 days |
|            | Identify and fix manual schema changes. | 3 days |
| **Week 3** | Set up DMS replication instance, source & target endpoints. | 4 days |
|            | Run DMS pre-migration checks and validate schema conversion issues. | 3 days |
| **Week 4** | Set up DMS task and test data migration (dry run). | 5 days |
|            | Reconcile schema and fix any issues. | 3 days |
| **Week 5** | Perform full data migration and reconcile post-migration. | 4 days |
|            | Connect Java microservices to Aurora PostgreSQL (Dev). | 3 days |
| **Week 6** | Perform application validation and ORM (MyBatis) fixes. | 5 days |
|            | Conduct database performance benchmarking and optimizations. | 3 days |
| **Week 7** | Final cutover: Validate DMS replication completion and app readiness. | 5 days |
|            | Schedule and execute final migration with app downtime if required. | 2 days |
| **Week 8** | Monitor post-migration performance, run UAT, and validate indexing/tuning. | 5 days |
|            | Conduct final stakeholder review and sign-off. | 2 days |
