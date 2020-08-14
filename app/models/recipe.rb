class Recipe < ApplicationRecord
  belongs_to :user
  has_many :instructions, dependent: :destroy
  accepts_nested_attributes_for :instructions, reject_if: lambda { |attributes| attributes['body'].blank? },
                                               allow_destroy: true

  has_many :ingredients, dependent: :destroy

  accepts_nested_attributes_for :ingredients, reject_if: lambda { |attributes| attributes['amount'].blank? },
                                              allow_destroy: true

  MAX_LENGTH_OF_TITLE = 40
  MAX_LENGTH_OF_DESCRITPION = 800
  validates :title, presence: true, length: { maximum: MAX_LENGTH_OF_TITLE }
  validates :description, presence: true, length: { maximum: MAX_LENGTH_OF_DESCRITPION }
end
