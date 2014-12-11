class ResearchTopic < ActiveRecord::Base
  include Votable
  has_many :votes

  acts_as_commentable

  include Authority::Abilities

  belongs_to :user

  STATES = [:under_review, :proposed, :accepted, :rejected, :complete, :hidden]

  scope :accepted, -> { where(state: 'accepted') }
  scope :viewable_by, lambda { |user_id| where("state = ? or user_id = ?", "accepted", user_id)}
  scope :sorted, -> { order(:votes_count)}

  def self.popular(user_id = nil)

    viewable_by(user_id).includes(:votes).sort do |rt1, rt2|
      sort_topics(rt1, rt2)
    end
  end

  def self.voted_by(user)
    accepted.joins(:votes).where(votes: {user_id: user.id, rating: 1} ).sort do |rt1, rt2|
      sort_topics(rt1, rt2)
    end
  end

  def self.created_by(user)
    where(user_id: user.id)
  end

  def self.newest(user_id = nil)
    viewable_by(user_id).order("created_at DESC")
  end


  def self.top_research_topics(minimum_percentage)
    ActiveRecord::Base.connection.execute(
      "
        select
        rt.id research_topic_id,
              count(v.id) topic_votes,
        max(vc.total) total_votes,
        count(v.id)/(1.00 * max(vc.total)) vote_percentage

        from research_topics rt, (select count(*) total from votes where research_topic_id is not null) vc, votes v
        where v.research_topic_id = rt.id
        group by rt.id
        having count(v.id)/(1.00 * max(vc.total)) > #{minimum_percentage};
      "
    ).to_a
  end

  def self.ranks
    ActiveRecord::Base.connection.execute(
      "
        select
          rt.id research_topic_id,
          rt.created_at research_topic_created_at,
          count(v.id) topic_votes
        from research_topics rt
        left join votes v on v.research_topic_id = rt.id
        where rt.state = 'accepted'
        group by rt.id
        order by topic_votes desc, research_topic_created_at desc;
      "
    ).to_a

  end

  # alias as per Sean's specs
  def votes_count
    rating
  end

  def accepted?
    state == 'accepted'
  end

  # As per Sean's specs
  def rank
    self.class.ranks.index { |rank_hash| rank_hash['research_topic_id'].to_i == self.id } + 1
  end

  private

  def self.sort_topics(rt1, rt2)
    comp = rt2.rating <=> rt1.rating
    comp.zero? ? (rt2.created_at <=> rt1.created_at) : comp
  end

end