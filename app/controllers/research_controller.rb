class ResearchController < ApplicationController
  before_action :authenticate_user!, :only => [:research_karma, :research_surveys]
  before_action :set_active_top_nav_link_to_research

  #before_action :fetch_notifications

  layout "research" #community

  # def fetch_notifications
  #   @posts = Post.notifications.viewable.all
  # end

  def index
    @research_topics_popular = ResearchTopic.popular.page params[:popular_page]
    @research_topics_most_active = ResearchTopic.most_active.page params[:most_active_page]
    @research_topics_newest = ResearchTopic.newest.page params[:newest_page]
    @research_topics_archived = ResearchTopic.archived.page params[:archived_page]
    @research_topics_category = ResearchTopic.category(params[:category]).page params[:category_page]

    @research_category = params[:category].to_sym if params[:category]
  end

  def my_contributions
    @research_access_events = current_user && OODT_ENABLED ? current_user.get_research_access_events : []
    @survey_scorecard = current_user && OODT_ENABLED ? current_user.get_survey_scorecard : []
  end

end