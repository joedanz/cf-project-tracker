/* UPGRADE FROM 2.5 */

/* pt_user_notify - add new columns for notification */
ALTER TABLE `pt_user_notify` ADD `email_todo_del` tinyint(1) default NULL;
ALTER TABLE `pt_user_notify` ADD `mobile_todo_del` tinyint(1) default NULL;
ALTER TABLE `pt_user_notify` ADD `email_todo_cmp` tinyint(1) default NULL;
ALTER TABLE `pt_user_notify` ADD `mobile_todo_cmp` tinyint(1) default NULL;
UPDATE `pt_user_notify` set `email_todo_del` = 0;
UPDATE `pt_user_notify` set `mobile_todo_del` = 0;
UPDATE `pt_user_notify` set `email_todo_cmp` = 0;
UPDATE `pt_user_notify` set `mobile_todo_cmp` = 0;
