class CanadaComputersManufacturer < BaseManufacturer
  def url
    "https://www.canadacomputers.com/product_info.php?ajaxstock=true&itemid=#{code}"
  end

  def link_to_buy
    "https://www.canadacomputers.com/product_info.php?cPath=43_557_559&item_id=#{code}"
  end
end
