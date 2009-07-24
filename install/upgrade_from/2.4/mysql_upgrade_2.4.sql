/* UPGRADE FROM 2.4 */

/* pt_client_rates - add table + index */
CREATE TABLE `pt_client_rates` (
  `rateID` char(35) NOT NULL,
  `clientID` char(35) default NULL,
  `category` varchar(150) default NULL,
  `rate` decimal(6,2) default NULL,  
  PRIMARY KEY  (`rateID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* pt_clients - add columns */
ALTER TABLE `pt_clients` ADD `contactEmail` varchar(150) default NULL;
ALTER TABLE `pt_clients` ADD `website` varchar(150) default NULL;

/* pt_milestones - add columns */
ALTER TABLE `pt_milestones` ADD `rate` decimal(8,2) default NULL;
ALTER TABLE `pt_milestones` ADD `billed` tinyint(1) default NULL;
UPDATE `pt_milestones` set `billed` = 0;
ALTER TABLE `pt_milestones` ADD `paid` tinyint(1) default NULL;
UPDATE `pt_milestones` set `paid` = 0;

/* pt_project_users - add fine grained permissions and default everything to off */
ALTER TABLE `pt_project_users` ADD `file_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `file_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `file_comment` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `issue_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `issue_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `issue_assign` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `issue_resolve` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `issue_close` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `issue_comment` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `msg_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `msg_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `msg_comment` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `mstone_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `mstone_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `mstone_comment` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `todolist_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `todolist_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `todo_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `todo_comment` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `time_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `time_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `bill_view` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `bill_edit` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `bill_rates` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `bill_invoices` int(1) default NULL;
ALTER TABLE `pt_project_users` ADD `bill_markpaid` int(1) default NULL;
UPDATE `pt_project_users` set `file_view` = 0;
UPDATE `pt_project_users` set `file_edit` = 0;
UPDATE `pt_project_users` set `file_comment` = 0;
UPDATE `pt_project_users` set `issue_view` = 0;
UPDATE `pt_project_users` set `issue_edit` = 0;
UPDATE `pt_project_users` set `issue_assign` = 0;
UPDATE `pt_project_users` set `issue_resolve` = 0;
UPDATE `pt_project_users` set `issue_close` = 0;
UPDATE `pt_project_users` set `issue_comment` = 0;
UPDATE `pt_project_users` set `msg_view` = 0;
UPDATE `pt_project_users` set `msg_edit` = 0;
UPDATE `pt_project_users` set `msg_comment` = 0;
UPDATE `pt_project_users` set `mstone_view` = 0;
UPDATE `pt_project_users` set `mstone_edit` = 0;
UPDATE `pt_project_users` set `mstone_comment` = 0;
UPDATE `pt_project_users` set `todolist_view` = 0;
UPDATE `pt_project_users` set `todolist_edit` = 0;
UPDATE `pt_project_users` set `todo_edit` = 0;
UPDATE `pt_project_users` set `todo_comment` = 0;
UPDATE `pt_project_users` set `time_view` = 0;
UPDATE `pt_project_users` set `time_edit` = 0;
UPDATE `pt_project_users` set `bill_view` = 0;
UPDATE `pt_project_users` set `bill_edit` = 0;
UPDATE `pt_project_users` set `bill_rates` = 0;
UPDATE `pt_project_users` set `bill_invoices` = 0;
UPDATE `pt_project_users` set `bill_markpaid` = 0;

/* pt_projects - add new columns + columns for default permissions */
ALTER TABLE `pt_projects` ADD `logo_img` varchar(150) default NULL;
ALTER TABLE `pt_projects` ADD `tab_billing` int(1) default NULL;
UPDATE `pt_projects` set `tab_billing` = 0;
ALTER TABLE `pt_projects` ADD `issue_svn_link` int(1) default NULL;
UPDATE `pt_projects` set `issue_svn_link` = 1;
ALTER TABLE `pt_projects` ADD `issue_timetrack` int(1) default NULL;
UPDATE `pt_projects` set `issue_timetrack` = 1;
ALTER TABLE `pt_projects` ADD `reg_file_view` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_file_edit` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_file_comment` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_issue_view` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_issue_edit` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_issue_assign` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_issue_resolve` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_issue_close` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_issue_comment` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_msg_view` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_msg_edit` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_msg_comment` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_mstone_view` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_mstone_edit` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_mstone_comment` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_todolist_view` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_todolist_edit` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_todo_edit` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_todo_comment` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_time_view` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_time_edit` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_bill_view` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_bill_edit` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_bill_rates` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_bill_invoices` int(1) default NULL;
ALTER TABLE `pt_projects` ADD `reg_bill_markpaid` int(1) default NULL;

/* pt_settings - add new settings */
INSERT INTO `pt_settings` values ('1E5ED63A-C938-2FE9-C60035D81F955266','company_name','');
INSERT INTO `pt_settings` values ('1E77669A-963D-735E-C7C22FA82FABC398','company_logo','');
INSERT INTO `pt_settings` values ('5D717D09-1372-7975-6F21844EACDAFC54','invoice_logo','');
INSERT INTO `pt_settings` values ('89DDF566-1372-7975-6F192B9AFBDB218A','default_locale','English (US)');
INSERT INTO `pt_settings` values ('89B9B664-1372-7975-6F7D802298571968','default_timezone','US/Eastern');

/* pt_timetrack - add new columns */
ALTER TABLE `pt_timetrack` ADD `rateID` varchar(35) default NULL;
ALTER TABLE `pt_timetrack` ADD `billed` tinyint(1) default NULL;
UPDATE `pt_timetrack` set `billed` = 0;
ALTER TABLE `pt_timetrack` ADD `paid` tinyint(1) default NULL;
UPDATE `pt_timetrack` set `paid` = 0;

/* pt_user_notify - add per project notifications table + index */
CREATE TABLE `pt_user_notify` (
  `userID` char(35) NOT NULL,
  `projectID` char(35) NOT NULL,
  `email_file_new` tinyint(1) default NULL,
  `mobile_file_new` tinyint(1) default NULL,
  `email_file_upd` tinyint(1) default NULL,
  `mobile_file_upd` tinyint(1) default NULL,
  `email_file_com` tinyint(1) default NULL,
  `mobile_file_com` tinyint(1) default NULL,
  `email_issue_new` tinyint(1) default NULL,
  `mobile_issue_new` tinyint(1) default NULL,
  `email_issue_upd` tinyint(1) default NULL,
  `mobile_issue_upd` tinyint(1) default NULL,
  `email_issue_com` tinyint(1) default NULL,
  `mobile_issue_com` tinyint(1) default NULL,
  `email_msg_new` tinyint(1) default NULL,
  `mobile_msg_new` tinyint(1) default NULL,
  `email_msg_upd` tinyint(1) default NULL,
  `mobile_msg_upd` tinyint(1) default NULL,
  `email_msg_com` tinyint(1) default NULL,
  `mobile_msg_com` tinyint(1) default NULL,
  `email_mstone_new` tinyint(1) default NULL,
  `mobile_mstone_new` tinyint(1) default NULL,
  `email_mstone_upd` tinyint(1) default NULL,
  `mobile_mstone_upd` tinyint(1) default NULL,
  `email_mstone_com` tinyint(1) default NULL,
  `mobile_mstone_com` tinyint(1) default NULL,
  `email_todo_new` tinyint(1) default NULL,
  `mobile_todo_new` tinyint(1) default NULL,
  `email_todo_upd` tinyint(1) default NULL,
  `mobile_todo_upd` tinyint(1) default NULL,
  `email_todo_com` tinyint(1) default NULL,
  `mobile_todo_com` tinyint(1) default NULL,
  `email_time_new` tinyint(1) default NULL,
  `mobile_time_new` tinyint(1) default NULL,
  `email_time_upd` tinyint(1) default NULL,
  `mobile_time_upd` tinyint(1) default NULL,
  `email_bill_new` tinyint(1) default NULL,
  `mobile_bill_new` tinyint(1) default NULL,
  `email_bill_upd` tinyint(1) default NULL,
  `mobile_bill_upd` tinyint(1) default NULL,
  `email_bill_paid` tinyint(1) default NULL,
  `mobile_bill_paid` tinyint(1) default NULL,
  PRIMARY KEY  (`userID`,`projectID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* pt_users - add new columns */
ALTER TABLE `pt_users` ADD `locale` varchar(32) default NULL;
UPDATE `pt_users` set `locale` = 'English (US)';
ALTER TABLE `pt_users` ADD `timezone` varchar(32) default NULL;
UPDATE `pt_users` set `timezone` = 'US/Eastern';
ALTER TABLE `pt_users` ADD `report` tinyint(1) default NULL;
UPDATE `pt_users` set `report` = 0;
ALTER TABLE `pt_users` ADD `invoice` tinyint(1) default NULL;
UPDATE `pt_users` set `invoice` = 0;
