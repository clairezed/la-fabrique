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

  def leading_zero(int, precision = 2)
    int.to_s.rjust(precision, '0')
  end
end
