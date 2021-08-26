module Api
  class LikesController < ApiController
    # GET /api/likes
    def index
      render plain: 'Like index'
    end

    # POST /api/likes
    def create
      render plain: 'Like create'
    end

    # DELETE /api/likes/:id
    def destroy
      render plain: 'Like destroy'
    end
  end
end
