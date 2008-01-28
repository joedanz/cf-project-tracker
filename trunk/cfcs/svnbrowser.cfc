<cfcomponent displayname="svnbrowser" output="false" hint="Subversion Repository Browser">
	<!---
	svn browser
	Original Code by Rick Osborne

	License: Mozilla Public License (MPL) version 1.1 - http://www.mozilla.org/MPL/
	READ THE LICENSE BEFORE YOU USE OR MODIFY THIS CODE
	--->

	<cfscript>
		variables.static = StructNew();
		variables.static.javaKey = "A9046475-06FF-9736-763E9BB4FC8112C1";
	</cfscript>

	<cffunction name="init" output="true" returntype="svnbrowser" description="Initialize our object" displayname="init">
		<cfargument name="RepositoryURL" type="string" required="true">
		<cfargument name="Username" type="string" required="false" default="">
		<cfargument name="Password" type="string" required="false" default="">
		<cfif IsDefined("super.init")><cfset super.init()></cfif>
		<!---
		The TMate JavaSVN library requires the following notice, so don't delete it!
		Copyright (c) 2004-2006 TMate Software. All rights reserved.
		It can be acquired from: http://tmate.org/svn/
		--->
		<cfset initJavaLoader() />

		<cfset this.drf=getJavaLoader().create("org.tmatesoft.svn.core.internal.io.dav.DAVRepositoryFactory").setup()>
		<cfset this.srf = getJavaLoader().create("org.tmatesoft.svn.core.io.SVNRepositoryFactory")>
		<cfset this.URL=Arguments.RepositoryURL>
		<cfset this.User=Arguments.Username>
		<cfset this.Password=Arguments.Password>
		<cfset this.Repository=this.srf.create(getJavaLoader().create("org.tmatesoft.svn.core.SVNURL").parseURIEncoded(this.URL))>
		<cfif (this.User NEQ "")>
			<cfset this.Repository.setAuthenticationManager(getJavaLoader().create("org.tmatesoft.svn.core.wc.SVNWCUtil").createDefaultAuthenticationManager(this.User,this.Password))>
		</cfif>
		<cfreturn this>
	</cffunction>

	<cffunction name="List" output="false" description="Retrieve a list of children for a resource" returntype="query">
		<cfargument name="Resource" type="string" required="true">
		<cfset var Q=QueryNew("Name,Author,Message,Date,Kind,Path,Revision,Size,URL,Content")>
		<cfset var ent=CreateObject("java","java.util.LinkedHashSet").init(16)>
		<cfset var i="">
		<cfset var f="">
		<cfset var u="">
		<cfset var NodeKind="">
		<cftry>
			<cfset NodeKind=this.Repository.checkPath(JavaCast("string",Arguments.Resource),JavaCast("int",-1))>
			<cfcatch>
				<cfset NodeKind=this.Repository.checkPath(JavaCast("string",Arguments.Resource),JavaCast("int",-1))>
			</cfcatch>
		</cftry>
		<cfif NodeKind EQ NodeKind.DIR>
			<cfset this.Repository.getDir(JavaCast("string",Arguments.Resource),JavaCast("int",-1),false,ent)>
			<cfset i=ent.iterator()>
			<cfloop condition="i.hasNext()">
				<cfset f=i.next()>
				<cfset QueryAddRow(Q)>
				<cfset Q.Name[Q.RecordCount]=f.getName()>
				<cfset Q.Author[Q.RecordCount]=f.getAuthor()>
				<cfset Q.Message[Q.RecordCount]=f.getCommitMessage()>
				<cfset Q.Date[Q.RecordCount]=f.getDate()>
				<cfset Q.Kind[Q.RecordCount]=f.getKind().toString()>
				<cfset Q.Path[Q.RecordCount]=f.getRelativePath()>
				<cfset Q.Revision[Q.RecordCount]=f.getRevision()>
				<cfset Q.Size[Q.RecordCount]=f.getSize()>
				<cfset u=f.getURL().toString()>
				<cfif Left(u,Len(this.URL)) EQ this.URL><cfset u=Mid(u,Len(this.URL)+1,Len(u))></cfif>
				<cfset Q.URL[Q.RecordCount]=u>
			</cfloop>
			<cfquery dbtype="query" name="Q">
			SELECT *
			FROM Q
			ORDER BY Kind, URL, Revision DESC
			</cfquery>
		</cfif>
		<cfreturn Q>
	</cffunction>

	<cffunction name="FileVersion" output="false" description="Retrieve the specific version of a file" returntype="query">
		<cfargument name="Resource" type="string" required="true">
		<cfargument name="Version" type="numeric" required="true">
		<cfargument name="format" hint="'string', or 'binary'." type="string" required="No" default="string">


		<cfset var Q=QueryNew("Name,Author,Message,Date,Kind,Path,Revision,Size,URL,Content")>
		<cfset var props=CreateObject("java","java.util.HashMap").init(16)>
		<cfset var out = CreateObject("java","java.io.ByteArrayOutputStream").init()>
		<cfset var MimeType="">
		<cfset var NodeKind="">

		<cftry>
			<cfset NodeKind=this.Repository.checkPath(JavaCast("string",Arguments.Resource),JavaCast("int",Arguments.Version))>
			<cfcatch>
				<cfset NodeKind=this.Repository.checkPath(JavaCast("string",Arguments.Resource),JavaCast("int",Arguments.Version))>
			</cfcatch>
		</cftry>
		<cfif NodeKind.compareTo(NodeKind.FILE) EQ 0>
			<cfset this.Repository.getFile(JavaCast("string",Arguments.Resource),JavaCast("int",Arguments.Version),props,out)>
			<cfset QueryAddRow(Q)>
			<cfset Q.Name[Q.RecordCount]=ListLast(Arguments.Resource,"/")>
			<cfif StructKeyExists(props,"svn:entry:last-author")>
				<cfset Q.Author[Q.RecordCount]=props["svn:entry:last-author"]>
			</cfif>
			<cfset Q.Date[Q.RecordCount]=CreateObject("java", "java.text.SimpleDateFormat").init("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'").parse(props["svn:entry:committed-date"], CreateObject("java", "java.text.ParsePosition").init(0))>
			<cfset Q.Kind[Q.RecordCount]="file">
			<cfset Q.Path[Q.RecordCount]=Mid(Arguments.Resource,1,Len(Arguments.Resource))>
			<cfset Q.Revision[Q.RecordCount]=props["svn:entry:committed-rev"]>
			<cfset Q.Size[Q.RecordCount]=out.size()>
			<cfset Q.URL[Q.RecordCount]=Mid(Arguments.Resource,1,Len(Arguments.Resource))>

			<cfswitch expression="#arguments.format#">
				<cfcase value="string">
					<cfset Q.Content[Q.RecordCount] = out.toString()>
				</cfcase>
				<cfcase value="binary">
					<cfset Q.Content[Q.RecordCount] = out.toByteArray()>
				</cfcase>
				<cfdefaultcase>
					<cfthrow message="Argument 'format' must either be 'string' or binary."
							detail="'#arguments.format#' not a supported format">
				</cfdefaultcase>
			</cfswitch>
		</cfif>
		<cfreturn Q>
	</cffunction>

	<cffunction name="History" output="false" description="Fetch a history of a given resource" returntype="query">
		<cfargument name="Resource" type="string" required="false">
		<cfset var Q = QueryNew("Name,Author,Message,Date,Kind,Path,Revision,Size,URL,Content")>
		<cfset var ent = CreateObject("java","java.util.LinkedHashSet").init(16)>
		<cfset var i = "">
		<cfset var f = "">
		<cfset var u = "">
		<cfset var lastRev = -1>
		<cfset var NodeKind = "">
		<cftry>
			<cfset NodeKind=this.Repository.checkPath(JavaCast("string",Arguments.Resource),JavaCast("int",lastRev))>
			<cfcatch>
				<cfset NodeKind=this.Repository.checkPath(JavaCast("string",Arguments.Resource),JavaCast("int",lastRev))>
			</cfcatch>
		</cftry>
		<cfif NodeKind.compareTo(NodeKind.FILE) EQ 0>
			<cfset u=ArrayNew(1)>
			<cfset ArrayAppend(u,arguments.resource)>
			<cfset lastRev=this.Repository.getLatestRevision()>
			<cfset this.Repository.log(u,ent,JavaCast("int",0),JavaCast("int",lastRev),false,true)>
			<cfset i=ent.iterator()>
			<cfloop condition="i.hasNext()">
				<cfset f=i.next()>
				<cfset QueryAddRow(Q)>
				<cfset Q.Message[Q.RecordCount]=f.getMessage()>
				<cfset Q.Date[Q.RecordCount]=f.getDate()>
				<cfset Q.Author[Q.RecordCount]=f.getAuthor()>
				<cfset Q.Revision[Q.RecordCount]=f.getRevision()>
				<cfset Q.Path[Q.RecordCount]=Mid(Arguments.Resource,1,Len(Arguments.Resource))>
				<cfset Q.Name[Q.RecordCount]=ListLast(Arguments.Resource,"/")>
				<cfset Q.Kind[Q.RecordCount]="file">
			</cfloop>
			<cfquery dbtype="query" name="Q">
			SELECT *
			FROM Q
			ORDER BY Revision DESC
			</cfquery>
		</cfif>
		<cfreturn Q>
	</cffunction>

	<cffunction name="getLog" output="true" description="Fetch a history of a given resource" returntype="query">
		<cfargument name="Resource" type="string" required="false">
		<cfset var Q = QueryNew("Name,Author,Message,Date,Kind,Path,Revision,Size,URL,Content")>
		<cfset var ent = CreateObject("java","java.util.LinkedHashSet").init(16)>
		<cfset var i = "">
		<cfset var f = "">
		<cfset var u = "">
		<cfset var lastRev = -1>
		<cfset var NodeKind = "">
		<!--- <cftry>
			<cfset NodeKind=this.Repository.checkPath(JavaCast("string",Arguments.Resource),JavaCast("int",lastRev))>
			<cfcatch>
				<cfset NodeKind=this.Repository.checkPath(JavaCast("string",Arguments.Resource),JavaCast("int",lastRev))>
			</cfcatch>
		</cftry>
		<cfif NodeKind.compareTo(NodeKind.FILE) EQ 0> --->
			<cfset u=ArrayNew(1)>
			<!--- <cfset ArrayAppend(u,arguments.resource)> --->
			<cfset lastRev=this.Repository.getLatestRevision()>
			<cfset this.Repository.log(u,ent,JavaCast("int",0),JavaCast("int",lastRev),true,true)>
			<cfset i=ent.iterator()>
			<cfloop condition="i.hasNext()">
				<cfset f=i.next()>
				<!--- <cfdump var="#f#"> --->
				<cfset QueryAddRow(Q)>
				<cfset Q.Message[Q.RecordCount]=f.getMessage()>
				<cfset Q.Date[Q.RecordCount]=f.getDate()>
				<cfset Q.Author[Q.RecordCount]=f.getAuthor()>
				<cfset Q.Revision[Q.RecordCount]=f.getRevision()>
				<!--- <cfset Q.Path[Q.RecordCount]=f.getChangedPaths()> --->
				<!--- <cfset Q.Name[Q.RecordCount]=ListLast(Arguments.Resource,"/")> --->
				<!--- <cfset Q.Kind[Q.RecordCount]=f.getClass()> --->
			</cfloop>


			<cfquery dbtype="query" name="Q">
			SELECT *
			FROM Q
			ORDER BY Date DESC
			</cfquery>
		<!--- </cfif> --->
		<cfreturn Q>
	</cffunction>


	<cffunction name="initJavaLoader" hint="initialised the JavaLoder as neccessary" access="private" returntype="void" output="false">
		<cfscript>
			var path = getDirectoryFromPath(getMetaData(this).path) & "/../includes/svnkit-1.1.4/";
			var qFiles = 0;
			var paths = ArrayNew(1);

			//if it's alreday there, leave it
			if(StructKeyExists(server, variables.static.javaKey))
			{
				return;
			}
		</cfscript>
		<cfdirectory action="list" filter="*.jar" directory="#path#" name="qFiles">
		<cfloop query="qFiles">
			<cfset ArrayAppend(paths, directory & "/" & name) />
		</cfloop>

		<cfscript>
			server[variables.static.javaKey] = createObject("component", "javaloader.JavaLoader").init(paths);
		</cfscript>
	</cffunction>

	<cffunction name="getJavaLoader" hint="" access="public" returntype="javaloader.JavaLoader" output="false">
		<cfreturn server[variables.static.javaKey] />
	</cffunction>

</cfcomponent>