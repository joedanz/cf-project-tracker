/* UPGRADE FROM 2.3 */
/* pt_projects */
ALTER TABLE `pt_projects` ADD `tab_files` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_issues` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_msgs` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_mstones` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_todos` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_svn` int(1) default NULL;

/* pt_issues */
ALTER TABLE `pt_issues` ADD `componentID` varchar(35) default NULL;
ALTER TABLE `pt_issues` ADD `versionID` varchar(35) default NULL;

/*Table structure for table `pt_project_components` */

CREATE TABLE `pt_project_components` (
  `componentID` char(35) NOT NULL,
  `projectID` char(35) NOT NULL,
  `component` varchar(50) default NULL,
  PRIMARY KEY  (`componentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_project_versions` */

CREATE TABLE `pt_project_versions` (
  `versionID` char(35) NOT NULL,
  `projectID` char(35) NOT NULL,
  `version` varchar(50) default NULL,
  PRIMARY KEY  (`versionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;