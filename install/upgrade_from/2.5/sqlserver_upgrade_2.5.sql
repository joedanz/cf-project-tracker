/* UPGRADE FROM 2.5 */

/* pt_issues */
ALTER TABLE [dbo].[pt_issues] ADD [googlecalID] [nvarchar] (500) NULL
GO

/* pt_milestones */
ALTER TABLE [dbo].[pt_milestones] ADD [googlecalID] [nvarchar] (500) NULL
GO

/* pt_projects */
ALTER TABLE [dbo].[pt_projects] ADD [googlecal] [nvarchar] (200) NULL
GO

/* pt_settings */
INSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('3CB6A28B-78E7-D183-3355FDC2AD339924','googlecal_enable','0')
GO
INSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('3CB6A28C-78E7-D183-33556DE390587F08','googlecal_user','')
GO
INSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('3CB6A28D-78E7-D183-335507D438CAEB30','googlecal_pass','')
GO
INSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('424E6B2F-78E7-D183-3355A1D332D34969','googlecal_timezone','US/Eastern')
GO
INSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('3CB6A28E-78E7-D183-33550BDFD7405ECF','googlecal_offset','-5')
GO

/* pt_todos */
ALTER TABLE [dbo].[pt_todos] ADD [googlecalID] [nvarchar] (500) NULL
GO

/* pt_user_notify - add new columns for notification */
ALTER TABLE [dbo].[pt_user_notify] ADD [email_todo_del] [tinyint] NULL
GO
UPDATE [dbo].[pt_user_notify] SET email_todo_del = 0
GO
ALTER TABLE [dbo].[pt_user_notify] ADD [mobile_todo_del] [tinyint] NULL
GO
UPDATE [dbo].[pt_user_notify] SET mobile_todo_del = 0
GO
ALTER TABLE [dbo].[pt_user_notify] ADD [email_todo_cmp] [tinyint] NULL
GO
UPDATE [dbo].[pt_user_notify] SET email_todo_cmp = 0
GO
ALTER TABLE [dbo].[pt_user_notify] ADD [mobile_todo_cmp] [tinyint] NULL
GO
UPDATE [dbo].[pt_user_notify] SET mobile_todo_cmp = 0
GO