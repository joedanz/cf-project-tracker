/* UPGRADE FROM 2.5 */

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