class AdventCalendar < ActiveRecord::Base
  extend Enumerize

  enumerize :provider, in: [:qiita, :adventar], scope: true
end
