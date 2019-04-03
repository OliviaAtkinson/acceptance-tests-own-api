class ApplicationController < ActionController::Base
    def find
        @achievement = Achievement.new
    end
end
