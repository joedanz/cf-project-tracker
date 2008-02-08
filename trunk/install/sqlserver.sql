if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_activity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_activity]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_carriers]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_carriers]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_categories]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_categories]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_clients]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_clients]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_comments]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_comments]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_files]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_files]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_issues]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_issues]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_message_notify]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_message_files]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_message_notify]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_message_notify]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_messages]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_messages]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_milestones]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_milestones]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_project_users]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_project_users]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_projects]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_projects]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_settings]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_settings]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_todolists]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_todolists]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_todos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_todos]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_users]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_users]GOCREATE TABLE [dbo].[pt_activity] (	[activityID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[userID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[type] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[id] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[name] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[activity] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[stamp] [datetime] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_carriers] (	[carrierID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[carrier] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[countryCode] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[country] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[prefix] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[suffix] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[active] [tinyint] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_categories] (	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[categoryID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[type] [nvarchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[category] [nvarchar] (80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_clients] (	[clientID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[name] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[address] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[city] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[locality] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[country] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[postal] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[phone] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[fax] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[contactName] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[contactPhone] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[notes] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[active] [tinyint] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_comments] (	[commentID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[type] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[itemID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[userID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[comment] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[stamp] [datetime] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_files] (	[fileID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[title] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[categoryID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[filename] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[serverfilename] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[filetype] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[filesize] [bigint] NULL ,	[uploaded] [datetime] NULL ,	[uploadedBy] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_issues] (	[issueID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[milestoneID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[shortID] [nvarchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[issue] [nvarchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[detail] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[type] [nvarchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[severity] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[status] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[relevantURL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[created] [datetime] NULL ,	[createdBy] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[assignedTo] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[updated] [datetime] NULL ,	[updatedBy] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_message_files] (	[messageID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[fileID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_message_notify] (	[messageID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[userID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_messages] (	[messageID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[milestoneID] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[userID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[title] [nvarchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[message] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[categoryID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[allowcomments] [tinyint] NULL ,	[stamp] [datetime] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_milestones] (	[milestoneID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[userID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[forID] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[dueDate] [datetime] NULL ,	[completed] [datetime] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_project_users] (	[userID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[admin] [tinyint] NULL ,	[files] [tinyint] NULL ,	[issues] [tinyint] NULL ,	[msgs] [tinyint] NULL ,	[mstones] [tinyint] NULL ,	[todos] [tinyint] NULL ,	[svn] [tinyint] NULL) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_projects] (	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[ownerID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[clientID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[display] [tinyint] NULL ,	[ticketPrefix] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[added] [datetime] NULL ,	[addedBy] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[status] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[svnurl] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[svnuser] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[svnpass] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_settings] (	[settingID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[setting] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[settingValue] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_todolists] (	[todolistID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[title] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[milestoneID] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[userID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[added] [datetime] NULL ,	[rank] [tinyint] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_todos] (	[todoID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[todolistID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[userID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[task] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[rank] [int] NULL ,	[added] [datetime] NULL ,	[due] [datetime] NULL ,	[completed] [datetime] NULL ,	[svnrevision] [int] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_users] (	[userID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[firstName] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[lastName] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[username] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[password] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[email] [nvarchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[phone] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[mobile] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[carrierID] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[lastLogin] [datetime] NULL ,	[avatar] [tinyint] NULL ,	[style] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[email_files] [tinyint] NULL ,	[mobile_files] [tinyint] NULL ,	[email_issues] [tinyint] NULL ,	[mobile_issues] [tinyint] NULL ,	[email_msgs] [tinyint] NULL ,	[mobile_msgs] [tinyint] NULL ,	[email_mstones] [tinyint] NULL ,	[mobile_mstones] [tinyint] NULL ,	[email_todos] [tinyint] NULL ,	[mobile_todos] [tinyint] NULL ,	[admin] [tinyint] NULL ,	[active] [tinyint] NULL ) ON [PRIMARY]GOALTER TABLE [dbo].[pt_activity] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_activity] PRIMARY KEY  CLUSTERED 	(		[activityID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_carriers] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_carriers] PRIMARY KEY  CLUSTERED 	(		[carrierID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_categories] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_categories] PRIMARY KEY  CLUSTERED 	(		[projectID],[categoryID],[type]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_clients] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_clients] PRIMARY KEY  CLUSTERED 	(		[clientID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_comments] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_comments] PRIMARY KEY  CLUSTERED 	(		[commentID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_files] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_files] PRIMARY KEY  CLUSTERED 	(		[fileID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_issues] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_issues] PRIMARY KEY  CLUSTERED 	(		[issueID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_message_files] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_message_files] PRIMARY KEY  CLUSTERED 	(		[messageID],[fileID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_message_notify] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_message_notify] PRIMARY KEY  CLUSTERED 	(		[messageID],[projectID],[userID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_messages] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_messages] PRIMARY KEY  CLUSTERED 	(		[messageID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_milestones] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_milestones] PRIMARY KEY  CLUSTERED 	(		[milestoneID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_project_users] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_project_users] PRIMARY KEY  CLUSTERED 	(		[userID],[projectID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_projects] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_projects] PRIMARY KEY  CLUSTERED 	(		[projectID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_settings] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_settings] PRIMARY KEY  CLUSTERED 	(		[settingID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_todolists] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_todolists] PRIMARY KEY  CLUSTERED 	(		[todolistID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_todos] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_todos] PRIMARY KEY  CLUSTERED 	(		[todoID]	)  ON [PRIMARY] GOALTER TABLE [dbo].[pt_users] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_users] PRIMARY KEY  CLUSTERED 	(		[userID]	)  ON [PRIMARY] GOINSERT INTO [dbo].[pt_users](userID,firstName,lastName,username,password,style,email_files,mobile_files,email_issues,mobile_issues,email_msgs,mobile_msgs,email_mstones,mobile_mstones,email_todos,mobile_todos,avatar,admin,active) values('FCDCF4CD-16E6-58DE-13EDC6A2B362B22C','Admin','User','admin','admin','blue',1,1,1,1,1,1,1,1,1,1,0,1,1)GOINSERT INTO [dbo].[pt_users](userID,firstName,lastName,username,password,style,email_files,mobile_files,email_issues,mobile_issues,email_msgs,mobile_msgs,email_mstones,mobile_mstones,email_todos,mobile_todos,avatar,admin,active) values('7F16CA08-1372-7975-6F7F9DA33EBD6A09','Guest','User','guest','guest','blue',1,1,1,1,1,1,1,1,1,1,0,0,1)GOINSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('FC3D187C-16E6-58DE-133C5098C58225D3','app_title','Project Tracker')GOINSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('FC3D861A-16E6-58DE-1346E4E01F578F52','default_style','blue')GOINSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('E59DED9F-1372-7975-6FCD9DFAE904B617','enable_api','0')GOINSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('E5A50225-1372-7975-6F9777FB42FD45E6','api_key','')GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8464AB28-1372-7975-6F2E9747CA6E4693','AT&T','US','United States','1','@txt.att.net',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8464DE00-1372-7975-6FE886FCD149E667','Boost','US','United States','1','@myboostmobile.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84653DF3-1372-7975-6F03DA67DD9FB6A9','Cingular','US','United States','1','@txt.att.net',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('846562C1-1372-7975-6F0D79371C491F0C','Helio','US','United States','1','@messaging.sprintpcs.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('846589B2-1372-7975-6F34C8F27502E0DE','Nextel','US','United States','1','@messaging.nextel.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8465AECE-1372-7975-6FAEBDD9F3DDB156','Sprint','US','United States','1','@messaging.sprintpcs.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('846F02F5-1372-7975-6F6C106050F904CD','T-Mobile','US','United States','1','@tmomail.net',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8465D060-1372-7975-6F83333D63966358','Verizon','US','United States','1','@vtext.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8465FEC3-1372-7975-6F5CA6C75C25C7D4','Virgin USA','US','United States','1','@vmobl.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84662779-1372-7975-6F8F1751F5B64D4E','Aliant Mobility','CA','Canada','1','@chat.wirefree.ca',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('846652B0-1372-7975-6F46C791E680C346','Bell Mobility','CA','Canada','1','@txt.bellmobility.ca',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84667ED1-1372-7975-6F97CD40347FC5CB','Fido','CA','Canada','1','@fido.ca',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8466BB0F-1372-7975-6F6ABCC0603EE274','MTS','CA','Canada','1','@text.mtsmobility.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8466DE85-1372-7975-6F261B5E9D329B92','Rogers','CA','Canada','1','@pcs.rogers.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8466FEFD-1372-7975-6F8EA4D54A0C57F3','SaskTel','CA','Canada','1','@sms.sasktel.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84672060-1372-7975-6F8456BEBA71E39A','Solo Mobile','CA','Canada','1','@txt.bell.ca',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84675A6C-1372-7975-6F496C2375ED2815','TELUS','CA','Canada','1','@msg.telus.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84677BCF-1372-7975-6F89C8D24436A08A','Virgin Canada','CA','Canada','1','@vmobile.ca',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8467A2B0-1372-7975-6FEB7589919DC435','O2','UK','United Kingdom','1','@mmail.co.uk',1)GO