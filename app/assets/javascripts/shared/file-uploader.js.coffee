class @FileUploader

  DEFAULT_OPTIONS:
    scope: $(document)
    templateSelector:
      upload: '[data-template="AttachmentUpload"]'
      download: '[data-template="AttachmentDownload"]'

  constructor:  (options = {}) ->
    console.log "init!"
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    @fileInput = $("[data-file-upload]")

    @initFileUpload()

    @options.scope
      .on "ajax:success", "[data-delete-attachment]", (e, data, status, xhr) =>
        console.log data['id']
        @getMediaNode(data['id']).remove()
      .on "ajax:error", "[data-delete-attachment]", (e, xhr, status, error)  =>
        errors = JSON.parse(xhr.responseText)['errors']
        console.log errors
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')



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
        $("[data-is-modal='attachment']").modal('show')
        $("[data-is-modal-submit]").off('click').on 'click', =>
          console.log data
          data.formData = {
            "asset_tool_attachment[custom_file_name]": $("[data-is-ta-attribute='custom_file_name']").val(),
            "asset_tool_attachment[assetable_id]": $("[data-is-ta-attribute='assetable_id']").val(),
            "asset_tool_attachment[format_type]": $("[data-is-ta-attribute='format_type']:checked").val()
          }
          data.context = @prependNode(
            template: @options.templateSelector['upload'], 
            data: data.files[0],
            dataContainer: "[data-is-media-list]"
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
        $("[data-is-modal='attachment']").modal('hide')
        $(data.context).remove()
        console.log data.result
        data.context = @prependNode(
          template: @options.templateSelector['download'], 
          data: data.result,
          dataContainer: "[data-is-media-list]"
        )

  prependNode: (args = {}) ->
    template = $(args['template']).html()
    compiledTemplate = Handlebars.compile(template)(args['data'])
    return $(compiledTemplate).prependTo(args['dataContainer'])

  getMediaNode: (id) ->
    $("[data-is-download='#{id}']")


  # Form ---------------------------------------------------------
  populateForm: (file) =>
    format = @getFormat(file.type)
    $("[data-is-ta-attribute='custom_file_name']").val(file.name)
    $("[data-is-ta-attribute='format_type']:input[value='#{format}']").prop('checked', true)
  
  getFormat: (type) ->
    switch type
      when "image/jpeg", "image/png", "image/gif" then 'picture'
      when "application/pdf" then 'document'
      else null