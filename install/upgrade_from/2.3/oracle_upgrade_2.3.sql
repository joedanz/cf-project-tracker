/* UPGRADE FROM 2.3 */
/* pt_projects */
alter table
   pt_projects
add
   (
   tab_files NUMBER(1,0) NULL, 
   tab_issues NUMBER(1,0) NULL, 
   tab_msgs NUMBER(1,0) NULL, 
   tab_mstones NUMBER(1,0) NULL, 
   tab_todos NUMBER(1,0) NULL,             
   tab_svn NUMBER(1,0) NULL
   );

/* pt_issues */
alter table
   pt_issues
add
   (
   componentID varchar2(35) NULL, 
   versionID varchar2(35) NULL,
   dueDate date
   );

CREATE TABLE  "PT_PROJECT_COMPONENTS" 
   (	"COMPONENTID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"COMPONENT" VARCHAR2(50), 
	 CONSTRAINT "PK_PT_PROJECT_COMPONENTS" PRIMARY KEY ("COMPONENTID") ENABLE
   )
/
CREATE TABLE  "PT_PROJECT_VERSIONS" 
   (	"VERSIONID" CHAR(35) NOT NULL ENABLE, 
	"PROJECTID" CHAR(35) NOT NULL ENABLE, 
	"VERSION" VARCHAR2(50), 
	 CONSTRAINT "PK_PT_PROJECT_VERSIONS" PRIMARY KEY ("VERSIONID") ENABLE
   )
/