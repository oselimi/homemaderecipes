class Recipe < ApplicationRecord
  belongs_to :user
  has_many :instructions, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  MAX_LENGTH_OF_TITLE = 40
  MAX_LENGTH_OF_DESCRITPION = 200
  validates :title, presence: true, length: { maximum: MAX_LENGTH_OF_TITLE }
  validates :description, presence: true, length: { maximum: MAX_LENGTH_OF_DESCRITPION }
end
