#= require jquery
#= require jquery_ujs
#= require shared/tether.min 
#= require bootstrap

#= require_tree ./admin
#= require_tree ./locales

#= require ./shared/flash-messages


$ ->
  $(".datepicker").datepicker(format: 'dd/mm/yyyy', language: 'fr', autoclose: true)
  $('.tooltip_bottom').tooltip(placement: 'bottom')

  #Submenu : faire descendre les sous menus dans la sidebar (ajout de la classe toggled)
  $('body .submenu > a').on 'click', (e) ->
    e.preventDefault()
    $(this).next().slideToggle 200
    $(this).parent().toggleClass 'toggled'
    return