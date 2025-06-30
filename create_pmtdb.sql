-- Create the new ones

IF SUSER_ID('pmtuser') IS NULL

               CREATE LOGIN pmtuser WITH PASSWORD = 'pmtuser', CHECK_POLICY = OFF

GO

 

GRANT CONNECT SQL TO [pmtuser]

GO

 

-- Create the requested database

IF NOT EXISTS (SELECT * FROM sys.sysdatabases WHERE name = N'pmtdb')

               CREATE DATABASE [pmtdb]

GO

 

ALTER DATABASE [pmtdb] SET TRUSTWORTHY OFF

GO

 

ALTER DATABASE [pmtdb] SET AUTO_UPDATE_STATISTICS ON

GO

 

ALTER DATABASE [pmtdb] SET AUTO_UPDATE_STATISTICS_ASYNC ON

GO

 

ALTER DATABASE [pmtdb] SET ALLOW_SNAPSHOT_ISOLATION ON

GO

 

ALTER DATABASE [pmtdb] SET READ_COMMITTED_SNAPSHOT ON

GO

 

ALTER DATABASE [pmtdb] COLLATE Latin1_General_CS_AS

GO

 

IF NOT EXISTS (SELECT * from sys.change_tracking_databases WHERE database_id = DB_ID('pmtdb'))

               ALTER DATABASE [pmtdb] SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON)

GO

 

ALTER LOGIN [pmtuser] WITH DEFAULT_DATABASE = [pmtdb]

GO

 

USE [pmtdb]

GO

 

-- Check database user

IF USER_ID('pmtuser') IS NULL

               CREATE USER [pmtuser] FOR LOGIN [pmtuser] WITH DEFAULT_SCHEMA = [pmtdb]

GO

 

 

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'pmt_owner')

               EXEC( 'CREATE SCHEMA [pmt_owner] AUTHORIZATION [pmtuser]' )

GO

 

-- Add the user and configure

USE [pmtdb] exec sp_addrolemember 'db_ddladmin', 'pmtuser'

GO

 

USE [pmtdb] exec sp_addrolemember 'db_datareader', 'pmtuser'

GO

 

USE [pmtdb] exec sp_addrolemember 'db_datawriter', 'pmtuser'

GO

 

USE [pmtdb] exec sp_addrolemember 'db_owner', 'pmtuser'

GO

 

-- Gives user ability control the DBO schema

GRANT CONTROL ON SCHEMA::dbo TO [pmtuser] WITH GRANT OPTION

GO

 

-- Needed to execute showplan

GRANT SHOWPLAN TO [pmtuser]

GO

 

-- Needed to manipulate application roles

GRANT ALTER ANY APPLICATION ROLE TO [pmtuser]

GO

 

-- Needed to manipulate roles

GRANT ALTER ANY ROLE TO [pmtuser]

GO

 

-- Needed to view definitions of objects

GRANT VIEW DEFINITION TO [pmtuser]

GO

 

-- Needed to create schemas

GRANT CREATE SCHEMA TO [pmtuser]

GO

 

-- Needed for database-level DMVs

GRANT VIEW DATABASE STATE TO [pmtuser]

GO
