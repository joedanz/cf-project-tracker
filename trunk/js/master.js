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
		data: 'p=' + pid + '&e=' + $('#userID').val() + '&a=' + $('#a_existing:checked').val() + '&f=' + $('#f_existing').val() + '&i=' + $('#i_existing').val() + '&m=' + $('#m_existing').val() + '&ms=' + $('#ms_existing').val() + '&t=' + $('#t_existing').val() + '&s=' + $('#s_existing:checked').val(),
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
		data: 'addnew=1&p=' + pid + '&fn=' + $('#fname').val() + '&ln=' + $('#lname').val() + '&ph=' + $('#phone').val() + '&un=' + $('#username').val() + '&pw=' + $('#password').val() + '&adm=' + $('#admin').val() + '&e=' + $('#email').val() + '&a=' + $('#a_new:checked').val() + '&f=' + $('#f_new').val() + '&i=' + $('#i_new').val() + '&m=' + $('#m_new').val() + '&ms=' + $('#ms_new').val() + '&t=' + $('#t_new').val() + '&s=' + $('#s_new:checked').val(),
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
function save_permissions(pid,uid,strippedid) {
    $.ajax({
		type: 'get',
		url: './ajax/user_permissions.cfm',
		data: 'p=' + pid + '&u=' + uid + '&a=' + $('#a_'+strippedid+':checked').val() + '&f=' + $('#f_'+strippedid).val() + '&i=' + $('#i_'+strippedid).val() + '&m=' + $('#m_'+strippedid).val() + '&ms=' + $('#ms_'+strippedid).val() + '&t=' + $('#t_'+strippedid).val() + '&s=' + $('#s_'+strippedid+':checked').val(),
		success: function(txt){
	     $('#up_'+strippedid).slideUp();
		 if ($('#a_'+strippedid+':checked').val() == 1) {$('#ut_'+strippedid).html('Admin')} else {$('#ut_'+strippedid).html('User')};
		 proj_admins(pid);
	  }
	});
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
	var due = $('#due' + todolistid).val();
	add_todo_ajax(projectid,todolistid,newitem,forwho,due);
	redraw_incomplete(projectid,todolistid,'','add');
	$('#ta' + todolistid).val(''); $('#ta' + todolistid).focus();
}
function add_todo_ajax(projectid,todolistid,newitem,forwho,due) {
    $.ajax({
		type: 'post',
		url: './ajax/todo.cfm?action=add',
		data: 'action=add&p=' + projectid + '&l=' + todolistid + '&t=' + escape(newitem) + '&fw=' + forwho + '&d=' + due
	});	
}
function update_item(projectid,todolistid,todoid,completed) {
	var newitem = $('#ta' + todoid).val();
	var forwho = $('#forwho' + todoid).val();
	var due = $('#due' + todoid).val();
	update_todo_ajax(projectid,todolistid,todoid,newitem,forwho,due);
	if (completed == 'incomplete') {
		redraw_incomplete(projectid,todolistid,todoid,'update');	
	} else if (completed == 'complete') {
		redraw_completed(projectid,todolistid,todoid,'update');
	}
}
function update_todo_ajax(projectid,todolistid,todoid,newitem,forwho,due) {
    $.ajax({
		type: 'post',
		url: './ajax/todo.cfm?action=update',
		data: 'action=add&p=' + projectid + '&l=' + todolistid + '&t=' + escape(newitem) + '&i=' + todoid + '&fw=' + forwho + '&d=' + due
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

// REORDER TO-DO LISTS
function reorder_lists() {
	$('.itemedit').hide(); $('.tododetail').hide(); $('.top').hide(); 
	$(".listItem").removeClass("todolist"); $(".list").addClass("drag"); 
	$('#sorting_done').show();
	$('#reorder_menu').html('<a href="#" onclick="done_reordering();" class="reorder">Done Reordering</a>');
	$('.listWrapper').sortable(
		{
			accept : 'listItem',
			axis : 'vertically',
			activeclass : 'sortableactive',
			hoverclass : 'sortablehover',
			helperclass : 'sorthelper',
			opacity: 	0.5,
			fit :	false,
			onStop : save_order
		}
	)
}
function done_reordering() {
	$('.itemedit').show(); $('.tododetail').show(); $('.top').show(); 
	$(".list").removeClass("drag"); $(".listItem").addClass("todolist"); 
	save_order();
	$('.listWrapper').sortableDestroy(); 
	$('#sorting_done').hide();
	$('#reorder_menu').html('<a href="#" onclick="reorder_lists();" class="reorder">Reorder lists</a>');
}
function save_order() {
	thelist = serialize_lists('lw');
	$("#listsort").val(thelist);
    $.ajax({
		type: 'post',
		url: './ajax/sort_lists.cfm',
		data: 'pid=' + $('#projectID').val() + '&lw=' + $("#listsort").val()
	});		
}
function serialize_lists(s)
{
	serial = $.SortSerialize(s);
	return serial.hash.replace(/lw\[\]=/g,'').replace(/&/g,'|');
};

// REORDER TO-DO ITEMS
function reorder_items(todolistid) {
	$('.li' + todolistid).addClass('drag');
	$('.cb' + todolistid).hide(); $('.li_edit').hide();
	$('#listmenu' + todolistid).hide();
	$('#reorderdone' + todolistid).show();
	$('#todoitems' + todolistid).Sortable(
		{
			accept : 'li' + todolistid,
			axis : 'vertically',
			activeclass : 'sortableactive',
			hoverclass : 'sortablehover',
			helperclass : 'sorthelper',
			opacity: 	0.5,
			fit :	false,
			onStop : function() {
  				save_item_order(todolistid)
			}
		}
	)	
}
function done_reordering_items(todolistid) {
	$('#reorderdone' + todolistid).hide();
	$('#listmenu' + todolistid).show(); 
	$('.cb' + todolistid).show(); $('.li_edit').show();
	$('.li' + todolistid).removeClass('drag');
	$('#todoitems' + todolistid).SortableDestroy(); 
}
function save_item_order(todolistid) {
	thelist = serialize_items('todoitems' + todolistid,todolistid);
	$('#listsort').val(thelist);
    $.ajax({
		type: 'post',
		url: './ajax/sort_list_items.cfm',
		data: 'tlid=' + todolistid + '&li=' + $('#listsort').val()
	});		
}
function serialize_items(s,todolistid)
{
	serial = $.SortSerialize(s);
	return serial.hash.replace(/todoitems.{35}\[\]=/g,'').replace(/&/g,'|');
};