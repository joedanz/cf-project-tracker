function proj_admins(pid) {
    $.ajax({
		type: 'get',
		url: './ajax/proj_admins.cfm',
		data: 'p=' + pid,
		success: function(txt){
	     $('#proj_admins').html(txt);
	}
	});
}

function add_existing(pid) {
    $.ajax({
		type: 'get',
		url: './ajax/proj_users.cfm',
		data: 'p=' + pid + '&a=' + $('#userID').val() + '&r=' + $('#role').val(),
		success: function(txt){
	     $('#replace').html(txt);
		}
	});
	$("#userID").removeOption($('#userID').val());
	if (document.getElementById("userID").length == 0) $('#existing').hide();
	proj_admins(pid);
}

function add_new(pid) {
    $.ajax({
		type: 'post',
		url: './ajax/proj_users.cfm',
		data: 'addnew=1&p=' + pid + '&f=' + $('#fname').val() + '&l=' + $('#lname').val() + '&e=' + $('#email').val() + '&r=' + $('#newrole').val() + '&admin=' + $('#admin').val(),
		success: function(txt){
	     $('#replace').html(txt);
		}
	});
	proj_admins(pid);
}

function remove_user(pid,uid,lname,fname) {
    $.ajax({
		type: 'get',
		url: './ajax/proj_users.cfm',
		data: 'p=' + pid + '&d=' + uid
	});
	$("#userID").addOption(uid, lname + ', ' + fname);
	if (document.getElementById("userID").length >= 1) $('#existing').show();
	proj_admins(pid);
}
   