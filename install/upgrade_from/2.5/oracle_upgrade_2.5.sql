/* UPGRADE FROM 2.5 */

/* pt_issues */
alter table
   pt_issues
add
   (
   googlecalID VARCHAR2(500)
   );

/* pt_milestones */
alter table
   pt_milestones
add
   (
   googlecalID VARCHAR2(500)
   );

/* pt_projects */
alter table
   pt_projects
add
   (
   googlecal VARCHAR2(200)
   );

/* pt_settings */
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('3CB6A28B-78E7-D183-3355FDC2AD339924','googlecal_enable','0');
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('3CB6A28C-78E7-D183-33556DE390587F08','googlecal_user','');
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('3CB6A28D-78E7-D183-335507D438CAEB30','googlecal_pass','');
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('424E6B2F-78E7-D183-3355A1D332D34969','googlecal_timezone','US/Eastern');
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('3CB6A28E-78E7-D183-33550BDFD7405ECF','googlecal_offset','-5');

/* pt_todos */
alter table
   pt_todos
add
   (
   googlecalID VARCHAR2(500)
   );

/* pt_user_notify - add new columns for notification */
alter table
   pt_user_notify
add
   (
   email_todo_del NUMBER(1,0) NULL,
   mobile_todo_del NUMBER(1,0) NULL,
   email_todo_cmp NUMBER(1,0) NULL,
   mobile_todo_cmp NUMBER(1,0) NULL
   );

update pt_user_notify set email_todo_del = 0;
update pt_user_notify set mobile_todo_del = 0;
update pt_user_notify set email_todo_cmp = 0;
update pt_user_notify set mobile_todo_cmp = 0;
