class @PartOneToolForm

  constructor: () ->
    console.log 'PartOneForm'
    $('[data-is-autocomplete-select="tool-category"]').select2()
    new TagSelect()
    new Popover()

    # configuration des tooltip axis
    $("[data-is-axis-tooltip]").tooltip 
      title: () ->
        return $(this).data('is-axis-tooltip')

    # rendre certains radio_button uncheckable
    $("[data-uncheckable='true']").on 'click', (e)->
      e.preventDefault()
      $input = $(this).siblings('input')
      $input.prop('checked', !$input.prop('checked'))
