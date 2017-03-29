# frozen_string_literal: true

module CommentHelper
  def commenter(nickname)
    nickname.blank? ? 'Anonyme' : nickname
  end
end
