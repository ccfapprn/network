class StaticController < ApplicationController

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
    render "/static/splash", :layout => "splash_layout"
  end
end
