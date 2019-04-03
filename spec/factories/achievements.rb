FactoryBot.define do
    factory :achievement do
      user
      sequence(:title){|n| "Achievement #{n}"}
      description {"description"}
      privacy {:private_access}

      featured {false}
      cover_image {"some_file.png"}

      factory :public_achievement do
        privacy {:public_access}
      end
      # public_access method of privacy

      factory :private_achievement do
        privacy {:private_access}
      # private access method of privacy
      end

    end
  end