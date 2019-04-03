class AchievementsController < ApplicationController

    before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
    # devise before action, devise helper iself is authenticate user, specify what actions.
    before_action :owners_only, only: [:edit, :update, :destroy]


    # when we create new actions in the controller spec we need to apply the action method here.

    def index
        @achievement = Achievement.get_public_achievements
        # instead of public_access we use get_public_achievements
    end

    def new 
        @achievement = Achievement.new
    end

    def create
        # service = CreateAchievement.new(params[:achievement], current_user)
        # service.create
        # if service.created?
        #     UserMailer.achievement_created(current_user.email, @achievement.id).deliver_now
        #     # what kind of arguments it takes, deliver this email now
        #     redirect_to achievement_path(service.achievement)
        #     # this means that we need to stub it because this is dependencies message.
        # else
        #     @achievement = service.achievement
        #     render :new
        # end

        @achievement = Achievement.new(achievement_params)
        @achievement.user = current_user
        if @achievement.save
            UserMailer.achievement_created(current_user.email, @achievement.id).deliver_now
            tweet = TwitterService.new.tweet(@achievement.title)
            # when an achievement has been created the twitter service tweets the achievement message with the title of the created achievement 
            redirect_to achievement_url(@achievement), notice: "Achievement has been created, We tweeted for you! #{tweet.url}"
        else
            render :new
        end
    end

    def edit
    end

    def update
        if @achievement.update_attributes(achievement_params)
            redirect_to achievement_path
        else
            render :edit
        end
        # we have a ssuccess path and a fail(invalid) path.
        
    end

    def show
        @achievement = Achievement.find(params[:id])
    end

    def destroy
        @achievement.destroy
        # actually destroys the selected achievement id.
        redirect_to achievement_path
    end

    private

    def achievement_params
        params.require(:achievement).permit(:title, :description, :privacy, :cover_image, :featured )
    end

    def owners_only
        @achievement = Achievement.find(params[:id])
        if current_user != @achievement.user
            redirect_to achievement_path
        end
    end
end