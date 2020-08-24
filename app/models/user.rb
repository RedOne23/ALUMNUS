class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :photo
  geocoded_by :current_city
  after_validation :geocode, if: :will_save_change_to_current_city?
  has_many :favorites
end
