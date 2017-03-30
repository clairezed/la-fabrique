#= require jquery
#= require jquery_ujs
#= require vendor/tether.min 
#= require bootstrap
#= require jquery-fileupload/basic
#= require jquery-fileupload/vendor/tmpl
#= require social-share-button
#= require vendor/bootstrap-datepicker 
#= require vendor/redactor.min
#= require vendor/handlebars-v4.0.5
#= require vendor/select2.min
#= require vendor/typeahead.bundle.min
#= require vendor/jquery.nice-select.min

#= require ./shared/handlebars_helper
#= require ./shared/flash-messages
#= require ./shared/tool-typeahead
#= require ./shared/tag-typeahead
#= require ./shared/tag-select
#= require ./shared/file-uploader
#= require ./shared/link-modal
#= require ./shared/step-manager
#= require ./shared/popover

#= require_tree ./front
#= require_tree ./locales

$ ->
  $('[data-is-nice-select]').niceSelect()
  
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
