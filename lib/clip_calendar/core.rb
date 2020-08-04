require 'clip_calendar/date_format'
#require "clip_calendar/version"

module ClipCalendar

  class ArgumentNumberError < ArgumentError; end
  class ArgumentTypeError < ArgumentError; end

  class Core

    def initialize

      # 引数チェック
      raise ArgumentNumberError  unless ARGV.count == 2
      begin
        @dates= DateFormat.parse(ARGV[0])..DateFormat.parse(ARGV[1])
      rescue ArgumentError
        raise ArgumentTypeError
      end

    end

    def output
      @dates.map { |date| date.to_s }.join("\n")
    end

  end

end
