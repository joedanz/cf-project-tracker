<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfif StructKeyExists(url,"a")>
	<cfset application.role.add(url.p,url.a,url.r)>
	<cfset thread = CreateObject("java", "java.lang.Thread")>
	<cfset thread.sleep(250)>	
<cfelseif StructKeyExists(form,"addnew")>
	<cfset newID = createUUID()>
	<cfset application.user.create(newID,form.f,form.l,form.e,form.admin)>
	<cfset application.role.add(form.p,newID,form.r)>
	<cfset thread = CreateObject("java", "java.lang.Thread")>
	<cfset thread.sleep(250)>
	<cfset url.p = form.p>
<cfelseif StructKeyExists(url,"d")>
	<cfset application.role.remove(url.p,url.d)>
	<cfset thread = CreateObject("java", "java.lang.Thread")>
	<cfset thread.sleep(250)>	
</cfif>

<cfset projectUsers = application.project.projectUsers(url.p)>
<cfset userRole = application.role.get(session.user.userid,url.p)>

<cfoutput>
	<cfloop query="projectUsers">
	<div class="user<cfif currentRow neq recordCount> listitem</cfif>" id="#userID#">
		<h4 class="b">#lastName#, #firstName#&nbsp;
		<span style="font-weight:normal;font-size:.9em;">(<cfif compare(role,'')>#role#<cfelse>User</cfif>)</span></h4>
		<cfif compare(email,'')><a href="mailto:#email#">#email#</a><br /></cfif>
		<cfif compare(phone,'')>#phone#<br /></cfif>
		
		<cfif (listFind('Admin,Owner',userRole.role) and compare('Owner',role)) or session.user.userID eq userID>						<div style="font-weight:bold;font-size:.9em;margin-top:3px;">[ 
			
		<cfif session.user.userID eq userID><a href="account.cfm">edit</a></cfif>
		
		<cfif session.user.userID eq userID and listFind('User,Admin,Read-Only',role)> / </cfif>

 		<cfif listFind('User,Admin,Read-Only',role)>
 		<a href="##" onclick="remove_user('#url.p#','#userID#','#lastName#','#firstName#');$('###userID#').DropOutDown(500);">remove from project</a></cfif>
		<cfif compareNoCase('Owner',role)>
	 		<cfif compareNoCase('User',role)> / <a href="people.cfm?p=#url.p#&u=#userID#&r=Admin">make user</a></cfif>
	 		<cfif compareNoCase('Admin',role)> / <a href="people.cfm?p=#url.p#&u=#userID#&r=Admin">make admin</a></cfif>
			<cfif compareNoCase('Read-Only',role)> / <a href="people.cfm?p=#url.p#&u=#userID#&r=Read-Only">make read-only</a></cfif>
		</cfif>
 		]</div>
 		</cfif>					
		
	</div>
	</cfloop>
</cfoutput>

<cfif StructKeyExists(url,"a")>
	<cfoutput>
	<script type="text/javascript">
		$('###url.a#').Highlight(2000, '##ffa');
	</script>
	</cfoutput>	
</cfif>


<cfsetting enablecfoutputonly="false">