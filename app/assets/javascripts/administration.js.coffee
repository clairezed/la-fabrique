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
#= require vendor/typeahead.bundle.min

#= require ./shared/handlebars_helper
#= require ./shared/flash-messages
#= require ./shared/file-uploader
#= require ./shared/link-modal
#= require ./shared/step-manager
#= require ./shared/tool-typeahead
#= require ./shared/tag-typeahead
#= require ./shared/tag-select

#= require_tree ./admin
#= require_tree ./locales



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