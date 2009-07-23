/* UPGRADE FROM 2.5 beta 6 */

/* pt_project_users - add new column */
alter table
   pt_project_users
add
   (
   report NUMBER(1,0) NULL
   );
update pt_project_users set report = 0;

/* pt_projects - add new column */
alter table
   pt_projects
add
   (
   allow_def_rates NUMBER(1,0) NULL
   );
update pt_projects set allow_def_rates = 1;

/* pt_settings - add new settings */
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('89DDF566-1372-7975-6F192B9AFBDB218A','default_locale','English (US)');
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('89B9B664-1372-7975-6F7D802298571968','default_timezone','US/Eastern');

/* pt_users - add new columns */
alter table
   pt_users
add
   (
   locale varchar2(32) NULL,
   timezone varchar2(32) NULL,
   report NUMBER(1,0) NULL, 
   invoice NUMBER(1,0) NULL
   );
update pt_users set locale = 'English (US)';
update pt_users set timezone = 'US/Eastern';
update pt_users set report = 0;
update pt_users set invoice = 0;