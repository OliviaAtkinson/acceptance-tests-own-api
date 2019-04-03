require 'rails_helper'

# make a request to get all public achievements
RSpec.describe "Achievements API", type: :request do
    it 'gets public achievements' do
        # created two achievemetns in the data base.
        public_achievement = create(:public_achievement, title: 'My Achievement', description: 'hahaha' )
        private_achievement = FactoryBot.create(:private_achievement)

        # need to make the get request to:
        # the get request can take another parameter to the next param is the data:
        # the param after that is the additional headers that you want to provide with our request.
        # get request to the api
        get '/api/achievements', headers: {"Content-Type": "application/vnd.api+json"}
        expect(response.status).to eq(200)
        # we want to parse JSON because what we want to return from our server is the stringified JSON, 
        # so we get this string and we parse this string into the proper JSON
        # the stringified JSON is stored in response.body. now ready to write expectations on the json object
        json = JSON.parse(response.body)
        
        # as we have two achievements in the database we only want to respond to one, which is the public achievement
        expect(json['data'].count).to eq(1)
        # in the json object created a data array that hold the created achievement with the title id etc
        # make sure that the JSON data first element type to equal achievement
        expect(json['data'][0]["type"]).to eq('achievements')
        # want to make sure that we have this "my achievement" title.
        expect(json['data'][0]["attributes"]["title"]).to eq('My Achievement')
        # look at json api docs
    end
end