require 'rails_helper'

RSpec.describe Achievement, type: :model do
	describe 'validations' do
	# we can remove this :
		# it 'requires title' do
		# 	achievement = Achievement.new(title: '')
		# 	# achievement.valid?
		# # here is two ways of not allowing the fields to be empty!, if we use the last one then we dont need 'achievement.valid?'
		# 	# expect(achievement.errors[:title]).to include("can't be blank")
		# 	# expect(achievement.errors[:title]).not_to be_empty
		# 	expect(achievement.valid?).to be_falsy
		# end
	# and replace it with : 
		it{should validate_presence_of(:title)}
	# we can remove this :
		# it 'requires title to be unique for one user' do
		# 	user = FactoryBot.create(:user)
		# 	first_achievement = FactoryBot.create(:public_achievement, title: 'First Achievement', user: user)
		# 	new_achievement = Achievement.new(title: 'First Achievement', user: user)

		# 	expect(new_achievement.valid?).to be_falsy
		# end

		# it 'allows different users to have achievements to have identical titles' do
		# 	# first we prepare data in the database if we need it.
		# 	user1 = FactoryBot.create(:user)
		# 	user2 = FactoryBot.create(:user)
		# 	first_achievement = FactoryBot.create(:public_achievement, title: 'First Achievement', user: user1)
			
		# 	# then we instantiate model under test with values we needed
		# 	new_achievement = Achievement.new(title: 'First Achievement', user: user2)

		# 	# then we make action, in validaton case, its valid? method
		# 	# then we assert that the model is valid or invalid or that specific errors are added to the model.
		# 	expect(new_achievement.valid?).to be_truthy

		# end
	# and replace it with : 
		it {should validate_uniqueness_of(:title).scoped_to(:user_id).with_message("You can't have two achievements with the same title")}
	# we can remove this :
		# it 'belongs to user' do 
		# 	achievement = Achievement.new(title: 'some title', user: nil) 
		# 	expect(achievement.valid?).to be_falsy
		# 	# this is why we require an achievement to have some user or belong to some user.
		# end
	# and replace it with : 		
		it {should validate_presence_of(:user)}

	# we can remove this :
		# it 'has belongs_to user association' do
		# 	# 1st approach
		# 	user = FactoryBot.create(:user)
		# 	achievement = FactoryBot.create(:public_achievement, user: user)
		# 	expect(achievement.user).to eq(user)
		# 	# make sure that the achievement user are the same as user and returns the same object

		# 	# 2nd approach
		# 	u = Achievement.reflect_on_association(:user)
		# 	expect(u.macro).to eq(:belongs_to)

		# 	# i want to be sure that class has a method, so we dont do anything with the database.
		# end
	# and replace it with : 
		it { should belong_to(:user) }
	end

	it 'converts markdown to html' do
		achievement = Achievement.new(description: 'Awesome **thing** I *actually* did')
		expect(achievement.description_html).to include('<strong>thing</strong>')
		expect(achievement.description_html).to include('<em>actually</em>')
		# the include measure allows me to see this strinf is included in the expected full string.
	end

	it 'has silly title' do
		achievement = Achievement.new(title: "New Achievement", user: FactoryBot.create(:user, email: 'test@test.com'))
		expect(achievement.silly_title).to eq('New Achievement by test@test.com')
	end

	it 'only fetches achievements which title starts from provided letter' do
		user = FactoryBot.create(:user)
		achievement1 = FactoryBot.create(:public_achievement, title: 'Read a book', user: user)
		achievement2 = FactoryBot.create(:public_achievement, title: 'Passed an exam', user: user)
		expect(Achievement.by_letter("R")).to eq([achievement1])
	end


	# testing db queries
	it 'sorts achievements by user emails' do
		albert = FactoryBot.create(:user, email: 'albert@email.com')
		rob = FactoryBot.create(:user, email: 'rob@email.com')
		achievement1 = FactoryBot.create(:public_achievement, title: 'Read a book', user: rob)
		achievement2 = FactoryBot.create(:public_achievement, title: 'Rocked it', user: albert)
		# setting up records into the database in specific order
		expect(Achievement.by_letter("R")).to eq([achievement2, achievement1])
		# then you call method and make sure that records were returned in specific order and only the records that should be returned by this serch criteria or filter criteria.
		# you should be careful on how you write your achievements as they might be the wrong way around and can cause failures.
		# this works because by default it returns achievements sorted by id.
	end
end
# arrange data, make action, assert something.