class AdventCalendarUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :advent_calendar
end
