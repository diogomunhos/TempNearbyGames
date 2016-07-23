jQuery ->
  # $('body').prepend('<div id="fb-root"></div>')

  $.ajax
  url: "#{window.location.protocol}//connect.facebook.net/en_US/all.js"
  dataType: 'script'
  cache: true


  window.fbAsyncInit = ->
    FB.init(appId: '1735599803381451', cookie: true)

    $('#signin_facebook').click (e) ->
      console.log('click')
      e.preventDefault()
      FB.login (response) ->
        window.location.hash = ""
        window.location = '/auth/facebook/callback' if response.authResponse


        $('#signout_facebook').click (e) ->
          FB.getLoginStatus (response) ->
            FB.logout() if response.authResponse
            true