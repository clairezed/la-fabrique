class @ToolForm

  constructor: () ->
    fileUploader  = new FileUploader()
    linkModal     = new LinkModal()
    stepManager   = new StepManager()

    $('[data-toggle="collapse"]').click ->
      $('.collapse.show').collapse 'hide'


    tagSelect = $('[data-is-autocomplete-select="tag"]')


    tagSelect2 = tagSelect.select2
      tags: true

    tagSelect2
      .on 'select2:select', (evt) ->
        console.log 'select2:select'

