class ResearchTopic < ActiveRecord::Base
  include Votable
  has_many :votes, dependent: :destroy
  has_many :research_topics

  acts_as_commentable

  paginates_per 10

  include Authority::Abilities

  belongs_to :user

  STATES = [:proposed, :top_priority, :under_development, :being_researched, :completed, :better_answered_elsewhere, :answered_by_others, :rejected]
  #not as OLD iimplementation STATES = [:proposed, :under_study, :study_completed, :rejected]
  #Old Implementation: STATES = [:under_review, :proposed, :accepted, :rejected, :complete, :hidden]
  CATEGORIES = [:diet, :medications, :procedures_and_testing, :alternative_therapies, :exercise, :lifestyle, :environment, :genetics, :other]

  #default_scope { where("state != 'rejected'") }

  scope :proposed, -> { where(state: 'proposed') }
  #scope :under_study, -> { where(state: 'under_study') }
  #scope :study_completed, -> { where(state: 'study_completed') }
  scope :rejected, ->  { where(state: 'rejected') }
  scope :accepted, -> { where("state != 'rejected'").where("archive_date > ? or archive_date is ?",2.weeks.ago.to_date,nil) }

    
  #scope :sorted, -> { order(:votes_count)}

  scope :popular, -> { accepted.order(votes_count: :desc) }
  scope :most_active, -> { accepted.order(updated_at: :desc) } #make sure commenting touches the model
  scope :newest, -> { accepted.order(created_at: :desc) }
  scope :archived, -> { where("state != 'proposed'").where("state != 'rejected'").where("archive_date <= ?",2.weeks.ago.to_date).order(updated_at: :desc) }
  scope :category, ->(category) { accepted.where("category = ?",category).order(created_at: :desc) }

  # intentionally returns all now, to allow for future filtering (no filters needed at the moment):
  scope :viewable_by, lambda { |user_id| self.all}

  # trying to get something like this:
  # select r.id,count(commentable_id)  as comment_count from research_topics r
  # left outer join comments c on c.commentable_id = r.id and c.updated_at > (SYSDATE - 30)
  # group by r.id
  # order by comment_count desc, r.id;

  def self.most_commented
    most_active.sort {|a,b| a.comments_last_30 <=> b.comments_last_30}
  end

  def update(params)
    params = set_archive(params)
    super
  end

  # set or unset archive date if state changes from votable?
  def set_archive(params)
    if params["state"]
      if votable? && !votable?(params["state"])
        params.merge!({"archive_date"=>Date.today})
      end
      if !votable? && votable?(params["state"])
        params.merge!({"archive_date"=>nil})
      end
    end
    params
  end

  def votable?(in_state=nil)
    in_state = state if in_state == nil
    if in_state == "proposed"
      true
    else
      false
    end
  end

  def self.popular_old(user_id = nil)

    self.includes(:votes).sort do |rt1, rt2|
      sort_topics(rt1, rt2)
    end
  end

  #def self.voted_by(user)
  #  self.joins(:votes).where(votes: {user_id: user.id, rating: 1} ).sort do |rt1, rt2|
  #    sort_topics(rt1, rt2)
  #  end
  #end

  # now counted votes only for non-archived (archive date + 2 weeks == archived)
  def self.voted_by(user)
    self.joins(:votes).where(votes: {user_id: user.id, rating: 1} ).where("archive_date > ? or archive_date is ?",2.weeks.ago.to_date,nil).sort do |rt1, rt2|
      sort_topics(rt1, rt2)
    end
  end

  def self.created_by(user)
    where(user_id: user.id)
  end

  def self.random(count)
    count = self.count if count > self.count #we can't ask for more records than we have
    self.offset(rand(self.count - count)).first(count)
  end


  # FIX ME, name is misleading. To the user it counts up the votes, but technically since votes can have a rating of 0 or nil, these votes are ignored
  def update_rating
    self.votes_count = rating
    save
  end

  def non_author_comments
    comments.reject { |c| c.user == c.commentable.user }
  end



  # STATE GETTERS
  def proposed?
    state == 'proposed'
  end

  def active?
    state == 'under_study'
  end

  def completed?
    state == 'study_completed'
  end

  def rejected?
    state == 'rejected'
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
        where rt.state != 'rejected'

        and v.rating > 0
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
        where rt.state != 'rejected'

        and v.rating > 0
        group by rt.id
        order by topic_votes desc, research_topic_created_at desc;
      "
    ).to_a

  end

  # alias as per Sean's specs

  # def votes_count
  #   rating
  # end


  # As per Sean's specs
  def rank
    1 + (self.class.ranks.index { |rank_hash| rank_hash['research_topic_id'].to_i == self.id } || 0)
  end

  def comments_last_30
    count = 0
    comments.each {|c| count +=1 if c.updated_at > 30.days.ago}
    count
  end




  private

  def self.sort_topics(rt1, rt2)
    comp = rt2.rating <=> rt1.rating
    comp.zero? ? (rt2.created_at <=> rt1.created_at) : comp
  end

end