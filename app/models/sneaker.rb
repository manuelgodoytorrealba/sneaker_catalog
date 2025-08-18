class Sneaker < ApplicationRecord
  has_many_attached :images

  validates :brand, :model,  presence: true
end
