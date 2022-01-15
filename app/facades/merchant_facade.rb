class MerchantFacade
  def holidays
    service.next_holidays.map do |data|
      Holiday.new(data)
    end
  end

  def service
    HolidayService.new
  end
end
