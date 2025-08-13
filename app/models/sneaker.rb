class Sneaker < ApplicationRecord
  has_many_attached :images

  enum :condition, {
    new_with_box: 0, new_no_box: 1,
    used_like_new: 2, used_good: 3, used_fair: 4
  }

  validates :brand, :model, :price_cents, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

  def price
    (price_cents || 0) / 100.0
  end
end
