# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  # config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongoid
  # config.orm = :active_record

  # Add application observers to get notifications when reputation changes.
  # config.add_observer 'MyObserverClassName'

  # Define :user_model_name. This model will be used to grant badge if no
  # `:to` option is given. Default is 'User'.
  # config.user_model_name = 'User'

  # Define :current_user_method. Similar to previous option. It will be used
  # to retrieve :user_model_name object if no `:to` option is given. Default
  # is "current_#{user_model_name.downcase}".
  # config.current_user_method = 'current_user'
end

# Create application badges (uses https://github.com/norman/ambry)

# Multi-Level Badges
survey_responder_attr = {name: 'survey-responder', custom_fields: { title: 'Survey Responder', icon: 'fa-list-ul', category: 'research' }}

inquisitor_attr = {name: 'inquisitor', custom_fields: { title: 'Research Designer', icon: 'fa-question-circle', category: 'research' } }
sparker_attr =   {name: 'discusser', custom_fields: { title: 'Discusser', icon: 'fa-comments-o', category: 'research' }}
voter_attr = {name: 'voter', custom_fields: { title: 'Voter', icon: 'fa-check-circle-o', category: 'research' } }

checkin_attr =  {name: 'checkin', custom_fields: { title: 'Frequent Check-iner', icon: 'fa-clock-o', category: 'health_data' }}


badges = [

  ### SURVEYS ###

  # # Surveys
  survey_responder_attr.merge({level: 1, description: 'You\'ve completed your baseline survey'}),
  survey_responder_attr.merge({level: 2, description: 'You\'ve completed your second biannual survey'}),
  survey_responder_attr.merge({level: 3, description: 'You\'ve completed your third biannual survey'}),
  survey_responder_attr.merge({level: 4, description: 'You\'ve completed your fourth biannual survey'}),
  survey_responder_attr.merge({level: 5, description: 'You\'ve completed your fifth biannual survey'}),
  survey_responder_attr.merge({level: 6, description: 'You\'ve completed 5+ biannual surveys'}),
  # {name: 'just-registered', description: 'You joined! You\'re a boss!', custom_fields: { title: 'You Joined!', icon: 'fa-user', category: 'home' }},



  ### RESEARCH ###

  # Research Design
  inquisitor_attr.merge({level: 1, description: "You've asked one research question"}), # asked one
  inquisitor_attr.merge({level: 2, description: "People like your research question!"}), # got one vote
  inquisitor_attr.merge({level: 3, description: "Your research question has a following!"}), # got 5 votes
  inquisitor_attr.merge({level: 4, description: "You have a research question in the top 50% of questions!"}), # one of your research questions ranks well
  inquisitor_attr.merge({level: 5, description: "You have a research question in the top 25%!"}),
  inquisitor_attr.merge({level: 6, description: "You have a research question in the top 10%!"}),
  inquisitor_attr.merge({level: 7, description: "You have two research questions in the top 10%!"}),

  # Discussion
  sparker_attr.merge({level: 1, description: "You have commented on a research topic"}),
  sparker_attr.merge({level: 2, description: "You have asked a research question that has generated discussion"}),
  sparker_attr.merge({level: 3, description: "Your research question is heavily commented on"}),
  # your research topic is in the top % of discussed topics

  # Voting
  voter_attr.merge({level: 1, description: "You cast a vote!"}),
  voter_attr.merge({level: 2, description: "You've cast all your votes!"}),



  ### HEALTH DATA ###

  # Health Data
  checkin_attr.merge({level: 1, description: 'You\'ve done one health check in!'}),
  checkin_attr.merge({level: 2, description: 'You\'ve done three health check ins!'}),
  checkin_attr.merge({level: 3, description: 'You\'ve done five health check ins!'}),
  checkin_attr.merge({level: 4, description: 'You\'ve done 10 health check ins!'}),
  checkin_attr.merge({level: 5, description: 'You\'ve done 20 health check ins!'}),
  checkin_attr.merge({level: 6, description: 'You\'ve done 30+ health check ins!'}),
  #{name: 'connector', description: 'You\'ve connected 3 Data Sources', custom_fields: { title: 'Connector', icon: 'fa-link', category: 'health_data' }},
  #{name: 'sherlock', description: 'Investigate and graph your data', custom_fields: { title: 'Sherlock', icon: 'fa-search', category: 'health_data' }},


  # Members
  {name: 'community-face', description: 'You have created a social profile that other community members can see', custom_fields: { title: 'Community Face', icon: 'fa-group', category: 'members' }},
  {name: 'public-face', description: 'You have allowed your profile photo and location to be shown on the logged-out website. This helps newcomers and visitors learn about the power of this network.', custom_fields: { title: 'Public Face', icon: 'fa-slideshare', category: 'members' }}

]




badge_id = 1

badges.each do |attrs|
  Merit::Badge.create!(attrs.merge({id: badge_id}))
  badge_id += 1
end

