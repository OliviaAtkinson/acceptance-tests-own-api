require 'rails_helper'
require_relative '../support/login_form'
require_relative '../support/new_achievement_form'

feature 'create new achievement' do
    let(:new_achievement_form){NewAchievementForm.new}
    let(:login_form){LoginForm.new}
    let(:user){FactoryBot.create(:user)}

    background do
        login_form.visit_page.login_as(user)
    end
    # background is an alias for before, like scenario is an alias for it and feature is an alias for describe.

    scenario 'create new achievement with valid data', :vcr do
        # adding the vcr option in the example, when we run for the first itme it will make this request and cache it and when we run it the second time it will use this cached request.
        # log in form is a login page provided to me by devise.
        new_achievement_form.visit_page.fill_in_with(
            title: 'Read a book',
            cover_image: 'cover_image.png'
        ).submit

        expect(ActionMailer::Base.deliveries.count).to eq(1)
            # after i create a new achievement, im expecting the deliveries array to store the inputted email.
        expect(ActionMailer::Base.deliveries.last.to).to include(user.email)
            # this makes sure an email is sent to the authorised author
            # this test is to test the email, so when an achievement is made the author with receive an email.

        expect(Achievement.last.cover_image_identifier).to eq('cover_image.png')
        # the cover image identifier is a method given to me by carrierwave, so this is how we can get the identifier of the file or filename.
        expect(page).to have_content('Achievement has been created')
        expect(Achievement.last.title).to eq('Read a book')
        expect(page).to have_content("We tweeted for you! https://twitter.com")
        # we want to test that when an achievement has been made it sends a tweet to twitter of the achievement.
        end

    # scenario 'cannot create achievement with invalid data' do
    #     new_achievement_form.visit_page.submit
    #     expect(page).to have_content("can't be blank")
    # end
end