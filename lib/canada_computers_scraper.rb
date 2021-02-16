class CanadaComputersScraper
  attr_reader :code

  def initialize(code)
    # Code represents Canada Computer's internal canonical id
    @code = code
  end

  def in_stock_by_scraping?
    total_in_stock_by_scraping > 0
  end

  private

  def total_in_stock_by_scraping
    stock_number_regex = /<span class="stocknumber">.<\/span>/

    num_by_store = scrape.scan(stock_number_regex).map do |markup|
      prefix_regex = /<span class=\"stocknumber\">/
      suffix_regex = /<\/span>/

      markup.gsub!(prefix_regex, '')
      markup.gsub!(suffix_regex, '')
    end.map(&:to_i)

    num_by_store.sum
  end

  def scrape
    url = "https://www.canadacomputers.com/product_info.php?cPath=24_311_1326&item_id=#{code}"

    HTTParty.get(url)
  end
end