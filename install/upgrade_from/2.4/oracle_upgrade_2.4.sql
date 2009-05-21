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
   rate NUMBER(8,2) NULL,
   billed NUMBER(1,0) NULL,
   paid NUMBER(1,0) NULL
   );
update pt_milestones set billed = 0;
update pt_milestones set paid = 0;

/* pt_project_users */
alter table
   pt_project_users
add
   (
   file_view NUMBER(1,0) NULL,
   file_edit NUMBER(1,0) NULL,
   file_comment NUMBER(1,0) NULL,
   issue_view NUMBER(1,0) NULL,
   issue_edit NUMBER(1,0) NULL,
   issue_assign NUMBER(1,0) NULL,
   issue_resolve NUMBER(1,0) NULL,
   issue_close NUMBER(1,0) NULL,
   issue_comment NUMBER(1,0) NULL,
   msg_view NUMBER(1,0) NULL,
   msg_edit NUMBER(1,0) NULL,
   msg_comment NUMBER(1,0) NULL,
   mstone_view NUMBER(1,0) NULL,
   mstone_edit NUMBER(1,0) NULL,
   mstone_comment NUMBER(1,0) NULL,
   todolist_view NUMBER(1,0) NULL,
   todolist_edit NUMBER(1,0) NULL,
   todo_edit NUMBER(1,0) NULL,
   todo_comment NUMBER(1,0) NULL,
   time_view NUMBER(1,0) NULL,
   time_edit NUMBER(1,0) NULL,
   bill_view NUMBER(1,0) NULL,
   bill_edit NUMBER(1,0) NULL,
   bill_rates NUMBER(1,0) NULL,
   bill_invoices NUMBER(1,0) NULL,
   bill_markpaid NUMBER(1,0) NULL
   );
update pt_project_users set file_view = 0;
update pt_project_users set file_edit = 0;
update pt_project_users set file_comment = 0;
update pt_project_users set issue_view = 0;
update pt_project_users set issue_edit = 0;
update pt_project_users set issue_assign = 0;
update pt_project_users set issue_resolve = 0;
update pt_project_users set issue_close = 0;
update pt_project_users set issue_comment = 0;
update pt_project_users set msg_view = 0;
update pt_project_users set msg_edit = 0;
update pt_project_users set msg_comment = 0;
update pt_project_users set mstone_view = 0;
update pt_project_users set mstone_edit = 0;
update pt_project_users set mstone_comment = 0;
update pt_project_users set todolist_view = 0;
update pt_project_users set todolist_edit = 0;
update pt_project_users set todo_edit = 0;
update pt_project_users set todo_comment = 0;
update pt_project_users set time_view = 0;
update pt_project_users set time_edit = 0;
update pt_project_users set bill_view = 0;
update pt_project_users set bill_edit = 0;
update pt_project_users set bill_rates = 0;
update pt_project_users set bill_invoices = 0;
update pt_project_users set bill_markpaid = 0;

/* pt_projects */
alter table
   pt_projects
add
   (
   logo_img varchar2(150) NULL,
   tab_billing NUMBER(1,0) NULL,
   issue_svn_link NUMBER(1,0) NULL,
   issue_timetrack NUMBER(1,0) NULL,
   reg_file_view NUMBER(1,0) NULL,
   reg_file_edit NUMBER(1,0) NULL,
   reg_file_comment NUMBER(1,0) NULL,
   reg_issue_view NUMBER(1,0) NULL,
   reg_issue_edit NUMBER(1,0) NULL,
   reg_issue_assign NUMBER(1,0) NULL,
   reg_issue_resolve NUMBER(1,0) NULL,
   reg_issue_close NUMBER(1,0) NULL,
   reg_issue_comment NUMBER(1,0) NULL,
   reg_msg_view NUMBER(1,0) NULL,
   reg_msg_edit NUMBER(1,0) NULL,
   reg_msg_comment NUMBER(1,0) NULL,
   reg_mstone_view NUMBER(1,0) NULL,
   reg_mstone_edit NUMBER(1,0) NULL,
   reg_mstone_comment NUMBER(1,0) NULL,
   reg_todolist_view NUMBER(1,0) NULL,
   reg_todolist_edit NUMBER(1,0) NULL,
   reg_todo_edit NUMBER(1,0) NULL,
   reg_todo_comment NUMBER(1,0) NULL,
   reg_time_view NUMBER(1,0) NULL,
   reg_time_edit NUMBER(1,0) NULL,
   reg_bill_view NUMBER(1,0) NULL,
   reg_bill_edit NUMBER(1,0) NULL,
   reg_bill_rates NUMBER(1,0) NULL,
   reg_bill_invoices NUMBER(1,0) NULL,
   reg_bill_markpaid NUMBER(1,0) NULL
   );
update pt_projects set tab_billing = 0;
update pt_projects set issue_svn_link = 1;
update pt_projects set issue_timetrack = 1;

/* pt_settings */
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('1E5ED63A-C938-2FE9-C60035D81F955266','company_name','');
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('1E77669A-963D-735E-C7C22FA82FABC398','company_logo','');
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('5D717D09-1372-7975-6F21844EACDAFC54','invoice_logo','');
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('3D72D1F7-CD23-8BE3-60F9614093F89CCF','hourly_rate','');

/* pt_timetrack */
alter table
   pt_timetrack
add
   (
   rateID varchar2(35) NULL,
   billed NUMBER(1,0) NULL,
   paid NUMBER(1,0) NULL
   );
update pt_timetrack set billed = 0;
update pt_timetrack set paid = 0;

/* pt_user_notify */
CREATE TABLE  "PT_USER_NOTIFY" 
   (	"USERID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"EMAIL_FILE_NEW" NUMBER(1,0), 
	"MOBILE_FILE_NEW" NUMBER(1,0), 
	"EMAIL_FILE_UPD" NUMBER(1,0), 
	"MOBILE_FILE_UPD" NUMBER(1,0), 
	"EMAIL_FILE_COM" NUMBER(1,0), 
	"MOBILE_FILE_COM" NUMBER(1,0), 
	"EMAIL_ISSUE_NEW" NUMBER(1,0), 
	"MOBILE_ISSUE_NEW" NUMBER(1,0), 
	"EMAIL_ISSUE_UPD" NUMBER(1,0), 
	"MOBILE_ISSUE_UPD" NUMBER(1,0), 
	"EMAIL_ISSUE_COM" NUMBER(1,0), 
	"MOBILE_ISSUE_COM" NUMBER(1,0), 
	"EMAIL_MSG_NEW" NUMBER(1,0), 
	"MOBILE_MSG_NEW" NUMBER(1,0), 
	"EMAIL_MSG_UPD" NUMBER(1,0), 
	"MOBILE_MSG_UPD" NUMBER(1,0), 
	"EMAIL_MSG_COM" NUMBER(1,0), 
	"MOBILE_MSG_COM" NUMBER(1,0), 
	"EMAIL_MSTONE_NEW" NUMBER(1,0), 
	"MOBILE_MSTONE_NEW" NUMBER(1,0), 
	"EMAIL_MSTONE_UPD" NUMBER(1,0), 
	"MOBILE_MSTONE_UPD" NUMBER(1,0), 
	"EMAIL_MSTONE_COM" NUMBER(1,0), 
	"MOBILE_MSTONE_COM" NUMBER(1,0), 
	"EMAIL_TODO_NEW" NUMBER(1,0), 
	"MOBILE_TODO_NEW" NUMBER(1,0), 
	"EMAIL_TODO_UPD" NUMBER(1,0), 
	"MOBILE_TODO_UPD" NUMBER(1,0), 
	"EMAIL_TODO_COM" NUMBER(1,0), 
	"MOBILE_TODO_COM" NUMBER(1,0), 
	"EMAIL_TIME_NEW" NUMBER(1,0), 
	"MOBILE_TIME_NEW" NUMBER(1,0), 
	"EMAIL_TIME_UPD" NUMBER(1,0), 
	"MOBILE_TIME_UPD" NUMBER(1,0), 
	"EMAIL_BILL_NEW" NUMBER(1,0), 
	"MOBILE_BILL_NEW" NUMBER(1,0), 
	"EMAIL_BILL_UPD" NUMBER(1,0), 
	"MOBILE_BILL_UPD" NUMBER(1,0), 
	"EMAIL_BILL_PAID" NUMBER(1,0), 
	"MOBILE_BILL_PAID" NUMBER(1,0), 
	 CONSTRAINT "PK_PT_USER_NOTIFY" PRIMARY KEY ("USERID", "PROJECTID") ENABLE
   );

