class RemoveCheckinBadgesSinceRedundant < ActiveRecord::Migration
  def up
    User.find_each do |u| # more efficient query
      checkin_badges = u.badges.find_all { |x| x.custom_fields[:title] == "Check-iner"}
      checkin_badges.each { |b| u.rm_badge(b.id) }
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
