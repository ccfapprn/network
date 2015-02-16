class SocialProfile < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader
  belongs_to :user

  validates_uniqueness_of :name, allow_blank: true, case_sensitive: false
  validates :age, numericality: {only_integer: true, less_than_or_equal_to: 120, allow_nil: true, greater_than_or_equal_to: 1}
  validates :sex, inclusion: { in: %w(Male Female Other), allow_nil: true}

  scope :visible_to_community, -> { where ({visible_to_community: true}) }
  # visible_to_public?
  # visible_to_community?



  def self.unique_locations_count
    visible_to_community.select(:location_id).distinct.count
  end


  def private_photo_url(size = nil)
    if photo.present?
      if size
        photo.send(size).url || email_gravatar
      else
        photo.thumb.url || email_gravatar
      end
    else
      anonymous_gravatar
    end
  end

  def community_photo_url(size = nil)
    if visible_to_community?
      private_photo_url(size)
    else
      anonymous_gravatar
    end
  end

  def community_location
    if visible_to_community?
      location
    else
      "Private Location"
    end
  end

  def community_name
    if name.present? && visible_to_community?
      name
    else
      "Anonymous User" ##{Digest::MD5.hexdigest(user.email.to_s)[0,3]}"
    end
  end



  def location_for_map
    if latitude && longitude && visible_to_community?
      { latitude: latitude, longitude: longitude, title: name }
    else
      nil
    end
  end

  def self.locations_for_map(user=nil)
    # query below does not work with oracle
    res = select(:latitude, :longitude).where("show_location IS TRUE AND latitude IS NOT NULL AND longitude IS NOT NULL")
    # oracle would need somethign like this
    #res = select(:latitude, :longitude).where("show_location = 1 AND latitude IS NOT NULL AND longitude IS NOT NULL")
    res = res.where.not(id: user.social_profile.id) if user and user.social_profile

    res.map{|geo| {latitude: geo.latitude, longitude: geo.longitude} }
  end


  private

  def email_gravatar
    "//www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email.to_s)}?d=identicon" # s=200 would make it 200x200, default is 80
  end

  def anonymous_gravatar
    "//www.gravatar.com/avatar/#{Digest::MD5.hexdigest("anonymous_gravatar_" + user.id.to_s + "@" + Figaro.env.website_url)}?d=identicon"
  end

end


