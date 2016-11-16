/****************************************************************************
  Copyright (c) 2016 Microsoft Corporation. All Rights Reserved.
  Licensed under the MIT License (MIT)

  This source code is intended only as a supplement to Microsoft
  Development Tools and/or on-line documentation.  See these other
  materials for detailed information regarding Microsoft code samples.

  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
  KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
*****************************************************************************/

-- Restore changes to master database
USE master
GO
-- create a database for the security information
IF EXISTS (SELECT * FROM   master..sysdatabases WHERE  name =
'UserAccounts')
  DROP DATABASE UserAccounts
GO