ALTER TABLE `pt_message_files` ADD `type` varchar(6) default NULL;

ALTER TABLE `pt_message_files` CHANGE `messageID` `itemID` char(35) NOT NULL;

UPDATE `pt_message_files` SET `type` = 'msg';

RENAME TABLE `pt_message_files` TO `pt_file_attach`;

ALTER TABLE `pt_file_attach` DROP PRIMARY KEY;

ALTER TABLE `pt_file_attach` MODIFY `type` varchar(6) NOT NULL;

ALTER TABLE `pt_file_attach` ADD PRIMARY KEY (`itemID`,`fileID`,`type`);