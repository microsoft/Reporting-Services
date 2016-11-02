/****************************************************************************
  This file is part of the Microsoft SQL Server Code Samples.
  Copyright (C) Microsoft Corporation.  All rights reserved.

  This source code is intended only as a supplement to Microsoft
  Development Tools and/or on-line documentation.  See these other
  materials for detailed information regarding Microsoft code samples.

  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
  KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
*****************************************************************************/

USE master
GO
-- create a database for the security information
IF EXISTS (SELECT * FROM   master..sysdatabases WHERE  name =
'UserAccounts')
  DROP DATABASE UserAccounts
GO
CREATE DATABASE UserAccounts
GO
USE UserAccounts
GO
CREATE TABLE [Users] (
  [UserName] [varchar] (255) NOT NULL ,
  [PasswordHash] [varchar] (50) NOT NULL ,
  [salt] [varchar] (10) NOT NULL,
  CONSTRAINT [PK_Users] PRIMARY KEY  CLUSTERED
  (
    [UserName]
  )  ON [PRIMARY] 
) ON [PRIMARY]
GO
-- create a stored procedure to register user details
CREATE PROCEDURE RegisterUser
@userName varchar(255),
@passwordHash varchar(50),
@salt varchar(10)
AS
INSERT INTO Users VALUES(@userName, @passwordHash, @salt)
GO
-- create a stored procedure to retrieve user details
CREATE PROCEDURE LookupUser
@userName varchar(255)
AS
SELECT PasswordHash, salt 
FROM Users
WHERE UserName = @userName
GO


--
-- Start security grants
--

-- Capture the OS version in a temp table so that we can pick 
-- the correct windows account to grant access to for the objects 
-- defined in this file.  This enables ASP.NET programs to access 
-- these objects.
CREATE TABLE #GetVersionValues
(
	[Index]	int,
	[Name]	sysname,
	Internal_value	int,
	Character_Value	sysname
);
GO

INSERT #GetVersionValues
EXEC master.dbo.xp_msver 'WindowsVersion';
GO

DECLARE @OSVersion decimal(9, 2);
DECLARE @ASPUserName nvarchar(100);
DECLARE @NetworkService nvarchar(100);

-- For globalization purposes, the sample install script uses a SID to set NT AUTHORITY\NETWORK SERVICE
-- SELECT SUSER_SID('NT AUTHORITY\NETWORK SERVICE') returns the English SID. 
SET @NetworkService = SUSER_SNAME(0x010100000000000514000000);

SELECT @OSVersion = CONVERT(decimal(9, 2), SUBSTRING(Character_Value, 1, CHARINDEX(' ', Character_Value) - 1)) 
FROM #GetVersionValues;

-- IIS6 uses a different account to run web apps under.  II6 first shipped with Windows 2003 (v5.2).
IF (@OSVersion < 5.20) 
	SET @ASPUserName = CONVERT(nvarchar(64), SERVERPROPERTY('machinename')) + N'\ASPNET';
ELSE
	SET @ASPUserName = @NetworkService;

-- Add a login for the local ASPNET account
-- In the following statements, replace LocalMachine with your
-- local machine name on Winows 2000 and Windows XP 
-- replace LocalMachine\ASPNET with NT AUTHORITY\NETWORK SERVICE 
-- on Windows 2003 (except when in IIS 5 compatibility mode)
exec ('sp_grantlogin [' + @ASPUserName + ']');

-- Add a database login for the UserAccounts database for the ASPNET account
exec ('sp_grantdbaccess [' + @ASPUserName + ']');

-- Grant execute permissions to the LookupUser and RegisterUser stored procs
exec ('grant execute on LookupUser to [' + @ASPUserName + ']');

exec ('grant execute on RegisterUser to [' + @ASPUserName + ']');





