class AdminController < ApplicationController
  def index
    # authorize against AdminPolicy#index? — passes only for admins.
    authorize :admin, :index?
  end
end
