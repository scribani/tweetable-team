module Api
  class TweetsController < ApiController
    # GET /api/tweets
    def index
      render plain: 'Tweet index'
    end

    # GET /api/tweets/:id
    def show
      render plain: 'Tweet show'
    end

    # POST /api/tweets
    def create
      render plain: 'Tweet create'
    end

    # PATCH/PUT /api/tweets/:id
    def update
      render plain: 'Tweet update'
    end

    # DELETE /api/tweets/:id
    def destroy
      render plain: 'Tweet destroy'
    end
  end
end
