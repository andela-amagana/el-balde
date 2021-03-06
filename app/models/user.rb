class User < ApplicationRecord
  extend Concerns::ModelMessages

  belongs_to :role
  has_many :authentications, dependent: :destroy
  has_many :lists, dependent: :destroy

  has_secure_password

  VALID_REGEX_NAME = /[a-zA-Z]+/
  VALID_REGEX_EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates :first_name,
            presence: true,
            format: { with: VALID_REGEX_NAME },
            length: { minimum: 3,
                      message: name_length }

  validates :last_name,
            presence: true,
            format: { with: VALID_REGEX_NAME },
            length: { minimum: 3,
                      message: name_length }

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: VALID_REGEX_EMAIL }

  validates :password,
            length: { minimum: 8 }

  before_validation :set_role, on: :create
  before_save :downcase_email

  def user_name
    "#{first_name} #{last_name}"
  end

  private

  def set_role
    self.role_id ||= Role.find_by(role_name: Role.role_names["n_user"]).id
  end

  def downcase_email
    self.email = email.delete(" ").downcase
  end
end
