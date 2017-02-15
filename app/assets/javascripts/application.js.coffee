#= require jquery
#= require jquery_ujs
#= require shared/tether.min 
#= require bootstrap

#= require ./shared/flash-messages


$ ->
  $('.tooltip_bottom').tooltip(placement: 'bottom')




@ajax_accept_cookies = (path) ->
  $.ajax
    url: path,
    dataType: "json",
    type: "PUT",
    success: (json) ->  
      if json.cookies_accepted
        $('#cookies_alert').remove()

