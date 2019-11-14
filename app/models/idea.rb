class Idea < ApplicationRecord

  validates :content, :impact, :ease, :confidence, presence: true
  validates :content, length: { maximum: 255 }
  validates :impact, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :ease, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :confidence, numericality: { only_integer: true , greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  before_save :calculate_average

  private

  def calculate_average
    self.average_score = (impact + ease + confidence) / 3
  end
end