/* UPGRADE FROM 2.1 */
/* pt_projects */
ALTER TABLE [dbo].[pt_projects] ADD [allow_reg] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_active] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_files] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_issues] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_msgs] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_mstones] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_todos] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [reg_svn] [tinyint] NULL
GO

UPDATE [dbo].[pt_projects]
	SET [allow_reg] = 0 ,
		[reg_active] = 1 ,
		[reg_files] = 1 ,
		[reg_issues] = 1 ,
		[reg_msgs] = 1 ,
		[reg_mstones] = 1 ,
		[reg_todos] = 1 ,
		[reg_svn] = 1
GO

UPDATE [dbo].[pt_carriers]
	SET [prefix] = ''
GO

ALTER TABLE [dbo].[pt_users] ALTER COLUMN [password] [char] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

UPDATE TABLE [dbo].[pt_users] SET [password] = '21232F297A57A5A743894A0E4A801FC3' WHERE [username] = 'admin'
GO

UPDATE TABLE [dbo].[pt_users] SET [password] = '084E0343A0486FF05530DF6C705C8BB4' WHERE [username] = 'guest'
GO
