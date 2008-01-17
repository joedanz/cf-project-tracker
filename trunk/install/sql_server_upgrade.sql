/* UPGRADE FROM BETA */
ALTER TABLE [dbo].[pt_project_users] ALTER COLUMN [role] [nvarchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

/* UPGRADE FROM 1.0 */
ALTER TABLE [dbo].[pt_comments] ALTER COLUMN [comment] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_files] ALTER COLUMN [description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_issues] ALTER COLUMN [detail] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_messages] ALTER COLUMN [message] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_milestones] ALTER COLUMN [description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_projects] ALTER COLUMN [description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_todolists] ALTER COLUMN [description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_todos] ALTER COLUMN [task] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
INSERT INTO [dbo].[pt_users](userID,firstName,lastName,username,password,style,email_todos,mobile_todos,email_mstones,mobile_mstones,email_issues,mobile_issues,avatar,admin,active) values('7F16CA08-1372-7975-6F7F9DA33EBD6A09','Guest','User','guest','guest','blue',0,0,0,0,0,0,0,0,1)
GO
ALTER TABLE [dbo].[pt_users] ADD [mobile] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [carrierID] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [email_files] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [mobile_files] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [email_issues] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [mobile_issues] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [email_msgs] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [mobile_msgs] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [email_mstones] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [mobile_mstones] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [email_todos] [bit] NULL
GO
ALTER TABLE [dbo].[pt_users] ADD [mobile_todos] [bit] NULL
GO
UPDATE [dbo].[pt_users] 
	SET [email_files] = 1 ,
		[mobile_files] = 1 ,
		[email_issues] = 1 ,
		[mobile_issues] = 1 ,
		[email_msgs] = 1 ,
		[mobile_msgs] = 1 ,
		[email_mstones] = 1 ,
		[mobile_mstones] = 1 ,
		[email_todos] = 1 ,
		[mobile_todos] = 1
GO

ALTER TABLE [dbo].[pt_activity] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_activity] PRIMARY KEY  CLUSTERED 
	(
		[activityID]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[pt_comments] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_comments] PRIMARY KEY  CLUSTERED 
	(
		[commentID]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[pt_files] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_files] PRIMARY KEY  CLUSTERED 
	(
		[fileID]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[pt_issues] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_issues] PRIMARY KEY  CLUSTERED 
	(
		[issueID]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[pt_message_notify] ALTER COLUMN [messageID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO
ALTER TABLE [dbo].[pt_message_notify] ALTER COLUMN [projectID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO
ALTER TABLE [dbo].[pt_message_notify] ALTER COLUMN [userID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO
ALTER TABLE [dbo].[pt_message_notify] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_message_notify] PRIMARY KEY  CLUSTERED 
	(
		[messageID],[projectID],[userID]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[pt_messages] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_messages] PRIMARY KEY  CLUSTERED 
	(
		[messageID]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[pt_milestones] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_milestones] PRIMARY KEY  CLUSTERED 
	(
		[milestoneID]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[pt_project_users] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_project_users] PRIMARY KEY  CLUSTERED 
	(
		[userID],[projectID]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[pt_projects] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_projects] PRIMARY KEY  CLUSTERED 
	(
		[projectID]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[pt_todolists] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_todolists] PRIMARY KEY  CLUSTERED 
	(
		[todolistID]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[pt_todos] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_todos] PRIMARY KEY  CLUSTERED 
	(
		[todoID]
	)  ON [PRIMARY] 
GO
ALTER TABLE [dbo].[pt_users] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_users] PRIMARY KEY  CLUSTERED 
	(
		[userID]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[pt_carriers] (
	[carrierID] [char] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[carrier] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[countryCode] [nvarchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[country] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[prefix] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[suffix] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[active] [bit] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[pt_carriers] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_carriers] PRIMARY KEY  CLUSTERED 
	(
		[carrierID]
	)  ON [PRIMARY] 
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8464AB28-1372-7975-6F2E9747CA6E4693','AT&T','US','United States','1','@txt.att.net',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8464DE00-1372-7975-6FE886FCD149E667','Boost','US','United States','1','@myboostmobile.com',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84653DF3-1372-7975-6F03DA67DD9FB6A9','Cingular','US','United States','1','@txt.att.net',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('846562C1-1372-7975-6F0D79371C491F0C','Helio','US','United States','1','@messaging.sprintpcs.com',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('846589B2-1372-7975-6F34C8F27502E0DE','Nextel','US','United States','1','@messaging.nextel.com',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8465AECE-1372-7975-6FAEBDD9F3DDB156','Sprint','US','United States','1','@messaging.sprintpcs.com',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('846F02F5-1372-7975-6F6C106050F904CD','T-Mobile','US','United States','1','@tmomail.net',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8465D060-1372-7975-6F83333D63966358','Verizon','US','United States','1','@vtext.com',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8465FEC3-1372-7975-6F5CA6C75C25C7D4','Virgin USA','US','United States','1','@vmobl.com',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84662779-1372-7975-6F8F1751F5B64D4E','Aliant Mobility','CA','Canada','1','@chat.wirefree.ca',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('846652B0-1372-7975-6F46C791E680C346','Bell Mobility','CA','Canada','1','@txt.bellmobility.ca',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84667ED1-1372-7975-6F97CD40347FC5CB','Fido','CA','Canada','1','@fido.ca',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8466BB0F-1372-7975-6F6ABCC0603EE274','MTS','CA','Canada','1','@text.mtsmobility.com',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8466DE85-1372-7975-6F261B5E9D329B92','Rogers','CA','Canada','1','@pcs.rogers.com',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8466FEFD-1372-7975-6F8EA4D54A0C57F3','SaskTel','CA','Canada','1','@sms.sasktel.com',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84672060-1372-7975-6F8456BEBA71E39A','Solo Mobile','CA','Canada','1','@txt.bell.ca',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84675A6C-1372-7975-6F496C2375ED2815','TELUS','CA','Canada','1','@msg.telus.com',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('84677BCF-1372-7975-6F89C8D24436A08A','Virgin Canada','CA','Canada','1','@vmobile.ca',1)
GO
INSERT INTO [dbo].[pt_carriers](carrierID,carrier,countryCode,country,prefix,suffix,active) values('8467A2B0-1372-7975-6FEB7589919DC435','O2','UK','United Kingdom','1','@mmail.co.uk',1)
GO
