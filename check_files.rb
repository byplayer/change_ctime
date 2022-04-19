# frozen_string_literal: true

require_relative 'lib/file_tools'

unless ARGV.length == 1
  puts "usage: ruby #{File.basename(__FILE__, '*.*')} target_dir"
  exit(2)
end

files = []

Dir.glob(File.join(ARGV[0], '**', '*')) do |f|
  files << f
end

files.sort!

files.each do |f|
  next unless File.file?(f)
  basename = File.basename(f)
  if basename =~
    /^(2[0-9]{3})[-_]?([0-9]{2})[-_]?([0-9]{2})[-_\.]?([0-9]{6})/
  elsif basename =~  /^Screenshot[ _]([0-9]{4})-([0-9]{2})-([0-9]{2})[ -]([0-9]{2})-([0-9]{2})-([0-9]{2})/
  elsif basename =~
              /^(2[0-9]{3})[-_]?([0-9]{2})[-_]?([0-9]{2})[-_]?(.*)([-_]?[0-9]*)?/
  else
    puts "error:#{f}"
  end
end