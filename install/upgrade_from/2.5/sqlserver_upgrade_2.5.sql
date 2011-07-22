/* UPGRADE FROM 2.5 */

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