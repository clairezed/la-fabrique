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
    self = @

    # need to specify formData : https://stackoverflow.com/questions/26633538/jquery-file-upload-post-and-nested-route-getting-no-route-matches-patch
    @fileInput.fileupload
      dataType: 'script'
      type: 'POST'
      autoUpload: false
      filesContainer: $("[data-is-media-list]")
      formData: [
        {name: '_method', value: 'post' }
      ]
      add: (e, data) ->
        console.log "add"
        $("[data-is-modal='attachment']").modal('show')
        $("[data-is-modal-submit]").off('click').on 'click', ->
          console.log data
          data.formData = {
            "asset_tool_attachment[custom_file_name]": $("[data-is-ta-attribute='custom_file_name']").val(),
            "asset_tool_attachment[assetable_id]": $("[data-is-ta-attribute='assetable_id']").val(),
            "asset_tool_attachment[format_type]": $("[data-is-ta-attribute='format_type']:checked").val()
          }
          file = data.files[0]
          template = $(self.options.templateSelector['upload']).html()
          @content = Handlebars.compile(template)(file)
          data.context = $(@content).prependTo("[data-is-media-list]")
          data.submit()
          return false
      progress: (e, data) ->
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', progress + '%')
      done: (e, data) ->
        console.log "done"
        console.log data
        $("[data-is-modal='attachment']").modal('hide')
        $(data.context).remove()
        
        file = JSON.parse(data.result)[0]
        template = $(self.options.templateSelector['download']).html()
        @content = Handlebars.compile(template)(file)
        $("[data-is-media-list]").prepend(@content)

    @fileInput.on 'fileuploadstart', ->
      console.log 'fileuploadstart'
    @fileInput.on 'fileuploaddone', ->
      console.log 'fileuploaddone'