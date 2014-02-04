<cfsetting enablecfoutputonly="true" showdebugoutput="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif not compare(left(url.p,1),'p')>
	<cfset itemWhich = "paid">
<cfelse>
	<cfset itemWhich = "billed">
</cfif>

<cfif v EQ "checked">
<cfset url.v = 1>
<cfelse>
<cfset url.v = 0>
</cfif>

<cfset application.billing.set(url.i,url.t,itemWhich,url.v)>

<cfsetting enablecfoutputonly="false"><cfsetting enablecfoutputonly="true" showdebugoutput="true">
<cfprocessingdirective pageencoding="utf-8">

<cfif not compare(left(url.p,1),'p')>
	<cfset itemWhich = "paid">
<cfelse>
	<cfset itemWhich = "billed">
</cfif>

<cfset application.billing.set(url.i,url.t,itemWhich,url.v)>

<cfsetting enablecfoutputonly="false">