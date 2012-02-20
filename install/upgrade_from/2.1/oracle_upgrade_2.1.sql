/* UPGRADE FROM 2.1 */
/* pt_projects */
alter table
   pt_projects
add
   (
   allow_reg NUMBER(1,0) NULL, 
   reg_active NUMBER(1,0) NULL, 
   reg_files NUMBER(1,0) NULL, 
   reg_issues NUMBER(1,0) NULL, 
   reg_msgs NUMBER(1,0) NULL, 
   reg_mstones NUMBER(1,0) NULL, 
   reg_todos NUMBER(1,0) NULL,             
   reg_svn NUMBER(1,0) NULL
   );

update pt_projects
	set allow_reg = 0 ,
		reg_active = 1 ,
		reg_files = 1 ,
		reg_issues = 1 ,
		reg_msgs = 1 ,
		reg_mstones = 1,
		reg_todos = 1,
		reg_svn = 1;

update pt_carriers
	set prefix = 1;
	
alter table 
	pt_users 
modify 
	(
	password char(32) NULL
	);
	
update pt_users	set password = '21232F297A57A5A743894A0E4A801FC3' where username = 'admin';
update pt_users	set password = '084E0343A0486FF05530DF6C705C8BB4' where username = 'guest';
	