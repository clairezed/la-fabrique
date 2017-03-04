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

#= require_tree ./admin
#= require_tree ./locales

#= require ./shared/flash-messages
#= require ./shared/file-uploader


$ ->
  $(".datepicker").datepicker(format: 'dd/mm/yyyy', language: 'fr', autoclose: true)
  $('.tooltip_bottom').tooltip(placement: 'bottom')

  #Submenu
  $('body .submenu > a').on 'click', (e) ->
    e.preventDefault()
    $submenuContainer = $(this).parent()
    $submenuContainer.toggleClass 'open'
    if $submenuContainer.hasClass 'open' then $(this).next().slideDown 200 else $(this).next().slideUp 200
    return