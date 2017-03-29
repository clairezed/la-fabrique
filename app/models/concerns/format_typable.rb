module FormatTypable
  extend ActiveSupport::Concern

  included do

    enum format_type: {
      picture:  0, # 
      document: 1, # 
      slide:    2, # 
      sound:    3, # 
      video:    4,
      other:    5
    }

    validates :format_type, presence: true

  end

end