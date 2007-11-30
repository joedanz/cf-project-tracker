/*
SQLyog Enterprise v4.06 RC1
Host - 5.0.24a-community-nt : Database - project
*********************************************************************
Server version : 5.0.24a-community-nt
*/


/*Table structure for table `pt_activity` */

CREATE TABLE `pt_activity` (
  `activityID` varchar(35) NOT NULL,
  `projectID` varchar(35) default NULL,
  `userID` varchar(35) default NULL,
  `type` varchar(12) default NULL,
  `id` varchar(35) default NULL,
  `name` varchar(100) default NULL,
  `activity` varchar(50) default NULL,
  `stamp` datetime default NULL,
  PRIMARY KEY  (`activityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_comments` */

CREATE TABLE `pt_comments` (
  `commentID` varchar(35) NOT NULL,
  `projectID` varchar(35) default NULL,
  `messageID` varchar(35) default NULL,
  `issueID` varchar(35) default NULL,
  `userID` varchar(35) default NULL,
  `comment` varchar(1000) default NULL,
  `stamp` datetime default NULL,
  PRIMARY KEY  (`commentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_files` */

CREATE TABLE `pt_files` (
  `fileID` varchar(35) NOT NULL,
  `projectID` varchar(35) default NULL,
  `title` varchar(200) default NULL,
  `description` varchar(1000) default NULL,
  `category` varchar(50) default NULL,
  `filename` varchar(150) default NULL,
  `serverfilename` varchar(150) default NULL,
  `filetype` varchar(4) default NULL,
  `filesize` int(9) default NULL,
  `uploaded` datetime default NULL,
  `uploadedBy` varchar(35) default NULL,
  PRIMARY KEY  (`fileID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_issues` */

CREATE TABLE `pt_issues` (
  `issueID` varchar(35) NOT NULL,
  `projectID` varchar(35) default NULL,
  `shortID` varchar(7) default NULL,
  `issue` varchar(120) default NULL,
  `detail` text default NULL,
  `type` varchar(11) default NULL,
  `severity` varchar(10) default NULL,
  `status` varchar(6) default NULL,
  `relevantURL` varchar(255) default NULL,
  `created` datetime default NULL,
  `createdBy` varchar(35) default NULL,
  `assignedTo` varchar(35) default NULL,
  `updated` datetime default NULL,
  `updatedBy` varchar(35) default NULL,
  PRIMARY KEY  (`issueID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_message_notify` */

CREATE TABLE `pt_message_notify` (
  `messageID` varchar(35) NOT NULL,
  `projectID` varchar(35) NOT NULL,
  `userID` varchar(35) NOT NULL,
  PRIMARY KEY  (`messageID`,`projectID`,`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_messages` */

CREATE TABLE `pt_messages` (
  `messageID` varchar(35) NOT NULL,
  `projectID` varchar(35) default NULL,
  `milestoneID` varchar(35) default NULL,
  `userID` varchar(35) default NULL,
  `title` varchar(120) default NULL,
  `message` text default NULL,
  `category` varchar(50) default NULL,
  `allowcomments` bit(1) default NULL,
  `stamp` datetime default NULL,
  PRIMARY KEY  (`messageID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_milestones` */

CREATE TABLE `pt_milestones` (
  `milestoneID` varchar(35) NOT NULL,
  `projectID` varchar(35) default NULL,
  `userID` varchar(35) default NULL,
  `forID` varchar(35) default NULL,
  `name` varchar(50) default NULL,
  `description` varchar(2000) default NULL,
  `dueDate` datetime default NULL,
  `completed` datetime default NULL,
  PRIMARY KEY  (`milestoneID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_project_users` */

CREATE TABLE `pt_project_users` (
  `userID` varchar(35) NOT NULL,
  `projectID` varchar(35) NOT NULL,
  `role` varchar(9) default NULL,
  PRIMARY KEY  (`userID`,`projectID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_projects` */

CREATE TABLE `pt_projects` (
  `projectID` varchar(35) NOT NULL,
  `name` varchar(50) default NULL,
  `description` text default NULL,
  `display` bit(1) default NULL,
  `ticketPrefix` varchar(2) default NULL,
  `added` datetime default NULL,
  `addedBy` varchar(35) default NULL,
  `status` varchar(8) default NULL,
  `active` bit(1) default NULL,
  `svnurl` varchar(100) default NULL,
  `svnuser` varchar(20) default NULL,
  `svnpass` varchar(20) default NULL,
  PRIMARY KEY  (`projectID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_settings` */

CREATE TABLE `pt_settings` (
  `settingID` varchar(35) NOT NULL,
  `setting` varchar(50) default NULL,
  `settingValue` varchar(250) default NULL,
  PRIMARY KEY  (`settingID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_todolists` */

CREATE TABLE `pt_todolists` (
  `todolistID` varchar(35) NOT NULL,
  `projectID` varchar(35) default NULL,
  `title` varchar(100) default NULL,
  `description` varchar(1000) default NULL,
  `milestoneID` varchar(35) default NULL,
  `userID` varchar(35) default NULL,
  `added` datetime default NULL,
  `rank` tinyint(3) default NULL,
  PRIMARY KEY  (`todolistID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_todos` */

CREATE TABLE `pt_todos` (
  `todoID` varchar(35) NOT NULL,
  `todolistID` varchar(35) default NULL,
  `projectID` varchar(35) default NULL,
  `userID` varchar(35) default NULL,
  `task` varchar(300) default NULL,
  `rank` int(3) default NULL,
  `added` datetime default NULL,
  `completed` datetime default NULL,
  `svnrevision` int(6) default NULL,
  PRIMARY KEY  (`todoID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `pt_users` */

CREATE TABLE `pt_users` (
  `userID` varchar(35) NOT NULL,
  `firstName` varchar(12) default NULL,
  `lastName` varchar(20) default NULL,
  `username` varchar(50) default NULL,
  `password` varchar(20) default NULL,
  `email` varchar(120) default NULL,
  `phone` varchar(15) default NULL,
  `lastLogin` datetime default NULL,
  `avatar` tinyint(1) default NULL,
  `style` varchar(20) default NULL,
  `admin` tinyint(1) default NULL,
  `active` tinyint(1) default NULL,
  PRIMARY KEY  (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Add admin user */
insert into `pt_users` (userID,username,password,style,admin,active) values('FCDCF4CD-16E6-58DE-13EDC6A2B362B22C','admin','admin','blue',1,1);

/*Add default settings */
insert into `pt_settings` values ('FC3D187C-16E6-58DE-133C5098C58225D3','app_title','TICC Project Tracker');
insert into `pt_settings` values ('FC3D861A-16E6-58DE-1346E4E01F578F52','default_style','blue');
