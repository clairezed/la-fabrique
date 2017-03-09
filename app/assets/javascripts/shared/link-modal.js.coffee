class @LinkModal

  DEFAULT_OPTIONS:
    scope: $(document)
    template: """
      <div class="modal fade">
        <div class="modal-dialog" role="document">
          <div class="modal-content" data-is-modal-content>
          </div>
      </div>
    """
    selectors:
      modalTriggerBtn:  '[data-link-btn]'
      createForm:       '[data-is-form="create-link"]'
      updateForm:       '[data-is-form="update-link"]'
      modalContent:     '[data-is-modal-content]'
      linkList:         '[data-is-link-list]'
      thumbTemplate:    '[data-template="LinkThumb"]'

  constructor:  (options = {}) ->
    # console.log "init Link modal!"
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    @$container = $(@options.template)
    @bindEvents()
    @loadLinks()

  bindEvents: =>
    @bindNew()
    @bindCreate()
    @bindUpdate()
    @bindDelete()


  # Binding =========================================================
  bindNew: =>
    @options.scope
      .on "ajax:success", @options.selectors.modalTriggerBtn, (e, data, status, xhr) =>
        @$container.find(@options.selectors.modalContent).html(data)
        @$container.modal('show')
      .on "ajax:error", @options.selectors.modalTriggerBtn, (e, xhr, status, error)  =>
        console.log error
        console.log xhr
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')

  bindCreate: =>
    @options.scope
      .on "ajax:success", @options.selectors.createForm, (e, data, status, xhr) =>
        @$container.modal('hide')
        @renderLink(data, 'thumbTemplate')
      .on "ajax:error", @options.selectors.createForm, (e, xhr, status, error)  =>
        @manageError(xhr)

  bindUpdate: =>
    @options.scope
      .on "ajax:success", @options.selectors.updateForm, (e, data, status, xhr) =>
        @$container.modal('hide')
        currentNode = @getNode(data['id'])
        compiledTemplate = @compileTemplate(data, 'thumbTemplate')
        currentNode.replaceWith(compiledTemplate)
      .on "ajax:error", @options.selectors.createForm, (e, xhr, status, error)  =>
        @manageError(xhr)

  bindDelete: =>
    @options.scope
      .on "ajax:success", "[data-delete-link]", (e, data, status, xhr) =>
        console.log data['id']
        @getNode(data['id']).remove()
      .on "ajax:error", "[data-delete-attachment]", (e, xhr, status, error)  =>
        @manageError(xhr)


  # Loading lists ===================================================
  loadLinks: =>
    toolId = @getToolId()
    if !!toolId # Si l'outil est persisté
      url = $(@options.selectors.linkList).data('list-url')
      console.log url
      $.get(url, {by_tool_id: toolId}, null, 'json'
      ).done((links) =>
        console.log(links)
        for link in links
          @renderLink(link, 'thumbTemplate')
      ).fail((error) =>
        console.log error
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')
      )

  renderLink: (data, templateSelector) =>
    compiledTemplate = @compileTemplate(data, templateSelector)
    $(@options.selectors.linkList).prepend(compiledTemplate)

  compileTemplate: (data, templateSelector) =>
    template = $(@options.selectors[templateSelector]).html()
    return Handlebars.compile(template)(data)

  manageError: (xhr) =>
    if xhr.status is 422 #erreur renvoyée à escient depuis le controller
      @$container.find(@options.selectors.modalContent).html(xhr.responseText)
    else
      console.log xhr
      flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')

  getNode: (id) ->
    $("[data-is-link='#{id}']")

  getToolId: =>
    return $(@options.selectors.linkList).data('is-link-list')