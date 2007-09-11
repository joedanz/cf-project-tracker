$(document).ready(function(){
	$('input, textarea, select').focus(function(){ $(this).css('background-color', '#ffc'); });
	$('input, textarea, select').blur(function(){ $(this).css('background-color', '#fff'); });
});

function togglemenu() {
	var targetContent = $('#projectmenu');
	if (targetContent.css('display') == 'none') {
		targetContent.SlideInUp();
	} else {
		targetContent.SlideOutUp();
	}
	return false;		
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