class BookUrl < Url
  attr_accessor :crawler
  has_one :book

  def crawler
    @crawler ||= Crawler.new
  end

  def scrap_content!
    crawler.crawl!(self)
  end
end
