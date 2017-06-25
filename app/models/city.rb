class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date_beg,date_end)

    self.listings.select do |listing|
      listing.reservations.select do |reservation|
        if reservation.checkin > date_end.to_date || reservation.checkout < date_beg.to_date
          false
        else
          true
        end
      end.empty?
    end
  end

  def self.highest_ratio_res_to_listings
    self.all.max_by do |city|
      all_listings = city.listings.length
      all_reservations = city.listings.inject(0) do |sum,listing|
        sum + listing.reservations.length
      end
      all_reservations / all_listings
    end
  end

  def self.most_res
    self.all.max_by do |city|
      total = city.listings.inject(0) do |sum,listing|
        sum + listing.reservations.length
      end
    end
  end
end
