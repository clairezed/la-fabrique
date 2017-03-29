# frozen_string_literal: true

module FormatHelper
  def boolean_class(boolean)
    return '' if boolean.nil?
    boolean ? 'success' : 'danger'
  end

  def boolean_title(boolean)
    return '' if boolean.nil?
    boolean ? 'Oui' : 'Non'
  end
end
