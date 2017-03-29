# frozen_string_literal: true

#
# Regroupe les fonctionnalités d'assainissement de strings
#
module SanitizationService
  module_function

  NORMALIZED_URL_REGEX = %r{\Ahttps?://}
  DEFAULT_URL_PREFIX = 'http://'

  # assainit un nom de base de fichier
  #
  def file_basename(string)
    string.gsub(/[^0-9A-Za-z.\-]/, '_')
  end

  # assainit le texte en provenance d'un wysiwyg simple
  #
  def basic_wysiwyg_input(text)
    # l'editeur wysiwyg redactor renvoit "<p><br></p>" quand le texte est vide;
    # dans ce cas on renvoit véritablement une string vide
    return '' if text == '<p><br></p>'
    Sanitize.fragment(text.to_s, Sanitize::Config::BASIC)
  end

  # supprime tous les tags d'un texte
  def html_to_plaintext(text)
    Sanitize.clean text
  end

  # normalise une url pour qu'elle commence toujours par http:// ou https://
  #
  # si string est blank, retourne une string vide
  #
  def normalize_url(string)
    url = string.to_s
    return url if url.blank?
    return url if NORMALIZED_URL_REGEX.match?(url)
    url.prepend(DEFAULT_URL_PREFIX)
  end

  def bank_number(string)
    string.gsub(/\s+/, '').upcase
  end
end
