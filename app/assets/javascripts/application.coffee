//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree

$(document).on('ready page:load', ->
 	 angular.bootstrap(document.body, ['mgcrea.ngStrapDocs'])
)