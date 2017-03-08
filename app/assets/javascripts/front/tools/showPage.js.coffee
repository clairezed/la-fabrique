class @ToolShowPage

  constructor: () ->
    console.log 'ShowPage'
    @commentFormSelector = '[data-comment-form]'
    @commentSuccessSelector = '[data-comment-success]'
    
    $(document)
      .on "ajax:success", @commentFormSelector, (e, data, status, xhr) =>
        $(@commentFormSelector).slideUp "slow", =>
          $(@commentSuccessSelector).slideDown()
      .on "ajax:error", @commentFormSelector, (e, xhr, status, error)  =>
        if xhr.status == 422
          flash("Merci de remplir votre commentaire", 'danger')
        else
          flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')