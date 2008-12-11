/* UPGRADE FROM 2.3 */
/* pt_projects */
ALTER TABLE `pt_projects` ADD `tab_files` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_issues` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_msgs` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_mstones` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_todos` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_svn` int(1) default NULL;