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
ALTER TABLE `pt_project_users` ADD `file_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `file_add` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `file_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `issue_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `issue_add` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `issue_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `issue_accept` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `issue_comment` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `msg_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `msg_add` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `msg_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `msg_comment` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `mstone_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `mstone_add` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `mstone_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `mstone_comment` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `todolist_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `todolist_add` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `todolist_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `todo_add` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `todo_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `todo_comment` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `time_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `time_add` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `time_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `bill_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `bill_add` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `bill_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `bill_rates` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `bill_invoices` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `bill_markpaid` int(1) default NULL;
UPDATE `pt_project_users` set `file_view` = 0;
UPDATE `pt_project_users` set `file_add` = 0;
UPDATE `pt_project_users` set `file_edit` = 0;
UPDATE `pt_project_users` set `issue_view` = 0;
UPDATE `pt_project_users` set `issue_add` = 0;
UPDATE `pt_project_users` set `issue_edit` = 0;
UPDATE `pt_project_users` set `issue_accept` = 0;
UPDATE `pt_project_users` set `issue_comment` = 0;
UPDATE `pt_project_users` set `msg_view` = 0;
UPDATE `pt_project_users` set `msg_add` = 0;
UPDATE `pt_project_users` set `msg_edit` = 0;
UPDATE `pt_project_users` set `msg_comment` = 0;
UPDATE `pt_project_users` set `mstone_view` = 0;
UPDATE `pt_project_users` set `mstone_add` = 0;
UPDATE `pt_project_users` set `mstone_edit` = 0;
UPDATE `pt_project_users` set `mstone_comment` = 0;
UPDATE `pt_project_users` set `todolist_view` = 0;
UPDATE `pt_project_users` set `todolist_add` = 0;
UPDATE `pt_project_users` set `todolist_edit` = 0;
UPDATE `pt_project_users` set `todo_add` = 0;
UPDATE `pt_project_users` set `todo_edit` = 0;
UPDATE `pt_project_users` set `todo_comment` = 0;
UPDATE `pt_project_users` set `time_view` = 0;
UPDATE `pt_project_users` set `time_add` = 0;
UPDATE `pt_project_users` set `time_edit` = 0;
UPDATE `pt_project_users` set `bill_view` = 0;
UPDATE `pt_project_users` set `bill_add` = 0;
UPDATE `pt_project_users` set `bill_edit` = 0;
UPDATE `pt_project_users` set `bill_rates` = 0;
UPDATE `pt_project_users` set `bill_invoices` = 0;
UPDATE `pt_project_users` set `bill_markpaid` = 0;

/* pt_projects */
ALTER TABLE `pt_projects` ADD `logo_img` varchar(150) default NULL;
ALTER TABLE `pt_projects` ADD `tab_billing` int(1) default NULL;
UPDATE `pt_projects` set `tab_billing` = 0;
ALTER TABLE `pt_projects` ADD `issue_svn_link` int(1) default NULL;
UPDATE `pt_projects` set `issue_svn_link` = 1;
ALTER TABLE `pt_projects` ADD `issue_timetrack` int(1) default NULL;
UPDATE `pt_projects` set `issue_timetrack` = 1;

/* pt_settings */
INSERT INTO `pt_settings` values ('1E5ED63A-C938-2FE9-C60035D81F955266','company_name','');
INSERT INTO `pt_settings` values ('1E77669A-963D-735E-C7C22FA82FABC398','company_logo','');
INSERT INTO `pt_settings` values ('5D717D09-1372-7975-6F21844EACDAFC54','invoice_logo','');
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
