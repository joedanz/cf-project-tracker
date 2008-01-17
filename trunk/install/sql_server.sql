if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_activity]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_activity]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_carriers]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_carriers]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_comments]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_comments]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_files]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_files]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_issues]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_issues]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_message_notify]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_message_notify]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_messages]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_messages]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_milestones]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_milestones]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_project_users]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_project_users]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_projects]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_projects]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_settings]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_settings]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_todolists]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_todolists]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_todos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_todos]GOif exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pt_users]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)drop table [dbo].[pt_users]GOCREATE TABLE [dbo].[pt_activity] (	[activityID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[userID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[type] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[id] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[activity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[stamp] [datetime] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_carriers] (	[carrierID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[carrier] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[countryCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[country] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[prefix] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[suffix] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[active] [bit] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_comments] (	[commentID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[messageID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[issueID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[userID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[comment] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[stamp] [datetime] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_files] (	[fileID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[title] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[category] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[filename] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[serverfilename] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[filetype] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[filesize] [bigint] NULL ,	[uploaded] [datetime] NULL ,	[uploadedBy] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_issues] (	[issueID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[shortID] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[issue] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[detail] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[type] [varchar] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[severity] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[status] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[relevantURL] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[created] [datetime] NULL ,	[createdBy] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[assignedTo] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[updated] [datetime] NULL ,	[updatedBy] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_message_notify] (	[messageID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[projectID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[userID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_messages] (	[messageID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[milestoneID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[userID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[title] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[message] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[category] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[allowcomments] [bit] NULL ,	[stamp] [datetime] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_milestones] (	[milestoneID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[userID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[forID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[description] [varchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[dueDate] [datetime] NULL ,	[completed] [datetime] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_project_users] (	[userID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[role] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_projects] (	[projectID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[display] [bit] NULL ,	[ticketPrefix] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[added] [datetime] NULL ,	[addedBy] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[status] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[svnurl] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[svnuser] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[svnpass] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_settings] (	[settingID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[setting] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[settingValue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_todolists] (	[todolistID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[projectID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[title] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[description] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[milestoneID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[userID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[added] [datetime] NULL ,	[rank] [tinyint] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_todos] (	[todoID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[todolistID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[projectID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[userID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[task] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[rank] [int] NULL ,	[added] [datetime] NULL ,	[completed] [datetime] NULL ,	[svnrevision] [int] NULL ) ON [PRIMARY]GOCREATE TABLE [dbo].[pt_users] (	[userID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,	[firstName] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[lastName] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[username] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[password] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[email] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[phone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[mobile] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[carrierID] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[lastLogin] [datetime] NULL ,	[avatar] [bit] NULL ,	[style] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,	[email_files] [bit] NULL ,	[mobile_files] [bit] NULL ,	[email_issues] [bit] NULL ,	[mobile_issues] [bit] NULL ,	[email_msgs] [bit] NULL ,	[mobile_msgs] [bit] NULL ,	[email_mstones] [bit] NULL ,	[mobile_mstones] [bit] NULL ,	[email_todos] [bit] NULL ,	[mobile_todos] [bit] NULL ,	[admin] [bit] NULL ,	[active] [bit] NULL ) ON [PRIMARY]GOALTER TABLE [dbo].[pt_settings] WITH NOCHECK ADD 	CONSTRAINT [PK_pt_settings] PRIMARY KEY  CLUSTERED 	(		[settingID]	)  ON [PRIMARY] GOINSERT INTO [dbo].[pt_users](userID,firstName,lastName,username,password,style,email_todos,mobile_todos,email_mstones,mobile_mstones,email_issues,mobile_issues,avatar,admin,active) values('FCDCF4CD-16E6-58DE-13EDC6A2B362B22C','Admin','User','admin','admin','blue',0,0,0,0,0,0,0,1,1)GOINSERT INTO [dbo].[pt_users](userID,firstName,lastName,username,password,style,email_todos,mobile_todos,email_mstones,mobile_mstones,email_issues,mobile_issues,avatar,admin,active) values('7F16CA08-1372-7975-6F7F9DA33EBD6A09','Guest','User','guest','guest','blue',0,0,0,0,0,0,0,0,1)GOINSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('FC3D187C-16E6-58DE-133C5098C58225D3','app_title','Project Tracker')GOINSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('FC3D861A-16E6-58DE-1346E4E01F578F52','default_style','blue')GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8464AB28-1372-7975-6F2E9747CA6E4693','AT&T','US','United States','1','@txt.att.net',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8464DE00-1372-7975-6FE886FCD149E667','Boost','US','United States','1','@myboostmobile.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84653DF3-1372-7975-6F03DA67DD9FB6A9','Cingular','US','United States','1','@txt.att.net',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('846562C1-1372-7975-6F0D79371C491F0C','Helio','US','United States','1','@messaging.sprintpcs.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('846589B2-1372-7975-6F34C8F27502E0DE','Nextel','US','United States','1','@messaging.nextel.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8465AECE-1372-7975-6FAEBDD9F3DDB156','Sprint','US','United States','1','@messaging.sprintpcs.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('846F02F5-1372-7975-6F6C106050F904CD','T-Mobile','US','United States','1','@tmomail.net',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8465D060-1372-7975-6F83333D63966358','Verizon','US','United States','1','@vtext.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8465FEC3-1372-7975-6F5CA6C75C25C7D4','Virgin USA','US','United States','1','@vmobl.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84662779-1372-7975-6F8F1751F5B64D4E','Aliant Mobility','CA','Canada','1','@chat.wirefree.ca',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('846652B0-1372-7975-6F46C791E680C346','Bell Mobility','CA','Canada','1','@txt.bellmobility.ca',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84667ED1-1372-7975-6F97CD40347FC5CB','Fido','CA','Canada','1','@fido.ca',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8466BB0F-1372-7975-6F6ABCC0603EE274','MTS','CA','Canada','1','@text.mtsmobility.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8466DE85-1372-7975-6F261B5E9D329B92','Rogers','CA','Canada','1','@pcs.rogers.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8466FEFD-1372-7975-6F8EA4D54A0C57F3','SaskTel','CA','Canada','1','@sms.sasktel.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84672060-1372-7975-6F8456BEBA71E39A','Solo Mobile','CA','Canada','1','@txt.bell.ca',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84675A6C-1372-7975-6F496C2375ED2815','TELUS','CA','Canada','1','@msg.telus.com',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84677BCF-1372-7975-6F89C8D24436A08A','Virgin Canada','CA','Canada','1','@vmobile.ca',1)GOINSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8467A2B0-1372-7975-6FEB7589919DC435','O2','UK','United Kingdom','1','@mmail.co.uk',1)GO