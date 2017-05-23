class @Popover

  DEFAULT_OPTIONS:
    scope: $(document)
    selectors:
      elementSelector:  '[data-is-popover]'

  POPOVER_OPTIONS:
    animation:  true
    # container:  'body'
    # content: ->
    #   console.log this
    delay:
      'show': 500
      'hide': 100
    html: true
    template: """
      <div class="popover popover--help" role="tooltip">
        <div class="popover-arrow">
        </div>
        <h3 class="popover-title"></h3>
        <div class="popover-content">
        </div>
      </div>
    """
    constraints: [
      to: 'scrollParent'  
      attachment: 'together'
      pin: true
      ]
    trigger: 'click, hover' 


  constructor:  (options = {}, popoverOptions={}) ->
    # console.log "init Link modal!"
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    @popoverOptions = $.extend(true, {}, @POPOVER_OPTIONS, popoverOptions)
    @$element = $(@options.selectors.elementSelector)

    @bindEvents()



  bindEvents: =>
    @$element.popover(@popoverOptions)