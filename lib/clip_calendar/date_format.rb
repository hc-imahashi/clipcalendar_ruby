require 'date'
require "clip_calendar/version"

module ClipCalendar

  class DateFormat < Date

    def self.parse(str)
      # 年付きでparse
      begin
        strptime(str, format = '%Y-%m-%d')
      rescue ArgumentError
      #だめだったら今年でparse
        strptime(str, format = '%m-%d')
      end
    end

    def to_s
      dw = ["日", "月", "火", "水", "木", "金", "土"]
      self.strftime("%Y/%m/%d(#{dw[wday]})")
    end

  end

end
