class UserMailer < ApplicationMailer
    def achievement_created(email, achievement_id)
        @achievement_id = achievement_id
        mail to: email,
        subject: 'Congratulations with your new achievement!'
    end
    # this method was undefined, here i defined it and it holds a email, so we want mail send to email.
end
