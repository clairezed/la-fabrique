class @StepManager

  DEFAULT_OPTIONS:
    scope: $(document)
    selectors:
      newStepBtn:     '[data-step-btn]'
      deleteStepBtn:  '[data-delete-step]'
      stepList:       '[data-is-step-list]'
      fieldTemplate:  '[data-template="StepField"]'
      initialIndex:   '[data-is-step-idx]'

  constructor:  (options = {}) ->
    console.log "init StepManager !"
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    @idx = $(@options.selectors.initialIndex).last().data('is-step-idx')
    @bindAddField()
    @bindDelete()


  # Events -------------------------------------------
  bindAddField: =>
    $(@options.selectors.newStepBtn).on 'click', =>
      # console.log "clic btn"
      @renderStepField()

  bindDelete: =>
    @options.scope.on 'click', @options.selectors.deleteStepBtn, (e) ->
      # si le step n'est pas encore persisté : 
      if this.href == "javascript:void(0)"
        $(this).parents('[data-is-step-idx]').remove()

    @options.scope
      .on "ajax:success", @options.selectors.deleteStepBtn, (e, data, status, xhr) =>
        @getNode(data['id']).remove()
      .on "ajax:error", "[data-delete-attachment]", (e, xhr, status, error)  =>
        @manageError(xhr)

  # Rendering -------------------------------------------
  renderStepField: =>
    template = $(@options.selectors.fieldTemplate).html()
    compiledTemplate =  Handlebars.compile(template)({idx: ++@idx, idxmore: @idx+1})
    $(@options.selectors.stepList).append(compiledTemplate)


  # Utilities -------------------------------------------
  manageError: (xhr) =>
    # if xhr.status is 422 #erreur renvoyée à escient depuis le controller
    #   @$container.find(@options.selectors.modalContent).html(xhr.responseText)
    # else
    console.log xhr
    flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')

  getNode: (id) ->
    $("[data-is-step='#{id}']")