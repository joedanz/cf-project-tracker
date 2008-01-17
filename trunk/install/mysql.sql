/*
SQLyog Enterprise v4.06 RC1
Host - 5.0.24a-community-nt : Database - project
*********************************************************************
Server version : 5.0.24a-community-nt
*/


/*Table structure for table `pt_activity` */

CREATE TABLE `pt_activity` (
  `activityID` char(35) NOT NULL,
  `projectID` char(35) default NULL,
  `userID` char(35) default NULL,
  `type` varchar(12) default NULL,
  `id` char(35) default NULL,
  `name` varchar(100) default NULL,
  `activity` varchar(50) default NULL,
  `stamp` datetime default NULL,
  PRIMARY KEY  (`activityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_carriers` */

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

/*Table structure for table `pt_comments` */

CREATE TABLE `pt_comments` (
  `commentID` char(35) NOT NULL,
  `projectID` char(35) default NULL,
  `messageID` varchar(35) default NULL,
  `issueID` varchar(35) default NULL,
  `userID` char(35) default NULL,
  `comment` text default NULL,
  `stamp` datetime default NULL,
  PRIMARY KEY  (`commentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_files` */

CREATE TABLE `pt_files` (
  `fileID` char(35) NOT NULL,
  `projectID` char(35) default NULL,
  `title` varchar(200) default NULL,
  `description` text default NULL,
  `category` varchar(50) default NULL,
  `filename` varchar(150) default NULL,
  `serverfilename` varchar(150) default NULL,
  `filetype` varchar(4) default NULL,
  `filesize` int(9) default NULL,
  `uploaded` datetime default NULL,
  `uploadedBy` char(35) default NULL,
  PRIMARY KEY  (`fileID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_issues` */

CREATE TABLE `pt_issues` (
  `issueID` char(35) NOT NULL,
  `projectID` char(35) default NULL,
  `shortID` varchar(7) default NULL,
  `issue` varchar(120) default NULL,
  `detail` text default NULL,
  `type` varchar(11) default NULL,
  `severity` varchar(10) default NULL,
  `status` varchar(6) default NULL,
  `relevantURL` varchar(255) default NULL,
  `created` datetime default NULL,
  `createdBy` char(35) default NULL,
  `assignedTo` varchar(35) default NULL,
  `updated` datetime default NULL,
  `updatedBy` varchar(35) default NULL,
  PRIMARY KEY  (`issueID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_message_notify` */

CREATE TABLE `pt_message_notify` (
  `messageID` char(35) NOT NULL,
  `projectID` char(35) NOT NULL,
  `userID` char(35) NOT NULL,
  PRIMARY KEY  (`messageID`,`projectID`,`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_messages` */

CREATE TABLE `pt_messages` (
  `messageID` char(35) NOT NULL,
  `projectID` char(35) default NULL,
  `milestoneID` varchar(35) default NULL,
  `userID` char(35) default NULL,
  `title` varchar(120) default NULL,
  `message` text default NULL,
  `category` varchar(50) default NULL,
  `allowcomments` bit(1) default NULL,
  `stamp` datetime default NULL,
  PRIMARY KEY  (`messageID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_milestones` */

CREATE TABLE `pt_milestones` (
  `milestoneID` char(35) NOT NULL,
  `projectID` char(35) default NULL,
  `userID` char(35) default NULL,
  `forID` varchar(35) default NULL,
  `name` varchar(50) default NULL,
  `description` text default NULL,
  `dueDate` datetime default NULL,
  `completed` datetime default NULL,
  PRIMARY KEY  (`milestoneID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_project_users` */

CREATE TABLE `pt_project_users` (
  `userID` char(35) NOT NULL,
  `projectID` char(35) NOT NULL,
  `role` varchar(9) default NULL,
  PRIMARY KEY  (`userID`,`projectID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_projects` */

CREATE TABLE `pt_projects` (
  `projectID` char(35) NOT NULL,
  `name` varchar(50) default NULL,
  `description` text default NULL,
  `display` bit(1) default NULL,
  `ticketPrefix` varchar(2) default NULL,
  `added` datetime default NULL,
  `addedBy` char(35) default NULL,
  `status` varchar(8) default NULL,
  `svnurl` varchar(100) default NULL,
  `svnuser` varchar(20) default NULL,
  `svnpass` varchar(20) default NULL,
  PRIMARY KEY  (`projectID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_settings` */

CREATE TABLE `pt_settings` (
  `settingID` char(35) NOT NULL,
  `setting` varchar(50) default NULL,
  `settingValue` varchar(250) default NULL,
  PRIMARY KEY  (`settingID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_todolists` */

CREATE TABLE `pt_todolists` (
  `todolistID` char(35) NOT NULL,
  `projectID` char(35) default NULL,
  `title` varchar(100) default NULL,
  `description` text default NULL,
  `milestoneID` varchar(35) default NULL,
  `userID` char(35) default NULL,
  `added` datetime default NULL,
  `rank` tinyint(3) default NULL,
  PRIMARY KEY  (`todolistID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_todos` */

CREATE TABLE `pt_todos` (
  `todoID` char(35) NOT NULL,
  `todolistID` char(35) default NULL,
  `projectID` char(35) default NULL,
  `userID` char(35) default NULL,
  `task` text default NULL,
  `rank` int(3) default NULL,
  `added` datetime default NULL,
  `completed` datetime default NULL,
  `svnrevision` int(6) default NULL,
  PRIMARY KEY  (`todoID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_users` */

CREATE TABLE `pt_users` (
  `userID` char(35) NOT NULL,
  `firstName` varchar(12) default NULL,
  `lastName` varchar(20) default NULL,
  `username` varchar(50) default NULL,
  `password` varchar(20) default NULL,
  `email` varchar(120) default NULL,
  `phone` varchar(15) default NULL,
  `mobile` varchar(15) default NULL,
  `carrierID` varchar(35) default NULL,
  `lastLogin` datetime default NULL,
  `avatar` tinyint(1) default NULL,
  `style` varchar(20) default NULL,
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
  `admin` tinyint(1) default NULL,
  `active` tinyint(1) default NULL,
  PRIMARY KEY  (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Add admin & guest users */
INSERT INTO `pt_users` (userID,firstName,lastName,username,password,style,email_todos,mobile_todos,email_mstones,mobile_mstones,email_issues,mobile_issues,avatar,admin,active) values('FCDCF4CD-16E6-58DE-13EDC6A2B362B22C','Admin','User','admin','admin','blue',0,0,0,0,0,0,0,1,1);
INSERT INTO `pt_users` (userID,firstName,lastName,username,password,style,email_todos,mobile_todos,email_mstones,mobile_mstones,email_issues,mobile_issues,avatar,admin,active) values('7F16CA08-1372-7975-6F7F9DA33EBD6A09','Guest','User','guest','guest','blue',0,0,0,0,0,0,0,0,1);

/*Add default settings */
INSERT INTO `pt_settings` values ('FC3D187C-16E6-58DE-133C5098C58225D3','app_title','TICC Project Tracker');
INSERT INTO `pt_settings` values ('FC3D861A-16E6-58DE-1346E4E01F578F52','default_style','blue');

/*Add carriers */
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