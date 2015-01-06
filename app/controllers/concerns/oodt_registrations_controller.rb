module OODTRegistrationsController
  extend ActiveSupport::Concern


  included do
    skip_before_action :redirect_to_pairing_if_user_not_paired
  end

  module ClassMethods

  end


  # changing logic of pairing
  # we now need to set alt_email and wait for confirmation
  # try pairing:  primary email and then confirmed alt email
  def pairing_wizard #(optional param: alt_email)
    #Try pairing to make sure everytime we run pairing_wizard we are working with the latest data\
    #try_pairing(params[:email]) if !current_user.paired_with_lcp
    if !current_user.paired_with_lcp
      if current_user.pair_with_lcp(current_user.email)
        flash.now[:notice] = "Success! We found that your email address, #{current_user.email}, matches an existing CCFA Partners account. Wonderful! We've connected them automatically to save you time entering data."
      elsif params[:alt_email]
        if current_user.set_alt_email(params[:alt_email])
          flash.now[:notice] = "Thank you for submitting your alternative email account for CCFA Partners.  A message with a confirmation link has been sent to your alternative email address #{current_user.alt_email}.  Please open this email and click on the link to confirm this alternative email address."
        else
          flash.now[:error] = "Unable to set alternative email #{params[:alt_email]}"
        end
      elsif current_user.alt_email 
        if current_user.alt_email_confirmed
          if current_user.pair_with_lcp(current_user.alt_email)
            flash.now[:notice] = "Success! We found that your alternative email address, #{current_user.alt_email}, matches an existing CCFA Partners account. Wonderful! We've connected them automatically to save you time entering data."
          else
            flash.now[:error] = "Your alternative email address #{current_user.alt_email} was not found in the existing CCFA Partners database.  Did you register under a different email address?  If so, provide that email address below, and we'll try to make the connection."
          end
        else
          #flash.now[:notice] = "Pending confirmation for alternative email address #{current_user.alt_email}"
          flash.now[:notice] = "Thank you for submitting your alternative email account for CCFA Partners.  A message with a confirmation link has been sent to your alternative email address #{current_user.alt_email}.  Please open this email and click on the link to confirm this alternative email address."
        end
      else
        flash.now[:notice] = "Your primary email address #{current_user.email} was not found in the legacy CCFA Partners system. Please try an alternative email address or set up a new account."
      end
    else
      #flash.now[:notice] = "Already paired"
      flash.now[:notice] = "Success! We found that your email address, #{current_user.email}, matches an existing CCFA Partners account. Wonderful! We've connected them automatically to save you time entering data."
    end

    # Then render pairing page
  end

  def redirect_to_lcp_reg
    redirect_to current_user.get_lcp_reg_url(return_url: pairing_wizard_url)
    return
  end

  private

  #def try_pairing(alt_email) #accepts optional URL param of email

  #  email_to_try = alt_email || current_user.email

  #  if current_user.pair_with_lcp(email_to_try)
  #    flash.now[:notice] = "Success! We found that your email address, #{email_to_try}, matches an existing CCFA Partners account. Wonderful! We've connected them automatically to save you time entering data."
  #    #TODO: make this message be different if the user was automatically paired
  #  elsif alt_email
  #    flash.now[:notice] = "Your email address, #{email_to_try}, didn't match an existing CCFA Partners account. Would you like to try another email?"
  #  end
  #end



end
