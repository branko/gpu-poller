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

    num_by_store = scrape_item.scan(stock_number_regex).map do |markup|
      prefix_regex = /<span class=\"stocknumber\">/
      suffix_regex = /<\/span>/

      markup.gsub!(prefix_regex, '')
      markup.gsub!(suffix_regex, '')
    end.map(&:to_i)

    num_by_store.sum
  end

  def scrape_item
    url = "https://www.canadacomputers.com/product_info.php?cPath=24_311_1326&item_id=#{code}"

    HTTParty.get(url)
  end

  ONLINE_IN_STOCK = /Online In Stock/
    PICKUP_IN_STOCK = /Available In Stores/
    COMPONENT_CSS_CLASS = 'col-xl-3 col-lg-4 col-6 mt-0_5 px-0_5 toggleBox mb-1'
    # Only check first two pages
    PAGES = ['1', '2'].freeze

  def self.search_in_stock?(keywords: '3070')
    url = "https://www.canadacomputers.com/search/results_details.php?language=en&pr=%2524750%2B-%2B%2524999.99"

    PAGES.each do |page|
      response = HTTParty.get(url, body: {
        page_num: page,
        language: 'en',
        keywords: keywords,
        ajax: true,
      })

      body = response.body

      item_components = body.split(COMPONENT_CSS_CLASS)

      in_stock = item_components.any? do |listing|
        listing.match?(ONLINE_IN_STOCK) || listing.match?(PICKUP_IN_STOCK)
      end

      yield(keywords) if in_stock

      in_stock
    end
  end
end