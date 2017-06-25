class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence:true
  validates :listing_type, presence:true
  validates :title, presence:true
  validates :description, presence:true
  validates :price, presence:true
  validates :neighborhood_id, presence:true

  after_create :change_user_host_status
  after_destroy :change_user_host_status_to_false

  def change_user_host_status
    host.host = true
    host.save
  end

  def change_user_host_status_to_false
    if host.listings.empty?
      host.host = false
      host.save
    end
  end

  def average_review_rating
    
    1.0*self.reviews.inject(0) do |sum, review|
      sum + review.rating
    end / self.reviews.length
  end
end
