/* UPGRADE FROM 2.3 */
/* pt_projects */
alter table
   pt_projects
add
   (
   tab_files tinyint(1) NULL, 
   tab_issues tinyint(1) NULL, 
   tab_msgs tinyint(1) NULL, 
   tab_mstones tinyint(1) NULL, 
   tab_todos tinyint(1) NULL,             
   tab_svn tinyint(1) NULL
   );