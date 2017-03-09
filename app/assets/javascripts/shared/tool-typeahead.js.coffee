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
    engine      = @createEngine(@$container.data('is-tt-container'))
    
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
        url: "#{url}?by_title=%QUERY"
        wildcard: '%QUERY'
    engine.initialize()
    engine


  # Events =================================================================
  bindEvents: =>
    @$input
      .on 'keyup', (e) =>
        unless e.keyCode is 9 or e.keyCode is 13 # ne pas vider si entrée ou tab
          if @$input.typeahead('val') == ''
            @clearAutocomplete()
      .on 'typeahead:render', (evt, suggestions) ->
        console.log 'render'
        # Small hack to highlight the first suggestion by default
        $('.tt-dataset').find('.tt-suggestion').removeClass('tt-cursor').first().addClass('tt-cursor')
      .on 'typeahead:selected typeahead:autocompleted', (evt, elt) =>
        console.log 'autocompleted'
        @manageResult(evt, elt)
        @clearAutocomplete()
      # .on 'typeahead:select', (evt, elt) =>
      #   console.log 'select'
      # .on 'typeahead:autocomplete', (evt, elt) =>
      #   console.log 'autocomplete'
      # .on 'typeahead:asyncrequest', (evt, elt) =>
      #   console.log 'typeahead:asyncrequest'
      # .on 'typeahead:asyncreceive', (evt, elt) =>
      #   console.log 'typeahead:asyncreceive'
      # .on 'typeahead:close', (evt, elt) =>
      #   console.log 'typeahead:close'
      #   @clearAutocomplete()

  clearAutocomplete:  =>
    @$input.val('')

  manageResult: (evt, elt) =>
    window.location.replace(elt.show_url)
    