namespace :crawler do
  namespace :fetch_urls do
    task category: :environment do
      Crawler.new.fetch_category_urls
    end

    task book: :environment do
      @crawler = Crawler.new
      CategoryUrl.where(fetchable: true).each do |curl|
        @crawler.fetch_book_urls(curl.href)
      end
    end
  end
  task scrap_content: :environment do
    BookUrl.where(fetchable: true).each do |burl|
      burl.delay.scrap_content!
    end
  end
end
