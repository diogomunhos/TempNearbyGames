// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require_tree ./secured
var selectedImages = [];
var carousel = 1;
function selectImage(id){
	var position = null;
	for(var i=0; i < selectedImages.length; i++){
		if(selectedImages[i].id === id){
			$("#inside-"+id).removeClass("selectItem");
			position = i;
			break;
		}
	}
	console.log("Position " + position);
	console.log("Images Before " + selectedImages);
	if(position != null){
		selectedImages.splice(position, 1);
	}else{
		console.log("push " + id);
		selectedImages.push({"id": id});
		$("#inside-"+id).addClass("selectItem");
		console.log("images "+ selectedImages);
	}
}

function insertHTML(){
	var html = $("#summernote").summernote("code");
	var carouselHtml = '';
	if(selectedImages.length > 1){
		carouselHtml += '<p> </p>';
		for(var i=0; i < selectedImages.length; i++){
			carouselHtml += '<a href="/images/'+selectedImages[i].id+'"><img src="/images/'+selectedImages[i].id+'" alt="" title="" /></a>'
			carouselHtml += '<p> </p>'
		}
	}
	var imageHtml = '<p> </p>';
	if(selectedImages.length === 1){
		imageHtml += '<a href="/images/'+selectedImages[0].id+'"><img src="/images/'+selectedImages[0].id+'" alt="" title="" /></a>'
		imageHtml += '<p> </p>'
	}
	if(selectedImages.length > 1){
		html += carouselHtml;
	}else if(selectedImages.length === 1){
		html += imageHtml;
	}
	console.log(html);
	$("#summernote").summernote("code", html);
	for(var i=0; i < selectedImages.length; i++){
		$("#inside-"+selectedImages[i].id).removeClass("selectItem");
	}
	selectedImages = [];
}

