<cfsetting enablecfoutputonly="true">

<cfset projects = application.project.get(session.user.userid)>
<cfquery name="active_projects" dbtype="query">
	select * from projects where status = 'Active'
</cfquery>
<cfquery name="onhold_projects" dbtype="query">
	select * from projects where status = 'On-Hold'
</cfquery>
<cfquery name="arch_projects" dbtype="query">
	select * from projects where status = 'Archived'
</cfquery>
<cfif not projects.recordCount>
	<cfset QueryAddRow(projects)>
	<cfset QuerySetCell(projects, "projectID", "0")>
</cfif>
<cfset todolists = application.todolist.get('','',valueList(projects.projectID))>
<cfset todos = application.todo.get('','','','rank,added','',valueList(projects.projectID))>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; To-Dos">

<cfhtmlhead text='<script type="text/javascript" src="./js/todos.js"></script>
'>

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2 class="todo">To-do items across all your projects</h2>
				</div>
				<div class="content">
				 	<div class="wrapper">
					 	
					 	
					<cfif todolists.recordCount>
					 	
					<div class="listWrapper" id="lw">
					<cfloop query="todolists">
					<div class="listItem todolist" id="#todolistID#" style="margin-bottom:20px;">
					<div class="top"><a href="##" onclick="$('##todoitems#todolistID#').toggle();$('##todocomplete#todolistID#').toggle();">show/hide</a></div>
					
					<h3 class="padtop padbottom list"><a href="project.cfm?p=#projectID#">#projName#</a> : <a href="todos.cfm?p=#projectID#&t=#todolistID#">#title#</a></h3>
						<div class="tododetail">
						<cfif compare(description,'')><div style="font-style:italic;">#description#</div></cfif>
						<cfquery name="todos_notcompleted" dbtype="query">
							select * from todos where todolistID = '#todolistID#' and completed IS NULL
						</cfquery>
						<ul class="nobullet" id="todoitems#todolistID#" style="display:none;">
						<cfloop query="todos_notcompleted">
						<li class="li#todolistID#" id="#todoID#"><input type="checkbox" name="todoID" value="#todoID#" class="cb#todolistID#" onclick="mark_complete('#projectID#','#todolistID#','#todoID#');" /> #task#<cfif compare(lastname,'')> <span class="g">(#firstName# #lastName#)</span></cfif></li>
						<li><div id="edititemform#todoID#" style="display:none;background-color:##ddd;padding:5px;">
						</div>
						</li>
												
						</cfloop>
						</ul>

						
						
						<cfquery name="todos_completed" dbtype="query">
							select * from todos where todolistID = '#todolistID#' and completed IS NOT NULL
						</cfquery>
						<ul class="nobullet" id="todocomplete#todolistID#" style="display:none;">
						<cfloop query="todos_completed">
						<li class="g" id="#todoID#"><input type="checkbox" name="todoID" value="#todoID#" checked="checked" onclick="mark_incomplete('#projectID#','#todolistID#','#todoID#');" /> <strike>#task#</strike> - <span class="g">#DateFormat(completed,"mmm d")#</span> <span class="li_edit"><a href="##" onclick="$('###todoID#').hide();$('##edititemform#todoID#').show();$('##ta#todoID#').focus();"><img src="./images/edit_sm.gif" height="11" width="13" alt="Edit?" /></a> <a href="##" onclick="delete_li('#projectID#','#todolistID#','#todoID#')"><img src="./images/trash_sm.gif" height="12" width="13" alt="Delete?" /></a></span></li>
						
						<li><div id="edititemform#todoID#" style="display:none;background-color:##ddd;padding:5px;">
						</div>
						</li>								
						
						</cfloop>
						</ul>
						</div>
						
						<div style="margin-top:10px;padding-top:10px;border-top:1px solid ##999;">
						<cfset daysago = DateDiff("d",added,Now())>
<cfif compare(name,'')><div class="ms mstone">Milestone: #name#</div></cfif>
<div class="posted">Posted by #firstName# #lastName# on #DateFormat(added,"dddd, mmmm d, yyyy")# (<cfif daysago eq 0>Today<cfelse>#daysago# Day<cfif daysago neq 1>s</cfif> Ago</cfif>)</div>
						</div>
						
					</div>
					</cfloop>
					</div>

					<cfelse>
						<div class="warn">You have no to-do items.</div> 	
					</cfif>					 	
					 	
					 	
					</div>
				</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">

		<h3><a href="editProject.cfm" class="add">Create a new project</a></h3><br />

		<cfif active_projects.recordCount>
		<div class="header"><h3>Your projects</h3></div>
		<div class="content">
			<ul>
				<cfloop query="active_projects">
					<li><a href="project.cfm?p=#projectID#">#name#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>
		
		<cfif onhold_projects.recordCount>
		<div class="header"><h3>On-Hold projects</h3></div>
		<div class="content">
			<ul>
				<cfloop query="onhold_projects">
					<li><a href="project.cfm?p=#projectID#">#name#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>
		
		<cfif arch_projects.recordCount>
		<div class="header"><h3>Archived projects</h3></div>
		<div class="content">
			<ul>
				<cfloop query="arch_projects">
					<li><a href="project.cfm?p=#projectID#">#name#</a></li>
				</cfloop>
			</ul>
		</div>
		</cfif>

	</div>
		
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">