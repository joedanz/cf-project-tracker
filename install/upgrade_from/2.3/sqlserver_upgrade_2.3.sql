/* UPGRADE FROM 2.3 */
/* pt_projects */
ALTER TABLE [dbo].[pt_projects] ADD [tab_files] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_issues] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_msgs] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_mstones] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_todos] [tinyint] NULL
GO
ALTER TABLE [dbo].[pt_projects] ADD [tab_svn] [tinyint] NULL
GO