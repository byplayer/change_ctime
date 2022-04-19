# frozen_string_literal: true

require_relative 'lib/file_tools'

Dir.glob(File.join(ARGV[0], '**', '*')) do |f|
  puts f
  basename = File.basename(f)
  puts basename
  next unless basename =~
              /^([0-9]{4})-?([0-9]{2})-?([0-9]{2})[-_]?([0-9]{2})([0-9]{2})([0-9]{2})/

  file_time = Time.strptime(Regexp.last_match[1] +
                            Regexp.last_match[2] +
                            Regexp.last_match[3] + ' ' +
                            Regexp.last_match[4] +
                            Regexp.last_match[5] +
                            Regexp.last_match[6],
                            '%Y%m%d %H%M%S')
  puts file_time
  change_ctime(f, file_time)
end
