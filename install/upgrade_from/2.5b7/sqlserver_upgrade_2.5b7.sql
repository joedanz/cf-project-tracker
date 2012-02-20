/* UPGRADE FROM 2.5 beta 7 */

/* pt_projects - add new column */
ALTER TABLE [dbo].[pt_projects] ADD [reg_report] [tinyint] NULL
GO
UPDATE [dbo].[pt_projects] SET reg_report = 0
GO
