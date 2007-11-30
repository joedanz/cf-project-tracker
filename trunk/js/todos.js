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
    $('#' + todoid).DropOutDown(500);
	$.ajax({
		type: 'get',
		url: './ajax/todo.cfm',
		data: 'action=mark_complete&t=' + todolistid + '&i=' + todoid
	});
	redraw_completed(projectid,todolistid,todoid);
}

function mark_incomplete(projectid,todolistid,todoid) {
	$('#' + todoid).DropOutUp(500);
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
		$('#' + todoid).DropOutDown(500);
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