require 'clip_calendar/date_format'
#require "clip_calendar/version"

module ClipCalendar

  class ArgumentNumberError < ArgumentError; end
  class ArgumentTypeError < ArgumentError; end

  class Core

    def initialize

      argument_index =0
      if ARGV[0] == '-f'
        @output_format_str = ARGV[1]
        raise ArgumentNumberError if @output_format_str.nil?
        argument_index= 2
      end

      begin
        start_date= DateFormat.parse(ARGV[argument_index] || Date.today.strftime('%Y-%m-%d'))
        end_date= DateFormat.parse(ARGV[argument_index+1] || (start_date+5).strftime('%Y-%m-%d'))
        @dates= start_date..end_date
      rescue ArgumentError
        raise ArgumentTypeError
      end
      raise ArgumentNumberError unless ARGV[argument_index+2].nil?

    end

    def output
      @dates.map { |date| date.to_s(@output_format_str) }.join("\n")
    end

  end

end
