<cfsetting enablecfoutputonly="true">



<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.title# &raquo; Milestones">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

				<div class="header">
					<h2><img src="./images/milestone.png" height="22" width="22" alt="Milestones" /> 
					Milestones across all your projects</h2>
				</div>
				<div class="content">
				 	left content
				</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">
		<div class="header"><h3>Your projects</h3></div>
		<div class="content">
			<ul>

			</ul>
		</div>
	</div>
		
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">