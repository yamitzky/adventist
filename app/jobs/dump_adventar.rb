require "resque"
require "open-uri"
require "nokogiri"

class DumpAdventar
  @queue = :adventar

  def self.perform(url)
    doc = Nokogiri::HTML open(url).read
    calendar = AdventCalendar.find_or_create_by!(
      name: doc.css(".mod-calendarHeader h2").text,
      url: url.to_s,
      provider: :adventar
    )

    entries = doc.css("table.mod-entryList tr")
    user_posts = []
    entries.each do |el|
      link_el = el.css(".mod-entryList-url a")
      next if link_el.empty?
      post_url = link_el.attr("href").to_s
      next if post_url.empty?

      user = User.find_or_initialize_by(
        provider: calendar.provider,
        name: el.css(".mod-userLink span").text,
      )
      user.image_url = el.css(".mod-userIcon").attr("src").to_s

      user_posts << {
        user: user,
        post_url: post_url
      }
    end

    user_posts.group_by{|up| up[:user].name}.each do |name, ups|
      user = ups[0][:user]
      # uniq post by domain
      post_urls = ups.uniq{|up|
        begin
          URI.parse(up[:post_url]).host
        rescue URI::InvalidURIError => e
        end
      }
      calendar.users << user unless calendar.users.include? user
      post_urls.each do |up|
        Resque.enqueue DumpAdventarRss, up[:post_url], user.id
      end
    end
  end
end
