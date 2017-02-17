module HomeMade
  module FormBuilder

    # Affiche les erreurs du formulaire
    # Paramètres possibles :
    # - show_title: boolean (true par défaut)
    # - only: <nested_attributes>
    # - except: <nested_attributes>
    def hm_form_errors(params = {})
      if (errors = self.object.errors).any?
        @template.content_tag :div, class: "error_explanation" do
          content = []
          if params[:show_title].nil? || params[:show_title] == true
            content << @template.content_tag(:strong, I18n.t(:form_errors))
          end
          content << @template.content_tag(:ul) do            

            if params[:only]
              messages = errors.messages.map{|key, val|
                errors.full_messages_for(key) if key.to_s.include?("#{params[:only]}.")
              }.compact.flatten
            elsif params[:except]
              messages = errors.messages.map{|key, val|
                errors.full_messages_for(key) if !key.to_s.include?("#{params[:except]}.")
              }.compact.flatten
            else
              messages = errors.full_messages
            end

            return "" if messages.empty?
            
            messages.map {|msg| @template.content_tag(:li, msg)}.join.html_safe
          end

          content.join.html_safe
        end
      end
    end

    # Génère un input text formaté pour bootstrap (pour les formulaire form-horizontal) :
    #     hm_text_field f, :lastname, {id: "lastname_input", placeholder: "Nom"}, {id: "lastname_div"}, "Coucou"
    # Donnera:
    #     <div class="form-group" id="lastname_div">
    #       <label for="lastname_input" class="form-label-default">Coucou</label>
    #       <div class="controls-default">
    #         <input type="text" class="form-control" id="lastname_input" placeholder="Nom">
    #       </div>
    #     </div>
    def hm_text_field attribute, input_options = {}, div_options = {}, label = nil
      input_options[:class], controls_class = set_form_and_controls_class(input_options[:class])

      input = self.text_field attribute, input_options

      unit = input_options.delete(:unit) if input_options[:unit].present?
      input_controls = @template.content_tag :div, class: controls_class do
        if unit.present?
          @template.content_tag :div, class: "input-group" do
            [input, @template.content_tag(:span, unit, class: "input-group-addon")].join.html_safe
          end
        else
          input
        end
      end

      hm_bootstrap_field_block attribute, input_controls, div_options, label
    end

    def hm_email_field attribute, input_options = {}, div_options = {}, label = nil
      input_options[:class], controls_class = set_form_and_controls_class(input_options[:class])
      input = self.email_field attribute, input_options

      input_controls = @template.content_tag :div, input, class: controls_class
      hm_bootstrap_field_block attribute, input_controls, div_options, label
    end
    
    def hm_password_field attribute, input_options = {}, div_options = {}, label = nil
      input_options[:class], controls_class = set_form_and_controls_class(input_options[:class])
      input = self.password_field attribute, input_options

      input_controls = @template.content_tag :div, input, class: controls_class
      hm_bootstrap_field_block attribute, input_controls, div_options, label
    end

    def hm_file_field attribute, input_options = {}, div_options = {}, label = nil
      nothing, controls_class = set_form_and_controls_class(input_options[:class])
      input = self.file_field attribute, input_options

      input_controls = @template.content_tag :div, input, class: controls_class
      hm_bootstrap_field_block attribute, input_controls, div_options, label
    end

    def hm_text_area attribute, input_options = {}, div_options = {}, label = nil
      input_options[:class], controls_class = set_form_and_controls_class(input_options[:class], "controls-xlarge")
      input = self.text_area attribute, input_options

      input_controls = @template.content_tag :div, input, class: controls_class
      hm_bootstrap_field_block attribute, input_controls, div_options, label
    end

    def hm_select attribute, collection, select_options = {}, input_options = {}, div_options = {}, label = nil
      input_options[:class], controls_class = set_form_and_controls_class(input_options[:class])
      input = self.select attribute, collection, select_options, input_options

      input_controls = @template.content_tag :div, input, class: controls_class
      hm_bootstrap_field_block attribute, input_controls, div_options, label
    end

    def hm_date_field attribute, input_options = {}, div_options = {}, label = nil
      classes = input_options[:class].try(:split, ' ') || []
      classes << "form-control" if !classes.include?("form-control")
      classes << "datepicker" if !classes.include?("datepicker")
      
      input_options[:class] = classes.join(' ')
      input_options[:value] ||= I18n.l(self.object.send(attribute).to_date) if self.object.send(attribute)

      hm_text_field attribute, input_options, div_options, label
    end

    def hm_datetime_field attribute, input_options = {}, div_options = {}, label = nil
      inputs = []

      # champ de date
      classes = input_options[:class].try(:split, ' ') || []
      classes << "form-control" if !classes.include?("form-control")
      classes << "datepicker" if !classes.include?("datepicker")
      input_options[:class] = classes.join(' ')

      controls_class = input_options[:class].select{|val| val.starts_with?("controls-")}.first || default_controls_class
      input_options[:class].delete(controls_class)

      input_options[:value] ||= I18n.l(self.object.send(attribute).to_date) if self.object.send(attribute)

      inputs << self.text_field(attribute, input_options)

      # champ d'heure/minute
      input_options_time = {}
      input_options_time[:class] = input_options[:class].gsub('datepicker', 'timepicker')
      input_options_time[:value] = I18n.l(self.object.send(attribute).to_time, format: :hour_min) if self.object.send(attribute)

      inputs << "à"
      inputs << @template.content_tag(:div, class: "bootstrap-timepicker") do
        self.text_field("#{attribute}_time".to_sym, input_options_time)
      end

      input_controls = @template.content_tag :div, inputs.join(' ').html_safe, class: controls_class
      hm_bootstrap_field_block attribute, input_controls, div_options, label
    end

    private

    def set_form_and_controls_class(classes, default_controls_class = "controls-default")
      classes = classes.try(:split, ' ') || []
      classes << "form-control" if !classes.include?("form-control")
      
      controls_class = classes.select{|val| val.starts_with?("controls-")}.first || default_controls_class
      classes.delete(controls_class)

      [classes.join(' '), controls_class]
    end

    def hm_bootstrap_field_block(attribute, input_controls, div_options = {}, custom_label = nil)
      label = self.label attribute, custom_label, class: "form-label-default"
      div_options[:class] = ["form-group row", div_options[:class]].compact.join(' ')

      @template.content_tag :div, [label, input_controls].join.html_safe, div_options
    end

  end
end

ActionView::Helpers::FormBuilder.send :include, HomeMade::FormBuilder