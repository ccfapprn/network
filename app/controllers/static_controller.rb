class StaticController < ApplicationController

  skip_before_action :redirect_to_pairing_if_user_not_paired

  def content
    @page = params[:page]
    render "/static/content/#{@page}", :layout => "content"
  end

  def resources
    @page = params[:page]
    render "/static/content/#{@page}", :layout => "resources"
  end

  def home
    @active_top_nav_link = :home
    @posts = Post.blog_posts.viewable
    render layout: "community"
  end

  def splash
    @page = params[:page]
    render "/static/splash", :layout => "splash"
  end
end
