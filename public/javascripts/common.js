function showWaiting(show){
	if (show)
		$("#waitingbg").css("display", "block");
	else
		$("#waitingbg").css("display", "none");	
}
function popup(msg){
	$("#popup").html(msg);
	$("#popup").css("display", "block");
	
}
function close_popup(){
	$("#popup").css("display", "none");
}