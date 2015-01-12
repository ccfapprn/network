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


      ### SURVEYS ###

      # survey_responder_attr.merge({level: 1, description: 'You\'ve completed your baseline survey'}),
      # survey_responder_attr.merge({level: 2, description: 'You\'ve completed your second biannual survey'}),
      # survey_responder_attr.merge({level: 3, description: 'You\'ve completed your third biannual survey'}),
      # survey_responder_attr.merge({level: 4, description: 'You\'ve completed your fourth biannual survey'}),
      # survey_responder_attr.merge({level: 5, description: 'You\'ve completed 5+ biannual surveys'}),
      # IMPLEMENTATION: SURVEY RESPONDER BADGES ARE GRANTED MANUALLY IN OODT.RB



      ### RESEARCH ###

      # research_designer_attr.merge({level: 1, description: "You've asked one research question"}), # asked one
      grant_on 'research_topics#create', badge: 'research_designer', level: 1, to: :user

      # research_designer_attr.merge({level: 2, description: "People like your research question!"}), # got one vote
      grant_on 'votes#create', badge: 'research_designer', level: 2, to: :votable_user

      # research_designer_attr.merge({level: 3, description: "Your research question has a following!"}), # got 5 votes
      grant_on 'votes#create', badge: 'research_designer', level: 3, to: :votable_user do |vote|
        vote.votable.votes.count > 5
      end

      # research_designer_attr.merge({level: 4, description: "You have a research question in the top 50% of questions!"}), # one of your research questions ranks well
      # research_designer_attr.merge({level: 5, description: "You have a research question in the top 25%!"}),
      # research_designer_attr.merge({level: 6, description: "You have a research question in the top 10%!"}),
      # research_designer_attr.merge({level: 7, description: "You have two research questions in the top 10%!"}),
      # FIXME: IMPLEMENTATION: THESE SHOULD BE WRITTEN IN A CRON JOB



      ### DISCUSSION ###

      # discusser_attr.merge({level: 1, description: "You have commented on a research topic"}),
      grant_on 'research_topics#comment', badge: 'discusser', level: 1 #implied to be current_user

      # discusser_attr.merge({level: 2, description: "You have asked a research question that has generated discussion"}),
      grant_on 'research_topics#comment', badge: 'discusser', level: 2, to: :user do |research_topic|
        research_topic.non_author_comments.any? #check if there are any non_author_comments
      end

      # discusser_attr.merge({level: 3, description: "Your research question is heavily commented on"}),
      grant_on 'research_topics#comment', badge: 'discusser', level: 3, to: :user do |research_topic|
        research_topic.non_author_comments.count >= 5 #check how many non_author_comments there are
      end



      ### VOTING ###
      # voter_attr.merge({level: 1, description: "You cast a vote!"}),
      grant_on 'votes#vote', badge: 'voter', temporary: true, level: 1, to: :user do |vote|
        vote.user.votes.where("rating > 0").count >= 1
      end
      # voter_attr.merge({level: 2, description: "You've cast all your votes!"}),
      grant_on 'votes#vote', badge: 'voter', temporary: true, level: 2, to: :user do |vote|
        vote.user.votes.where("rating > 0").count >= Figaro.env.votes_per_user.to_i
      end



      ### HEALTH DATA ###
      # these badges are directly in health_data_controller
      # def grant_checkin_badge_on(level, quota)
      #   grant_on 'health_data#check_in', badge: 'checkin', model_name: 'answer_session', level: level do |answer_session|
      #     answer_session.complete? && (answer_session.user.answer_sessions.count >= quota) #FIXME this will count all user sessions, not just health checkin types
      #     byebug
      #   end
      # end

      # # checkin_attr.merge({level: 1, description: 'You\'ve done one health check in!'}),
      # # checkin_attr.merge({level: 2, description: 'You\'ve done three health check ins!'}),
      # # checkin_attr.merge({level: 3, description: 'You\'ve done five health check ins!'}),
      # # checkin_attr.merge({level: 4, description: 'You\'ve done 10 health check ins!'}),
      # # checkin_attr.merge({level: 5, description: 'You\'ve done 20 health check ins!'}),
      # # checkin_attr.merge({level: 6, description: 'You\'ve done 30+ health check ins!'}),
      # grant_checkin_badge_on(1,1)
      # grant_checkin_badge_on(2,3)
      # # grant_checkin_badge_on(3,5)
      # # grant_checkin_badge_on(4,10)
      # # grant_checkin_badge_on(5,20)
      # # grant_checkin_badge_on(6,30)

      # grant_on 'health_data#check_in', badge: 'checkin', level: 6 do |answer_session|
      #   byebug
      # end



      ### SOCIAL ###

      # {name: 'community-face', description: 'You have created a social profile that other community members can see', custom_fields: { title: 'Community Face', icon: 'fa-group', category: 'members' }},
      # {name: 'public-face', description: 'You have allowed your profile photo and location to be shown on the logged-out website. This helps newcomers and visitors learn about the power of this network.', custom_fields: { title: 'Public Face', icon: 'fa-slideshare', category: 'members' }}
      grant_on 'members#update_profile', badge: 'face', level: 1, model_name: 'social_profile', to: :user, temporary: true do |social_profile|
        social_profile.present? && social_profile.user.visible_to_community?
      end
      # grant_on 'members#update_profile', badge: 'face', level: 2, model_name: 'social_profile', to: :user, temporary: true do |social_profile|
      #   social_profile.present? && social_profile.user.show_publicly?
      # end


    end
  end
end




      #   {name: 'check-iner', description: 'You\'ve done 40 frequent surveys', custom_fields: { title: 'Frequent Check-iner', icon: 'fa-clock-o', category: 'health_data' }},
          # NEED FREQUENT SURVEY ENGINE UP FOR THIS

      #   {name: 'connector', description: 'You\'ve connected 3 Data Sources', custom_fields: { title: 'Connector', icon: 'fa-link', category: 'health_data' }},
          # NEED VALIDIC UP AND RUNNING TO DO THIS. THIS IS A PURE VALIDIC CALL. THIS WOULD BE DONE AFTER SOME ACTION

      #   {name: 'data-dumper', description: 'Use Your Connected Devices', custom_fields: { title: 'Data Dumper', icon: 'fa-bar-chart', category: 'health_data' }},
          # THIS WOULD HAPPEN AFTER AN IMPORT OF VALIDIC

      #   {name: 'sherlock', description: 'Investigate and graph your data', custom_fields: { title: 'Sherlock', icon: 'fa-search', category: 'health_data' }},
          # I'LL HAVE TO LOOK AND SEE WHAT ACTIONS ONE CAN TAKE ON THE UI TO INVESTIGATE THIS DATA




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
