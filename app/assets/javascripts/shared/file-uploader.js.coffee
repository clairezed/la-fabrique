class @FileUploader

  DEFAULT_OPTIONS:
    scope: $(document)
    template:
      modal: """
      <div class="modal fade>
        <div class="modal-dialog" role="document">
          <div class="modal-content" data-is-modal-content>
          </div>
      </div>
    """
    templateSelector:
      upload:   '[data-template="AttachmentUpload"]'
      download: '[data-template="AttachmentDownload"]'
    selectors: 
      listAnchor:   "[data-is-media-list]"
      modalContent: '[data-is-modal-content]'
      modalNew:        '[data-is-modal="attachment"]'

  constructor:  (options = {}) ->
    console.log "init!"
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    @fileInput = $("[data-file-upload]")
    @$modalEditContainer = $(@options.template.modal)
    @$modalNewContainer = $(@options.selectors.modalNew)

    @loadMedias()
    @initFileUpload()
    @bindEvents()



  bindEvents: =>
    # Attachement deletion ---------------------------------------
    @options.scope
      .on "ajax:success", "[data-delete-attachment]", (e, data, status, xhr) =>
        console.log data['id']
        @getMediaNode(data['id']).remove()
      .on "ajax:error", "[data-delete-attachment]", (e, xhr, status, error)  =>
        errors = JSON.parse(xhr.responseText)['errors']
        console.log errors
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')

    # Attachement edit modal ---------------------------------------
    @options.scope
      .on "ajax:success", "[data-edit-attachment]", (e, data, status, xhr) =>
        console.log data
        @$modalEditContainer.find(@options.selectors.modalContent).html(data)
        @$modalEditContainer.modal('show')
      .on "ajax:error", "[data-delete-attachment]", (e, xhr, status, error)  =>
        # errors = JSON.parse(xhr.responseText)['errors']
        console.log error
        console.log xhr
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')
    
    # Attachement update form ---------------------------------------
    @options.scope
      .on "ajax:success", "[data-is-form='update-attachment']", (e, data, status, xhr) =>
        console.log data
        currentNode = @getMediaNode(data['id'])
        compiledTemplate = @compileTemplate(data, 'download')
        currentNode.replaceWith(compiledTemplate)
        @$modalEditContainer.modal('hide')
      .on "ajax:error", "[data-delete-attachment]", (e, xhr, status, error)  =>
        # errors = JSON.parse(xhr.responseText)['errors']
        console.log error
        console.log xhr
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')

  loadMedias: =>
    url = $(@options.selectors.listAnchor).data('list-url')
    console.log url
    $.get(url, {}, null, 'json'
    ).done((items) =>
      console.log(items)
      for item in items
        @prependNode(
          template: 'download', 
          data: item
        )
    ).fail((error) =>
      console.log error
      flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')
    )

  initFileUpload: =>
    # need to specify formData : https://stackoverflow.com/questions/26633538/jquery-file-upload-post-and-nested-route-getting-no-route-matches-patch
    @fileInput.fileupload
      dataType: 'json'
      type: 'POST'
      autoUpload: false
      filesContainer: $("[data-is-media-list]")
      formData: [
        {name: '_method', value: 'post' }
      ]
      add: (e, data) =>
        console.log "add"
        @populateForm(data.files[0])
        @$modalNewContainer.modal('show')
        $("[data-is-modal-submit]").off('click').on 'click', =>
          console.log data
          data.formData = {
            "asset_tool_attachment[custom_file_name]": ($("[data-is-ta-attribute='custom_file_name']").val() || ''),
            "asset_tool_attachment[format_type]": ($("[data-is-ta-attribute='format_type']:checked").val() || '')
          }
          data.context = @prependNode(
            template: 'upload', 
            data: data.files[0]
          )
          data.submit()
          return false
      progress: (e, data) ->
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', progress + '%')
      done: (e, data) =>
        console.log "done"
        console.log data
        @$modalNewContainer.modal('hide')
        $(data.context).remove()
        console.log data.result
        data.context = @prependNode(
          template: 'download', 
          data: data.result
        )
      fail: (e, data) =>
        console.log "fail"
        console.log data.jqXHR
        if data.jqXHR.status is 424 # pb de type de média
          @cancelUpload(data.jqXHR.responseText)
        else
          errorsArray = JSON.parse(data.jqXHR.responseText).errors
          @displayError(errorsArray[0])


  # Rendering ---------------------------------------------------------
  compileTemplate: (data, templateSelector) =>
    template = $(@options.templateSelector[templateSelector]).html()
    return Handlebars.compile(template)(data)

  prependNode: (args = {}) ->
    compiledTemplate = @compileTemplate(args['data'], args['template'])
    return $(compiledTemplate).prependTo(@options.selectors.listAnchor)

  getMediaNode: (id) ->
    $("[data-is-download='#{id}']")


  # Failure management --------------------------------------------
  displayError: (message) =>
    $("[data-is-upload]").remove()
    flashAjaxError(message)

  cancelUpload: (message) =>
    @displayError(message)
    @$modalNewContainer.modal('hide')


  # Form ---------------------------------------------------------
  populateForm: (file) =>
    format = @getFormat(file.type)
    console.log format
    $("[data-is-ta-attribute='custom_file_name']").val(file.name)
    $("[data-is-ta-attribute='format_type']:input[value='#{format}']").prop('checked', true)
  
  getFormat: (type) =>
    console.log type
    switch type
      when "image/jpeg", \
        "image/png", \
        "image/gif" \
        then 'picture'
      when "application/pdf", \
        "application/msword", \
        "application/vnd.oasis.opendocument.text", \
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document", \
        "application/vnd.ms-excel", \
        "application/vnd.oasis.opendocument.spreadsheet", \
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"\
        then 'document'
      when "application/vnd.ms-powerpoint" \
        then 'slide'
      when 'audio/wav', \
        'audio/mp3'\
        then 'sound'
      else null

