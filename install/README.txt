Project Tracker v2.4.5
by Joe Danziger (joe@ajaxcf.com)

Initial Release: June 5, 2007
Current Release: January 16, 2009

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

If you change setting in the config files, you'll need to add 
"&reinit=1" at the end of any URL to refresh the system settings.

UPGRADING FROM 1.0 BETA:
To upgrade, simply copy the latest files over the existing ones.
You may need to reinitialize you app by adding a "?reinit" on the 
end of a URL.  All of the settings are contained in the config 
directory and in the database.  You should keep your existing 
config files and copy them back on top of the newly installed 
ones, but you may want to check for any added settings.  There
are also 2 database upgrade scripts to be run.
** Note: if you receive upgrade errors, it may be from ntext
   fields that cannot be altered automatically.  You may need
   to change these manually if you run into a problem.
   
UPGRADING FROM OTHER VERSIONS:
There are upgrade scripts included in the install directory for the
various versions.  Please run the necessary DB and/or CF scripts. 

DEMO VERSION:
A demo of this app can currently be found at http://ajaxcf.com/project
This version if running on ColdFusion MX 7 - so no image stuff.  
You can login with username "admin" and password "admin".

ABOUT ROLES:
There are 3 possible roles a user can have.  Admins can make any changes
to any projects.  Project owners can edit project settings and add users
to projects.  Project users can contribute to any project they have been
assigned to (by an admin or project owner). 

REQUIREMENTS:
ColdFusion or BlueDragon
CF8/BD7 required for avatars
mySQL, SQL Server, or Oracle

AUTO-LOGIN MODIFICATION:
To launch the application in an already logged in state as the guest user
(this is good for public views of projects), include "?guest" at the end
of your project URL.  If you use this as your project URLm you will still 
be able to logout and log back in as a different user.  You must still 
mofify the settings for the guest account to determine which projects are
accessible.

THANKS:
To Mark Mandel for getting the SVNKit and JavaLoader stuff working.
To Jeffry Houser and Jeff Coughlin for their many suggestions.
To Jason Dean for getting things going on Oracle.

FEEDBACK?
Please email joe@ajaxcf.com with any suggestions or other feedback.
My Amazon Wishlist, should you be so inclined, is located at:
http://amazon.com/gp/registry/wishlist/1X4EGLWAC43FJ/102-5824999-1765764

PROJECT HOME:
http://projecttracker.riaforge.com 

SVN REPOSITORY:
http://svn.riaforge.org/projecttracker

INCLUDED CODE:
RSS feeds created using rss.cfc by Ray Camden (www.coldfusionjedi.com)
SVNBrowser and CFDiff CFCs by Rick Osborne (http://rickosborne.org/)
JavaLoader by Mark Mandel used for SVNKit (http://www.compoundtheory.com/)
API help from BasecampCFC by Terrence Ryan (http://www.numtopia.com/terry/)