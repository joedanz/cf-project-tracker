/* UPGRADE FROM 2.5 beta 7 */

/* pt_projects - add new column */
ALTER TABLE `pt_projects` ADD `reg_report` int(1) default NULL;
UPDATE `pt_projects` set `reg_report` = 0;
