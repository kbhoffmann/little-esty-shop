class Holiday
  attr_reader :date, :localName, :name

  def initialize(data)
    @date = data[:date]
    @name = data[:name]
  end
end
