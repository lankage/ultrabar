# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer
#  first_name             :string
#  last_name              :string
#  username               :string
#  display_name           :string
#  ldap                   :boolean
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  enum role: %i[user vip admin]
  after_initialize :set_default_role, if: :new_record?

  validates :username, :email, :first_name, :last_name, presence: true
  validates :username, :email, uniqueness: { case_sensitive: false }

  has_many :experiments
  has_many :organisms
  has_many :strains
  has_many :media

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
end
