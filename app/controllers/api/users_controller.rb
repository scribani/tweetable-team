module Api
  class UsersController < ApiController
    # GET /api/users/:id
    def show
      render plain: 'User show'
    end

    # POST /api/users
    def create
      render plain: 'User create'
    end

    # PATCH/PUT /api/users/:id
    def update
      render plain: 'User update'
    end
  end
end
