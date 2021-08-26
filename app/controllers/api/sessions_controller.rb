module Api
  class SessionsController < ApiController
    # POST /api/login
    def create
      render plain: 'Session create'
    end

    # POST /api/logout
    def destroy
      render plain: 'Session destroy'
    end
  end
end
