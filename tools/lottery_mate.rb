#!/usr/bin/env ruby
#
# usage:
# ruby lottery_mate.rb <path> <100.0%> <path>
#
# example:
# ruby lottery_mate.rb sample.txt 3.14 output.txt

if ARGV.length != 3
  warn "Usage: ruby #{$0} <input file_path> <probability_percent> <output file_path>"
  exit 1
end

input_path = ARGV[0]
probability = ARGV[1].to_f / 100.0
output_path = ARGV[2]

unless File.exist?(input_path)
  warn "File not found: #{input_path}"
  exit 1
end

# ファイルからprobabilityで設定された確率で行を抽出してファイルに出力
def draw_lines
  File.open(output_path, "wb") do |out|
    File.foreach(input_path) do |line|
      out.print line if rand < probability
    end
  end
end

# ファイルからprobabilityで設定された確率と評価値から
# 抽出確率を決めて行を抽出してファイルに出力
# 差が開いた棋譜が多め
# 0->0.1, 1->1.1, 2->log2(3)+0.1, 64->log2(65)+0.1
def draw_lines_depth_adaptive
  File.open(output_path, "wb") do |out|
    File.foreach(input_path) do |line|
      m = /,-?([0-9.]+)/.match(line)
      continue unless m  # 末尾に評価値がない

      # 0->0.1, 1->1.1, 2->log2(3)+0.1, 64->log2(65)+0.1
      corrected_probability = probability / (Math.log2(m[1].to_f + 1) + 0.1)

      out.print line if rand < corrected_probability
    end
  end
end

draw_lines()
# draw_lines_depth_adaptive()
