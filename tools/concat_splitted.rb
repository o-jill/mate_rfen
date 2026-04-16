# split/mateXX*.txt を concat/mateN.txt に連結する

FROM = 2
TO = 12

IN_DIR = "split"
OUT_DIR = "concat"


def input_pattern(index)
  format("mate%02d*.txt", index)
end

def output_path(index)
  File.join(OUT_DIR, "mate#{index}.txt")
end

start_time = Time.now

Dir.mkdir(OUT_DIR) unless Dir.exist?(OUT_DIR)

(FROM..TO).each do |index|
  pattern = File.join(IN_DIR, input_pattern(index))
  input_files = Dir.glob(pattern).sort
  output_file = output_path(index)

  File.delete(output_file) if File.exist?(output_file)

  puts "#{output_file}"
  next if input_files.empty?

  File.open(output_file, "w:UTF-8") do |out|
    input_files.each do |path|
      puts path
      File.foreach(path, mode: "r:UTF-8") do |line|
        out.write(line)
      end
    end
  end
end

elapsed_time = Time.now - start_time
puts "processing time: #{elapsed_time}"
