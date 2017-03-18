class @ToolForm

  constructor: () ->
    fileUploader  = new FileUploader()
    linkModal     = new LinkModal()
    stepManager   = new StepManager()

    $('[data-toggle="collapse"]').click ->
      $('.collapse.show').collapse 'hide'

    tagSelect = $('[data-is-autocomplete-select="tag"]')
    autocompleteUrl = tagSelect.data('path')

    tagSelect2 = tagSelect.select2
      tags: true
      ajax: 
        url: autocompleteUrl
        dataType: 'json'
        delay: 250
        cache: true
        data: (params) ->
          # console.log params
          by_title: params.term
        processResults: (data, params) ->
          # console.log "data : "
          # console.log data
          # console.log "params : "
          # console.log params
          {results: data}

    # tagSelect2
    #   .on 'select2:select', (evt) ->
    #     console.log 'select2:select'
    #     console.log evt
