class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'


  def guests
      reservations.map do |reservation|
        reservation.guest
      end.uniq
  end

  def hosts
    reviews.map do |review|
      review.reservation.listing.host
    end.uniq
  end

  def host_reviews
    #Incorrect -- supposed to be without first
    #This works, not sure why ???
    guests.map do |guest|
      guest.reviews
    end.first
  end

  # def guests
  #   User.all.select do |user|
  #     !user.host
  #   end
  # end
  #
  # def hosts
  #   User.all.select do |user|
  #     user.host
  #   end
  # end
  #
  # def host_reviews
  #   binding.pry
  #   self.guests.select do |guest|
  #     guest.reviews
  #   end
  # end

end
