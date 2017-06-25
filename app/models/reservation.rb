class Reservation < ActiveRecord::Base
  attr_accessor :delete_file

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence:true
  validates :checkout, presence:true

  #validates :checkin, numericality: {less_than: :checkout}
  #validates :listing_id, uniqueness: {scope: :guest_id}

  before_validation :start_must_be_before_end_date
  before_validation :can_not_make_reservation_on_own_listing
  before_validation :checks_checkin
  before_validation :checks_checkout

  def checks_checkin
    if !checkin.nil? && !checkout.nil?
    listing.reservations.select do |reservation|
      if checkin < reservation.checkin || checkin > reservation.checkout
        false
      else
        true
      end
    end.empty?
    end
  end

  def checks_checkout
    if !checkin.nil? && !checkout.nil?
    listing.reservations.select do |reservation|
      if checkout < reservation.checkin || checkout > reservation.checkout
        false
      else
        true
      end
    end.empty?
    end
  end

  def can_not_make_reservation_on_own_listing
    guest_id != listing.host.id
  end

  def start_must_be_before_end_date
    if !checkin.nil? && !checkout.nil?
      checkin < checkout
    end
  end



  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price*self.duration
  end
end
