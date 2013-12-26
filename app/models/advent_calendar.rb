class AdventCalendar < ActiveRecord::Base
  extend Enumerize

  has_many :advent_calendar_users
  has_many :users, through: :advent_calendar_users

  enumerize :provider, in: [:qiita, :adventar], scope: true
end
