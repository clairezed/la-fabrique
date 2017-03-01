class @FileUploader

  DEFAULT_OPTIONS:
    scope: $(document)

  constructor:  (options = {}) ->
    console.log "init!"


    # need to specify formData : https://stackoverflow.com/questions/26633538/jquery-file-upload-post-and-nested-route-getting-no-route-matches-patch
    @fileInput = $("[data-file-upload]")
    @fileInput.fileupload
      dataType: 'script'
      type: 'POST'
      autoUpload: false
      formData: [
        {name: '_method', value: 'post' },
        {name: 'test', value: 'testvalue'}
      ]
      add: (e, data) ->
        console.log "add"
        $("[data-is-modal='attachment']").modal('show')
        $("[data-is-modal-submit]").off('click').on 'click', ->
          console.log "click"
          console.log data
          data.formData = {
            "asset_tool_attachment[custom_file_name]": $("[data-is-ta-attribute='custom_file_name']").val(),
            "asset_tool_attachment[assetable_id]": $("[data-is-ta-attribute='assetable_id']").val(),
            "asset_tool_attachment[format_type]": $("[data-is-ta-attribute='format_type']").val()

          }
          data.submit()
          return false
        # $("[data-is-modal-submit]").on 'click', ->
        #   console.log click
          # data.submit()
      done:  (e, data) ->
        console.log "done"
        console.log e
        console.log data
        $("[data-is-modal='attachment']").modal('hide')

    # console.log @fileInput
    console.log @fileInput.fileupload('option', 'url')

    @document_upload_form = $("[data-is-form='attachment'")
    @fileInput.on 'fileuploadstart', ->
      console.log 'fileuploadstart'
    @fileInput.on 'fileuploaddone', ->
      console.log 'fileuploaddone'


    # @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    # $scope = @options.scope
    # typeaheadContainers = $scope.find('[data-is-practitioner-typeahead]')
    # for container in typeaheadContainers
    #   @initTypeahead(container)
