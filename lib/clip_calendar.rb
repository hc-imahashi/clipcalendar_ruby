require "clip_calendar/version"
require 'clipboard'
require 'clip_calendar/core'

module ClipCalendar

  begin
    clip_calendar= ClipCalendar::Core.new
  rescue ArgumentNumberError
    puts "### Wrong numbers of input (expected: 2, actual: #{ARGV.count})"
    exit (1)
  rescue ArgumentTypeError
    puts '### invalid argment type: '
    exit (1)
  end

  Clipboard.copy clip_calendar.output

end
