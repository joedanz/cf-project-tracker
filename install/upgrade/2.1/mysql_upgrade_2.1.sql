/* UPGRADE FROM 2.1 */
/* pt_projects */
ALTER TABLE `pt_projects` ADD `allow_reg` tinyint(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_active` tinyint(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_files` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_issues` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_msgs` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_mstones` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_todos` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_svn` int(1) default NULL;

update `pt_projects` 
	set `allow_reg` = 0 ,
		`reg_active` = 1 ,
		`reg_files` = 1 ,
		`reg_issues` = 1 ,
		`reg_msgs` = 1 ,
		`reg_mstones` = 1,
		`reg_todos` = 1,
		`reg_svn` = 1;
