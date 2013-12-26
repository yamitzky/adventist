class User < ActiveRecord::Base
  extend Enumerize

  has_many :websites

  enumerize :provider, in: [:qiita, :adventar], scope: true
end
