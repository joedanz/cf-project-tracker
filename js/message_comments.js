function show_preview() {
	$('#preview').show();
	$('#commentbody').empty();
	var oEditor = FCKeditorAPI.GetInstance('comment');
	$('#commentbody').append(oEditor.GetHTML());
}
function confirmSubmit() {
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
		$('#'+cid).DropOutDown(500);
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