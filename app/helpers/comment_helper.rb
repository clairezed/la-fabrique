# frozen_string_literal: true

module CommentHelper

  # Etat -----------------------------------------------

  def comment_state_title(state)
    I18n.t(state, scope: %i(comment_states title))
  end

  def comment_state_style(state)
    I18n.t(state, scope: %i(comment_states style))
  end

  def comment_state_options(states = Comment.states.keys)
    states.map do |state|
      [comment_state_title(state), state.to_s]
    end
  end

  # Auteur -----------------------------------------------

  def commenter(nickname)
    nickname.blank? ? 'Anonyme' : nickname
  end

  def full_commenter(comment)
    [commenter(comment.nickname), comment.organization].reject(&:empty?).join(' - ')
  end

end
