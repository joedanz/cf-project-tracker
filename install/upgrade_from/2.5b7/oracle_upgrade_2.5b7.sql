/* UPGRADE FROM 2.5 beta 7 */

/* pt_projects - add new column */
alter table
   pt_projects
add
   (
   reg_report NUMBER(1,0) NULL
   );
update pt_projects set reg_report = 0;
