class ResearchTopicsController < ApplicationController
  before_action :authenticate_user!

  before_action :no_layout, :only => [:research_topics, :vote_counter]
  before_action :set_research_topic, only: [:show, :update, :edit, :destroy]
  before_action :set_active_top_nav_link_to_research
  before_action :set_active_sub_nav

  layout "research"

  authorize_actions_for ResearchTopic, only: [:index] #, :create, :new]

  def research_topics
    raise StandardError
  end

  def set_active_sub_nav
    @active_sub_nav = :research_prioritization
  end

  def index
    @research_topics = ResearchTopic.proposed
  end

  def show
    authorize_action_for @research_topic
  end


  def create
    @research_topic = current_user.research_topics.new(research_topic_params)

    if @research_topic.save
      redirect_to research_path(active_tab: "newest"), notice: "Your research topic has been successfully submitted!"
    else
      render :new
    end
  end

  def update
    authorize_action_for @research_topic

    if current_user.can_moderate?(@research_topic)
      @research_topic.update(research_topic_moderator_params)
    end

    if @research_topic.update(research_topic_params)
      if current_user.can_moderate?(@research_topic)
        redirect_to admin_research_topic_path(@research_topic), notice: "Your research topic has been successfully updated!"
      else
        redirect_to research_topic_path(@research_topic), notice: "Your research topic has been successfully updated!"
      end
    else
      if current_user.can_moderate?(@research_topic)
        redirect_to admin_research_topics_path, error: "There were problems updating your research topic."
      else
        flash[:error] = "There were problems updating your research topic."
        render :edit
      end

    end
  end

  def edit
    authorize_action_for @research_topic

  end

  def new
    @research_topic = ResearchTopic.new
  end

  def destroy
    authorize_action_for @research_topic

    @research_topic.destroy

    if current_user.can?(:view_admin_dashboard)
      redirect_to admin_research_topics_path, notice: "Research topic deleted!"
    else
      redirect_to research_topics_path, notice: "Research topic deleted!"
    end

  end

  def comment
    @research_topic = ResearchTopic.find(params[:research_topic_id])

    @comment = Comment.build_from( @research_topic, current_user.id, params[:body])

    if @comment.save
      redirect_to research_topic_path(@research_topic), notice: "Thank you for commenting!"
    else
      redirect_to research_topic_path(@research_topic), alert: "Your comment could not be submitted!"
    end

  end

  private

  def research_topic_params
    params.require(:research_topic).permit(:text, :description, :category)
  end

  def research_topic_moderator_params
    params.require(:research_topic).permit(:state)
  end

  def set_research_topic
    @research_topic = ResearchTopic.find_by_id(params[:id])
  end

end