(function() {
  require(jquery);

  require(jquery_ujs);

  require(turbolinks);

  require_tree;

  $(document).on('ready page:load', function() {
    return angular.bootstrap(document.body, ['mgcrea.ngStrapDocs']);
  });

}).call(this);
