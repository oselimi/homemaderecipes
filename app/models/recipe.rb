class Recipe < ApplicationRecord
  belongs_to :user

  MAX_LENGTH_OF_TITLE = 40
  MAX_LENGTH_OF_DESCRITPION = 200
  validates :title, presence: true, length: { maximum: MAX_LENGTH_OF_TITLE }
  validates :description, presence: true, length: { maximum: MAX_LENGTH_OF_DESCRITPION }
end