<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif not StructKeyExists(url,'p')>
	<cfoutput><h2>No Project Selected!</h2></cfoutput><cfabort>
</cfif>

<cfif session.user.admin>
	<cfset project = application.project.get(projectID=url.p)>
<cfelse>
	<cfset project = application.project.get(session.user.userid,url.p)>
</cfif>

<cfif not session.user.admin and not project.msg_view eq 1>
	<cfoutput><h2>You do not have permission to access messages!!!</h2></cfoutput>
	<cfabort>
</cfif>

<cfif StructKeyExists(url,"dm") and not compare(hash(url.dm),url.dmh)>
	<cfset application.message.delete(url.p,url.dm)>
<cfelseif StructKeyExists(url,"v")>
	<cfset session.user.msgview = url.v>
</cfif>

<cfparam name="session.user.msgview" default="full">
<cfparam name="url.c" default="">
<cfparam name="url.ms" default="">
<cfparam name="url.m" default="0">
<cfparam name="url.y" default="0">

<cfset messages = application.message.get(url.p,'',url.c,url.ms,url.m,url.y)>
<cfset categories = application.category.get(url.p,'msg')>
<cfset milestones = application.message.milestones(url.p)>
<cfset dates = application.message.dates(url.p)>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#project.name# &raquo; Messages" project="#project.name#" projectid="#url.p#" svnurl="#project.svnurl#">

<cfoutput>
<div id="container">
<cfif project.recordCount>
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<cfif messages.recordCount>
					<span class="rightmenu">
						<cfif not compare(session.user.msgview,'full')><span class="current">Expanded View</span><cfelse><a href="#cgi.script_name#?p=#url.p#&amp;v=full">Expanded View</a></cfif> | 
						<cfif not compare(session.user.msgview,'list')><span class="current">List View</span><cfelse><a href="#cgi.script_name#?p=#url.p#&amp;v=list">List View</a></cfif>
					</span>
					</cfif>
					
					<h2 class="msg">
					<cfif compare(url.c,'')>
						<cfset category = application.category.get(url.p,'msg',url.c)>
						Messages in category: #category.category#
					<cfelseif compare(url.ms,'')>
						Messages for milestone: #messages.name#
					<cfelseif compare(url.m,'0')>
						Messages from #monthAsString(url.m)# #url.y#
					<cfelse>
						All messages
					</cfif>
					</h2>
				</div>
				<div class="content">
									 	
				 	<cfif messages.recordCount>
				 	
				 	
				 	<cfif not compare(session.user.msgview,'full')> <!--- expanded view --->
				 	<cfloop query="messages">
					<span class="stamp">
					#LSDateFormat(DateAdd("h",session.tzOffset,stamp),"dddd, d mmmm")#
					</span>
					 	
					<div class="wrapper itemlist">
					<h3 class="padtop">#title#</h3>
					<cfif commentCount>
						<cfset comment = application.comment.get(url.p,'msg',messageID,'1')>
						<a class="b" href="message.cfm?p=#url.p#&amp;m=#messageID###comments">#commentCount# comment<cfif commentCount gt 1>s</cfif></a>
						<span style="color:##666;">
						&nbsp;Last by #comment.firstName# #comment.lastName# on #LSDateFormat(DateAdd("h",session.tzOffset,comment.stamp),"ddd, mmm d")# at <cfif application.settings.clockHours eq 12>#LSTimeFormat(DateAdd("h",session.tzOffset,comment.stamp),"h:mmtt")#<cfelse>#LSTimeFormat(DateAdd("h",session.tzOffset,comment.stamp),"HH:mm")#</cfif>
						</span>
					</cfif>
					<p>#message#</p>
					<cfif compare(name,'')><div class="ms">Milestone: #name#</div></cfif>
					<div class="byline">
						Posted by #firstName# #lastName# in <a href="#cgi.script_name#?p=#url.p#&amp;c=#categoryID#">#category#</a>
						<cfif session.user.admin or project.msg_edit eq 1 or userID eq session.user.userID> | <a href="editMessage.cfm?p=#url.p#&amp;m=#messageID#&amp;mh=#hash(messageID)#" class="edit">Edit</a>
						 | <a href="messages.cfm?p=#url.p#&amp;dm=#messageID#&amp;dmh=#hash(messageID)#" class="delete" onclick="return confirm('Are you sure you wish to delete this message and all associated comments?')">Delete</a></cfif>
						<cfif allowComments> | <a href="message.cfm?p=#url.p#&amp;m=#messageID###comments" class="comment"><cfif not commentCount>Post the first comment<cfelse>#commentCount# comment<cfif commentCount gt 1>s</cfif> posted</cfif></a></cfif>
						<cfif attachcount gt 0> | <a href="message.cfm?p=#url.p#&amp;m=#messageID###attach" class="attach">#attachcount# file<cfif attachcount gt 1>s</cfif> attached</a></cfif>
					</div>
					</div>
					</cfloop>
					<cfelse> <!--- list view --->
					
					<div class="wrapper">
					<cfloop query="messages">
					<div style="border-bottom:1px solid ##ccc;padding:10px 5px;">
					<div style="float:right;width:250px;">
						<cfif commentCount eq 0><span class="comment g">No comments posted.</span><cfelse>
						<cfset comment = application.comment.get(url.p,'msg',messageID,'1')>
						<span class="comment g">
						&nbsp;Last comment by #firstName# #lastName#<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						#request.udf.relativeTime(DateAdd("h",session.tzOffset,stamp))#				
						</span>
						</cfif>
						
					</div>	
					
					<div style="float:right;width:120px;margin-right:20px;">
					<cfif attachcount gt 0><a href="message.cfm?p=#url.p#&amp;m=#messageID###attach" class="attach">#attachcount# file<cfif attachcount gt 1>s</cfif> attached</a></cfif>
					</div>
						
					<a href="message.cfm?p=#url.p#&amp;m=#messageID#" class="fs12">#title#</a><br />
					by #firstName# #lastName# on #LSDateFormat(DateAdd("h",session.tzOffset,stamp),"ddd, d mmm")# at <cfif application.settings.clockHours eq 12>#LSTimeFormat(DateAdd("h",session.tzOffset,stamp),"h:mmtt")#<cfelse>#LSTimeFormat(DateAdd("h",session.tzOffset,stamp),"HH:mm")#</cfif>
					</div>
					</cfloop>
					</div>
					
					</cfif> <!--- end list view --->
					

					<cfelse>
					<div class="wrapper"><div class="warn">No messages have been posted.</div></div>
					</cfif>

				</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">
		<cfif compare(project.logo_img,'')>
			<img src="#application.settings.userFilesMapping#/projects/#project.logo_img#" border="0" alt="#project.name#" class="projlogo" />
		</cfif>
				
		<cfif session.user.admin or project.msg_edit eq 1>
		<h3><a href="editMessage.cfm?p=#url.p#" class="add">Post a new message</a></h3><br />
		</cfif>
		
		<cfif categories.recordCount>
		<div class="header"><h3>Categories</h3></div>
		<div class="content">
			<ul>
				<cfloop query="categories">
					<li><a href="#cgi.script_name#?p=#url.p#&amp;c=#categoryID#"<cfif not compareNoCase(url.c,categoryID)> class="b"</cfif>>#category#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>
		
		<cfif milestones.recordCount>
		<div class="header"><h3>Milestones</h3></div>
		<div class="content">
			<ul>
				<cfloop query="milestones">
					<li><a href="#cgi.script_name#?p=#url.p#&amp;ms=#milestoneid#"<cfif not compareNoCase(url.ms,milestoneID)> class="b"</cfif>>#name#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>
		
		<cfif dates.recordCount>
		<div class="header"><h3>Timeframe</h3></div>
		<div class="content">
			<ul>
				<cfloop query="dates">
					<li><a href="#cgi.script_name#?p=#url.p#&amp;m=#m#&amp;y=#y#"<cfif not compareNoCase(url.m,m) and not compareNoCase(url.y,y)> class="b"</cfif>>#monthAsString(m)# #y#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>
				
	</div>
<cfelse>
	<div class="alert">Project Not Found.</div>
</cfif>
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">