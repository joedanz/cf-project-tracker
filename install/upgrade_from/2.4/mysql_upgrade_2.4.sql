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

/* pt_project_users */
ALTER TABLE `pt_project_users` ADD `billing` int(1) default NULL;
UPDATE `pt_project_users` set `billing` = 0;

/* pt_projects */
ALTER TABLE `pt_projects` ADD `tab_billing` int(1) default NULL;
UPDATE `pt_projects` set `tab_billing` = 0;
ALTER TABLE `pt_projects` ADD `issue_svn_link` int(1) default NULL;
UPDATE `pt_projects` set `issue_svn_link` = 1;

/* pt_timetrack */
ALTER TABLE `pt_timetrack` ADD `rateID` varchar(35) default NULL;