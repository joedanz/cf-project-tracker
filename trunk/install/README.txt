Project Tracker v1.0 BETA
by Joe Danziger

Initial Release: June 5, 2007

This application was inspired by Basecamp (http://www.basecamphq.com) 
put out by the 37signals crew.  It is being released as open source
in response to the CFUnited contest to win a Wii.

Not too much documentation so far - hopefully most should be self explanatory.
This app is still under development and will be undergoing improvements.
It will be hosted on RIAForge so keep an eye there for updates.

INSTALLATION:
You also need to edit the settings files in the config directory.
One is called when using the built in dev server on 127.0.0.1,
the settings.ini.cfm settings get called in any other instance.
You need to install the database tables (scripts are included).  The 
scripts add a record for the admin user and 2 entries for default 
settings.  You can name your database whatever you'd like but make
sure to match the settings in the config files.

UPGRADING:
To upgrade, simply copy the lates files over the existing ones.
You may need to reinitialize you app by adding a "?reinit" on
the end of a URL.  All of the settings are contained in the 
config directory or in the database.

SUBVERSION NOTES:
There is a Subversion repository browser and code browser.  This 
has not undergone extensive testing, but it works on my system.
You need to install the subversion client tools on the server 
and then set the path to svn.exe in the settings files.

DEMO VERSION:
A demo of this app can currently be found at http://ajaxcf.com/project
This version if running on ColdFusion MX 7.  You can login with
username "admin" and password "admin".

ABOUT ROLES:
There are 3 possible roles a user can have.  Admins can make any changes
to any projects.  Project owners can edit project settings and add users
to projects.  Project users can contribute to any project they have been
assigned to (by an admin or project owner). 

REQUIREMENTS:
ColdFusion MX
ColdFusion 8 required for avatars
mySQL or SQL Server

FEEDBACK?
Please email joe@ajaxcf.com with any suggestions or other feedback.
My wishlist, should you be inclined, is located at:
http://amazon.com/gp/registry/wishlist/1X4EGLWAC43FJ/102-5824999-1765764

PROJECT HOME:
http://projecttracker.riaforge.com 