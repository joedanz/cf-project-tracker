<cfcomponent displayname="svnbrowser" output="false" hint="Subversion Repository Browser">
	<!---
	svn browser
	Original Code by Rick Osborne: http://code.google.com/p/cfdiff/

	License: Mozilla Public License (MPL) version 1.1 - http://www.mozilla.org/MPL/
	READ THE LICENSE BEFORE YOU USE OR MODIFY THIS CODE
	
	Edited by Paul Klinkenberg, www.coldfusiondeveloper.nl
	for project Subversion repository browser: http://www.coldfusiondeveloper.nl/post.cfm/subversion-repository-browser-in-coldfusion
	
	Version 1.0, March 2010
		Among other things, I added the option to use svn:// repository urls instead of only http://.
	Version 1.1, 12 July 2010
		Added option to view the latest version of a file, by setting 'HEAD' as the revision number.
	--->


	<!--- You *probably* won't have to edit anything below this line.
	But if you did, you'd better call svn.cfm?init=1 in your browser afterwards. --->
	
	<cfset variables.useClassLoader = true />
	
	
	<cffunction name="loadSvnClass" returntype="any" access="private" hint="I return java class instances">
		<cfargument name="class" type="string" required="yes" />
		<cfset var paths = arrayNew(1) />
		<cfif variables.useClassLoader>
			<cfif not structKeyExists(variables, "_javaClassLoader")>
				<cfset paths[1] = getDirectoryFromPath(getMetaData(this).path) & "/../includes/svnkit-1.3.0.5847/svnkit.jar" />
				<cfset variables._javaClassLoader = createObject("component", "cfcs.JavaLoader").init(paths) />
			</cfif>
			<cfreturn variables._javaClassLoader.create(arguments.class) />
		<cfelse>
			<cfreturn createObject("java", arguments.class) />
		</cfif>
	</cffunction>
	
	
	<cffunction name="init" output="true" returntype="svnbrowser" description="Initialize our object" displayname="init">
		<cfargument name="RepositoryURL" type="string" required="true">
		<cfargument name="Username" type="string" required="false" default="">
		<cfargument name="Password" type="string" required="false" default="">
		<cfset var URL_obj = "" />
		<cfset var args = arrayNew(1) />
		<cfset var auth_obj = "" />
		<!---
		The TMate JavaSVN library requires the following notice, so don't delete it!
		Copyright (c) 2004-2006 TMate Software. All rights reserved.
		It can be acquired from: http://tmate.org/svn/
		--->
		<cfif find("http", Arguments.RepositoryURL) eq 1>
			<cfset this.drf=loadSvnClass("org.tmatesoft.svn.core.internal.io.dav.DAVRepositoryFactory") />
		<cfelse>
			<cfset this.drf=loadSvnClass("org.tmatesoft.svn.core.internal.io.svn.SVNRepositoryFactoryImpl") />
		</cfif>
		<cfset this.drf.setup() />
		
		<cfset this.URL=Arguments.RepositoryURL>
		<cfset this.User=Arguments.Username>
		<cfset this.Password=Arguments.Password>
		<cfset args[1] = this.URL />
		<cfset URL_obj = loadSvnClass("org.tmatesoft.svn.core.SVNURL") />
		<cfset URL_obj = URL_obj.parseURIEncoded(this.URL) />
		<cfset this.srf = loadSvnClass("org.tmatesoft.svn.core.io.SVNRepositoryFactory") />
		<cfset this.Repository = this.srf.create(URL_obj) />
		<cfif (this.User NEQ "")>
			<cfset auth_obj = loadSvnClass("org.tmatesoft.svn.core.wc.SVNWCUtil") />
			<cfset this.Repository.setAuthenticationManager( auth_obj.createDefaultAuthenticationManager(this.User, this.Password))>
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
		<cfset var NodeKind = "">
		<cftry>
			<cfset NodeKind=this.Repository.checkPath(JavaCast("string",Arguments.Resource),JavaCast("int",-1))>
			<cfcatch>
				<cfset NodeKind=this.Repository.checkPath(JavaCast("string",Arguments.Resource),JavaCast("int",-1))>
			</cfcatch>
		</cftry>
		<cfif NodeKind.compareTo(NodeKind.DIR) eq 0>
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
		<cfargument name="Version" type="any" required="true" />
		<cfset var Q=QueryNew("Name,Author,Message,Date,Kind,Path,Revision,Size,URL,Content")>
		<cfset var props = loadSvnClass("org.tmatesoft.svn.core.SVNProperties") />
		<cfset var out = CreateObject("java","java.io.ByteArrayOutputStream").init()>
		<cfset var MimeType="">
		<cfset var NodeKind="">
		<cfset var local = structNew() />
		
		<cfif arguments.version neq "HEAD" and not isNumeric(arguments.Version)>
			<cfthrow message="Version must be either numeric or 'HEAD'!" />
		</cfif>
		<!--- if version=HEAD, get the latest revision for the file --->
		<cfif arguments.version eq "HEAD">
			<cfset arguments.version = -1 />
		</cfif>
		
		<cfset props.init() />
		<cftry>
			<cfset NodeKind=this.Repository.checkPath(JavaCast("string",Arguments.Resource),JavaCast("int",Arguments.Version))>
			<cfcatch>
				<cfset NodeKind=this.Repository.checkPath(JavaCast("string",Arguments.Resource),JavaCast("int",Arguments.Version))>
			</cfcatch>
		</cftry>
		<cfif NodeKind.compareTo(NodeKind.FILE) EQ 0>
			<!--- getFile(java.lang.String, long, org.tmatesoft.svn.core.SVNProperties, java.io.OutputStream) --->
			<cfset this.Repository.getFile(JavaCast("string",Arguments.Resource),JavaCast("long",Arguments.Version),props,out)>
			<cfset local.newprops = structNew() />
			<cfloop collection="#props.asMap()#" item="local.key">
				<cfset local.newprops[local.key] = props.getStringValue(local.key) />
			</cfloop>
			<cfset props = local.newprops />
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
			<cfset Q.Content[Q.RecordCount]=out.toByteArray() />
		</cfif>
		<cfreturn Q>
	</cffunction>
	
	
	<cffunction name="History" output="false" description="Fetch a history of a given resource" returntype="query">
		<cfargument name="Resource" type="string" required="true">
		<cfset var Q=QueryNew("Name,Author,Message,Date,Kind,Path,Revision,Size,URL,Content")>
		<cfset var ent=CreateObject("java","java.util.LinkedHashSet").init(16)>
		<cfset var i="">
		<cfset var f="">
		<cfset var u="">
		<cfset var lastRev=-1>
		<cfset var NodeKind="">
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
			<cfset this.Repository.log(u,ent,JavaCast("int",1),JavaCast("int",lastRev),false,true)>
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
		<cfargument name="numEntries" type="numeric" required="false" default="20">
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
				<cfset Q.Path[Q.RecordCount]=f.getChangedPaths()>
				<!--- <cfset Q.Name[Q.RecordCount]=ListLast(Arguments.Resource,"/")> --->
				<!--- <cfset Q.Kind[Q.RecordCount]=f.getClass()> --->
			</cfloop>
			
			<cfquery dbtype="query" name="Q" maxrows="#arguments.numEntries#">
			SELECT *
			FROM Q
			ORDER BY Revision DESC
			</cfquery>		
			
		<!--- </cfif> --->
		<cfreturn Q>
	</cffunction>
	
</cfcomponent>