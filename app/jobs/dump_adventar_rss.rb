require "cgi"
require "addressable/uri"
require "open-uri"

class DumpAdventarRss
  @queue = :adventar_rss

  def self.perform(url, user_id)
    begin
      uri = URI.parse(url.to_s)
    rescue URI::InvalidURIError => e
      url = Addressable::URI.parse(url.to_s).normalize
      unless url.scheme
        url = URI.extract(url.to_s).first
        return unless url # URL is bad, RSS record should not be created
      end

      begin
        uri = URI.parse(url.to_s)
      rescue URI::InvalidURIError => e
        return # URL is bad
      end
    end

    rss_url = HeuristicFeedFinder.find uri.to_s

    if rss_url
      begin
        feed = SimpleRSS.parse open(rss_url)
      rescue SimpleRSSError => e
      else
        title = feed.try(:title).try(:force_encoding, "UTF-8")
        top_url = URI.extract(feed.try(:url).to_s).first
      end
    end

    top_url ||= "#{uri.scheme}://#{uri.host}"
    title ||= Nokogiri::HTML(open(top_url).read).try :title

    Website.find_or_create_by!(
      url: top_url,
      user_id: user_id,
    ) do |website|
      website.feed_url = rss_url
      website.title = title
    end
  end

  class HeuristicFeedFinder
    def self.find(url)
      url = url.to_s
      if url =~ /^(http:\/\/qiita.com\/[^\/]+)\/items/
        rss = "#{$1}/feed"
      else
        rss = Feedbag.find(url).first
        return unless rss
        rss.sub! "feedburner.jp", "feedburner.com"
        return if rss == "http://feeds.feedburner.com/"
      end
      return rss
    end
  end

end
