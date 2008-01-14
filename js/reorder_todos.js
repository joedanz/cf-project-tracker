// TO-DO LISTS
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

function testalert() {
	alert('test');
}

// TO-DO ITEMS
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