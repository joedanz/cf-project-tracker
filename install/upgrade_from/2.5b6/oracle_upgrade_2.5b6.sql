/* UPGRADE FROM 2.5 beta 6 */

/* pt_settings - add new settings */
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('89DDF566-1372-7975-6F192B9AFBDB218A','default_locale','English (US)');
INSERT INTO pt_settings (settingid,setting,settingvalue) values 
('89B9B664-1372-7975-6F7D802298571968','default_timezone','US/Eastern');

/* pt_users - add new column */
alter table
   pt_users
add
   (
   locale varchar2(32) NULL,
   timezone varchar2(32) NULL
   );
update pt_users set locale = 'English (US)';
update pt_users set timezone = 'US/Eastern';