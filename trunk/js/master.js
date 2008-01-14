$(document).ready(function(){
	$('input, textarea, select').focus(function(){ $(this).css('background-color', '#ffc'); });
	$('input, textarea, select').blur(function(){ $(this).css('background-color', '#fff'); });
});

function togglemenu() {
	var targetContent = $('#projectmenu');
	if (targetContent.css('display') == 'none') {
		targetContent.slideDown();
	} else {
		targetContent.slideUp();
	}
	return false;		
}

// *** COMMENTS ***
function comment_preview() {
	$('#preview').show();
	$('#commentbody').empty();
	var oEditor = FCKeditorAPI.GetInstance('comment');
	$('#commentbody').append(oEditor.GetHTML());
}
function confirm_comment() {
	var errors = '';
	var oEditor = FCKeditorAPI.GetInstance('comment');
	if (oEditor.GetHTML() == '') {errors = errors + '   ** You must enter a comment.\n';}
	if (errors != '') {
		alert('Please correct the following errors:\n\n' + errors)
		return false;
	} else return true;
}
function delete_comment(cid) {
	var del = confirm('Are you sure you wish to delete this comment?\nNote: this action is irreversible.');
	if (del == true) {
		var comment_num = eval($('#cnum').text()-1);
		if (comment_num == '') newcomment_num = '0' 
			else newcomment_num = comment_num;
		$('#cnum').html(newcomment_num);
		$('#'+cid).fadeOut(500);
		delete_comment_ajax(cid);
		return true;
	} else return false;
}
function delete_comment_ajax(cid) {
    $.ajax({
		type: 'get',
		url: './ajax/comment.cfm',
		data: 'action=delete&c=' + cid
	});
}

// *** MILESTONES ***
function upcoming_milestones(pid,limit) {
    $.ajax({
		type: 'get',
		url: './ajax/mstones.cfm',
		data: 'type=upcoming&p=' + pid + '&l=' + limit,
		success: function(txt){
	     $('#upcoming_milestones').html(txt);
	}
	});
}
function all_upcoming_milestones(limit) {
    $.ajax({
		type: 'get',
		url: './ajax/mstones.cfm',
		data: 'type=allupcoming&l=' + limit,
		success: function(txt){
	     $('#upcoming_milestones').html(txt);
	}
	});
}

// *** PEOPLE ***
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

// *** TO-DOS ***
function redraw_incomplete(projectid,todolistid,todoid,type) {
    $.ajax({
		type: 'get',
		url: './ajax/todo.cfm',
		data: 'action=redraw_incomplete&p=' + projectid + '&t=' + todolistid + '&i=' + todoid + '&type=' + type,
		success: function(txt){
		     $('#todoitems' + todolistid).html(txt);
		}
	});
}

function redraw_completed(projectid,todolistid,todoid) {
    $.ajax({
		type: 'get',
		url: './ajax/todo.cfm',
		data: 'action=redraw_completed&p=' + projectid + '&t=' + todolistid + '&i=' + todoid,
		success: function(txt){
		     $('#todocomplete' + todolistid).html(txt);
		}
	});
}

function mark_complete(projectid,todolistid,todoid) {
    $('#' + todoid).fadeOut(500);
	$.ajax({
		type: 'get',
		url: './ajax/todo.cfm',
		data: 'action=mark_complete&t=' + todolistid + '&i=' + todoid
	});
	redraw_completed(projectid,todolistid,todoid);
}

function mark_incomplete(projectid,todolistid,todoid) {
	$('#' + todoid).fadeOut(500);
	$.ajax({
		type: 'get',
		url: './ajax/todo.cfm',
		data: 'action=mark_incomplete&t=' + todolistid + '&i=' + todoid
	});
	redraw_incomplete(projectid,todolistid,todoid,'update');
}

function add_item(projectid,todolistid) {
	var newitem = $('#ta' + todolistid).val();
	var forwho = $('#forwho' + todolistid).val();
	add_todo_ajax(projectid,todolistid,newitem,forwho);
	redraw_incomplete(projectid,todolistid,'','add');
	$('#ta' + todolistid).val(''); $('#ta' + todolistid).focus();
}

function add_todo_ajax(projectid,todolistid,newitem,forwho) {
    $.ajax({
		type: 'post',
		url: './ajax/todo.cfm?action=add',
		data: 'action=add&p=' + projectid + '&l=' + todolistid + '&t=' + escape(newitem) + '&fw=' + forwho
	});	
}

function update_item(projectid,todolistid,todoid,completed) {
	var newitem = $('#ta' + todoid).val();
	var forwho = $('#forwho' + todoid).val();
	update_todo_ajax(projectid,todolistid,todoid,newitem,forwho);
	if (completed == 'incomplete') {
		redraw_incomplete(projectid,todolistid,todoid,'update');	
	} else if (completed == 'complete') {
		redraw_completed(projectid,todolistid,todoid,'update');
	}
}

function update_todo_ajax(projectid,todolistid,todoid,newitem,forwho) {
    $.ajax({
		type: 'post',
		url: './ajax/todo.cfm?action=update',
		data: 'action=add&p=' + projectid + '&l=' + todolistid + '&t=' + escape(newitem) + '&i=' + todoid + '&fw=' + forwho
	});	
}

function delete_li(projectid,todolistid,todoid) {
	var del = confirm('Are you sure you wish to delete this item?');
	if (del == true) {
		delete_todo_ajax(projectid,todolistid,todoid);
		$('#' + todoid).fadeOut(500);
	} else return false;
}

function delete_todo_ajax(projectid,todolistid,todoid) {
    $.ajax({
		type: 'get',
		url: './ajax/todo.cfm',
		data: 'action=delete&p=' + projectid + '&l=' + todolistid + '&t=' + todoid
	});
}

function limitText(limitField) {
	var charLimit = 300;
	if ($('#'+limitField).val().length > charLimit) {
		$('#'+limitField).val($('#'+limitField).val().substring(0, charLimit));
	} else {
		charsLeft = charLimit - $('#'+limitField).val().length;
		$('.addtask').prev().prev(".remaining").html("(" + charsLeft + " characters remaining)");
	}
}

