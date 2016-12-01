class User < ApplicationRecord
  # association for wishlist item
  has_many :wishlist_items, dependent: :destroy #ask margo for confirmation
  # association with physical books
  has_many :physical_books
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
  has_many :received_messages, class_name: "Message", foreign_key: "recipient_id"
  has_many :sold_transactions, class_name: "Transaction", foreign_key: "seller_id"
  has_many :received_transactions, class_name: "Transaction", foreign_key: "receiver_id"
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :profile_pic_url, presence: true
  validates :street1, presence: true
  validates :postbox, presence: true
  validates :postcode, presence: true
  validates :city, presence: true
  validates :country, presence: true


  def address
    [street1, street2, postbox, postcode, city, country].compact.join(', ')
  end
  geocoded_by :address # concatenation of variables: "street1", "street2", "postbox", "postcode", "city", "country"

  after_validation :geocode, if: :address_changed?

  def address_changed?
    if street1_changed? || street2_changed? || postbox_changed? || postcode_changed? || city_changed? || country_changed?
      return true
    else
      return false
    end

  end

end
