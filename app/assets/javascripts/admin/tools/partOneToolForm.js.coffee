class @PartOneToolForm

  constructor: () ->
    console.log 'PartOneForm'
    $('[data-is-autocomplete-select="tool-category"]').select2()
    new TagSelect()

    $("[data-is-axis-tooltip]").tooltip 
      title: () ->
        return $(this).data('is-axis-tooltip')

