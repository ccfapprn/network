module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments
  end

  # def non_author_comments
  #   comments.reject |comment|
  #     comment.user == self.user
  #   end
  # end


  module ClassMethods
  end
end
