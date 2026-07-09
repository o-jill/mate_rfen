# 2つの入力テキストファイルを結合し、大文字小文字を区別して重複行を削除し、
# ソートした結果を UTF-8 BOM なし・LF 改行で出力するスクリプトです。
input_path1, input_path2, output_path = ARGV

if [input_path1, input_path2, output_path].any?(&:nil?)
  warn "Usage: ruby tools/usu.rb INPUT1 INPUT2 OUTPUT"
  exit 1
end

unless File.file?(input_path1)
  warn "\"#{input_path1}\" does not exist!"
  exit 1
end

unless File.file?(input_path2)
  warn "\"#{input_path2}\" does not exist!"
  exit 1
end

WINDOWS_NEWLINE = "\n"

def read_lines(path)
  puts "reading #{path} ..."
  File.readlines(path, chomp: true, encoding: "UTF-8")
end

# 行を連結して出力しようとすると
# 扱えるバッファサイズを超えるので
# 少しずつ出力する
def write_utf8_no_bom(path, lines)
  File.delete(path) if File.exist?(path)

  # 10000行ずつファイルに出力
  lines.each_slice(10000) do |l|
    content = l.join(WINDOWS_NEWLINE)
    content += WINDOWS_NEWLINE

    File.open(path, "ab") do |f|
      f.write(content.encode("UTF-8"))
    end
  end

  # content = lines.join(WINDOWS_NEWLINE)
  # content += WINDOWS_NEWLINE unless lines.empty?
  # File.binwrite(path, content.encode("UTF-8"))
end

def write_utf8_no_bom_ikki(path, lines)
  # 全部結合
  content = lines.join(WINDOWS_NEWLINE)
  content += WINDOWS_NEWLINE unless lines.empty?
  # ファイルに出力
  File.binwrite(path, content.encode("UTF-8"))
end

start_time = Time.now

merged_lines = read_lines(input_path1) + read_lines(input_path2)

# write_utf8_no_bom(output_path, merged_lines)
puts "merged."

unique_sorted_lines = merged_lines.sort.uniq
write_utf8_no_bom(output_path, unique_sorted_lines)

puts "done."

end_time = Time.now
elapsed_time = end_time - start_time
puts "processing time: #{elapsed_time}"
