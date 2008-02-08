/** IF YOU RECEIVE ERRORS, YOU MAY NEED TO REMOVE PRIMARY KEYS BEFORE ALTERING COLUMNS **/
/* UPGRADE FROM BETA */
ALTER TABLE `pt_project_users` MODIFY `role` varchar(9) default NULL;

/* UPGRADE FROM 1.0 */
/* pt_activity */
ALTER TABLE `pt_activity` MODIFY `activityID` char(35) NOT NULL;
ALTER TABLE `pt_activity` MODIFY `projectID` char(35) NOT NULL;
ALTER TABLE `pt_activity` MODIFY `userID` char(35) NOT NULL;
ALTER TABLE `pt_activity` MODIFY `id` char(35) NOT NULL;

/* pt_carriers */
CREATE TABLE `pt_carriers` (
  `carrierID` char(35) NOT NULL,
  `carrier` varchar(20) default NULL,
  `countryCode` varchar(2) default NULL,
  `country` varchar(20) default NULL,
  `prefix` varchar(3) default NULL,
  `suffix` varchar(40) default NULL,
  `active` tinyint(1) default NULL,
  PRIMARY KEY  (`carrierID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `pt_carriers` values('8464AB28-1372-7975-6F2E9747CA6E4693','AT&T','US','United States','1','@txt.att.net',1);
INSERT INTO `pt_carriers` values('8464DE00-1372-7975-6FE886FCD149E667','Boost','US','United States','1','@myboostmobile.com',1);
INSERT INTO `pt_carriers` values('84653DF3-1372-7975-6F03DA67DD9FB6A9','Cingular','US','United States','1','@txt.att.net',1);
INSERT INTO `pt_carriers` values('846562C1-1372-7975-6F0D79371C491F0C','Helio','US','United States','1','@messaging.sprintpcs.com',1);
INSERT INTO `pt_carriers` values('846589B2-1372-7975-6F34C8F27502E0DE','Nextel','US','United States','1','@messaging.nextel.com',1);
INSERT INTO `pt_carriers` values('8465AECE-1372-7975-6FAEBDD9F3DDB156','Sprint','US','United States','1','@messaging.sprintpcs.com',1);
INSERT INTO `pt_carriers` values('846F02F5-1372-7975-6F6C106050F904CD','T-Mobile','US','United States','1','@tmomail.net',1);
INSERT INTO `pt_carriers` values('8465D060-1372-7975-6F83333D63966358','Verizon','US','United States','1','@vtext.com',1);
INSERT INTO `pt_carriers` values('8465FEC3-1372-7975-6F5CA6C75C25C7D4','Virgin USA','US','United States','1','@vmobl.com',1);
INSERT INTO `pt_carriers` values('84662779-1372-7975-6F8F1751F5B64D4E','Aliant Mobility','CA','Canada','1','@chat.wirefree.ca',1);
INSERT INTO `pt_carriers` values('846652B0-1372-7975-6F46C791E680C346','Bell Mobility','CA','Canada','1','@txt.bellmobility.ca',1);
INSERT INTO `pt_carriers` values('84667ED1-1372-7975-6F97CD40347FC5CB','Fido','CA','Canada','1','@fido.ca',1);
INSERT INTO `pt_carriers` values('8466BB0F-1372-7975-6F6ABCC0603EE274','MTS','CA','Canada','1','@text.mtsmobility.com',1);
INSERT INTO `pt_carriers` values('8466DE85-1372-7975-6F261B5E9D329B92','Rogers','CA','Canada','1','@pcs.rogers.com',1);
INSERT INTO `pt_carriers` values('8466FEFD-1372-7975-6F8EA4D54A0C57F3','SaskTel','CA','Canada','1','@sms.sasktel.com',1);
INSERT INTO `pt_carriers` values('84672060-1372-7975-6F8456BEBA71E39A','Solo Mobile','CA','Canada','1','@txt.bell.ca',1);
INSERT INTO `pt_carriers` values('84675A6C-1372-7975-6F496C2375ED2815','TELUS','CA','Canada','1','@msg.telus.com',1);
INSERT INTO `pt_carriers` values('84677BCF-1372-7975-6F89C8D24436A08A','Virgin Canada','CA','Canada','1','@vmobile.ca',1);
INSERT INTO `pt_carriers` values('8467A2B0-1372-7975-6FEB7589919DC435','O2','UK','United Kingdom','1','@mmail.co.uk',1);

/* pt_categories */
CREATE TABLE `pt_categories` (
  `projectID` char(35) NOT NULL,
  `categoryID` char(35) NOT NULL,
  `type` varchar(5) default NULL,
  `category` varchar(80) default NULL,
  PRIMARY KEY  (`projectID`,`categoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_clients` */
CREATE TABLE `pt_clients` (
  `clientID` char(35) NOT NULL,
  `name` varchar(150) default NULL,
  `address` text default NULL,
  `city` varchar(150) default NULL,
  `locality` varchar(200) default NULL,
  `country` varchar(35) default NULL,
  `postal` varchar(40) default NULL,
  `phone` varchar(40) default NULL,
  `fax` varchar(40) default NULL,
  `contactName` varchar(60) default NULL,
  `contactPhone` varchar(40) default NULL,
  `notes` text default NULL,
  `active` tinyint(1) default NULL,
  PRIMARY KEY  (`clientID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* pt_comments */
ALTER TABLE `pt_comments` MODIFY `commentID` char(35) NOT NULL;
ALTER TABLE `pt_comments` MODIFY `projectID` char(35) NOT NULL;
ALTER TABLE `pt_comments` MODIFY `userID` char(35) NOT NULL;
ALTER TABLE `pt_comments` MODIFY `comment` text default NULL;
ALTER TABLE `pt_comments` ADD `type` varchar(6) default NULL;
ALTER TABLE `pt_comments` ADD `itemID` char(35) default NULL;

/* pt_files */
ALTER TABLE `pt_files` MODIFY `fileID` char(35) NOT NULL;
ALTER TABLE `pt_files` MODIFY `projectID` char(35) NOT NULL;
ALTER TABLE `pt_files` MODIFY `uploadedBy` char(35) NOT NULL;
ALTER TABLE `pt_files` MODIFY `description` text default NULL;
ALTER TABLE `pt_files` ADD `categoryID` char(35) default NULL;

/* pt_issues */
ALTER TABLE `pt_issues` MODIFY `issueID` char(35) NOT NULL;
ALTER TABLE `pt_issues` MODIFY `projectID` char(35) NOT NULL;
ALTER TABLE `pt_issues` ADD `milestoneID` varchar(35) default NULL;
ALTER TABLE `pt_issues` MODIFY `createdBy` char(35) NOT NULL;
ALTER TABLE `pt_issues` MODIFY `detail` text default NULL;

/* pt_message_files */
CREATE TABLE `pt_message_files` (
  `messageID` char(35) NOT NULL,
  `fileID` char(35) NOT NULL,
  PRIMARY KEY  (`messageID`,`fileID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* pt_message_notify */
ALTER TABLE `pt_message_notify` MODIFY `messageID` char(35) NOT NULL;
ALTER TABLE `pt_message_notify` MODIFY `projectID` char(35) NOT NULL;
ALTER TABLE `pt_message_notify` MODIFY `userID` char(35) NOT NULL;

/* pt_messages */
ALTER TABLE `pt_messages` MODIFY `messageID` char(35) NOT NULL;
ALTER TABLE `pt_messages` MODIFY `projectID` char(35) NOT NULL;
ALTER TABLE `pt_messages` MODIFY `userID` char(35) NOT NULL;
ALTER TABLE `pt_messages` MODIFY `message` text default NULL;
ALTER TABLE `pt_messages` ADD `categoryID` char(35) default NULL;

/* pt_milestones */
ALTER TABLE `pt_milestones` MODIFY `milestoneID` char(35) NOT NULL;
ALTER TABLE `pt_milestones` MODIFY `projectID` char(35) NOT NULL;
ALTER TABLE `pt_milestones` MODIFY `userID` char(35) NOT NULL;
ALTER TABLE `pt_milestones` MODIFY `description` text default NULL;

/* pt_project_users */
ALTER TABLE `pt_project_users` MODIFY `userID` char(35) NOT NULL;
ALTER TABLE `pt_project_users` MODIFY `projectID` char(35) NOT NULL;
ALTER TABLE `pt_project_users` DROP `role`;
ALTER TABLE `pt_project_users` ADD `admin` tinyint(1) default NULL;
ALTER TABLE `pt_project_users` ADD `files` tinyint(1) default NULL;
ALTER TABLE `pt_project_users` ADD `issues` tinyint(1) default NULL;
ALTER TABLE `pt_project_users` ADD `msgs` tinyint(1) default NULL;
ALTER TABLE `pt_project_users` ADD `mstones` tinyint(1) default NULL;
ALTER TABLE `pt_project_users` ADD `todos` tinyint(1) default NULL;
ALTER TABLE `pt_project_users` ADD `svn` tinyint(1) default NULL;
update `pt_project_users` 
	set `admin` = 0 ,
		`files` = 2 ,
		`issues` = 2 ,
		`msgs` = 2 ,
		`mstones` = 2,
		`todos` = 2,
		`svn` = 1;

/* pt_projects */
ALTER TABLE `pt_projects` MODIFY `projectID` char(35) NOT NULL;
ALTER TABLE `pt_projects` ADD `ownerID` char(35) default NULL;
ALTER TABLE `pt_projects` ADD `clientID` varchar(35) default NULL;
ALTER TABLE `pt_projects` MODIFY `addedBy` char(35) NOT NULL;
ALTER TABLE `pt_projects` MODIFY `description` text default NULL;

/* pt_settings */
ALTER TABLE `pt_settings` MODIFY `settingID` char(35) NOT NULL;
INSERT INTO `pt_settings` values ('E59DED9F-1372-7975-6FCD9DFAE904B617','enable_api','0');
INSERT INTO `pt_settings` values ('E5A50225-1372-7975-6F9777FB42FD45E6','api_key','');

/* pt_todolists */
ALTER TABLE `pt_todolists` MODIFY `todolistID` char(35) NOT NULL;
ALTER TABLE `pt_todolists` MODIFY `projectID` char(35) NOT NULL;
ALTER TABLE `pt_todolists` MODIFY `userID` char(35) NOT NULL;
ALTER TABLE `pt_todolists` MODIFY `description` text default NULL;

/* pt_todos */
ALTER TABLE `pt_todos` MODIFY `todoID` char(35) NOT NULL;
ALTER TABLE `pt_todos` MODIFY `todolistID` char(35) NOT NULL;
ALTER TABLE `pt_todos` MODIFY `projectID` char(35) NOT NULL;
ALTER TABLE `pt_todos` MODIFY `userID` char(35) NOT NULL;
ALTER TABLE `pt_todos` MODIFY `task` text default NULL;
ALTER TABLE `pt_todos` ADD `due` datetime default NULL;

/* pt_users */
ALTER TABLE `pt_users` MODIFY `userID` char(35) NOT NULL;
ALTER TABLE `pt_users` ADD `mobile` varchar(15) default NULL;
ALTER TABLE `pt_users` ADD `carrierID` varchar(35) default NULL;
ALTER TABLE `pt_users` ADD `email_files` tinyint(1) default NULL;
ALTER TABLE `pt_users` ADD `mobile_files` tinyint(1) default NULL;
ALTER TABLE `pt_users` ADD `email_issues` tinyint(1) default NULL;
ALTER TABLE `pt_users` ADD `mobile_issues` tinyint(1) default NULL;
ALTER TABLE `pt_users` ADD `email_msgs` tinyint(1) default NULL;
ALTER TABLE `pt_users` ADD `mobile_msgs` tinyint(1) default NULL;
ALTER TABLE `pt_users` ADD `email_mstones` tinyint(1) default NULL;
ALTER TABLE `pt_users` ADD `mobile_mstones` tinyint(1) default NULL;
ALTER TABLE `pt_users` ADD `email_todos` tinyint(1) default NULL;
ALTER TABLE `pt_users` ADD `mobile_todos` tinyint(1) default NULL;
update `pt_users` 
	set `email_files` = 1 ,
		`mobile_files` = 1 ,
		`email_issues` = 1 ,
		`mobile_issues` = 1,
		`email_msgs` = 1 ,
		`mobile_msgs` = 1 ,
		`email_mstones` = 1 ,
		`mobile_mstones` = 1 ,
		`email_todos` = 1 ,
		`mobile_todos` = 1;
INSERT INTO `pt_users` (userID,firstName,lastName,username,password,style,email_issues,mobile_issues,email_mstones,mobile_mstones,email_todos,mobile_todos,avatar,admin,active) values('7F16CA08-1372-7975-6F7F9DA33EBD6A09','Guest','User','guest','guest','blue',1,1,1,1,1,1,1,1,1,1,0,0,1);