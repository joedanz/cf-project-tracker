alter table pt_message_files add ( type VARCHAR2(6) NULL );

alter table pt_message_files rename column messageID to itemID;

update pt_message_files	set type = 'msg';
	
alter table pt_message_files rename to pt_file_attach;

ALTER TABLE pt_file_attach DROP CONSTRAINT PK_PT_FILE_ATTACH;
   
alter table pt_file_attach modify ( type VARCHAR2(6) NOT NULL );   

ALTER TABLE pt_file_attach
ADD CONSTRAINT PK_PT_FILE_ATTACH PRIMARY KEY("ITEMID", "FILEID", "TYPE");

CREATE TABLE  "PT_SCREENSHOTS" 
   (	"FILEID" CHAR(35) NOT NULL ENABLE, 
	"ISSUEID" CHAR(35) NOT NULL ENABLE, 
	"TITLE" VARCHAR2(200), 
	"DESCRIPTION" CLOB, 
	"CATEGORYID" CHAR(35) NOT NULL ENABLE, 
	"FILENAME" VARCHAR2(150), 
	"SERVERFILENAME" VARCHAR2(150), 
	"FILETYPE" VARCHAR2(4), 
	"FILESIZE" NUMBER(10,0), 
	"UPLOADED" DATE, 
	"UPLOADEDBY" CHAR(35) NOT NULL ENABLE, 
	 CONSTRAINT "PK_PT_SCREENSHOTS" PRIMARY KEY ("FILEID") ENABLE
   );