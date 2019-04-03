# controller test
require 'rails_helper'

describe AchievementsController do
    describe 'guest user' do
        describe 'GET index' do

            let(:achievement) { instance_double(Achievement) }
            # it creates the test double for the achievement instance object.
 
            before do
                allow(Achievement).to receive(:get_public_achievements) { [achievement] }
            end
            # use this here so both specs will use the same stub method and nobody will actually heed the database.


            it 'renders :index template' do
                get :index
                expect(response).to render_template(:index)
            end 

            it 'assigns public achievements to template' do
                get :index
                expect(assigns(:achievement)).to eq([achievement])
                # we get index, and we expect that assigns achievements to equal the same thing that we returned from this get public achievement method.
            end
            # receiving a public achievement message and return only one achievement.
            # thinking about messages, our controller action will send some query message to achievement model to get public achievements.


        end
    end

    describe 'authenticated user' do
        let(:user) { instance_double(User) }
        # user is going to be a instance user model
        before do
            allow(controller).to receive(:current_user) { user }
            allow(controller).to receive(:authenticate_user!) { true }
            # we allow controller to receive authenticate user and return ttrue, that simply means that our user is authenticated.  
        end
        # so this way we stubbed all dependencies about authentication, about current user and about the user model itself.
        # this is how we stub authentication.


        describe "POST create" do
            let(:achievement_params) { { title: "title" } }
        #     # just a hash with title. i dont care about the data because i just take it and pass it to create achievement initialization.
            let(:create_achievement) { instance_double(CreateAchievement) }
            # return create_achievement instance double.
            let(:achievement){instance_double(Achievement)}
            # we are creating a instance double of the class that holds all methods and objects.

            before do
                allow(CreateAchievement).to receive(:new) {create_achievement}
                allow(create_achievement).to receive(:create)
                allow(create_achievement).to receive(:created?)
                allow(create_achievement).to receive(:achievement){achievement}

            end
            # we do this to stub this new method to return instance double method
            # so when we call a new message, this particular object will be returned, ***
            # i stub a new message on CreateAchievement with a fake one, and return everytime when it is called, 

# so this what happens when an achievement is successfully created.
            it 'sends create message to CreateAchievement' do
                expect(CreateAchievement).to receive(:new).with(ActionController::Parameters.new(achievement_params), user)
                # expect the CreateAchievement class to receive a new message with some parameters. the user is the current user that we stubbed right here.
                expect(create_achievement).to receive(:create)
                # ***then we set expectations on this object here
                # expect create achievement object (the instance of create achievement class) to receieve create message.
                post :create, params: {achievement: achievement_params}
                # make a post request to create with achievement.
            end

            context 'achievement is created' do
                before {allow(create_achievement).to receive(:created?) {true}}
                # this mean that the achievement was usccessfully created.
                it 'redirects to' do
                    post :create ,params: {achievement: achievement_params}
                    expect(response.status).to eq(302)
                end
            end
# we can do this for when an achievement is not successfully created:
            context 'achievement is not created' do
                before {allow(create_achievement).to receive(:created?) {false}}
                it 'render :new template' do
                    post :create ,params: {achievement: achievement_params}
                    expect(response).to render_template(:new)
                end

                it 'assigns achievement to template' do
                    post :create ,params: {achievement: achievement_params}
                    expect(assigns(:achievement)).to eq(achievement)
                end
            end
        end
        
    end
    
end