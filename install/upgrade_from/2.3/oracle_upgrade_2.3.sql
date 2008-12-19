/* UPGRADE FROM 2.3 */

/* pt_issues */
alter table
   pt_issues
add
   (
   componentID varchar2(35) NULL, 
   versionID varchar2(35) NULL,
   dueDate date,
   svnrevision NUMBER(10,0)
   );

/* pt_project_components */
CREATE TABLE  "PT_PROJECT_COMPONENTS" 
   (	"COMPONENTID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"COMPONENT" VARCHAR2(50), 
	 CONSTRAINT "PK_PT_PROJECT_COMPONENTS" PRIMARY KEY ("COMPONENTID") ENABLE
   );

/* pt_project_users */
alter table
   pt_project_users
add
   (
   timetrack NUMBER(1,0) NULL
   );
update pt_project_users set timetrack = 0;

/* pt_project_versions */
CREATE TABLE  "PT_PROJECT_VERSIONS" 
   (	"VERSIONID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"VERSION" VARCHAR2(50), 
	 CONSTRAINT "PK_PT_PROJECT_VERSIONS" PRIMARY KEY ("VERSIONID") ENABLE
   );
   
/* pt_projects */
alter table
   pt_projects
add
   (
   reg_time NUMBER(1,0) NULL,
   tab_files NUMBER(1,0) NULL, 
   tab_issues NUMBER(1,0) NULL, 
   tab_msgs NUMBER(1,0) NULL, 
   tab_mstones NUMBER(1,0) NULL, 
   tab_svn NUMBER(1,0) NULL,
   tab_time NUMBER(1,0) NULL,
   tab_todos NUMBER(1,0) NULL
   );
update pt_projects set reg_time = 1;
update pt_projects set tab_files = 1;
update pt_projects set tab_issues = 1;
update pt_projects set tab_msgs = 1;
update pt_projects set tab_mstones = 1;
update pt_projects set tab_svn = 1;
update pt_projects set tab_time = 1;
update pt_projects set tab_todos = 1;

/* pt_timetrack */
CREATE TABLE  "PT_TIMETRACK" 
   (	"TIMETRACKID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"USERID" CHAR(35) NOT NULL ENABLE, 
	"DATESTAMP" DATE, 
	"HOURS" NUMBER(6,2), 
	"DESCRIPTION" VARCHAR2(255), 
	"ITEMID" VARCHAR2(35), 
	"ITEMTYPE" VARCHAR2(10), 
	 CONSTRAINT "PK_PT_TIMETRACK" PRIMARY KEY ("TIMETRACKID") ENABLE
   );

/* pt_todolists */
alter table
   pt_todolists
add
   (
   timetrack NUMBER(1,0) NULL
   );
update pt_todolists set timetrack = 0;