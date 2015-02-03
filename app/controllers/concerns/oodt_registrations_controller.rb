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


    # Is the user already paired with LCP?
    if current_user.paired_with_lcp
      # Yes! Sync Their OODT Status so we know if they've completed their baseline survey since we've last seen them.
      current_user.sync_oodt_status(return_url: pairing_wizard_url)

    else
      # No! user is not yet paired with LCP. Let's see if we can solve this...

      # 1. Try to Pair them with their primary email address
      if current_user.pair_with_lcp(email: current_user.email, return_url: pairing_wizard_url)
        flash.now[:notice] = "Success! Your account was linked to your survey data."

      # 2. If that didn't work, have they JUST provided an alternative email to try?
      elsif params[:alt_email]
        # Try setting this alternative email to their user account
        if current_user.set_alt_email(params[:alt_email])
          flash.now[:notice] = "Thank you for submitting your alternative email account for CCFA Partners.  A message with a confirmation link has been sent to your alternative email address #{current_user.alt_email}.  Please open this email and click on the link to confirm this alternative email address."
        else
          flash.now[:error] = "Unable to set alternative email #{params[:alt_email]}"
        end

      # 3. Do they have an alternative email set on file?
      elsif current_user.alt_email
        # Is that email confirmed?
        if current_user.alt_email_confirmed
          # Trying pairing their confirmed email with LCP
          if current_user.pair_with_lcp(email: current_user.alt_email, return_url: pairing_wizard_url)
            flash.now[:notice] = "Success! We found that your alternative email address, #{current_user.alt_email}, matches an existing CCFA Partners account. Wonderful! We've connected them automatically to save you time entering data."
          else
            flash.now[:error] = "Your alternative email address #{current_user.alt_email} was not found in the existing CCFA Partners database.  Did you register under a different email address?  If so, provide that email address below, and we'll try to make the connection."
          end
        else
          # Tell the user they need to first confirm that alternative email.
          flash.now[:notice] = "Thank you for submitting your alternative email account for CCFA Partners.  A message with a confirmation link has been sent to your alternative email address #{current_user.alt_email}.  Please open this email and click on the link to confirm this alternative email address."
        end

      # OUT OF LUCK You're out of luck bub. Your primary email address didn't match legacy partners, and you haven't provided an alternative. You need to create a new LCP account or give an alternative email address.
      else
        flash.now[:notice] = "Welcome!  It looks like your email address #{current_user.alt_email} is brand new to our network.  Please see instructions below to complete registration."
      end

    end

  end


  def redirect_to_lcp_reg
    redirect_to current_user.get_lcp_reg_url(return_url: pairing_wizard_url)
    return
  end

  def confirm_alt_email
    @token = params[:token]
    @confirmed = User.confirm_alt_email(@token)
  end


end
