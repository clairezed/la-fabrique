class @ToolTypeahead

  DEFAULT_OPTIONS:
    container: "[data-is-tt-container]"
    inputIdentifier: "[data-is-tt-input]"
    templates:
      empty:
        """
          <span class='typeahead-no-result'>Aucun résultat</span>
        """
      suggestion:
        """
          <p>{{title}}</p>
        """

  constructor:  (options = {}) ->
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    @$container = $(@options.container)
    @$input     = @$container.find(@options.inputIdentifier)
    engine      = @createEngine(@$container.data('autocomplete-path'))
    
    @$input.typeahead({
      hint: true
      highlight: true
      minLength: 1
    },{
      name: 'items'
      displayKey: 'title'
      source: engine.ttAdapter()
      limit: 10
      templates:
        suggestion: Handlebars.compile(@options.templates.suggestion)
        empty: Handlebars.compile(@options.templates.empty)
    })
    @bindEvents()


  # créée le moteur de suggestion
  #
  createEngine: (url, options = {}) ->
    engine = new Bloodhound
      name: 'items'
      datumTokenizer: (d) ->
        Bloodhound.tokenizers.whitespace(d.formatted_address)
      queryTokenizer: Bloodhound.tokenizers.whitespace
      remote:
        url: "#{url}?place=%QUERY"
        wildcard: '%QUERY'
    engine.initialize()
    engine suggestion: Handlebars.compile(@options.templates.suggestion)
    })


  # Events =================================================================
  bindEvents: =>
    @$input
      .on 'keyup', (e) =>
        unless e.keyCode is 9 or e.keyCode is 13 # ne pas vider si entrée ou tab
          if @$input.typeahead('val') == ''
            @clearAutocomplete()
      .on 'typeahead:render', (evt, suggestions) ->
        # Small hack to highlight the first suggestion by default
        $('.tt-dataset').find('.tt-suggestion').removeClass('tt-cursor').first().addClass('tt-cursor')
      .on 'typeahead:selected typeahead:autocompleted', (evt, elt) =>
        console.log elt

  clearAutocomplete:  =>
    @data = {}
    @$input.val('')
    element.val('') for key, element of @elements
    

  # $input
  #   .on 'keyup', (e) ->
  #     if $input.typeahead('val') == ''
  #       $id_input.val('')
  #       $input.val('')
  #   .on 'typeahead:render', (evt, suggestions) ->
  #     # Small hack to highlight the first suggestion by default
  #     $('.tt-dataset').find('.tt-suggestion').removeClass('tt-cursor').first().addClass('tt-cursor')
  #   .on 'typeahead:selected typeahead:autocompleted', (evt, elt) ->
  #     $id_input.val(elt.id).trigger('change')
  #     # on redirige vers la page show du praticien cliqué
  #     window.location.replace(elt.show_url)

