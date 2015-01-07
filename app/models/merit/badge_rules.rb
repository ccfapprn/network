# Be sure to restart your server when you modify this file.
#
# +grant_on+ accepts:
# * Nothing (always grants)
# * A block which evaluates to boolean (recieves the object as parameter)
# * A block with a hash composed of methods to run on the target object with
#   expected values (+votes: 5+ for instance).
#
# +grant_on+ can have a +:to+ method name, which called over the target object
# should retrieve the object to badge (could be +:user+, +:self+, +:follower+,
# etc). If it's not defined merit will apply the badge to the user who
# triggered the action (:action_user by default). If it's :itself, it badges
# the created object (new user for instance).
#
# The :temporary option indicates that if the condition doesn't hold but the
# badge is granted, then it's removed. It's false by default (badges are kept
# forever).

module Merit
  class BadgeRules
    include Merit::BadgeRulesMethods

    def initialize

      # survey_responder_attr.merge({level: 1, description: 'You\'ve completed your baseline survey'}),
      # survey_responder_attr.merge({level: 2, description: 'You\'ve completed your second biannual survey'}),
      # survey_responder_attr.merge({level: 3, description: 'You\'ve completed your third biannual survey'}),
      # survey_responder_attr.merge({level: 4, description: 'You\'ve completed your fourth biannual survey'}),
      # survey_responder_attr.merge({level: 5, description: 'You\'ve completed your fifth biannual survey'}),
      # survey_responder_attr.merge({level: 6, description: 'You\'ve completed 5+ biannual surveys'}),

      #grant_on 'registrations#create', badge: 'just-registered', model_name: 'User'

      WRITE ME


      ### RESEARCH ###

      # Research Design
      # inquisitor_attr.merge({level: 1, description: "You've asked one research question"}), # asked one
      # inquisitor_attr.merge({level: 2, description: "People like your research question!"}), # got one vote
      # inquisitor_attr.merge({level: 3, description: "Your research question has a following!"}), # got 5 votes
      # inquisitor_attr.merge({level: 4, description: "You have a research question in the top 50% of questions!"}), # one of your research questions ranks well
      # inquisitor_attr.merge({level: 5, description: "You have a research question in the top 25%!"}),
      # inquisitor_attr.merge({level: 6, description: "You have a research question in the top 10%!"}),
      # inquisitor_attr.merge({level: 7, description: "You have two research questions in the top 10%!"}),

      WRITE ME



      # Discussion
      # sparker_attr.merge({level: 1, description: "You have commented on a research topic"}),
      # sparker_attr.merge({level: 2, description: "You have asked a research question that has generated discussion"}),
      # sparker_attr.merge({level: 3, description: "Your research question is heavily commented on"}),
      grant_on 'comments#create', badge: 'sparker', level: 1, to: :user
      grant_on 'comments#create', badge: 'sparker', level: 2, to: :commentable_user do |comment|
        comment.commentable.non_author_comments.any?
      end
      grant_on 'comments#create', badge: 'sparker', level: 3, to: :commentable_user do |comment|
        comment.commentable.non_author_comments.count > 5
      end

      # Voting
      # voter_attr.merge({level: 1, description: "You cast a vote!"}),
      # voter_attr.merge({level: 2, description: "You've cast all your votes!"}),
      grant_voter_badge_on(1,1..1)
      grant_voter_badge_on(2,2..9999)


      ### HEALTH DATA ###

      # Health Data
      # checkin_attr.merge({level: 1, description: 'You\'ve done one health check in!'}),
      # checkin_attr.merge({level: 2, description: 'You\'ve done three health check ins!'}),
      # checkin_attr.merge({level: 3, description: 'You\'ve done five health check ins!'}),
      # checkin_attr.merge({level: 4, description: 'You\'ve done 10 health check ins!'}),
      # checkin_attr.merge({level: 5, description: 'You\'ve done 20 health check ins!'}),
      # checkin_attr.merge({level: 6, description: 'You\'ve done 30+ health check ins!'}),
      grant_checkin_badge_on(1,1..1)
      grant_checkin_badge_on(2,3..3)
      grant_checkin_badge_on(3,5..5)
      grant_checkin_badge_on(4,10..10)
      grant_checkin_badge_on(5,20..20)
      grant_checkin_badge_on(6,30..30)



      # Members
      # {name: 'community-face', description: 'You have created a social profile that other community members can see', custom_fields: { title: 'Community Face', icon: 'fa-group', category: 'members' }},
      # {name: 'public-face', description: 'You have allowed your profile photo and location to be shown on the logged-out website. This helps newcomers and visitors learn about the power of this network.', custom_fields: { title: 'Public Face', icon: 'fa-slideshare', category: 'members' }}

      WRITE ME




       # If it creates user, grant badge
      # Should be "current_user" after registration for badge to be granted.

      # grant_on 'registrations#create', badge: 'just-registered', model_name: 'User'


      ##########################
      #### Research Topics #####
      ##########################
      # Inquisitor Badges
      # grant_inquisitor_badge_on(1,1..1)
      # grant_inquisitor_badge_on(2,2..4)
      # grant_inquisitor_badge_on(3,5..9999)
      # # Vote Badges
      # grant_voter_badge_on(1,1..1)
      # grant_voter_badge_on(2,2..4)
      # grant_voter_badge_on(3,5..5)


      # FOR COMMENT BADGE, NEED COMMENTS IMPLEMENTED {name: 'discusser', description: 'You commented on 3 topics', custom_fields: { title: 'Discusser', icon: 'fa-comments-o', category: 'research' }},


      ##########################
      #### Health Data #####
      ##########################

      #   {name: 'check-iner', description: 'You\'ve done 40 frequent surveys', custom_fields: { title: 'Frequent Check-iner', icon: 'fa-clock-o', category: 'health_data' }},
          # NEED FREQUENT SURVEY ENGINE UP FOR THIS

      #   {name: 'connector', description: 'You\'ve connected 3 Data Sources', custom_fields: { title: 'Connector', icon: 'fa-link', category: 'health_data' }},
          # NEED VALIDIC UP AND RUNNING TO DO THIS. THIS IS A PURE VALIDIC CALL. THIS WOULD BE DONE AFTER SOME ACTION

      #   {name: 'data-dumper', description: 'Use Your Connected Devices', custom_fields: { title: 'Data Dumper', icon: 'fa-bar-chart', category: 'health_data' }},
          # THIS WOULD HAPPEN AFTER AN IMPORT OF VALIDIC

      #   {name: 'sherlock', description: 'Investigate and graph your data', custom_fields: { title: 'Sherlock', icon: 'fa-search', category: 'health_data' }},
          # I'LL HAVE TO LOOK AND SEE WHAT ACTIONS ONE CAN TAKE ON THE UI TO INVESTIGATE THIS DATA


      ##########################
      #### Members #####
      ##########################
      # grant_on 'members#update_profile', badge: 'socialite', model_name: 'social_profile', to: :user, temporary: true do |social_profile|
      #   social_profile.present? && social_profile.show_location
      # end
      # grant_on 'members#update_profile', badge: 'greeter', model_name: 'social_profile', to: :user, temporary: true do |social_profile|
      #   social_profile.present? && social_profile.show_publicly?
      # end


    end


    # Helper Methods
    # def grant_inquisitor_badge_on(level, range)
    #   grant_on ['research_topics#create', 'research_topics#destroy'], badge: 'inquisitor', temporary: true, level: level do |research_topic|
    #     range.include? research_topic.user.research_topics.count
    #   end
    # end

    def grant_voter_badge_on(level, range)
      grant_on 'votes#vote', badge: 'voter', temporary: true, level: level, to: :user do |vote|
        range.include? vote.user.votes.where("rating > 0").count
      end
    end


    def grant_checkin_badge_on(level, range)
      grant_on 'health_data#check_in', badge: 'checkin', level: level, model_name: 'answer_session', to: :user do |answer_session|
        answer_session.complete? && range.include? answer_session.user.answer_sessions.count #FIXME this will count all user sessions, not just health checkin types
      end
    end

  end
end





# ### FOR A CRON JOB: whenever gem?
# # NEED A QUERY EFFICIENT WAY TO SORT ALL RESEARCH TOPICS AND TO DISCOVER THE TOP 10/25/50% list of voted topics
# grant_on 'votes#vote', badge: 'voter', temporary: true, do |vote|
#   vote.research_topic && vote.research_topic.sort { |r,s| r.votes.count > s.votes.count }.first(ResearchTopic.count / 2).include?(vote.research_topic) # RESEARCH TOPIC IN TOP 25%
# end
# # THIS WILL BE A QUERY TO THE PARTNERS OODT SURVEYS COMPLETED / OFFERRED LIST
# # {name: 'dutiful-citizen', description: 'You\'ve responded to 10 biannual surveys', custom_fields: { title: 'Dutiful Citizen', icon: 'fa-list-ul', category: 'research' }},
# grant_on 'votes#vote', badge: 'voter', temporary: true, do |vote|
#   #sadsad
# end
