class Rss < ActiveRecord::Base
  belongs_to :user

  validates :url, format: {with: /\Ahttps?:\/\/.+/}
end
