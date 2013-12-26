class User < ActiveRecord::Base
  extend Enumerize

  has_many :rsses

  enumerize :provider, in: [:qiita, :adventar], scope: true
end
