class Post < ActiveRecord::Base
  include Authority::Abilities

  require 'acts-as-taggable-on'
  require "kaminari"

  include ::ActionView::Helpers::TextHelper

  default_scope { order("created_at DESC") }

  scope :blog_posts, -> { where(post_type: "blog") }
  scope :notifications, -> { where(post_type: "notification") }
  scope :viewable, -> { where(state: "accepted").order(:created_at) }

  #TODO
  scope :research_blog, -> { where(post_type: "blog") }
  scope :patient_blog, -> { where(post_type: "blog") }
  scope :tech_blog, -> { where(post_type: "blog") }


  acts_as_taggable

  belongs_to :user
  has_many :votes

  def tags=(val)
    tag_list.add(val)
  end

  def is_notification?
    post_type == "notification"
  end

  def is_blog_post?
    post_type == "blog"
  end

end