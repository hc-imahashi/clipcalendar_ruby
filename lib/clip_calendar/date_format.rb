require 'date'
require "clip_calendar/version"

module ClipCalendar

  class DateFormat < Date

    def to_s
      dw = ["日", "月", "火", "水", "木", "金", "土"]
      self.strftime("%Y/%m/%d(#{dw[wday]})")
    end

  end

end
