# Allow ".mp3" as an extension for files with the MIME type "application/octet-stream".
Paperclip.options[:content_type_mappings] = {
  mp3: %w(application/octet-stream)
}