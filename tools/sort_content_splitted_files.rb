#
# ディレクトリ内のファイルを行ごとにソート
# 対象 "*.txt"
#

require 'fileutils'

# コマンドライン引数からフォルダパスを取得
target_dir = ARGV[0]

unless target_dir
  warn "usage:  ruby sort_content_splitted_files.rb DIRECTORY"
end

# 対象 "*.txt"
file_pattern = File.join(target_dir, '*.txt')

files = Dir.glob(file_pattern)

if files.empty?
  puts "対象となるテキストファイルが見つかりませんでした: #{target_dir}"
  exit
end

sz = files.size

files.each_with_index do |file_path, idx|
  next unless File.file?(file_path)

  puts "processing: #{file_path} #{idx}/#{sz}"

  # 文字コード順でソート
  sorted_lines = File.readlines(file_path, chomp: true).sort

  # 上書き保存
  File.open(file_path, 'wb:utf-8') do |file|
    # file.puts(sorted_lines)
    file.write(sorted_lines.join("\n") + "\n")
  end
end

puts "done."
