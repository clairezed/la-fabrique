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
      modalAnchor:      '[data-is-modal-container]'
      modalTriggerBtn:  '[data-link-btn]'
      createForm:       '[data-is-form="create-link"]'
      modalContent:     '[data-is-modal-content]'
      linkList:         '[data-is-link-list]'
      thumbTemplate:    '[data-template="LinkThumb"]'

  constructor:  (options = {}) ->
    console.log "init Link modal!"
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    @$container = $(@options.template)
    @bindEvents()
    @loadLists()

  bindEvents: =>
    @bindNew()
    @bindCreate()

  loadLists: =>
    @loadLinks()



  # Binding =========================================================
  bindNew: =>
    console.log "bindNew"
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
        console.log "success"
        console.log data
        @$container.modal('hide')
        @renderLink(data, 'thumbTemplate')
      .on "ajax:error", @options.selectors.createForm, (e, xhr, status, error)  =>
        console.log error
        console.log xhr
        # TODO : if 422 else
        @$container.find(@options.selectors.modalContent).html(xhr.responseText)
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')

  # Loading lists ===================================================
  loadLinks: =>
    url = $(@options.selectors.linkList).data('is-link-list')
    $.get(url, {}, null, 'json'
    ).done((links) =>
      console.log(links)
      for link in links
        @renderLink(link, 'thumbTemplate')
    ).fail((error) =>
      console.log error
      # unless error.statusText == 'abort' # Abort =  Erreur que nous lançons volontairement
      #   @updateStore
      #     error: "Une erreur s'est produite lors de la connexion avec le serveur. Veuillez réessayer ultérieurement"
    )

  renderLink: (data, templateSelector) =>
    template = $(@options.selectors[templateSelector]).html()
    compiledTemplate = Handlebars.compile(template)(data)
    $(@options.selectors.linkList).prepend(compiledTemplate)