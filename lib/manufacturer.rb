class Manufacturer
  attr_reader :code, :name, :price
  def initialize(code, name, price)
    @code = code
    @name = name
    @price = price
  end

  def url
    "https://www.canadacomputers.com/product_info.php?ajaxstock=true&itemid=#{code}"
  end

  def link_to_buy
    "https://www.canadacomputers.com/product_info.php?cPath=43_557_559&item_id=#{code}"
  end
end
