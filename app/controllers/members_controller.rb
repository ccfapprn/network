class MembersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :locations, :discussion]
  before_action :set_active_top_nav_link_to_members, except: [:profile]

  layout "community"

  # def profile
  #   @social_profile = current_user.social_profile

  #   @active_top_nav_link = :my_account
  #   render layout: "account"
  # end

  def update_profile
    @social_profile = current_user.social_profile

    if @social_profile.update(social_profile_params)
      flash[:notice] = "Updated Successfully!"
    else
      #
    end
    redirect_to account_path

    # Hack for Badge_Rules.rb to work correctly
    @member = @social_profile
  end


  # def update_profile
  #   @social_profile = current_user.social_profile

  #   if @social_profile.update(social_profile_params)
  #     flash[:notice] = "Updated Successfully!"
  #     redirect_to social_profile_path
  #   else
  #     render :profile
  #   end
  # end

  def index
    @network_users_count = OODT_ENABLED ? User.get_network_user_count : User.count
  end



  def locations
    if params[:show_user]
      @locations = SocialProfile.locations_for_map(current_user)
      @user_location = current_user.social_profile.location_for_map if current_user && current_user.social_profile
    else
      @locations = SocialProfile.locations_for_map
    end

  end

  private

  def social_profile_params

    params.require(:social_profile).permit(
        :name,
        :show_location,
        :show_karma,
        :location,
        :latitude,
        :longitude,
        :location_id,
        :make_public,
        :age,
        :sex,
        :photo,
        :visible_to_community,
        :visible_to_world
    )
  end
end
