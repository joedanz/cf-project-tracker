/* UPGRADE FROM 2.5 beta 6 */

/* pt_settings - add new settings */
INSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('89DDF566-1372-7975-6F192B9AFBDB218A','default_locale','English (US)')
GO
INSERT INTO [dbo].[pt_settings](settingID,setting,settingValue) values('89B9B664-1372-7975-6F7D802298571968','default_timezone','US/Eastern')
GO

/* pt_users - add new column */
ALTER TABLE [dbo].[pt_users] ADD [locale] [nvarchar] (32) NULL
GO
UPDATE [dbo].[pt_users] SET locale = 'English (US)'
GO
ALTER TABLE [dbo].[pt_users] ADD [timezone] [nvarchar] (32) NULL
GO
UPDATE [dbo].[pt_users] SET timezone = 'US/Eastern'
GO