require 'rails_helper'

feature 'achievement page' do
    scenario 'achievement public page' do
        achievement = create(:achievement, title: 'Just did it')
        # created a new achievement in the database
        visit("/achievements/#{achievement.id}")
        # vivisting the page of the achievements

        expect(page).to have_content('Just did it')
        # testing the page to have the achievement 'just did it'

        # achievements = create_list(:achievement, 3)
        # p achievements
    end

    scenario 'rendre markdown description' do
        achievement = create(:achievement, description: 'That *was* hard')
        visit("/achievements/#{achievement.id}")

        expect(page).to have_css('em', text: 'was')
        # here i define the css that we want to find. then i can provide different options like text.
        # the text is what is included between these tags. 
        # now i know the difference between have content and have css.
    end
end