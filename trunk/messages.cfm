<cfsetting enablecfoutputonly="true">

<cfparam name="url.p" default="">
<cfset project = application.project.get(session.user.userid,url.p)>

<cfif isDefined("url.dm") and not compare(hash(url.dm),url.dmh>
	<cfset application.message.delete(url.p,url.dm)>
<cfelseif isDefined("url.v")>
	<cfset session.user.msgview = url.v>
</cfif>

<cfparam name="session.user.msgview" default="full">
<cfparam name="url.c" default="">
<cfparam name="url.ms" default="">
<cfparam name="url.m" default="0">
<cfparam name="url.y" default="0">

<cfset messages = application.message.get(url.p,'',url.c,url.ms,url.m,url.y)>
<cfset categories = application.message.categories(url.p)>
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
						<cfif not compare(session.user.msgview,'full')><span class="current">Expanded View</span><cfelse><a href="#cgi.script_name#?p=#url.p#&v=full">Expanded View</a></cfif> | 
						<cfif not compare(session.user.msgview,'list')><span class="current">List View</span><cfelse><a href="#cgi.script_name#?p=#url.p#&v=list">List View</a></cfif>
					</span>
					</cfif>
					
					<h2 class="msg">
					<cfif compare(url.c,'')>
						Messages in category: #url.c#
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
					#DateFormat(stamp,"dddd, d mmmm")#
					</span>
					 	
					<div class="wrapper itemlist">
					<h3 class="padtop">#title#</h3>
					<cfif commentCount>
						<cfset comment = application.comment.get(url.p,messageID,'','1')>
						<a class="b" href="message.cfm?p=#url.p#&m=#messageID###comments">#commentCount# comment<cfif commentCount gt 1>s</cfif></a>
						<span style="color:##666;">
						&nbsp;Last by #comment.firstName# #comment.lastName# on #DateFormat(comment.stamp,"ddd, mmm d")# at #TimeFormat(comment.stamp,"h:mmtt")#
						</span>
					</cfif>
					<p>#message#</p>
					<cfif compare(name,'')><div class="ms">Milestone: #name#</div></cfif>
					<div class="byline<cfif currentRow neq recordCount> listitem</cfif>">
						Posted by #firstName# #lastName# in <a href="#cgi.script_name#?p=#url.p#&c=#urlEncodedFormat(category)#">#category#</a>
						<cfif userID eq session.user.userID or session.user.admin> | <a href="editMessage.cfm?p=#url.p#&m=#messageID#&mh=#hash(messageID)#" class="edit">Edit</a>
						 | <a href="messages.cfm?p=#url.p#&dm=#messageID#&dmh=#hash(messageID)#" class="delete" onclick="return confirm('Are you sure you wish to delete this message and all associated comments?')">Delete</a></cfif>
						<cfif allowComments> | <a href="message.cfm?p=#url.p#&m=#messageID###comments" class="comment">Post <cfif not commentCount>the first<cfelse>another</cfif> comment</a></cfif>
					</div>
					</div>
					</cfloop>
					<cfelse> <!--- list view --->
					
					<div class="wrapper">
					<cfloop query="messages">
					<div style="border-bottom:1px solid ##ccc;padding:10px;">
					<div style="float:right;width:300px;">
						<cfif commentCount eq 0><span class="comment g">No comments posted.</span><cfelse>
						<cfset comment = application.comment.get(url.p,'','1')>
						<span class="comment g">
						&nbsp;Last comment by #firstName# #lastName#<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<cfif DateDiff("n",stamp,Now()) lt 60>
							#DateDiff("n",stamp,Now())# minutes
						<cfelseif DateDiff("h",stamp,Now()) lt 24>
							#DateDiff("h",stamp,Now())# hours
						<cfelseif DateDiff("d",stamp,Now()) lt 31>
							#DateDiff("d",stamp,Now())# days
						<cfelseif DateDiff("m",stamp,Now()) lt 12>
							#DateDiff("m",stamp,Now())# months
						<cfelse>
							#DateDiff("y",stamp,Now())# year<cfif DateDiff("y",stamp,Now()) gt 1>s</cfif>
						</cfif> ago						
						</span>
						</cfif>
					</div>	
						
					<a href="message.cfm?p=#url.p#&m=#messageID#" class="fs12">#title#</a><br />
					by #firstName# #lastName# on #dateFormat(stamp,"ddd, d mmm")# at #timeFormat(stamp,"h:mmtt")#
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
		
		<h3><a href="editMessage.cfm?p=#url.p#" class="add">Post a new message</a></h3><br />
		
		<cfif categories.recordCount>
		<div class="header"><h3>Categories</h3></div>
		<div class="content">
			<ul>
				<cfloop query="categories">
					<li><a href="#cgi.script_name#?p=#url.p#&c=#urlEncodedFormat(category)#">#category#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>
		
		<cfif milestones.recordCount>
		<div class="header"><h3>Milestones</h3></div>
		<div class="content">
			<ul>
				<cfloop query="milestones">
					<li><a href="#cgi.script_name#?p=#url.p#&ms=#milestoneid#">#name#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>
		
		<cfif dates.recordCount>
		<div class="header"><h3>Timeframe</h3></div>
		<div class="content">
			<ul>
				<cfloop query="dates">
					<li><a href="#cgi.script_name#?p=#url.p#&m=#m#&y=#y#">#monthAsString(m)# #y#</a></li>
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