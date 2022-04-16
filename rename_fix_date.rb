require_relative 'lib/file_tools'

unless ARGV.length == 3
  puts "usage: ruby #{File.basename(__FILE__, '*.*')} YYYYMMDD HH target_dir"
  exit(2)
end

ymd = ARGV[0]
hour = ARGV[1].to_i

min = 0
sec = 0
Dir.glob(File.join(ARGV[2], '**', '*')) do |f|
  puts f

  new_fname = "#{ymd}#{format('%02d%02d%02d', hour, min, sec)}_#{File.basename(f)}"
  new_path = check_fname_overlapping(File.join(File.dirname(f), new_fname))
  puts "  move to:#{new_path}"
  FileUtils.mv(f, new_path)

  sec += 1
  if sec >= 60
    sec = 0
    min += 1
  end
end