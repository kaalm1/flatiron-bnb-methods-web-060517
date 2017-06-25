class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence:true
  validates :description, presence:true
  validates :reservation_id, presence:true

  before_validation :checkout_has_happened

  def checkout_has_happened
    if !reservation.nil?
      Date.today > reservation.checkout
    end
  end
end
