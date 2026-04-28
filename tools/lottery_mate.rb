#!/usr/bin/env ruby
#
# usage:
# ruby script.rb <path> <100.0%> <path>
#
# example:
# ruby script.rb sample.txt 3.14 output.txt

if ARGV.length != 3
  puts "Usage: ruby #{$0} <input file_path> <probability_percent> <output file_path>"
  exit 1
end

input_path = ARGV[0]
probability = ARGV[1].to_f / 100.0
output_path = ARGV[2]

unless File.exist?(input_path)
  puts "File not found: #{input_path}"
  exit 1
end

File.open(output_path, "w") do |out|
  File.foreach(input_path) do |line|
    out.print line if rand < probability
  end
end