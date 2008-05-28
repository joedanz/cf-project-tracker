alter table pt_message_files add ( type VARCHAR2(6) NULL );

alter table pt_message_files rename column messageID to itemID;

update pt_message_files	set type = 'msg';
	
alter table pt_message_files rename to pt_file_attach;
   
alter table pt_file_attach modify ( type VARCHAR2(6) NOT NULL );   