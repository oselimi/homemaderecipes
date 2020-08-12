class Ingredient < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  MAX_LENGTH_OF_AMOUNT = 200

  validates :amount, presence: true, length: { maximum: MAX_LENGTH_OF_AMOUNT }
end
