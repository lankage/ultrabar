# For sending emails via forms
class Message
  # don't need the whole shebang because it isn't being stored here
  include ActiveModel::Model
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :name, :email, :content

  validates :name, :content, presence: true
  validates_format_of :email, with: Devise.email_regexp
end
