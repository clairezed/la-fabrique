class @PartOneForm

  constructor: () ->
    console.log 'PartOneForm'
    $('[data-is-autocomplete-select="tool-category"]').select2()
    new TagSelect()