Project Tracker v1.0
by Joe Danziger (joe@ajaxcf.com)

Initial Release: June 5, 2007
Current Release: November 30, 2007

This application was inspired by Basecamp (http://www.basecamphq.com) 
put out by the 37signals crew.  Not too much documentation but 
hopefully most should be self explanatory.

INSTALLATION:
You need to edit the settings files in the config directory.
One is called when using the built in dev server on 127.0.0.1,
the settings.ini.cfm settings get called in any other instance.

The rootURL should be set to the site address without any trailing 
slash or directories - just the http:// plus the hostname or
IP address.  The mapping should be set to "/project" or wherever
you've placed the application - also with no trailing slash.

You also need to install the database tables (scripts are included).  
The scripts add an admin and a guest user, plus 2 entries for default 
settings.  You can name your database whatever you'd like but make
sure to match the settings in the config files.

UPGRADING FROM 1.0 BETA:
To upgrade, simply copy the latest files over the existing ones.
You may need to reinitialize you app by adding a "?reinit" on
the end of a URL.  All of the settings are contained in the 
config directory and in the database.  You should keep your 
existing config files and copy them back on top of the newly
installed ones.  
Database changes made since the beta:
  1) pt_comments - "comment" extended to 1000 characters.
  2) pt_project_users - "role" extended to 9 characters.
  3) pt_todolists - "description" extended to 1000 characters.
  4) pt_todos - "task" extended to 300 characters.
Database changes made since version 1.0:
  1) pt_users - guest user now added by default.
  				"mobile" varchar(15) added
  				"carrierID" varchar(35) added
  				"email_todos" tinyint(1) added
  				"mobile_todos" tinyint(1) added
  				"email_mstones" tinyint(1) added
  				"mobile_nstones" tinyint(1) added
  				"email_issues" tinyint(1) added
  				"mobile_issues" tinyint(1) added

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
ColdFusion or BlueDragon
CF8/BD7 required for avatars
mySQL or SQL Server

AUTO-LOGIN MODIFICATION:
To launch the application in an already logged in state as the guest user
(this is good for public views of projects), include "?guest" at the end
of your project URL.  If you use this as your project URLm you will still 
be able to logout and log back in as a different user.  You must still 
mofify the settings for the guest account to determine which projects are
accessible.

FEEDBACK?
Please email joe@ajaxcf.com with any suggestions or other feedback.
My wishlist, should you be inclined, is located at:
http://amazon.com/gp/registry/wishlist/1X4EGLWAC43FJ/102-5824999-1765764

PROJECT HOME:
http://projecttracker.riaforge.com 

SVN REPOSITORY:
http://svn.riaforge.org/projecttracke

INCLUDED CODE:
RSS feeds created using rss.cfc by Ray Camden (www.coldfusionjedi.com)