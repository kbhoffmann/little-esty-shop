require 'httparty'
require 'json'

class HolidayService

  def next_holidays
    response = HTTParty.get("https://date.nager.at/api/v2/NextPublicHolidays/us")
    parsed = JSON.parse(response.body, symbolize_names: true)
  end

end
