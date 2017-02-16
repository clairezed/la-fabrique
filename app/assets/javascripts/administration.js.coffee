#= require jquery
#= require jquery_ujs
#= require vendor/tether.min 
#= require bootstrap
#= require vendor/bootstrap-datepicker 
#= require vendor/redactor.min 

#= require_tree ./admin
#= require_tree ./locales

#= require ./shared/flash-messages


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