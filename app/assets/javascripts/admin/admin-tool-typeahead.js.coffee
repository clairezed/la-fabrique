class @AdminToolTypeahead extends @ToolTypeahead

  constructor:  (options = {}) ->
    super()
    @toolTemplateSelector = '[data-template="TrainingTool"]'
    @toolList = '[data-is-tool-list]'

  bindEvents: =>
    super()
    @$input.on 'typeahead:close', (evt, elt) =>
      console.log 'typeahead:close'
      @clearAutocomplete()

  manageResult: (evt, elt) =>
    @renderTool(elt)

  renderTool: (data) =>
    template = $(@toolTemplateSelector).html()
    compiledTemplate =  Handlebars.compile(template)(data)
    $(@toolList).append(compiledTemplate)
