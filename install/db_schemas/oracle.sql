CREATE TABLE  "PT_ACTIVITY" 
   (	"ACTIVITYID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"USERID" CHAR(35) NOT NULL ENABLE, 
	"TYPE" VARCHAR2(12), 
	"ID" CHAR(35) NOT NULL ENABLE, 
	"NAME" VARCHAR2(100), 
	"ACTIVITY" VARCHAR2(50), 
	"STAMP" DATE, 
	 CONSTRAINT "PK_PT_ACTIVITY" PRIMARY KEY ("ACTIVITYID") ENABLE
   )
/
CREATE TABLE  "PT_CARRIERS" 
   (	"CARRIERID" CHAR(35) NOT NULL ENABLE, 
	"CARRIER" VARCHAR2(20), 
	"COUNTRYCODE" VARCHAR2(2), 
	"COUNTRY" VARCHAR2(20), 
	"PREFIX" VARCHAR2(3), 
	"SUFFIX" VARCHAR2(40), 
	"ACTIVE" NUMBER(1,0), 
	 CONSTRAINT "PK_PT_CARRIERS" PRIMARY KEY ("CARRIERID") ENABLE
   )
/
CREATE TABLE  "PT_CATEGORIES" 
   (	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"CATEGORYID" CHAR(35) NOT NULL ENABLE, 
	"TYPE" VARCHAR2(5), 
	"CATEGORY" VARCHAR2(80), 
	 CONSTRAINT "PK_PT_CATEGORIES" PRIMARY KEY ("PROJECTID", "CATEGORYID") ENABLE
   )
/
CREATE TABLE  "PT_CLIENT_RATES" 
   (	"RATEID" CHAR(35) NOT NULL ENABLE, 
    "CLIENTID" CHAR(35) NOT NULL ENABLE, 
	"CATEGORY" VARCHAR2(50), 
	"RATE" NUMBER(6,2), 
	 CONSTRAINT "PK_PT_CLIENT_RATES" PRIMARY KEY ("RATEID") ENABLE
   )
/
CREATE TABLE  "PT_CLIENTS" 
   (	"CLIENTID" CHAR(35) NOT NULL ENABLE, 
	"NAME" VARCHAR2(150), 
	"ADDRESS" CLOB, 
	"CITY" VARCHAR2(150), 
	"LOCALITY" VARCHAR2(200), 
	"COUNTRY" VARCHAR2(35), 
	"POSTAL" VARCHAR2(40), 
	"PHONE" VARCHAR2(40), 
	"FAX" VARCHAR2(40), 
	"CONTACTNAME" VARCHAR2(60), 
	"CONTACTPHONE" VARCHAR2(40), 
	"CONTACTEMAIL" VARCHAR2(150), 
	"WEBSITE" VARCHAR2(150), 
	"NOTES" CLOB, 
	"ACTIVE" NUMBER(1,0), 
	 CONSTRAINT "PK_PT_CLIENTS" PRIMARY KEY ("CLIENTID") ENABLE
   )
/
CREATE TABLE  "PT_COMMENTS" 
   (	"COMMENTID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"TYPE" VARCHAR2(6), 
	"ITEMID" CHAR(35), 
	"USERID" CHAR(35) NOT NULL ENABLE, 
	"COMMENTTEXT" CLOB, 
	"STAMP" DATE, 
	 CONSTRAINT "PK_PT_COMMENTS" PRIMARY KEY ("COMMENTID") ENABLE
   )
/
CREATE TABLE  "PT_FILES" 
   (	"FILEID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"TITLE" VARCHAR2(200), 
	"DESCRIPTION" CLOB, 
	"CATEGORYID" CHAR(35) NOT NULL ENABLE, 
	"FILENAME" VARCHAR2(150), 
	"SERVERFILENAME" VARCHAR2(150), 
	"FILETYPE" VARCHAR2(4), 
	"FILESIZE" NUMBER(10,0), 
	"UPLOADED" DATE, 
	"UPLOADEDBY" CHAR(35) NOT NULL ENABLE, 
	 CONSTRAINT "PK_PT_FILES" PRIMARY KEY ("FILEID") ENABLE
   )
/
CREATE TABLE  "PT_FILE_ATTACH" 
   (	"ITEMID" CHAR(35) NOT NULL ENABLE, 
	"FILEID" CHAR(35) NOT NULL ENABLE, 
	"TYPE" VARCHAR2(6) NOT NULL ENABLE, 
	 CONSTRAINT "PK_PT_FILE_ATTACH" PRIMARY KEY ("ITEMID", "FILEID", "TYPE") ENABLE
   )
/
CREATE TABLE  "PT_ISSUES" 
   (	"ISSUEID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"MILESTONEID" VARCHAR2(35), 
	"SHORTID" VARCHAR2(7), 
	"ISSUE" VARCHAR2(120), 
	"DETAIL" CLOB, 
	"TYPE" VARCHAR2(11), 
	"SEVERITY" VARCHAR2(10), 
	"STATUS" VARCHAR2(8), 
	"RELEVANTURL" VARCHAR2(255), 
	"CREATED" DATE, 
	"CREATEDBY" CHAR(35) NOT NULL ENABLE, 
	"ASSIGNEDTO" VARCHAR2(35), 
	"UPDATED" DATE, 
	"UPDATEDBY" VARCHAR2(35), 
	"RESOLUTION" VARCHAR2(12), 
	"RESOLUTIONDESC" CLOB, 
	"COMPONENTID" VARCHAR2(35), 
	"VERSIONID" VARCHAR2(35), 
	"DUEDATE" DATE, 
	 CONSTRAINT "PK_PT_ISSUES" PRIMARY KEY ("ISSUEID") ENABLE
   )
/
CREATE TABLE  "PT_MESSAGES" 
   (	"MESSAGEID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"MILESTONEID" VARCHAR2(35), 
	"USERID" CHAR(35) NOT NULL ENABLE, 
	"TITLE" VARCHAR2(120), 
	"MESSAGE" CLOB, 
	"CATEGORYID" CHAR(35) NOT NULL ENABLE, 
	"ALLOWCOMMENTS" NUMBER(1,0), 
	"STAMP" DATE, 
	 CONSTRAINT "PK_PT_MESSAGES" PRIMARY KEY ("MESSAGEID") ENABLE
   )
/
CREATE TABLE  "PT_MESSAGE_NOTIFY" 
   (	"MESSAGEID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"USERID" CHAR(35) NOT NULL ENABLE, 
	 CONSTRAINT "PK_PT_MESSAGE_NOTIFY" PRIMARY KEY ("MESSAGEID", "PROJECTID", "USERID") ENABLE
   )
/
CREATE TABLE  "PT_MILESTONES" 
   (	"MILESTONEID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"USERID" CHAR(35) NOT NULL ENABLE, 
	"FORID" VARCHAR2(35), 
	"NAME" VARCHAR2(50), 
	"DESCRIPTION" CLOB, 
	"DUEDATE" DATE, 
	"COMPLETED" DATE, 
	"RATE" NUMBER(8,2),
	 CONSTRAINT "PK_PT_MILESTONES" PRIMARY KEY ("MILESTONEID") ENABLE
   )
/
CREATE TABLE  "PT_PROJECT_COMPONENTS" 
   (	"COMPONENTID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"COMPONENT" VARCHAR2(50), 
	 CONSTRAINT "PK_PT_PROJECT_COMPONENTS" PRIMARY KEY ("COMPONENTID") ENABLE
   )
/
CREATE TABLE  "PT_PROJECT_USERS" 
   (	"USERID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"ADMIN" NUMBER(1,0), 
	"BILLING" NUMBER(1,0), 
	"FILES" NUMBER(1,0), 
	"ISSUES" NUMBER(1,0), 
	"MSGS" NUMBER(1,0), 
	"MSTONES" NUMBER(1,0), 
	"TIMETRACK" NUMBER(1,0), 
	"TODOS" NUMBER(1,0), 
	"SVN" NUMBER(1,0), 
	 CONSTRAINT "PK_PT_PROJECT_USERS" PRIMARY KEY ("USERID", "PROJECTID") ENABLE
   )
/
CREATE TABLE  "PT_PROJECT_VERSIONS" 
   (	"VERSIONID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"VERSION" VARCHAR2(50), 
	 CONSTRAINT "PK_PT_PROJECT_VERSIONS" PRIMARY KEY ("VERSIONID") ENABLE
   )
/
CREATE TABLE  "PT_PROJECTS" 
   (	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"OWNERID" CHAR(35), 
	"CLIENTID" VARCHAR2(35), 
	"NAME" VARCHAR2(50), 
	"DESCRIPTION" CLOB, 
	"DISPLAY" NUMBER(3,0), 
	"TICKETPREFIX" VARCHAR2(20), 
	"ADDED" DATE, 
	"ADDEDBY" CHAR(35) NOT NULL ENABLE, 
	"STATUS" VARCHAR2(8), 
	"SVNURL" VARCHAR2(100), 
	"SVNUSER" VARCHAR2(20), 
	"SVNPASS" VARCHAR2(20), 
	"ALLOW_REG" NUMBER(1,0) NULL,
	"REG_ACTIVE" NUMBER(1,0) NULL, 
	"REG_FILES" NUMBER(1,0) NULL, 
	"REG_ISSUES" NUMBER(1,0) NULL, 
	"REG_MSGS" NUMBER(1,0) NULL, 
	"REG_MSTONES" NUMBER(1,0) NULL, 
	"REG_SVN" NUMBER(1,0) NULL,
	"REG_TIME" NUMBER(1,0) NULL,
	"REG_TODOS" NUMBER(1,0) NULL, 
	"TAB_BILLING" NUMBER(1,0) NULL,             
	"TAB_FILES" NUMBER(1,0) NULL, 
	"TAB_ISSUES" NUMBER(1,0) NULL, 
	"TAB_MSGS" NUMBER(1,0) NULL, 
	"TAB_MSTONES" NUMBER(1,0) NULL, 
	"TAB_SVN" NUMBER(1,0) NULL,
	"TAB_TIME" NUMBER(1,0) NULL,
	"TAB_TODOS" NUMBER(1,0) NULL,
    "ISSUE_SVN_LINK" NUMBER(1,0) NULL,
    "ISSUE_TIMETRACK" NUMBER(1,0) NULL,
	 CONSTRAINT "PK_PT_PROJECTS" PRIMARY KEY ("PROJECTID") ENABLE
   )
/
CREATE TABLE  "PT_SCREENSHOTS" 
   (	"FILEID" CHAR(35) NOT NULL ENABLE, 
	"ISSUEID" CHAR(35) NOT NULL ENABLE, 
	"TITLE" VARCHAR2(200), 
	"DESCRIPTION" CLOB, 
	"FILENAME" VARCHAR2(150), 
	"SERVERFILENAME" VARCHAR2(150), 
	"FILETYPE" VARCHAR2(4), 
	"FILESIZE" NUMBER(10,0), 
	"UPLOADED" DATE, 
	"UPLOADEDBY" CHAR(35) NOT NULL ENABLE, 
	 CONSTRAINT "PK_PT_SCREENSHOTS" PRIMARY KEY ("FILEID") ENABLE
   )
/
CREATE TABLE  "PT_SETTINGS" 
   (	"SETTINGID" CHAR(35) NOT NULL ENABLE, 
	"SETTING" VARCHAR2(50), 
	"SETTINGVALUE" VARCHAR2(250), 
	 CONSTRAINT "PK_PT_SETTINGS" PRIMARY KEY ("SETTINGID") ENABLE
   )
/
CREATE TABLE  "PT_SVN_LINK" 
   (	"LINKID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35), 
	"REVISION" NUMBER(5,0), 
	"ITEMID" CHAR(35), 
	"ITEMTYPE" VARCHAR2(10), 
	 CONSTRAINT "PK_PT_SVN_LINK" PRIMARY KEY ("LINKID") ENABLE
   )
/
CREATE TABLE  "PT_TIMETRACK" 
   (	"TIMETRACKID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"USERID" CHAR(35) NOT NULL ENABLE, 
	"DATESTAMP" DATE, 
	"HOURS" NUMBER(6,2), 
	"DESCRIPTION" VARCHAR2(255), 
	"ITEMID" VARCHAR2(35), 
	"ITEMTYPE" VARCHAR2(10),
	"RATEID" VARCHAR2(35),  
	 CONSTRAINT "PK_PT_TIMETRACK" PRIMARY KEY ("TIMETRACKID") ENABLE
   )
/
CREATE TABLE  "PT_TODOLISTS" 
   (	"TODOLISTID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"TITLE" VARCHAR2(100), 
	"DESCRIPTION" CLOB, 
	"MILESTONEID" VARCHAR2(35), 
	"USERID" CHAR(35) NOT NULL ENABLE, 
	"ADDED" DATE, 
	"RANK" NUMBER(3,0), 
	"TIMETRACK" NUMBER(1,0), 
	 CONSTRAINT "PK_PT_TODOLISTS" PRIMARY KEY ("TODOLISTID") ENABLE
   )
/
CREATE TABLE  "PT_TODOS" 
   (	"TODOID" CHAR(35) NOT NULL ENABLE, 
	"TODOLISTID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"USERID" CHAR(35) NOT NULL ENABLE, 
	"TASK" VARCHAR2(600), 
	"RANK" NUMBER(10,0), 
	"ADDED" DATE, 
	"DUE" DATE, 
	"COMPLETED" DATE, 
	 CONSTRAINT "PK_PT_TODOS" PRIMARY KEY ("TODOID") ENABLE
   )
/
CREATE TABLE  "PT_USERS" 
   (	"USERID" CHAR(35) NOT NULL ENABLE, 
	"FIRSTNAME" VARCHAR2(12), 
	"LASTNAME" VARCHAR2(20), 
	"USERNAME" VARCHAR2(50), 
	"PASSWORD" CHAR(32), 
	"EMAIL" VARCHAR2(120), 
	"PHONE" VARCHAR2(15), 
	"MOBILE" VARCHAR2(15), 
	"CARRIERID" VARCHAR2(35), 
	"LASTLOGIN" DATE, 
	"AVATAR" NUMBER(1,0), 
	"STYLE" VARCHAR2(20), 
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
	"ADMIN" NUMBER(1,0), 
	"ACTIVE" NUMBER(1,0), 
	 CONSTRAINT "PK_PT_USERS" PRIMARY KEY ("USERID") ENABLE
   )
/

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('8464AB28-1372-7975-6F2E9747CA6E4693','ATT','US','United States','','@txt.att.net',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('8464DE00-1372-7975-6FE886FCD149E667','Boost','US','United States','','@myboostmobile.com',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('84653DF3-1372-7975-6F03DA67DD9FB6A9','Cingular','US','United States','','@txt.att.net',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('846562C1-1372-7975-6F0D79371C491F0C','Helio','US','United States','','@messaging.sprintpcs.com',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('846589B2-1372-7975-6F34C8F27502E0DE','Nextel','US','United States','','@messaging.nextel.com',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('8465AECE-1372-7975-6FAEBDD9F3DDB156','Sprint','US','United 
States','','@messaging.sprintpcs.com',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('846F02F5-1372-7975-6F6C106050F904CD','T-Mobile','US','United States','','@tmomail.net',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('8465D060-1372-7975-6F83333D63966358','Verizon','US','United States','','@vtext.com',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('8465FEC3-1372-7975-6F5CA6C75C25C7D4','Virgin USA','US','United States','','@vmobl.com',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('84662779-1372-7975-6F8F1751F5B64D4E','Aliant Mobility','CA','Canada','','@chat.wirefree.ca',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('846652B0-1372-7975-6F46C791E680C346','Bell Mobility','CA','Canada','','@txt.bellmobility.ca',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('84667ED1-1372-7975-6F97CD40347FC5CB','Fido','CA','Canada','','@fido.ca',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('8466BB0F-1372-7975-6F6ABCC0603EE274','MTS','CA','Canada','','@text.mtsmobility.com',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('8466DE85-1372-7975-6F261B5E9D329B92','Rogers','CA','Canada','','@pcs.rogers.com',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('8466FEFD-1372-7975-6F8EA4D54A0C57F3','SaskTel','CA','Canada','','@sms.sasktel.com',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('84672060-1372-7975-6F8456BEBA71E39A','Solo Mobile','CA','Canada','','@txt.bell.ca',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('84675A6C-1372-7975-6F496C2375ED2815','TELUS','CA','Canada','','@msg.telus.com',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('84677BCF-1372-7975-6F89C8D24436A08A','Virgin Canada','CA','Canada','','@vmobile.ca',1);

INSERT INTO pt_carriers (carrierid,carrier,countrycode,country,prefix,suffix,active)  
values('8467A2B0-1372-7975-6FEB7589919DC435','O2','UK','United Kingdom','','@mmail.co.uk',1);


INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('FC3D187C-16E6-58DE-133C5098C58225D3','app_title','Project Tracker');

INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('FC3D861A-16E6-58DE-1346E4E01F578F52','default_style','blue');

INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('E59DED9F-1372-7975-6FCD9DFAE904B617','enable_api','0');

INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('E5A50225-1372-7975-6F9777FB42FD45E6','api_key','');

INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('50ED062A-16E6-58DE-13EF9FEB2312EE8C','email_subject_prefix','');

INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('50ED2D69-16E6-58DE-130067F4C29ABF35','sms_subject_prefix','');

INSERT INTO pt_users
(userID,firstName,lastName,username,password,style,email_files,mobile_files,email_issues,mobile_issues,email_msgs,mobile_msgs,email_mstones,mobile_mstones,email_todos,mobile_todos,avatar,admin,active) 
values('FCDCF4CD-16E6-58DE-13EDC6A2B362B22C','Admin','User','admin','21232F297A57A5A743894A0E4A801FC3','blue',0,0,0,0,0,0,0,0,0,0,0,1,1
);

INSERT INTO pt_users
(userID,firstName,lastName,username,password,style,email_files,mobile_files,email_issues,mobile_issues,email_msgs,mobile_msgs,email_mstones,mobile_mstones,email_todos,mobile_todos,avatar,admin,active) 
values('7F16CA08-1372-7975-6F7F9DA33EBD6A09','Guest','User','guest','084E0343A0486FF05530DF6C705C8BB4','blue',0,0,0,0,0,0,0,0,0,0,0,0,1
);

create or replace function month(v_date in date) return varchar2 is
begin
return(to_char(v_date, 'mm'));
end month;
create or replace function year(v_date in date) return varchar2 is
begin
return(to_char(v_date, 'yyyy'));
end year;	

/
