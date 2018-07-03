# Create the database

The database is created by running Entity Framework migrations. 

Running the `Update-Database` command the first time will create a database using the connection string 
'PartsUnlimitedContext' defined in Web.config

**Steps**

1. Ensure startup project set to PartsUnlimited.Web
2. In Package Manager Console (Tools > NuGet Package Manager > Package Manager Console):
	1. Set the default project to PartsUnlimited.Infrastructure
	2. Run command Update-Database
