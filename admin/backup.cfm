<cfsetting enablecfoutputonly="true">
<cfprocessingdirective pageencoding="utf-8">

<cfparam name="url.action" default="backup">
<cfset tableRows = 1>
<cfset recordRows = 0>

<!--- Loads header/footer --->
<cfmodule template="#application.settings.mapping#/tags/layout.cfm" templatename="main" title="#application.settings.app_title# &raquo; Admin">

<cfoutput>
<div id="container">
	<!--- left column --->
	<div class="left">
		<div class="main">

			<div class="header">
				
				<h2 class="admin">Administration - 
					<cfswitch expression="#url.action#">
						<cfcase value="choose">Restore Backup File</cfcase>
						<cfcase value="restore">Backup Restore</cfcase>
						<cfdefaultcase>Database Backup</cfdefaultcase>>
					</cfswitch>
				</h2>
			</div>
			<div class="content">
				<div class="wrapper">
			 	
			 		<cfswitch expression="#url.action#">
						<cfcase value="backup">
							<cfset data = structNew()>
							<cfloop list="#application.DataMgr.getDatabaseTables()#" index="i">
								<cfif len(application.settings.tablePrefix) eq 0 or (len(application.settings.tablePrefix) and left(i,len(application.settings.tablePrefix)) is application.settings.tablePrefix)>
									<cfquery name="getData" datasource="#application.settings.dsn#">
										select * from #i#
									</cfquery>
									<cfset data[i] = getData>
								</cfif>
							</cfloop>

							<cfwddx action="cfml2wddx" input="#data#" output="packet">
							<cffile action="write" file="#expandPath("./backup/temp/data.packet")#" output="#packet#">
						
							<!--- file to store zip --->
							<cfset zfile = expandPath("./backup/#UCase(LSDateFormat(DateConvert("local2Utc",Now()),"yyyymmmdd"))#_#LSTimeFormat(DateConvert("local2Utc",Now()),"HHMMSS")#_backup.zip")>
						
							<!--- zip up data --->
							<cfzip action="zip" file="#zfile#" overwrite="true" source="#expandPath("./backup/temp/")#">
								
							<div class="successbox">Backup file saved to <em>#zfile#</em>.</div>
							
							<table class="clean full">
								<thead>
									<tr>
										<th>##</th>
										<th>Table</th>
										<th>Records</th>
									</tr>
								</thead>
								<tbody>
									<cfloop list="#application.DataMgr.getDatabaseTables()#" index="i">
										<cfif len(application.settings.tablePrefix) eq 0 or (len(application.settings.tablePrefix) and left(i,len(application.settings.tablePrefix)) is application.settings.tablePrefix)>
											<cfquery name="table" datasource="#application.settings.dsn#">
												select count(*) as numRecords from #i#
											</cfquery>
											<tr>
												<td>#tableRows#)</td>
												<td>#i#</td>
												<td>#table.numRecords#</td>
											</tr>
											<cfset tableRows = tableRows + 1>
											<cfset recordRows = recordRows + table.numRecords>
										</cfif>
									</cfloop>
								</tbody>
								<tfoot>
									<tr>
										<th colspan="3">Total Tables: #numberFormat(tableRows)# //
										Total Rows: #numberFormat(recordRows)#
										</th>
									</tr>
								</tfoot>
							</table>
						</cfcase>

			 			<cfcase value="choose">
				 			<cfif StructKeyExists(url,'rmv')>
								<cffile action="delete" file="#expandPath('./backup')#/#url.rmv#">
							</cfif>
				 			
							<cfdirectory action="list" directory="#expandPath('./backup')#" name="backup_files">
							<cfquery name="backups" dbtype="query">
								select * from backup_files where name != 'temp' order by datelastmodified desc
							</cfquery>
				 			<cfif backups.recordCount eq 0>
								<div class="alert">There are no backup files.</div>
							<cfelse>
								<table class="clean full">
								<thead>
									<tr>
										<th>##</th>
										<th>Backup File</th>
										<th>Created</th>
										<th>Size</th>
										<th class="tac">Delete?</th>
									</tr>
								</thead>
								<tbody>
									<cfloop query="backups">
										<tr>
											<td>#currentRow#)</td>
											<td><a href="#cgi.script_name#?action=restore&file=#URLEncodedFormat(name)#" onclick="return confirm('Are you sure you wish to restore this backup?\nThis will permanently delete all current data in the application.')">#name#</a></td>
											<td>#LSDateFormat(DateAdd("h",session.tzOffset,datelastmodified),"long")# @ #LSTimeFormat(datelastmodified,"h:mmtt")#</td>
											<td>#numberFormat(size)#</td>
											<td class="tac"><a href="#cgi.script_name#?action=choose&rmv=#URLEncodedFormat(name)#" onclick="return confirm('Are you sure you wish to delete this backup file?')" class="delete"></a></td>
										</tr>
									</cfloop>
								</tbody>
								<tfoot>
									<tr>
										<th colspan="3">Total Backup Files: #numberFormat(backups.recordCount)#</th>
									</tr>
								</tfoot>
							</table>						
							
							</cfif>
						</cfcase>

			 			<cfcase value="restore">
							<cfset zfile = expandPath("./backup/#url.file#")>
							<!--- unzip data --->
							<cfzip action="read" file="#zfile#" entrypath="data.packet" variable="result">
							
							<cfwddx action="wddx2cfml" input="#result#" output="data">
						
							
							<table class="clean full">
								<thead>
									<tr>
										<th>##</th>
										<th>Table</th>
										<th class="tac">Old Rows</th>
										<th class="tac">New Rows</th>
										<th>Status</th>
									</tr>
								</thead>
								<tbody>
									<cfloop collection="#data#" item="t"> <!--- loop over tables --->
										<!--- get current row count --->
										<cfquery name="old" datasource="#application.settings.dsn#">
											select count(*) as numRecords from #t#
										</cfquery>
										<!--- delete current table data --->
										<cfquery datasource="#application.settings.dsn#">
											DELETE FROM #t#
										</cfquery>
										<!--- get table structure info --->
										<cfset ts = application.DataMgr.getDBTableStruct(t)>
										<cfloop from="1" to="#data[t].recordcount#" index="r"> <!--- loop over table rows --->
											<cfquery datasource="#application.settings.dsn#">
												INSERT INTO #t# (
												
													<cfset rowNum = 1>
													<cfloop from="1" to="#arrayLen(ts)#" index="i">
														#ts[i].ColumnName#
														<cfif rowNum neq arrayLen(ts)>,</cfif>
														<cfset rowNum = rowNum + 1>
													</cfloop>
												) VALUES (
													<cfset rowNum = 1>
													<cfloop from="1" to="#arrayLen(ts)#" index="i">
														<cfif not compareNoCase(ts[i].CF_DataType,'CF_SQL_INTEGER') and not isNumeric(data[t][ts[i].ColumnName][r])>
															NULL
														<cfelse>					
															<cfqueryparam cfsqltype="#ts[i].CF_DataType#" value="#data[t][ts[i].ColumnName][r]#" />
														</cfif>
														<cfif rowNum neq arrayLen(ts)>,</cfif>
														<cfset rowNum = rowNum + 1>
													</cfloop>
												)
											</cfquery>
										</cfloop>
										<tr>
											<td>#tableRows#)</td>
											<td>#t#</td>
											<td class="tac">#numberFormat(old.numRecords)#</td>
											<td class="tac">#numberFormat(data[t].recordCount)#</td>
											<td>Success</td>	
										</tr>
										<cfset tableRows = tableRows + 1>
									</cfloop>
								</tbody>
							</table>
						</cfcase>
					</cfswitch>
			 	</div>
			</div>
			
		</div>
		<div class="bottom">&nbsp;</div>
		<div class="footer">
			<cfinclude template="#application.settings.mapping#/footer.cfm">
		</div>	  
	</div>

	<!--- right column --->
	<div class="right">
		<cfinclude template="rightmenu.cfm">
	</div>
		
</div>
</cfoutput>

</cfmodule>

<cfsetting enablecfoutputonly="false">