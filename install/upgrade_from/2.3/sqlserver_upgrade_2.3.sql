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

/* pt_issues */
ALTER TABLE [dbo].[pt_issues] ADD [componentID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_issues] ADD [versionID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

CREATE TABLE [dbo].[pt_project_components] (
	[componentID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[component] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[pt_project_versions] (
	[versionID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[version] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[pt_project_components] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_project_components] PRIMARY KEY  CLUSTERED 
	(
		[componentID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[pt_project_versions] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_project_versions] PRIMARY KEY  CLUSTERED 
	(
		[versionID]
	)  ON [PRIMARY] 
GO