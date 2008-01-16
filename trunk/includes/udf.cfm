<cfsetting enablecfoutputonly=true>

<cfscript>
/**
 * Strips all non-numeric characters from a string.
 * Modified by RCamden to use one line of code.
 * 
 * @param str 	 String to format. (Required)
 * @return Returns a string. 
 * @author Mindframe, Inc. (info@mindframe.com) 
 * @version 1, September 6, 2002 
 */
function NumbersOnly(str) {
	return reReplace(str,"[^[:digit:]]","","all");
}
request.udf.NumbersOnly = NumbersOnly;

/**
 * Allows you to specify the mask you want added to your phone number.
 * v2 - code optimized by Ray Camden
 * 
 * @param varInput 	 Phone number to be formatted. (Required)
 * @param varMask 	 Mask to use for formatting. x represents a digit. (Required)
 * @return Returns a string. 
 * @author Derrick Rapley (adrapley@rapleyzone.com) 
 * @version 3, August 30, 2005 
 */
function phoneFormat(varInput, varMask) {
	var curPosition = "";
	var newFormat = "";
	var i = "";

	if(len(trim(varInput))) {
		newFormat = " " & reReplace(varInput,"[^[:digit:]]","","all");
		for (i=1; i lte len(trim(varmask)); i=i+1) {
			curPosition = mid(varMask,i,1);
			if(curPosition neq "x") newFormat = insert(curPosition,newFormat, i) & " ";
		}
	}
	return trim(newFormat);
}
request.udf.phoneFormat = phoneFormat;
</cfscript>

<cfsetting enablecfoutputonly=false>