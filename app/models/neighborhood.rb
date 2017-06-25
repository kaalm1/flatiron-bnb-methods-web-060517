class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def neighborhood_openings(date_beg,date_end)
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

    self.all.max_by do |neighborhood|
      all_listings = neighborhood.listings.length
      all_reservations = neighborhood.listings.inject(0) do |sum,listing|
        sum + listing.reservations.length
      end
      if all_listings != 0
        all_reservations / all_listings
      else
        0
      end
    end
  end

  def self.most_res
    self.all.max_by do |neighborhood|
      neighborhood.listings.inject(0) do |sum,listing|
        sum + listing.reservations.length
      end
    end
  end
end
