<cfsetting enablecfoutputonly="true" showdebugoutput="false">

<cfswitch expression="#url.a#">
	<cfcase value="add">
		<cfset newID = createUUID()>
		<cfset application.client.addRate(newID,url.c,url.cat,url.r)>
		<cfset rates = application.client.getRates(url.c)>
		<cfoutput query="rates">
			<li id="r#rateID#"<cfif not compare(newID,rateID)> class="cur_rate"</cfif>>#category# - #DollarFormat(rate)#/hr&nbsp;<cfif numLines eq 0> <a href="##" class="x" onclick="delete_client_rate('#rateID#');return false;"></a><cfelse> <small class="g">(#numLines# time tracking items)</small></cfif></li>
		</cfoutput>
		<cfoutput>
			<script type="text/javascript">
				$('.cur_rate').animate({backgroundColor:'##ffffb7'},200).animate({backgroundColor:'##fff'},2000);
			</script>		
		</cfoutput>
	</cfcase>
	<cfcase value="delete">
		<cfset application.client.deleteRate(url.r)>
	</cfcase>
</cfswitch>

<cfsetting enablecfoutputonly="false">