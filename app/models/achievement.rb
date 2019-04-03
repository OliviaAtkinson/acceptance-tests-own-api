class Achievement < ApplicationRecord
    # association
    belongs_to :user
    # validation, we can customise different validations.
    validates :title, presence: true
    validates :user, presence: true
    validates :title, uniqueness: {
        scope: :user_id,
        message: "You can't have two achievements with the same title"
    }
    # this means that this validation applies to the scope of users.
    # validate :unique_title_for_one_user

    

    enum privacy: [:public_access, :private_access, :friends_access]

    mount_uploader :cover_image, CoverImageUploader

    # instance method, which converts markdown into html.
    def description_html
        Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(description)
    end

    def silly_title
        "#{title} by #{user.email}"
    end

    def self.by_letter(letter)
        includes(:user).where("title LIKE ?", "#{letter}%").order("users.email")
        # the percent sign means any letter in SQL.
        # ordering records by users' email field.
    end

    def self.get_public_achievements
    end

    # private

    # def unique_title_for_one_user 
    #     existing_achievement = Achievement.find_by(title: title)
    #     # using the current achievement title to find another achievement with the same title in the db

    #     if existing_achievement && existing_achievement.user == user
    #     # if the exsisting achievement actually exsists and the exsisting achievement user is the same aa this particular user then ..
    #         errors.add(:title, "You can't have two achievements with the same title")
    #     end
    # end

    
end

