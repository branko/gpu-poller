class BaseManufacturer
  attr_reader :code, :name, :price, :link
  def initialize(code, name, price, link=nil)
    @code = code
    @name = name
    @price = price
    @link = link
  end

  def url
    raise NotImplementedError, "Implement in subclass"
  end

  def link_to_buy
    return link if link
    raise NotImplementedError, "Implement in subclass"
  end
end
