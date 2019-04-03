class Api::AchievementsController < ApiController
    def index
        # p request.headers["Content-type"]
        achievements = Achievement.public_access
        render json: achievements

    end
end