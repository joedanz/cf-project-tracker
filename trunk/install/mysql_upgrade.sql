/* UPGRADE FROM BETA */
alter table `pt_comments` MODIFY `comment` varchar(1000) default NULL;
alter table `pt_project_users` MODIFY `role` varchar(9) default NULL;
alter table `pt_todolists` MODIFY `description` varchar(1000) default NULL;
alter table `pt_todos` MODIFY `task` varchar(300) default NULL;

/* UPGRADE FROM 1.0 */
insert into `pt_users` (userID,firstName,lastName,username,password,style,email_todos,mobile_todos,email_mstones,mobile_mstones,email_issues,mobile_issues,avatar,admin,active) values('7F16CA08-1372-7975-6F7F9DA33EBD6A09','Guest','User','guest','guest','blue',0,0,0,0,0,0,0,0,1);
alter table `pt_users` ADD `mobile` varchar(15) default NULL;
alter table `pt_users` ADD `carrierID` varchar(35) default NULL;
alter table `pt_users` ADD `email_todos` tinyint(1) default NULL;
alter table `pt_users` ADD `mobile_todos` tinyint(1) default NULL;
alter table `pt_users` ADD `email_mstones` tinyint(1) default NULL;
alter table `pt_users` ADD `mobile_mstones` tinyint(1) default NULL;
alter table `pt_users` ADD `email_issues` tinyint(1) default NULL;
alter table `pt_users` ADD `mobile_issues` tinyint(1) default NULL;
update `pt_users` 
	set `email_todos` = 1 ,
		`mobile_todos` = 1 ,
		`email_mstones` = 1 ,
		`mobile_mstones` = 1 ,
		`email_issues` = 1 ,
		`mobile_issues` = 1;