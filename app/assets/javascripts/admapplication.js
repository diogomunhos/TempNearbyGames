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
	var carouselHtml = '<div class="col-lg-12" style="margin-bottom: 20px;">';
	carouselHtml += '<div class="col-lg-8 col-lg-offset-2">';
	carouselHtml +=   '<div id="carousel-show" class="carousel slide" data-ride="carousel">';
	if(selectedImages.length > 1){
		// carouselHtml +=     '<ol class="carousel-indicators">';
		// for(var i=0; i < selectedImages.length; i++){
		// 	carouselHtml +=   '<li data-target="#carousel-show" data-slide-to="'+i+'" class="active"></li>';
		// }
		// carouselHtml +=   '</ol>';
		carouselHtml += '<div class="carousel-inner" role="listbox">';
		for(var i=0; i < selectedImages.length; i++){
			carouselHtml += (i === 0) ? '<div class="item active">' : '<div class="item">';
			carouselHtml += '<a href="/images/show_image/'+selectedImages[i].id+'" target="blank_"><img src="/images/show_image/'+selectedImages[i].id+'"></a>';
			carouselHtml += '</div>';
		}
		carouselHtml += '</div>';
		carouselHtml += '<a class="left carousel-control" href="#carousel-show" role="button" data-slide="prev">';
		carouselHtml +=   '<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>';
		carouselHtml +=   '<span class="sr-only">Previous</span>';
		carouselHtml += '</a>';
		carouselHtml += '<a class="right carousel-control" href="#carousel-show" role="button" data-slide="next">';
		carouselHtml += '<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>';
		carouselHtml += '<span class="sr-only">Next</span>';
		carouselHtml += '</a>';
		carouselHtml += '</div>';
		carouselHtml += '</div>';
		carouselHtml += '</div>';
		carouselHtml += '<p>Continue here...</p>';
	}
	var imageHtml = '<div class="col-lg-12" style="margin-bottom: 20px;">';
	if(selectedImages.length === 1){
		imageHtml += '<div class="col-lg-8 col-lg-offset-2">';
		imageHtml += '<a href="/images/show_image/'+selectedImages[0].id+'" target="blank_"><img src="/images/show_image/'+selectedImages[0].id+'" ></a>';
		imageHtml += '</div>';
	}
	imageHtml += '</div>';
	imageHtml += '<p>Continue here...</p>';
	if(selectedImages.length > 1){
		html += carouselHtml;
	}else if(selectedImages.length === 1){
		html += imageHtml;
	}
	console.log(html);
	$("#summernote").summernote("code", html);
}

