/* UPGRADE FROM 2.4 */

/* pt_client_rates */
CREATE TABLE `pt_client_rates` (
  `rateID` char(35) NOT NULL,
  `clientID` char(35) NOT NULL,
  `category` varchar(150) default NULL,
  `rate` decimal(6,2) default NULL,  
  PRIMARY KEY  (`rateID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* pt_clients */
ALTER TABLE `pt_clients` ADD `contactEmail` varchar(150) default NULL;
ALTER TABLE `pt_clients` ADD `website` varchar(150) default NULL;

/* pt_milestones */
ALTER TABLE `pt_milestones` ADD `rate` decimal(8,2) default NULL;
ALTER TABLE `pt_milestones` ADD `billed` tinyint(1) default NULL;
UPDATE `pt_milestones` set `billed` = 0;
ALTER TABLE `pt_milestones` ADD `paid` tinyint(1) default NULL;
UPDATE `pt_milestones` set `paid` = 0;

/* pt_project_users */
ALTER TABLE `pt_project_users` ADD `billing` int(1) default NULL;
UPDATE `pt_project_users` set `billing` = 0;

/* pt_projects */
ALTER TABLE `pt_projects` ADD `tab_billing` int(1) default NULL;
UPDATE `pt_projects` set `tab_billing` = 0;
ALTER TABLE `pt_projects` ADD `issue_svn_link` int(1) default NULL;
UPDATE `pt_projects` set `issue_svn_link` = 1;
ALTER TABLE `pt_projects` ADD `issue_timetrack` int(1) default NULL;
UPDATE `pt_projects` set `issue_timetrack` = 1;

/* pt_settings */
INSERT INTO `pt_settings` values ('1E5ED63A-C938-2FE9-C60035D81F955266','company_name','');
INSERT INTO `pt_settings` values ('1E77669A-963D-735E-C7C22FA82FABC398','company_logo','');
INSERT INTO `pt_settings` values ('3D72D1F7-CD23-8BE3-60F9614093F89CCF','hourly_rate','');

/* pt_timetrack */
ALTER TABLE `pt_timetrack` ADD `rateID` varchar(35) default NULL;
ALTER TABLE `pt_timetrack` ADD `billed` tinyint(1) default NULL;
UPDATE `pt_timetrack` set `billed` = 0;
ALTER TABLE `pt_timetrack` ADD `paid` tinyint(1) default NULL;
UPDATE `pt_timetrack` set `paid` = 0;

/* pt_user_notify */
CREATE TABLE `pt_user_notify` (
  `userID` char(35) NOT NULL,
  `projectID` char(35) NOT NULL,
  `email_files` tinyint(1) default NULL,
  `mobile_files` tinyint(1) default NULL,
  `email_issues` tinyint(1) default NULL,
  `mobile_issues` tinyint(1) default NULL,
  `email_msgs` tinyint(1) default NULL,
  `mobile_msgs` tinyint(1) default NULL,
  `email_mstones` tinyint(1) default NULL,
  `mobile_mstones` tinyint(1) default NULL,
  `email_todos` tinyint(1) default NULL,
  `mobile_todos` tinyint(1) default NULL,
  PRIMARY KEY  (`userID`,`projectID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
