input_path, placeholder = ARGV

if [input_path, placeholder].any?(&:nil?)
  warn "Usage: ruby tools/split_by_leading_char.rb INPUT_FILE PLACEHOLDER"
  exit 1
end

unless File.file?(input_path)
  warn "\"#{input_path}\" does not exist!"
  exit 1
end

# 出力先ファイル名を組み立てる。
def output_path_for(placeholder, suffix)
  "#{placeholder}_#{suffix}.txt"
end

TABLE = [
  {pattern: "1a", name: "1a_"},
  {pattern: "1b", name: "1b_"},
  {pattern: "1c", name: "1c_"},
  {pattern: "1d", name: "1d_"},
  {pattern: "1e", name: "1e_"},
  {pattern: "1f", name: "1f_"},
  {pattern: "1g", name: "1g_"},
  {pattern: "1h", name: "1h_"},
  {pattern: "1A", name: "1A"},
  {pattern: "1B", name: "1B"},
  {pattern: "1C", name: "1C"},
  {pattern: "1D", name: "1D"},
  {pattern: "1E", name: "1E"},
  {pattern: "1F", name: "1F"},
  {pattern: "1G", name: "1G"},
  {pattern: "1H", name: "1H"},
  {pattern: "1", name: "1"},
  {pattern: "2a", name: "2a_"},
  {pattern: "2b", name: "2b_"},
  {pattern: "2c", name: "2c_"},
  {pattern: "2d", name: "2d_"},
  {pattern: "2e", name: "2e_"},
  {pattern: "2A", name: "2A"},
  {pattern: "2B", name: "2B"},
  {pattern: "2C", name: "2C"},
  {pattern: "2D", name: "2D"},
  {pattern: "2E", name: "2E"},
  {pattern: "2", name: "2"},
  {pattern: "3a", name: "3a_"},
  {pattern: "3A", name: "3A"},
  {pattern: "3", name: "3"},
  {pattern: "4", name: "4"},
  {pattern: "5", name: "5"},
  {pattern: "6", name: "6"},
  {pattern: "7", name: "7"},
  {pattern: "8", name: "8"},
  {pattern: "a1", name: "a1_"},
  {pattern: "a1a", name: "a_1a_"},
  {pattern: "a1A", name: "a1_A"},
  {pattern: "a2", name: "a2_"},
  {pattern: "a3", name: "a3_"},
  {pattern: "A1A", name: "A1A"},
  {pattern: "A1a", name: "A1a_"},
  {pattern: "A2", name: "A2"},
  {pattern: "A3", name: "A3"},
  {pattern: "AaA", name: "Aa_A"},
  {pattern: "aAa", name: "a_Aa_"},
  {pattern: "Aa1", name: "Aa_1"},
  {pattern: "aA1", name: "a_A1"},
  {pattern: "Aa", name: "Aa_"},
  {pattern: "aA", name: "a_A"},
  {pattern: "Aa1", name: "Aa1"},
  {pattern: "aA1", name: "aA_1"},
  {pattern: "AaA", name: "Aa_A"},
  {pattern: "aAa", name: "a_Aa_"},
  {pattern: "Ab", name: "Ab_"},
  {pattern: "AB", name: "AB"},
  {pattern: "aB", name: "a_B"},
  {pattern: "Ac", name: "Ac_"},
  {pattern: "aC", name: "a_C"},
  {pattern: "Ad", name: "Ad_"},
  {pattern: "aD", name: "a_D"},
  {pattern: "Ae", name: "Ae_"},
  {pattern: "aE", name: "a_E"},
  {pattern: "Af", name: "Af_"},
  {pattern: "aF", name: "a_F"},
  {pattern: "Ag1", name: "Ag_1"},
  {pattern: "aG1", name: "a_G1"},
  {pattern: "Ag1", name: "Ag_A"},
  {pattern: "aG1", name: "a_Ga_"},
  {pattern: "AgA", name: "Ag_A"},
  {pattern: "AgB", name: "Ag_B"},
  {pattern: "aGa", name: "a_Ga_"},
  {pattern: "aGb", name: "a_Gb_"},
  {pattern: "Ag", name: "Ag_"},
  {pattern: "aG", name: "a_G"},
  {pattern: "a", name: "a_"},
  {pattern: "A", name: "A"},
  {pattern: "B1", name: "B1"},
  {pattern: "b1", name: "b1_"},
  {pattern: "Ba", name: "Ba_"},
  {pattern: "bA", name: "b_A"},
  {pattern: "B", name: "B"},
  {pattern: "b", name: "b_"},
  {pattern: "C", name: "C"},
  {pattern: "c", name: "c_"},
  {pattern: "D", name: "D"},
  {pattern: "d", name: "d_"},
  {pattern: "E", name: "E"},
  {pattern: "e", name: "e_"},
  {pattern: "F1", name: "F1"},
  {pattern: "f1", name: "f_1"},
  {pattern: "Fa", name: "Fa_"},
  {pattern: "fA", name: "f_A"},
  {pattern: "F", name: "F"},
  {pattern: "f", name: "f_"},
  {pattern: "G1a", name: "G1a_"},
  {pattern: "g1a", name: "g1_a_"},
  {pattern: "G1A", name: "G1A"},
  {pattern: "g1A", name: "g1_A"},
  {pattern: "G1", name: "G1"},
  {pattern: "g1", name: "g1_"},
  {pattern: "Ga1", name: "Ga_1"},
  {pattern: "gA1", name: "g_A1"},
  {pattern: "GaA", name: "Ga_A"},
  {pattern: "gAa", name: "g_Aa_"},
  {pattern: "GaB", name: "Ga_B"},
  {pattern: "gAb", name: "g_Ab_"},
  {pattern: "Ga", name: "Ga_"},
  {pattern: "gA", name: "g_A"},
  {pattern: "G", name: "G"},
  {pattern: "g", name: "g_"},
  {pattern: "h1", name: "h_1"},
  {pattern: "H1", name: "H1"},
  {pattern: "h2", name: "h_2"},
  {pattern: "H2", name: "H2"},
  {pattern: "hA", name: "h_A"},
  {pattern: "Ha", name: "Ha_"},
  {pattern: "H", name: "H"},
  {pattern: "h", name: "h_"},
  {pattern: "I1", name: "I1"},
  {pattern: "i1", name: "i_1"},
  {pattern: "I2", name: "I2"},
  {pattern: "i2", name: "i_2"},
  {pattern: "Ia", name: "Ia_"},
  {pattern: "iA", name: "i_A"},
  {pattern: "Ib", name: "Ib_"},
  {pattern: "iB", name: "i_B"},
  {pattern: "I", name: "I"},
  {pattern: "i", name: "i_"},
  {pattern: "J1", name: "J1"},
  {pattern: "j1", name: "j_1"},
  {pattern: "J2", name: "J2"},
  {pattern: "j2", name: "j_2"},
  {pattern: "Ja", name: "Ja_"},
  {pattern: "jA", name: "j_A"},
  {pattern: "Jb", name: "Jb_"},
  {pattern: "jB", name: "j_B"},
  {pattern: "J", name: "J"},
  {pattern: "j", name: "j_"},
  {pattern: "K", name: "K"},
  {pattern: "k", name: "k_"},
  {pattern: "L", name: "L"},
  {pattern: "l", name: "l_"},
  {pattern: "M", name: "M"},
  {pattern: "m", name: "m_"},
  {pattern: "N", name: "N"},
  {pattern: "n", name: "n_"},
  {pattern: "O", name: "O"},
  {pattern: "o", name: "o_"},
  {pattern: "Z", name: "Z"},
  {pattern: "z", name: "z_"},
].freeze

  # 1行の先頭文字から振り分け先のキーを決める。
def bucket_name_for(line)
  first_char = line[0]
  TABLE.each do |elem|
    return elem[:name] if line.start_with?(elem[:pattern])
  end

  return "others" if first_char.nil?

  return first_char if first_char.match?(/[0-9A-Za-z]/)

  "others"
end

# 振り分け先ごとの出力ファイルハンドルを保持する。
handles = {}

def save_line_by_line(input_path, placeholder)
  begin
    # 入力を1行ずつ読み込み、対応するファイルへそのまま書き出す。
    File.foreach(input_path, mode: "r:BOM|UTF-8") do |line|
      bucket = bucket_name_for(line)
      handles[bucket] ||= File.open(output_path_for(placeholder, bucket), "a:UTF-8")
      handles[bucket].write(line)
    end
  ensure
    # 途中で例外が出ても、開いたファイルはすべて閉じる。
    handles.each_value(&:close)
  end
end

def save_lines_once(input_path, placeholder)
  res = []

  data = File.open(input_path, mode: "r:BOM|UTF-8").readlines()
  TABLE.each do |ptn|
    filtered, remain = data.partition do |l|
      l.start_with?(ptn[:pattern])
    end

    data = remain

    unless filtered.empty? then
      File.open(output_path_for(placeholder, ptn[:name]), "a:UTF-8")
        .write(filtered.join())
    end
  end

  unless data.empty? then
    File.open(output_path_for(placeholder, "others"), "a:UTF-8")
      .write(data.join())
  end
end

start_time = Time.now

# save_line_by_line(input_path, placeholder)
save_lines_once(input_path, placeholder)

end_time = Time.now
elapsed_time = end_time - start_time
puts "processing time: #{elapsed_time}"
