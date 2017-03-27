class @PartTwoForm

  constructor: () ->
    console.log 'PartTwoForm'
    stepManager   = new StepManager()
    fileUploader  = new FileUploader()
    linkModal     = new LinkModal()
    new Popover()
