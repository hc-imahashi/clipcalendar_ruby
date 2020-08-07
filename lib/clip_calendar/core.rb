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
        start_date_str= ARGV&.first || Date.today.strftime('%Y-%m-%d')
        start_date= DateFormat.parse(start_date_str)
        if ARGV.count > 1
          end_date= DateFormat.parse(ARGV[1])
        else
          end_date = start_date + 5
        end
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
