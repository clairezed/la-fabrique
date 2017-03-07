#= require jquery
#= require jquery_ujs
#= require vendor/tether.min 
#= require bootstrap
#= require jquery-fileupload/basic
#= require jquery-fileupload/vendor/tmpl
#= require vendor/bootstrap-datepicker 
#= require vendor/redactor.min
#= require vendor/handlebars-v4.0.5
#= require vendor/select2.min
#= require ./shared/handlebars_helper

#= require ./shared/flash-messages


$ ->
  $('.tooltip_bottom').tooltip(placement: 'bottom')

  # explanation section show / hide
  $("[data-for-explanation-collapse]").on 'click', ->
    $("[data-is-explanation-collapse]").toggleClass('explanation--hidden')

@ajax_accept_cookies = (path) ->
  $.ajax
    url: path,
    dataType: "json",
    type: "PUT",
    success: (json) ->  
      if json.cookies_accepted
        $('#cookies_alert').remove()
