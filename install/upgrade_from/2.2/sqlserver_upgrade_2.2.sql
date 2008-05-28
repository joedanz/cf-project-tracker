ALTER TABLE [dbo].[pt_message_files] ADD [type] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
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

ALTER TABLE [dbo].[pt_file_attach] ALTER COLUMN [type] [nvarchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
GO

ALTER TABLE [dbo].[pt_file_attach] WITH NOCHECK ADD 
	CONSTRAINT [PK_pt_file_attach] PRIMARY KEY  CLUSTERED 
	(
		[itemID],[fileID],[type]
	)  ON [PRIMARY] 
GO