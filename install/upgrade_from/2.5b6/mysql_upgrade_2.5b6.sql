/* UPGRADE FROM 2.5 beta 6 */

/* pt_project_users - add new column */
ALTER TABLE `pt_project_users` ADD `report` int(1) default NULL;
UPDATE `pt_project_users` set `report` = 0;

/* pt_projects - add new column */
ALTER TABLE `pt_projects` ADD `allow_def_rates` tinyint(1) default NULL;
UPDATE `pt_projects` set `allow_def_rates` = 1;

/* pt_settings - add new settings */
INSERT INTO `pt_settings` values ('89DDF566-1372-7975-6F192B9AFBDB218A','default_locale','English (US)');
INSERT INTO `pt_settings` values ('89B9B664-1372-7975-6F7D802298571968','default_timezone','US/Eastern');

/* pt_users - add new column */
ALTER TABLE `pt_users` ADD `locale` varchar(32) default NULL;
UPDATE `pt_users` set `locale` = 'English (US)';
ALTER TABLE `pt_users` ADD `timezone` varchar(32) default NULL;
UPDATE `pt_users` set `timezone` = 'US/Eastern';
ALTER TABLE `pt_users` ADD `report` tinyint(1) default NULL;
UPDATE `pt_users` set `report` = 0;
ALTER TABLE `pt_users` ADD `invoice` tinyint(1) default NULL;
UPDATE `pt_users` set `invoice` = 0;
