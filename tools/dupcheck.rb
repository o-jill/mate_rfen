#
# 同じ局面を二重登録してないかチェックする
#

input_path, output_wrong, output_correct = ARGV

unless input_path
  warn "Usage: ruby tools/usu.rb INPUT OUTPUT_WRONG OUTPUT_CORRECT"
  exit 1
end

unless File.file?(input_path)
  warn "\"#{input_path}\" does not exist!"
  exit 1
end

old = ""
oldbody = ""
duplicated = false;
count = 0;

File.foreach(input_path, mode: "r:BOM|UTF-8") do |line|
  rfen, score = line.split(',')

  if rfen == oldbody
    puts "duplicated:"
    puts "#{old}"
    puts "#{line}"
    duplicated = true

    count = count + 1

    File.open(output_wrong, "a:UTF-8").write("#{old}#{line}") if output_wrong

    next
  end

  if old.chomp.empty?
    old = line
    oldbody = rfen

    next
  end

  File.open(output_correct, "ab:UTF-8").write("#{old}") if output_correct && not duplicated

  old = line
  oldbody = rfen
  duplicated = false
end

File.open(output_correct, "ab:UTF-8").write("#{old}") if output_correct && not duplicated

puts "# of dup.: #{count}"
