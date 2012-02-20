ALTER TABLE [dbo].[pt_message_files] ADD [type] [nvarchar] (6) NULL
GO

EXEC sp_rename 'pt_message_files.[messageID]', 'itemID', 'COLUMN'
GO

UPDATE [dbo].[pt_message_files] 
	SET [type] = 'msg'
GO

EXEC sp_rename 'pt_message_files', 'pt_file_attach';
GO

ALTER TABLE pt_file_attach DROP CONSTRAINT PK_pt_message_files
GO

ALTER TABLE [dbo].[pt_file_attach] ALTER COLUMN [type] [nvarchar] (6) NOT NULL
GO

ALTER TABLE [dbo].[pt_file_attach] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_file_attach] PRIMARY KEY  CLUSTERED 
	(
		[itemID],[fileID],[type]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[pt_screenshots] (
	[fileID] [char] (35) NOT NULL ,
	[issueID] [char] (35) NOT NULL ,
	[title] [nvarchar] (200) NULL ,
	[description] [ntext] NULL ,
	[filename] [nvarchar] (150) NULL ,
	[serverfilename] [nvarchar] (150) NULL ,
	[filetype] [nvarchar] (4) NULL ,
	[filesize] [bigint] NULL ,
	[uploaded] [datetime] NULL ,
	[uploadedBy] [char] (35) NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[pt_screenshots] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_screenshots] PRIMARY KEY  CLUSTERED 
	(
		[fileID]
	)  ON [PRIMARY] 
GO