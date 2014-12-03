class BookUrl < Url
  CRAWLER = Crawler.new
  attr_accessor :crawler
  has_one :book

  def crawler
    @crawler ||= Crawler.new
  end

  def scrap_content!
    CRAWLER.crawl!(self)
  end
end
