class SessionsController < Devise::SessionsController;

  def initialize
    include_plugins
    super
  end


  private


  def include_plugins
    self.class.send(:include, OODTSessionsController) if OODT_ENABLED
  end

end