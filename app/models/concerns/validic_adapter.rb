module ValidicAdapter
  extend ActiveSupport::Concern

  # OVERVIEW:
  # User.rb extends this class to get these methods to interact with Validic
  # Views on the website should enable the user to visit the app marketplace and connect app: currently the only view that does this is:
      # my_connections.html.haml
      # where the button to the validic app marketplace is present.
  # We "lazy"-provision users on Validic, but only provisioning them when we need to render the app marketplace URL. We could do this lazier with more tricks.

  # WARNING:
  # You may need to occasionally call @user.delete_all_validic_users durind development to prevent conflicts when trying
  # to provision a user again since validic provoisions users based on the user id we pass them



  ####################
  # API CONNECTION SETUP
  ####################
  def validic
    conn = Faraday.new(:url => "https://api.validic.com/v1/organizations/#{Figaro.env.validic_organization_id}/")
  end

  def basic_data
    {access_token: Figaro.env.validic_access_token}
  end

  def basic_user_data
    {access_token: Figaro.env.validic_access_token, "user[uid]" => self.id}
  end

  def basic_auth_data
    {access_token: Figaro.env.validic_access_token, authentication_token: validic_access_token}
  end

  def get_validic_org_summary
    response = Faraday.get "https://api.validic.com/v1/organizations/#{Figaro.env.validic_organization_id}.json", basic_data
  end

  def check_validic_alive
    response = Faraday.get "https://api.validic.com/v1/organizations/#{Figaro.env.validic_organization_id}.json", basic_data
    #response = get_validic_org_summary
    response.success?
  end






  ###################
  # USER PROVISIONING
  ###################

  def provision_if_unprovisioned
    provision_validic_user unless validic_user_provisioned?
  end

  def validic_user_provisioned?
    (!self.validic_id.nil? && !self.validic_access_token.nil?)
  end

  def provision_validic_user
    response = validic.post "users.json", basic_user_data

    if response.success?
      body = JSON.parse(response.body)
      self.validic_id = body['user']['_id']
      self.validic_access_token = body['user']['access_token']
      self.save
      #send_validic_credentials_to_oodt if self.oodt_user? #oodt does not currently have this API call up
    else
      logger.error "API Call to Validic to provision user ##{self.id} was unsucccessful. Validic returned the following response:\n#{response.body}"
      return false
    end
  end



  ###################
  # CONNECTING APPS
  ###################

  def validic_app_marketplace_url
    # to create custom marketplace, all users must be provisioned before marketplace is displayed, moved to controller
    #provision_if_unprovisioned #this only provisions users when they get to the marketplace link
    "https://app.validic.com/#{Figaro.env.validic_organization_id}/#{self.validic_access_token}"
  end



  ###################
  # RECEIVING THE LIST OF CONNECTED APPS AND THEIR DATA
  ###################

  # NOT WRITTEN
  # follow the template of the provision_validic_user method above, modifying the validic.post arguments and response handling based on the Validic documnetation




  ###################
  # DELETING USER
  ###################
  def delete_validic_user(id = self.validic_id)
    response = validic.delete "users/#{id}.json", basic_data

    if response.success?
      self.validic_id = nil
      self.validic_access_token = nil
      self.save
    else
      logger.error "API Call to Validic to delete user ##{self.id} was unsucccessful. Validic returned the following response:\n#{response.body}"
      return false
    end

  end

  def get_validic_marketplace
    if validic_id
      response = validic.get "apps.json", basic_auth_data
      if response.success?
        JSON.parse(response.body)['apps']
      else
        logger.error "API Call to validic to get user marketplace (apps.json) for user #{id} failed.  Validic returned the following response:\n#{response.body}"
        false
      end
    else
      false
    end
  end







  ###################
  # CLASS METHODS
  ###################

  # SHOULD BE CLASS METHOD
  def get_all_validic_users
    response = validic.get "users.json", basic_user_data
    if response.success?
      body = JSON.parse(response.body)
      # gather up all the ids into a flat array
      body["users"].collect { |u| u["_id"] }
    else
      logger.error "API Call to Validic to provision user ##{self.id} was unsucccessful. Validic returned the following response:\n#{response.body}"
      return false
    end
  end

  # module ClassMethods
  # end
  # #FIXME need to factor out most of these methods into class methods, but time constraints
  # # Read up on concerns
  def delete_all_validic_users
    get_all_validic_users.each { |id| delete_validic_user(id) } if get_all_validic_users.present?
  end

end
