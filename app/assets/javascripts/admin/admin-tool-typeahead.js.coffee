class @AdminToolTypeahead extends @ToolTypeahead

  constructor:  (options = {}) ->
    super()
    @toolTemplateSelector = '[data-template="TrainingTool"]'
    @toolList = '[data-is-tool-list]'

  bindEvents: =>
    super()

    @$input.on 'typeahead:close', (evt, elt) =>
      @clearAutocomplete()

    $(document).on 'click', '[data-trigger-deletion]', ->
      id = $(this).data('trigger-deletion')
      $("[data-is-tool='#{id}']").remove()


  manageResult: (evt, elt) =>
    @renderTool(elt)

  renderTool: (data) =>
    template = $(@toolTemplateSelector).html()
    compiledTemplate =  Handlebars.compile(template)(data)
    $(@toolList).append(compiledTemplate)


