/* UPGRADE FROM 2.3 */

/* pt_issues */
ALTER TABLE `pt_issues` ADD `componentID` varchar(35) default NULL;
ALTER TABLE `pt_issues` ADD `versionID` varchar(35) default NULL;
ALTER TABLE `pt_issues` ADD `dueDate` datetime default NULL;
ALTER TABLE `pt_issues` ADD `svnrevision` int(6) default NULL;

/* pt_project_components */
CREATE TABLE `pt_project_components` (
  `componentID` char(35) NOT NULL,
  `projectID` char(35) NOT NULL,
  `component` varchar(50) default NULL,
  PRIMARY KEY  (`componentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* pt_project_users */
ALTER TABLE `pt_project_users` ADD `timetrack` int(1) default NULL;
UPDATE `pt_project_users` set `timetrack` = 0;

/* pt_project_versions */
CREATE TABLE `pt_project_versions` (
  `versionID` char(35) NOT NULL,
  `projectID` char(35) NOT NULL,
  `version` varchar(50) default NULL,
  PRIMARY KEY  (`versionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* pt_projects */
ALTER TABLE `pt_projects` ADD `reg_time` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_files` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_issues` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_msgs` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_mstones` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_svn` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_time` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `tab_todos` int(1) default NULL;
UPDATE `pt_projects` set `reg_time` = 1;
UPDATE `pt_projects` set `tab_files` = 1;
UPDATE `pt_projects` set `tab_issues` = 1;
UPDATE `pt_projects` set `tab_msgs` = 1;
UPDATE `pt_projects` set `tab_mstones` = 1;
UPDATE `pt_projects` set `tab_svn` = 1;
UPDATE `pt_projects` set `tab_time` = 1;
UPDATE `pt_projects` set `tab_todos` = 1;

/* pt_timetrack */
CREATE TABLE `pt_timetrack` (
  `timetrackID` char(35) NOT NULL,
  `projectID` char(35) NOT NULL,
  `userID` char(35) NOT NULL,
  `dateStamp` datetime default NULL,  
  `hours` decimal(6,2) default NULL,  
  `description` varchar(255) default NULL,
  `itemID` varchar(35) default NULL,
  `itemType` varchar(10) default NULL,
  PRIMARY KEY  (`timetrackID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* pt_todolists */
ALTER TABLE `pt_todolists` ADD `timetrack` int(1) default NULL;
UPDATE `pt_todolists` set `timetrack` = 0;

/* pt_todos */
ALTER TABLE `pt_todos` MODIFY `task` varchar(300) default NULL;