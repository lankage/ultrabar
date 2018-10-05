class MessageMailer < ApplicationMailer
  # related files: model/message.rb, controller/messages_controller.rb, views/message_mailer/*
  def help_email(message)
    @message = message

    mail subject: "CRISPY: Message from #{@message.try(:name) || 'a user'}"
  end
end
