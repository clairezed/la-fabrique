# frozen_string_literal: true

# Make sure errors on associations are also set on the _id and _ids fields
module ActionView::Helpers::ActiveModelInstanceTag
  def error_message_with_associations
    if @method_name.end_with?('_ids')
      # Check for a has_(and_belongs_to_)many association (these always use the _ids postfix field).
      association = object.class.reflect_on_association(@method_name.chomp('_ids').pluralize.to_sym)
    else
      # Check for a belongs_to association with method_name matching the foreign key column
      association = object.class.reflect_on_all_associations.find do |a|
        a.macro == :belongs_to && a.foreign_key == @method_name
      end
    end
    if association.present?
      object.errors[association.name] + error_message_without_associations
    else
      error_message_without_associations
    end
  end
  alias_method_chain :error_message, :associations
end
