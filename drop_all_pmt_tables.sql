DECLARE @SchemaName NVARCHAR(MAX) = 'pmt_owner';
DECLARE @sql NVARCHAR(MAX) = '';

-- Drop foreign key constraints
SELECT @sql = @sql + 'ALTER TABLE [' + SCHEMA_NAME(t.schema_id) + '].[' + t.name + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
FROM sys.foreign_keys fk
JOIN sys.tables t ON fk.parent_object_id = t.object_id
WHERE SCHEMA_NAME(t.schema_id) = @SchemaName;

-- Drop tables
SELECT @sql = @sql + 'DROP TABLE [' + SCHEMA_NAME(t.schema_id) + '].[' + t.name + '];' + CHAR(13)
FROM sys.tables t
WHERE SCHEMA_NAME(t.schema_id) = @SchemaName;

-- Execute the generated SQL
EXEC sp_executesql @sql;

