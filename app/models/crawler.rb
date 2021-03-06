class Crawler
  BASE_URL = "http://basicbook.net/"
  attr_accessor :agent

  def initialize
    @options = {
      open_timeout: 3,
      read_timeout: 4,
      keep_alive: true,
      redirect_ok: true,
    }
    @agent = Mechanize.new do |a|
      a.log = Logger.new("#{Rails.root}/log/downloader.log")
      a.user_agent_alias = "Linux Firefox"
      a.open_timeout = @options[:open_timeout]
      a.read_timeout = @options[:read_timeout]
      a.keep_alive = @options[:keep_alive]
      a.redirect_ok = @options[:redirect_ok]
    end
    @agent.pluggable_parser.default = Mechanize::Download
  end

  def fetch_category_urls
    page = @agent.get(BASE_URL)
    page.links_with(href: %r(#{BASE_URL}category\/\w+)).each do |link|
      @agent.log.info("CATEGORY #{link.href}")
      CategoryUrl.find_or_create_by!(
        href: link.href,
        fetchable: link.href !~ /.*?\/feed\/?$/
      )
    end
  end

  def fetch_book_urls(category_url)
    page = @agent.get(category_url)
    page.links_with(
      href: %r{http:\/\/basicbook\.net\/\d+\/[\w-]+\.html}
    ).each do |link|
      @agent.log.info("BOOK #{link.href}")
      BookUrl.find_or_create_by(
        href: link.href,
        fetchable: link.href !~ /\#\w+$/
      )
    end
  end

  def crawl!(book_url)
    image_regex = /http.*?([^\/]*\.jpg)$/i
    book = Book.find_or_initialize_by(book_url_id: book_url.id)
    page = @agent.get(book_url.href)
    book.name = page.at("//h1[@class='entry-title']").text
    page.at("//div[@class='entry entry-content']//a[starts-with(@rel, 'attachment wp-att')]/img").tap do |image|
      if image
        image_src = image.get_attribute(:src)
      else
        image_src = page.image_with(src: image_regex).try(:src)
      end
      book.image = image_src.gsub(image_regex, '\1') if image_src
    end
    book.timeStamp = page.at("//div[@class='entry-meta']//span[@class='meta-date']")
      .text.gsub(/on\s+/, "")
    content = page.search("//div[@class='entry entry-content']/*")
      .map(&:text).map(&:strip)
    delim_index = content.index { |c| c =~ /.*?download.*?/ }
    content = content.take(delim_index - 1) if delim_index
    book.description = content.find { |text| text.length > 200 }
    author_marker = content.index { |c| c =~ /^by\s{0,}/i }
    if author_marker && author_marker <= 1
      book.author = content.delete_at(author_marker).gsub(/^by\s{0,}/i, '')
    end
    if book.author.blank?
      maker = page.at("//div[@class='entry entry-content']/h2")
      while maker.next_sibling.content.strip.blank?
        maker = maker.next_sibling
      end
      if maker.next_sibling.name == "ul"
        book.author = maker.next_sibling.content.strip
      end
    end
    book.content = content.delete_if(&:blank?).join("\n")
    book.save
  rescue => e
    @agent.log.error(e)
    return
  end
end
