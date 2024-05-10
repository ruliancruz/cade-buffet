class Message < ApplicationRecord
  belongs_to :order

  enum author: { buffet: 0, client: 1 }

  validates :text, presence: true
end
