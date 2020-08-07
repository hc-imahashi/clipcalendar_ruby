require 'clip_calendar/date_format'
#require "clip_calendar/version"

module ClipCalendar

  class ArgumentNumberError < ArgumentError; end
  class ArgumentTypeError < ArgumentError; end

  class Core

    def initialize

      # 引数チェック
      raise ArgumentNumberError  unless  ARGV.count <= 2
      begin
        start_date= DateFormat.parse(ARGV[0] || Date.today.strftime('%Y-%m-%d'))
        end_date= DateFormat.parse(ARGV[1] || (start_date+5).strftime('%Y-%m-%d'))
        @dates= start_date..end_date
      rescue ArgumentError
        raise ArgumentTypeError
      end

    end

    def output
      @dates.map { |date| date.to_s }.join("\n")
    end

  end

end
