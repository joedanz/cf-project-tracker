/* UPGRADE FROM 2.4 */

/* pt_client_rates */
CREATE TABLE  "PT_CLIENT_RATES" 
   (	"RATEID" CHAR(35) NOT NULL ENABLE, 
    "CLIENTID" CHAR(35) NOT NULL ENABLE, 
	"CATEGORY" VARCHAR2(50), 
	"RATE" NUMBER(6,2), 
	 CONSTRAINT "PK_PT_CLIENT_RATES" PRIMARY KEY ("RATEID") ENABLE
   );

/* pt_clients */
alter table
   pt_clients
add
   (
   CONTACTEMAIL varchar2(150) NULL ,
   WEBSITE varchar2(150) NULL
   );
   
/* pt_milestones */
alter table
   pt_milestones
add
   (
   rate NUMBER(8,2) NULL
   );

/* pt_project_users */
alter table
   pt_project_users
add
   (
   billing NUMBER(1,0) NULL
   );
update pt_project_users set billing = 0;

/* pt_projects */
alter table
   pt_projects
add
   (
   tab_billing NUMBER(1,0) NULL,
   issue_svn_link NUMBER(1,0) NULL,
   issue_timetrack NUMBER(1,0) NULL
   );
update pt_projects set tab_billing = 0;
update pt_projects set issue_svn_link = 1;
update pt_projects set issue_timetrack = 1;

/* pt_timetrack */
alter table
   pt_timetrack
add
   (
   rateID varchar2(35) NULL
   );

/* pt_user_notify */
CREATE TABLE  "PT_USER_NOTIFY" 
   (	"USERID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"EMAIL_FILES" NUMBER(1,0), 
	"MOBILE_FILES" NUMBER(1,0), 
	"EMAIL_ISSUES" NUMBER(1,0), 
	"MOBILE_ISSUES" NUMBER(1,0), 
	"EMAIL_MSGS" NUMBER(1,0), 
	"MOBILE_MSGS" NUMBER(1,0), 
	"EMAIL_MSTONES" NUMBER(1,0), 
	"MOBILE_MSTONES" NUMBER(1,0), 
	"EMAIL_TODOS" NUMBER(1,0), 
	"MOBILE_TODOS" NUMBER(1,0), 
	 CONSTRAINT "PK_PT_USER_NOTIFY" PRIMARY KEY ("USERID", "PROJECTID") ENABLE
   );

