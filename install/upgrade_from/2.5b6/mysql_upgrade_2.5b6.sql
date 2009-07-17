/* UPGRADE FROM 2.5 beta 6 */

/* pt_settings - add new settings */
INSERT INTO `pt_settings` values ('89DDF566-1372-7975-6F192B9AFBDB218A','default_locale','English (US)');
INSERT INTO `pt_settings` values ('89B9B664-1372-7975-6F7D802298571968','default_timezone','US/Eastern');

/* pt_timetrack - add new column */
ALTER TABLE `pt_users` ADD `locale` varchar(32) default NULL;
UPDATE `pt_users` set `locale` = 'English (US)';
ALTER TABLE `pt_users` ADD `timezone` varchar(32) default NULL;
UPDATE `pt_users` set `timezone` = 'US/Eastern';
