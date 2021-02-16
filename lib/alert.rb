class Alert
  class << self
    COLOR_MAP = {
      info: :green,
      warn: :yellow,
      error: :red,
    }

    COLOR_MAP.keys.each do |mname|
      define_method(mname) do |msg|
        puts Paint[msg, COLOR_MAP[mname]]
      end
    end
  end
end
