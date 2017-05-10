class @TagSelect


  constructor:  (options = {}) ->
    # @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    tagSelect = $('[data-is-autocomplete-select="tag"]')
    autocompleteUrl = tagSelect.data('path')

    tagSelect2 = tagSelect.select2
      tags: true
      tokenSeparators: [',', ';', '/']
      language: "fr"
      # debug: true
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