//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree

$(document).on('ready page:load', ->
 	 angular.bootstrap(document.body, ['mgcrea.ngStrapDocs'])
)

$(document).on('ready page:load', ->
		window.location = window.location.href.replace(/#.*/, '') if window.location.href.indexOf('#_=_') > 0
)