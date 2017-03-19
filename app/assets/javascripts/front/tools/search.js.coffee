class @ToolSearch

  constructor: () ->
    console.log 'ToolSearch'
    # $('[data-is-autocomplete-select]').select2()
    new ToolTypeahead()
    new TagTypeahead()
