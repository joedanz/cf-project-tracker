/* UPGRADE FROM 2.5 */

/* pt_issues */
ALTER TABLE `pt_issues` ADD `googlecalID` varchar(500) default NULL;

/* pt_milestones */
ALTER TABLE `pt_milestones` ADD `googlecalID` varchar(500) default NULL;

/* pt_projects */
ALTER TABLE `pt_projects` ADD `googlecal` varchar(200) default NULL;

/* pt_settings */
INSERT INTO `pt_settings` values ('3CB6A28B-78E7-D183-3355FDC2AD339924','googlecal_enable','0');
INSERT INTO `pt_settings` values ('3CB6A28C-78E7-D183-33556DE390587F08','googlecal_user','');
INSERT INTO `pt_settings` values ('3CB6A28D-78E7-D183-335507D438CAEB30','googlecal_pass','');
INSERT INTO `pt_settings` values ('424E6B2F-78E7-D183-3355A1D332D34969','googlecal_timezone','US/Eastern');
INSERT INTO `pt_settings` values ('3CB6A28E-78E7-D183-33550BDFD7405ECF','googlecal_offset','-5');

/* pt_todos */
ALTER TABLE `pt_todos` ADD `googlecalID` varchar(500) default NULL;

/* pt_user_notify - add new columns for notification */
ALTER TABLE `pt_user_notify` ADD `email_todo_del` tinyint(1) default NULL;
ALTER TABLE `pt_user_notify` ADD `mobile_todo_del` tinyint(1) default NULL;
ALTER TABLE `pt_user_notify` ADD `email_todo_cmp` tinyint(1) default NULL;
ALTER TABLE `pt_user_notify` ADD `mobile_todo_cmp` tinyint(1) default NULL;
UPDATE `pt_user_notify` set `email_todo_del` = 0;
UPDATE `pt_user_notify` set `mobile_todo_del` = 0;
UPDATE `pt_user_notify` set `email_todo_cmp` = 0;
UPDATE `pt_user_notify` set `mobile_todo_cmp` = 0;
