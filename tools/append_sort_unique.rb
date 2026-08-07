#
# mate2.txtにmate2_validated.txtを追記。
# 中身をソートしてmate2_merged.txtに保存する。
#
# ex. ruby tools/append_sort_unique.rb validate07_5\mate2_validate.txt merged_new2\mate2_append.txt merged_new2\mate2_uniq.txt merged_new2\mate2.txt
#

inputpath, appendpath, uniqpath, mergedpath = ARGV

if [inputpath, appendpath, uniqpath, mergedpath].any?(&:nil?)
  warn "Usage: ruby tools/append_split_unique.rb INPUTFILE APPENDFILE UNIQFILE MERGEDFILE"
  exit 1
end

unless File.file?(inputpath)
  warn "\"#{inputpath}\" does not exist!"
  exit 1
end

unless File.file?(appendpath)
  warn "\"#{appendpath}\" does not exist!"
  exit 1
end

# append
puts "append #{inputpath} to #{appendpath}"
File.open(inputpath, mode: "r:BOM|UTF-8") do |fin|
  File.open(appendpath, "ab:UTF-8") do |fout|
    fin.each_line do |line|
      fout.write(line)
    end
  end
end

# sort /unique mate2_new.txt /O mate2_uniq.txt
puts "unique #{appendpath} to #{uniqpath}"
puts "C:\\Windows\\System32\\sort.exe sort /case /unique #{appendpath} /O #{uniqpath}"
`C:\\Windows\\System32\\sort.exe /case /unique #{appendpath} /O #{uniqpath}`


# crlf to lf
puts "CRLF(#{uniqpath}) to LF(#{mergedpath})"
File.open(uniqpath, mode: "r:BOM|UTF-8") do |fin|
  File.open(mergedpath, "ab:UTF-8") do |fout|
    fin.each_line do |line|
      fout.write(line)
    end
  end
end
