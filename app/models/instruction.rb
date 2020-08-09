class Instruction < ApplicationRecord
  belongs_to :recipe
  belongs_to :user

  MIN_LENGTH_OF_STEP = 4
  MIN_LENGTH_OF_BODY = 6

  validates :step, presence: true, length: { minimum: MIN_LENGTH_OF_STEP }
  validates :body, presence: true, length: { minimum: MIN_LENGTH_OF_BODY }
end
