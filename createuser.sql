-- Create the new ones

IF SUSER_ID('bpmuser') IS NULL

               CREATE LOGIN bpmuser WITH PASSWORD = 'bpmuser', CHECK_POLICY = OFF

GO

 

GRANT CONNECT SQL TO [bpmuser]

GO

 

-- Create the requested database

IF NOT EXISTS (SELECT * FROM sys.sysdatabases WHERE name = N'bpm')

               CREATE DATABASE [bpm]

GO

 

ALTER DATABASE [bpm] SET TRUSTWORTHY OFF

GO

 

ALTER DATABASE [bpm] SET AUTO_UPDATE_STATISTICS ON

GO

 

ALTER DATABASE [bpm] SET AUTO_UPDATE_STATISTICS_ASYNC ON

GO

 

ALTER DATABASE [bpm] SET ALLOW_SNAPSHOT_ISOLATION ON

GO

 

ALTER DATABASE [bpm] SET READ_COMMITTED_SNAPSHOT ON

GO

 

ALTER DATABASE [bpm] COLLATE Latin1_General_CS_AS

GO

 

IF NOT EXISTS (SELECT * from sys.change_tracking_databases WHERE database_id = DB_ID('bpm'))

               ALTER DATABASE [bpm] SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 2 DAYS, AUTO_CLEANUP = ON)

GO

 

ALTER LOGIN [bpmuser] WITH DEFAULT_DATABASE = [bpm]

GO

 

USE [bpm]

GO

 

-- Check database user

IF USER_ID('bpmuser') IS NULL

               CREATE USER [bpmuser] FOR LOGIN [bpmuser] WITH DEFAULT_SCHEMA = [bpm]

GO

 

 

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'bpm')

               EXEC( 'CREATE SCHEMA [bpm] AUTHORIZATION [bpmuser]' )

GO

 

-- Add the user and configure

USE [bpm] exec sp_addrolemember 'db_ddladmin', 'bpmuser'

GO

 

USE [bpm] exec sp_addrolemember 'db_datareader', 'bpmuser'

GO

 

USE [bpm] exec sp_addrolemember 'db_datawriter', 'bpmuser'

GO

 

USE [bpm] exec sp_addrolemember 'db_owner', 'bpmuser'

GO

 

-- Gives user ability control the DBO schema

GRANT CONTROL ON SCHEMA::dbo TO [bpmuser] WITH GRANT OPTION

GO

 

-- Needed to execute showplan

GRANT SHOWPLAN TO [bpmuser]

GO

 

-- Needed to manipulate application roles

GRANT ALTER ANY APPLICATION ROLE TO [bpmuser]

GO

 

-- Needed to manipulate roles

GRANT ALTER ANY ROLE TO [bpmuser]

GO

 

-- Needed to view definitions of objects

GRANT VIEW DEFINITION TO [bpmuser]

GO

 

-- Needed to create schemas

GRANT CREATE SCHEMA TO [bpmuser]

GO

 

-- Needed for database-level DMVs

GRANT VIEW DATABASE STATE TO [bpmuser]

GO
