/* UPGRADE FROM BETA */
ALTER TABLE [dbo].[pt_comments] MODIFY [comment] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_project_users] MODIFY [role] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_todolists] MODIFY [description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_todos] MODIFY [task] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

/* UPGRADE FROM 1.0 */
INSERT INTO [dbo].[pt_Users](userID,firstName,lastName,username,password,style,email_todos,mobile_todos,email_mstones,mobile_mstones,email_issues,mobile_issues,avatar,admin,active) values('7F16CA08-1372-7975-6F7F9DA33EBD6A09','Guest','User','guest','guest','blue',0,0,0,0,0,0,0,0,1)
GO
ALTER TABLE [dbo].[pt_users] ADD [mobile] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [email_todos] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [mobile_todos] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [email_mstones] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [mobile_mstones] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [email_issues] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [mobile_issues] [bit] NULL
GO
UPDATE [dbo].[pt_users] 
	SET [email_todos] = 1 ,
		[mobile_todos] = 1 ,
		[email_mstones] = 1 ,
		[mobile_mstones] = 1 ,
		[email_issues] = 1 ,
		[mobile_issues] = 1
GO
