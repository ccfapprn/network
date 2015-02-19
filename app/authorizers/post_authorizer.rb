class PostAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    user.can?(:moderate)
  end
  def self.updatable_by?(user)
    user.can?(:moderate)
  end
  def self.deletable_by?(user)
    user.can?(:moderate)
  end

  def self.readable_by?(user)
    user.can?(:moderate)
  end

  def updatable_by?(user)
    user.can?(:moderate) || resource.user == user
  end

  def deletable_by?(user)
    user.can?(:moderate) || resource.user == user
  end

  def readable_by?(user)
    user.can?(:moderate) || resource.user == user || resource.state == 'accepted'
  end
end