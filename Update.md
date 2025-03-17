I wanted to share a quick update on the database migration, as we were unable to connect in the last few meetings:
	•	We have set up the RDS Oracle database. Initially, we considered a Multi-AZ deployment, but we realised that a Single-AZ setup is better for faster replication through AWS DMS. For now, we have provisioned an RDS Standard Edition instance in the development environment.
	•	The schemas, roles, and process IDs have been created. However, we may need to make some changes to the schema from what we had originally planned.
	•	We also had to create an additional schema called AWSDMS_CONTROL, which is mandatory for running a DMS task successfully. Without this, the task throws an error, as this schema is required for logging DMS activities.
	•	As a pilot test, we migrated two tables—one with partitions and one without. A key observation was that migrating around 1 lakh rows took nearly 2 hours, which is quite slow. To improve this, we are referring to AWS documentation that suggests using CDC (Change Data Capture). This will allow continuous data migration until all data is transferred, after which we can switch the connection.
	•	We have successfully connected to the RDS using SQL Developer and validated the table counts.
	•	Additional database objects, such as sequences, need to be created separately, and we are currently working on that.

Please let me know if you have any feedback or if you would like to discuss this further.
