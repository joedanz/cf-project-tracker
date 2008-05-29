ALTER TABLE `pt_message_files` ADD `type` varchar(6) default NULL;

ALTER TABLE `pt_message_files` CHANGE `messageID` `itemID` char(35) NOT NULL;

UPDATE `pt_message_files` SET `type` = 'msg';

RENAME TABLE `pt_message_files` TO `pt_file_attach`;

ALTER TABLE `pt_file_attach` DROP PRIMARY KEY;

ALTER TABLE `pt_file_attach` MODIFY `type` varchar(6) NOT NULL;

ALTER TABLE `pt_file_attach` ADD PRIMARY KEY (`itemID`,`fileID`,`type`);

CREATE TABLE `pt_screenshots` (
  `fileID` char(35) NOT NULL,
  `issueID` char(35) NOT NULL,
  `title` varchar(200) default NULL,
  `description` text default NULL,
  `categoryID` char(35) NOT NULL,  
  `filename` varchar(150) default NULL,
  `serverfilename` varchar(150) default NULL,
  `filetype` varchar(4) default NULL,
  `filesize` int(9) default NULL,
  `uploaded` datetime default NULL,
  `uploadedBy` char(35) NOT NULL,
  PRIMARY KEY  (`fileID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
