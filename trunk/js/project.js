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