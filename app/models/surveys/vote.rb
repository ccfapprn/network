class Vote < ActiveRecord::Base
  # Always needs to belong to user
  belongs_to :user

  # Can only belong to ONE of the following
  belongs_to :question
  belongs_to :comment
  belongs_to :post
  belongs_to :research_topic

  after_save :update_research_topic_rating


  def self.popular_research_questions
    res = Vote.select("questions.id as question_id, sum(votes.rating) as rating").where("groups.name = 'Research Questions'").joins("full outer join questions on votes.question_id = questions.id").joins("full outer join groups on questions.group_id = groups.id").group("questions.id")
    process_rq_results(res)
  end

  def self.user_research_questions(user)
    res = Vote.select("question_id as question_id, sum(rating) as rating").where(user_id: user.id, rating: 1).group("question_id")
    process_rq_results(res)
  end

  def self.new_research_questions
    res = Vote.select("questions.id as question_id, questions.created_at as created_at, sum(votes.rating) as rating").where("groups.name = 'Research Questions'").joins("full outer join questions on votes.question_id = questions.id").joins("full outer join groups on questions.group_id = groups.id").group("questions.id, questions.created_at")

    res.map {|question| {question: Question.find(question.question_id), created_at: question.created_at, rating: question.rating || 0}}.sort {|q1, q2| q1[:created_at] <=> q2[:created_at]}
  end

  def self.cast_vote()

  end

  # This helps with app/models/merit/point_rules.rb
  def research_topic_author
    if research_topic
      return research_topic.user
    else
      return false
    end
  end


  def update_research_topic_rating
    if research_topic
      research_topic.update_rating
    end
  end

  private

  def self.process_rq_results(results)
    final_list = results.map {|question| {question: Question.find(question.question_id), rating: question.rating || 0}}.sort {|q1, q2| q2[:rating] <=> q1[:rating]}
    final_list
  end

end