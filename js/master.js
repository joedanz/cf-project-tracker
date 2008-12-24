$(document).ready(function(){
	$('input:not($("#searchbox")), textarea, select').focus(function(){ $(this).css('background-color', '#ffc'); });
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

// *** ISSUES ***
function confirmSubmitIssue() {
	var errors = '';
	var oEditor = FCKeditorAPI.GetInstance('detail');
	if (document.edit.issue.value == '') {errors = errors + '   ** You must enter an issue.\n';}
	if (oEditor.GetHTML() == '') {errors = errors + '   ** You must enter the issue detail.\n';}
	if (errors != '') {
		alert('Please correct the following errors:\n\n' + errors)
		return false;
	} else return true;
}
function newIssueComponent(id) {
	if (id == 'new') {
		var newcat = prompt('Enter the new component name:','');
		var opt = new Option(newcat, newcat);
  		var sel = document.edit.component;
  		sel.options[sel.options.length] = opt;
		sel.selectedIndex = sel.options.length-1;		
	}	
}
function newIssueVersion(id) {
	if (id == 'new') {
		var newcat = prompt('Enter the new version name:','');
		var opt = new Option(newcat, newcat);
  		var sel = document.edit.version;
  		sel.options[sel.options.length] = opt;
		sel.selectedIndex = sel.options.length-1;		
	}	
}

// *** MESSAGES ***
function newMsgCat(id) {
	if (id == 'new') {
		var newcat = prompt('Enter the new category name:','');
		var opt = new Option(newcat, newcat);
  		var sel = document.edit.category;
  		sel.options[sel.options.length] = opt;
		sel.selectedIndex = sel.options.length-1;		
	}	
}
function showNotify() {
	var targetContent = $('#notify');
	if (targetContent.css('display') == 'none') {
		targetContent.slideDown(300);
		$('#notifylinkbg').removeClass('collapsed');
		$('#notifylinkbg').addClass('expanded');
		$('#notifylink').addClass('notifybg');
	} else {
		targetContent.slideUp(300);
		$('#notifylinkbg').removeClass('expanded');
		$('#notifylink').removeClass('notifybg');
		$('#notifylinkbg').addClass('collapsed');
	}
	return false;	
}
function notify_all() {
	if ($('#everyone').attr('checked')==true) {
		$('#notify').checkCheckboxes(':not(.notoggle)');		
	} else $('#notify').unCheckCheckboxes(':not(.notoggle)');
}
function confirmSubmitMsg() {
	var errors = '';
	var oEditor = FCKeditorAPI.GetInstance('message');
	if (document.edit.title.value == '') {errors = errors + '   ** You must enter a title.\n';}
	if (document.edit.category.value == '') {errors = errors + '   ** You must enter a category.\n';}
	if (oEditor.GetHTML() == '') {errors = errors + '   ** You must enter the message body.\n';}
	if (errors != '') {
		alert('Please correct the following errors:\n\n' + errors)
		return false;
	} else return true;
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
		data: 'p=' + pid + '&e=' + $('#userID').val() + '&a=' + $('#a_existing:checked').val() + '&f=' + $('#f_existing').val() + '&i=' + $('#i_existing').val() + '&m=' + $('#m_existing').val() + '&ms=' + $('#ms_existing').val() + '&t=' + $('#t_existing').val() + '&tt=' + $('#tt_existing').val() + '&s=' + $('#s_existing:checked').val(),
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
		data: 'addnew=1&p=' + pid + '&fn=' + $('#fname').val() + '&ln=' + $('#lname').val() + '&ph=' + $('#phone').val() + '&un=' + $('#username').val() + '&pw=' + $('#password').val() + '&adm=' + $('#admin').val() + '&e=' + $('#email').val() + '&a=' + $('#a_new:checked').val() + '&f=' + $('#f_new').val() + '&i=' + $('#i_new').val() + '&m=' + $('#m_new').val() + '&ms=' + $('#ms_new').val() + '&t=' + $('#t_new').val() + '&tt=' + $('#tt_new').val() + '&s=' + $('#s_new:checked').val(),
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
		data: 'p=' + pid + '&u=' + uid + '&a=' + $('#a_'+strippedid+':checked').val() + '&f=' + $('#f_'+strippedid).val() + '&i=' + $('#i_'+strippedid).val() + '&m=' + $('#m_'+strippedid).val() + '&ms=' + $('#ms_'+strippedid).val() + '&t=' + $('#t_'+strippedid).val()  + '&tt=' + $('#tt_'+strippedid).val() + '&s=' + $('#s_'+strippedid+':checked').val(),
		success: function(txt){
	     $('#up_'+strippedid).slideUp();
		 if ($('#a_'+strippedid+':checked').val() == 1) {$('#ut_'+strippedid).html('Admin')} else {$('#ut_'+strippedid).html('User')};
		 proj_admins(pid);
	  }
	});
}

// *** SETTINGS ***
function section_toggle(section) {
	var targetContent = $('#' + section + 'info');
	if (targetContent.css('display') == 'none') {
		targetContent.slideDown(300);
		$('#' + section + 'link').removeClass('collapsed');
		$('#' + section + 'link').addClass('expanded');
		$('#' + section + 'url').focus();
	} else {
		targetContent.slideUp(300);
		$('#' + section + 'link').removeClass('expanded');
		$('#' + section + 'link').addClass('collapsed');
	}
}
function add_cat(projectid,type) {
    $.ajax({
		type: 'get',
		url: './ajax/' + type + '_cat.cfm',
		data: 'action=add&p=' + projectid + '&c=' + $('#' + type + 'Cat').val(),
		success: function(txt){
		     $('#' + type + 'cats').html(txt);
			 $('#' + type + 'Cat').val('');
			 $('#addnew' + type).show();
			 $('#newrow' + type).hide();
		}
	});	
}
function edit_cat(projectid,categoryid,row,type) {
    $.ajax({
		type: 'get',
		url: './ajax/' + type + '_cat.cfm',
		data: 'action=update&p=' + projectid + '&cid=' + categoryid + '&c=' + $('#' + type + 'cat' + row).val(),
		success: function(txt){
		     $('#' + type + 'cats').html(txt);
			 $('#edit_' + type + 'r' + row).hide();
			 $('#' + type + 'r' + row).show();
		}
	});	
}
function confirm_cat_delete(projectid,categoryid,category,type) {
	var answer = confirm('Are you sure you wish to remove the category \"' + category + '\"?')
	if (answer) {
	    $.ajax({
			type: 'get',
			url: './ajax/' + type + '_cat.cfm',
			data: 'action=delete&p=' + projectid + '&c=' + categoryid,
			success: function(txt){
			     $('#' + type + 'cats').html(txt);
			}
		});
	}
}
function add_proj_item(projectid,type) {
    $.ajax({
		type: 'get',
		url: './ajax/proj_' + type + 's.cfm',
		data: 'action=add&p=' + projectid + '&i=' + $('#new' + type).val(),
		success: function(txt){
		     $('#' + type + 's').html(txt);
			 $('#new' + type).val('');
			 $('#addnew' + type).show();
			 $('#newrow' + type).hide();
		}
	});	
}
function edit_proj_item(projectid,itemid,row,type) {
    $.ajax({
		type: 'get',
		url: './ajax/proj_' + type + 's.cfm',
		data: 'action=update&p=' + projectid + '&iid=' + itemid + '&i=' + $('#' + type + row).val(),
		success: function(txt){
		     $('#' + type + 's').html(txt);
			 $('#edit_' + type + 'r' + row).hide();
			 $('#' + type + 'r' + row).show();
		}
	});	
}
function confirm_item_delete(projectid,itemid,item,type) {
	var answer = confirm('Are you sure you wish to remove the ' + type + ' \"' + item + '\"?')
	if (answer) {
	    $.ajax({
			type: 'get',
			url: './ajax/proj_' + type + 's.cfm',
			data: 'action=delete&p=' + projectid + '&i=' + itemid,
			success: function(txt){
			     $('#' + type + 's').html(txt);
			}
		});
	}
}

// *** TIME TRACKING ***
function add_time_row(projectid) {
	if (($('#datestamp').val() == '') || ($('#hrs').val() == '') || ($('#desc').val() == '')) {
		alert('You must enter the date, number of hours, and a description.')
	} else 
	$.ajax({
		type: 'get',
		url: './ajax/timetrack.cfm',
		data: 'act=add&p=' + projectid + '&u=' + $('#userid').val() + '&t=' + $('#datestamp').val() + '&h=' + escape($('#hrs').val()) + '&d=' + escape($('#desc').val()),
		success: function(txt){
	     $('#time tbody').prepend(txt);
		 $('#hrs').val('');
		 $('#desc').val('');
		}
	});
}
function edit_time_row(projectid,timetrackid,ttidstripped) {
	$.ajax({
		type: 'get',
		url: './ajax/timetrack_edit.cfm',
		data: 'p=' + projectid + '&tt=' + timetrackid,
		success: function(txt){
			$('#r'+ttidstripped).replaceWith(txt);
		}
	});
}
function cancel_time_edit(projectid,timetrackid,ttidstripped) {
	$.ajax({
		type: 'get',
		url: './ajax/timetrack.cfm',
		data: 'act=cancel&p=' + projectid + '&tt=' + timetrackid,
		success: function(txt){
			$('#r'+ttidstripped).replaceWith(txt);
		}
	});
}
function save_time_edit(projectid,timetrackid,ttidstripped) {
    if (($('#datestamp'+ttidstripped).val() == '') || ($('#hrs'+ttidstripped).val() == '') || ($('#desc'+ttidstripped).val() == '')) {
		alert('You must enter the date, number of hours, and a description.')
	} else 
	$.ajax({
		type: 'get',
		url: './ajax/timetrack.cfm',
		data: 'act=update&p=' + projectid + '&tt=' + timetrackid + '&u=' + $('#userid'+ttidstripped).val() + '&t=' + $('#datestamp'+ttidstripped).val() + '&h=' + escape($('#hrs'+ttidstripped).val()) + '&d=' + escape($('#desc'+ttidstripped).val()),
		success: function(txt){
			$('#r'+ttidstripped).replaceWith(txt);
		}
	});
}
function delete_time(projectid,timetrackid,ttidstripped) {
	var del = confirm('Are you sure you wish to delete this time tracking item?');
	if (del == true) {
		delete_time_ajax(projectid,timetrackid);
		$('#r' + ttidstripped).fadeOut(500);
	} else return false;
}
function delete_time_ajax(projectid,timetrackid) {
    $.ajax({
		type: 'get',
		url: './ajax/timetrack.cfm',
		data: 'act=delete&p=' + projectid + '&tt=' + timetrackid,
		success: function(txt){
			$('#totalhours').html(txt);
		}
	});
}

// *** TO-DOS ***
function redraw_incomplete(projectid,todolistid,todoid,type) {
    $.ajax({
		type: 'get',
		url: './ajax/todo.cfm',
		data: 'action=redraw_incomplete&p=' + projectid + '&tl=' + todolistid + '&t=' + todoid + '&type=' + type,
		success: function(txt){
		     $('#todoitems' + todolistid).html(txt);
		}
	});
}
function redraw_completed(projectid,todolistid,todoid) {
    $.ajax({
		type: 'get',
		url: './ajax/todo.cfm',
		data: 'action=redraw_completed&p=' + projectid + '&tl=' + todolistid + '&t=' + todoid,
		success: function(txt){
		     $('#todocomplete' + todolistid).html(txt);
		}
	});
}
function mark_complete(projectid,todolistid,todoid,todoidstripped) {
    $('#id_' + todoidstripped).fadeOut(400, function(){	$(this).remove(); });
	$.ajax({
		type: 'get',
		url: './ajax/todo.cfm',
		data: 'action=mark_complete&tl=' + todolistid + '&t=' + todoid
	});
	redraw_completed(projectid,todolistid,todoid);
}
function mark_incomplete(projectid,todolistid,todoid,todoidstripped) {
	$('#id_' + todoidstripped).fadeOut(400, function(){	$(this).remove(); });
	$.ajax({
		type: 'get',
		url: './ajax/todo.cfm',
		data: 'action=mark_incomplete&tl=' + todolistid + '&t=' + todoid
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

function edit_item(projectid,todolistid,todoid) {
	$.ajax({
		type: 'get',
		url: './ajax/todo.cfm',
		data: 'action=edit&p=' + projectid + '&tl=' + todolistid + '&t=' + todoid,
		success: function(txt){
			$('#edit'+todoid).html(txt);
		}
	});
}

function cancel_edit(projectid, todolistid, todoid){
	$.ajax({
		type: 'post',
		url: './ajax/todo.cfm',
		data: 'action=cancel&p=' + projectid + '&tl=' + todolistid + '&t=' + todoid,
		success: function(txt){
			$('#edit'+todoid).html(txt);
		}
	});
}

function update_item(projectid,todolistid,todoid) {
	var newitem = $('#task' + todoid).val();
	var forwho = $('#forwho' + todoid).val();
	var forwhofull = $('#forwho' + todoid + ' :selected').text();
	var due = $('#due' + todoid).val();
	var completed = $('#completed' + todoid).val();
	$.ajax({
		type: 'post',
		url: './ajax/todo.cfm',
		data: 'action=update&p=' + projectid + '&tl=' + todolistid + '&t=' + todoid + '&task=' + escape(newitem) + '&fw=' + forwho + '&fwfull=' + escape(forwhofull) + '&d=' + due + '&c=' + completed,
		success: function(txt){
			$('#edit'+todoid).html(txt);
		}
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
		data: 'action=delete&p=' + projectid + '&tl=' + todolistid + '&t=' + todoid
	});
}
	
function todo_time(action,projectid,todolistid,todoid,todoidstripped) {
	var data = 'p=' + projectid + '&tl=' + todolistid + '&t=' + todoid;
	if (action == 'edit') data = data + '&edit=1';
	if (action == 'save') data = data + '&d=' + escape($('#datestamp' + todoidstripped).val()) + '&u=' + $('#person' + todoidstripped).val() + '&h=' + escape($('#hours' + todoidstripped).val()) + '&note=' + escape($('#note' + todoidstripped).val());
	if ((action == 'save') && (($('#datestamp'+todoidstripped).val() == '') || ($('#hrs'+todoidstripped).val() == '') || ($('#desc'+todoidstripped).val() == ''))) {
		alert('You must enter the date, number of hours, and a description.')
	} else 
	$.ajax({
		type: 'get',
		url: './ajax/todo_time.cfm',
		data: data,
		success: function(txt){
			$('#id_'+todoidstripped).html(txt);
		}
	});
}

// REORDER TO-DO LISTS
function reorder_lists() {
	$('.itemedit').hide(); $('.tododetail').hide(); $('.top').hide(); 
	$(".todolist").css("background-color","#fff"); $(".list").addClass("drag"); 
	$('#sorting_done').show();
	$('#reorder_menu').html('<a href="#" onclick="done_reordering();" class="reorder">Done Reordering</a>');
	$('#listWrapper').sortable({
		axis: "y",
		update: function() { save_order() }
	});
}
function done_reordering() {
	$('.itemedit').show(); $('.tododetail').show(); $('.top').show(); 
	$(".list").removeClass("drag"); $(".todolist").css("background-color","#f7f7f7");
	$('.listWrapper').sortable('destroy'); 
	$('#sorting_done').hide();
	$('#reorder_menu').html('<a href="#" onclick="reorder_lists();" class="reorder">Reorder lists</a>');
}
function save_order() {
	thelist = serialize_lists('#listWrapper');
	$("#listsort").val(thelist);
    $.ajax({
		type: 'post',
		url: './ajax/sort_lists.cfm',
		data: 'pid=' + $('#projectID').val() + '&lw=' + $("#listsort").val()
	});		
}
function serialize_lists(s)
{
	serial = $(s).sortable('serialize');
	return serial.replace(/id\[\]=/g,'').replace(/&/g,'|');
};

// REORDER TO-DO ITEMS
function reorder_items_by_due(projectid,todolistid){
    $.ajax({
		type: 'get',
		url: './ajax/sort_list_items.cfm',
		data: 'type=due&p=' + projectid + '&lid=' + todolistid,
		success: function(txt){
		     $('#todoitems' + todolistid).html(txt);
		}
	});
}

function reorder_items(todolistid) {
	$('.li' + todolistid).addClass('drag');
	$('.cb' + todolistid).hide(); $('.li_edit').hide();
	$('.t' + todolistid + ' a.time').hide(); $('.t' + todolistid + ' a.timefull').hide();
	$('#listmenu' + todolistid).hide();
	$('#reorderdone' + todolistid).show();
	$('#todoitems' + todolistid).sortable({
		axis: "y",
		update: function() { save_item_order(todolistid) }
	});
}
function done_reordering_items(todolistid) {
	$('#reorderdone' + todolistid).hide();
	$('#listmenu' + todolistid).show(); 
	$('.t' + todolistid + ' a.time').show(); $('.t' + todolistid + ' a.timefull').show();
	$('.cb' + todolistid).show(); $('.li_edit').show();
	$('.li' + todolistid).removeClass('drag');
	$('#todoitems' + todolistid).sortable('destroy'); 
}
function save_item_order(todolistid) {
	thelist = serialize_items('#todoitems' + todolistid);
	$('#listsort').val(thelist);
    $.ajax({
		type: 'post',
		url: './ajax/sort_list_items.cfm',
		data: 'type=manual&tlid=' + todolistid + '&li=' + $('#listsort').val()
	});	
}
function serialize_items(s)
{
	serial = $(s).sortable('serialize');
	return serial.replace(/id\[\]=/g,'').replace(/&/g,'|');
};

// FILE ATTACHMENTS
function showFiles() {
	var targetContent = $('#files');
	if (targetContent.css('display') == 'none') {
		targetContent.slideDown(300);
		$('#fileslinkbg').removeClass('collapsed');
		$('#fileslinkbg').addClass('expanded');
		$('#fileslink').addClass('notifybg');
	} else {
		targetContent.slideUp(300);
		$('#fileslinkbg').removeClass('expanded');
		$('#fileslink').removeClass('notifybg');
		$('#fileslinkbg').addClass('collapsed');
	}
	return false;	
}
function files_all() {
	if ($('#allfiles').attr('checked')==true) {
		$('#files').checkCheckboxes(':not(.notoggle)');		
	} else $('#files').unCheckCheckboxes(':not(.notoggle)');
}

// TABLESORTER PARSERS
$.tablesorter.addParser({
	id: 'usMonthOnlyDate',
	is: function(s) {
		return s.match(new RegExp(/^[A-Za-z]{3,10}\.? [0-9]{1,2}$/));
	},
	format: function(s) {
		s += ', ' + new Date().getYear();
		return $.tablesorter.formatFloat((new Date(s)).getTime());;
	}, 
    type: 'numeric' 
});
$.tablesorter.addParser({ 
    id: 'statuses', 
    is: function(s) {  
        return false; // return false so this parser is not auto detected
    }, 
    format: function(s) { 
        return s.toLowerCase().replace(/trivial/,4).replace(/minor/,3).replace(/normal/,2).replace(/major/,1).replace(/critical/,0); 
    }, 
    type: 'numeric'
});