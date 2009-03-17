<cfsetting enablecfoutputonly="true" showdebugoutput="true">

<cfif not compare(left(url.p,1),'p')>
	<cfset itemWhich = "paid">
<cfelse>
	<cfset itemWhich = "billed">
</cfif>

<cfset application.billing.set(url.i,url.t,itemWhich,url.v)>

<cfsetting enablecfoutputonly="false">