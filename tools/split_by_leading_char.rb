# example:
# ruby split_by_leading_char.rb mateXX.txt splitYY\mateXX_

# arguments
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
  {pattern: "1a1", name: "1a_1"},
  {pattern: "1aA", name: "1a_A"},
  {pattern: "1a", name: "1a_"},
  {pattern: "1b", name: "1b_"},
  {pattern: "1c", name: "1c_"},
  {pattern: "1d", name: "1d_"},
  {pattern: "1e", name: "1e_"},
  {pattern: "1f1", name: "1f_1"},
  {pattern: "1fA", name: "1f_A"},
  {pattern: "1f", name: "1f_"},
  {pattern: "1g1", name: "1g_1"},
  {pattern: "1gA", name: "1g_A"},
  {pattern: "1ga", name: "1g_a_"},
  {pattern: "1g", name: "1g_"},
  {pattern: "1h", name: "1h_"},
  {pattern: "1i", name: "1i_"},
  {pattern: "1j", name: "1j_"},
  {pattern: "1A1", name: "1A1"},
  {pattern: "1Aa", name: "1Aa_"},
  {pattern: "1A", name: "1A"},
  {pattern: "1B", name: "1B"},
  {pattern: "1C", name: "1C"},
  {pattern: "1D", name: "1D"},
  {pattern: "1E", name: "1E"},
  {pattern: "1F1", name: "1F1"},
  {pattern: "1FA", name: "1Fa_"},
  {pattern: "1F", name: "1F"},
  {pattern: "1G1", name: "1G1"},
  {pattern: "1GA", name: "1GA"},
  {pattern: "1Ga", name: "1Ga_"},
  {pattern: "1G", name: "1G"},
  {pattern: "1H", name: "1H"},
  {pattern: "1I", name: "1I"},
  {pattern: "1J", name: "1J"},
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

  {pattern: "a1a", name: "a_1a_"},
  {pattern: "a1A", name: "a_1A"},
  {pattern: "a1b", name: "a_1b_"},
  {pattern: "a1B", name: "a_1B"},
  {pattern: "a1c", name: "a_1c_"},
  {pattern: "a1C", name: "a_1C"},
  {pattern: "a1d", name: "a_1d_"},
  {pattern: "a1D", name: "a_1D"},
  {pattern: "a1e", name: "a_1e_"},
  {pattern: "a1E", name: "a_1E"},
  {pattern: "A1A", name: "A1A"},
  {pattern: "A1a", name: "A1a_"},
  {pattern: "A1B", name: "A1B"},
  {pattern: "A1b", name: "A1b_"},
  {pattern: "A1C", name: "A1C"},
  {pattern: "A1c", name: "A1c_"},
  {pattern: "A1D", name: "A1D"},
  {pattern: "A1d", name: "A1d_"},
  {pattern: "A1E", name: "A1E"},
  {pattern: "A1e", name: "A1e_"},
  {pattern: "a1", name: "a_1"},
  {pattern: "A1", name: "A1"},
  {pattern: "a2", name: "a_2"},
  {pattern: "A2", name: "A2"},
  {pattern: "a3", name: "a_3"},
  {pattern: "A3", name: "A3"},
  {pattern: "Aa1", name: "Aa_1"},
  {pattern: "aA1", name: "a_A1"},
  {pattern: "Aa2", name: "Aa_2"},
  {pattern: "aA2", name: "a_A2"},
  {pattern: "Aa3", name: "Aa_3"},
  {pattern: "aA3", name: "a_A3"},
  {pattern: "Aa4", name: "Aa_4"},
  {pattern: "aA4", name: "a_A4"},
  {pattern: "Aa5", name: "Aa_5"},
  {pattern: "aA5", name: "a_A5"},
  {pattern: "AaA", name: "Aa_A"},
  {pattern: "aAa", name: "a_Aa_"},
  {pattern: "AaB", name: "Aa_B"},
  {pattern: "aAb", name: "a_Ab_"},
  {pattern: "AaC", name: "Aa_C"},
  {pattern: "aAc", name: "a_Ac_"},
  {pattern: "AaD", name: "Aa_D"},
  {pattern: "aAd", name: "a_Ad_"},
  {pattern: "AaE", name: "Aa_E"},
  {pattern: "aAe", name: "a_Ae_"},
  {pattern: "AaF", name: "Aa_F"},
  {pattern: "aAf", name: "a_Af_"},
  {pattern: "AaG", name: "Aa_G"},
  {pattern: "aAg", name: "a_Ag_"},
  {pattern: "Aa", name: "Aa_"},
  {pattern: "aA", name: "a_A"},
  {pattern: "Ab1", name: "Ab_1"},
  {pattern: "aB1", name: "a_B1"},
  {pattern: "AbA", name: "Ab_A"},
  {pattern: "aBa", name: "a_Ba_"},
  {pattern: "Ab", name: "Ab_"},
  {pattern: "aB", name: "a_B"},
  {pattern: "Ac", name: "Ac_"},
  {pattern: "aC", name: "a_C"},
  {pattern: "Ad", name: "Ad_"},
  {pattern: "aD", name: "a_D"},
  {pattern: "Ae", name: "Ae_"},
  {pattern: "aE", name: "a_E"},
  {pattern: "Af1", name: "Af_1"},
  {pattern: "aF1", name: "a_F1"},
  {pattern: "AfA", name: "Af_A"},
  {pattern: "aFa", name: "a_Fa_"},
  {pattern: "AfB", name: "Af_B"},
  {pattern: "aFb", name: "a_Fb_"},
  {pattern: "Af", name: "Af_"},
  {pattern: "aF", name: "a_F"},
  {pattern: "Ag1", name: "Ag_1"},
  {pattern: "aG1", name: "a_G1"},
  {pattern: "Ag1", name: "Ag_A"},
  {pattern: "aG1", name: "a_Ga_"},
  {pattern: "AgA1", name: "Ag_A1"},
  {pattern: "AgAa", name: "Ag_Aa_"},
  {pattern: "AgAb", name: "Ag_Ab_"},
  {pattern: "AgAc", name: "Ag_Ac_"},
  {pattern: "AgAd", name: "Ag_Ad_"},
  {pattern: "AgA", name: "Ag_A"},
  {pattern: "AgBa", name: "Ag_Ba_"},
  {pattern: "AgBb", name: "Ag_Bb_"},
  {pattern: "AgB", name: "Ag_B"},
  {pattern: "AgC", name: "Ag_C"},
  {pattern: "AgD", name: "Ag_D"},
  {pattern: "aGa1", name: "a_Ga_1"},
  {pattern: "aGaA", name: "a_Ga_A"},
  {pattern: "aGaB", name: "a_Ga_B"},
  {pattern: "aGaC", name: "a_Ga_C"},
  {pattern: "aGaD", name: "a_Ga_D"},
  {pattern: "aGaE", name: "a_Ga_E"},
  {pattern: "aGa", name: "a_Ga_"},
  {pattern: "aGbA", name: "a_Gb_A"},
  {pattern: "aGbB", name: "a_Gb_B"},
  {pattern: "aGb", name: "a_Gb_"},
  {pattern: "aGc", name: "a_Gc_"},
  {pattern: "aGd", name: "a_Gd_"},
  {pattern: "aGe", name: "a_Ge_"},
  {pattern: "Ag", name: "Ag_"},
  {pattern: "aG", name: "a_G"},
  {pattern: "Ah", name: "Ah_"},
  {pattern: "aH", name: "a_H"},
  {pattern: "Aj", name: "Aj_"},
  {pattern: "aJ", name: "a_J"},
  {pattern: "a", name: "a_"},
  {pattern: "A", name: "A"},

  {pattern: "B1", name: "B1"},
  {pattern: "b1", name: "b_1"},
  {pattern: "Ba", name: "Ba_"},
  {pattern: "bA", name: "b_A"},
  {pattern: "Bb", name: "Bb_"},
  {pattern: "bB", name: "b_B"},
  {pattern: "Bd", name: "Bd_"},
  {pattern: "bD", name: "b_D"},
  {pattern: "Bf", name: "Bf_"},
  {pattern: "bF", name: "b_F"},
  {pattern: "B", name: "B"},
  {pattern: "b", name: "b_"},

  {pattern: "C1", name: "C1"},
  {pattern: "c1", name: "c_1"},
  {pattern: "C2", name: "C2"},
  {pattern: "c2", name: "c_2"},
  {pattern: "Ca", name: "Ca_"},
  {pattern: "cA", name: "c_A"},
  {pattern: "Cb", name: "Cb_"},
  {pattern: "cB", name: "c_B"},
  {pattern: "Ce", name: "Ce_"},
  {pattern: "cE", name: "c_E"},
  {pattern: "C", name: "C"},
  {pattern: "c", name: "c_"},

  {pattern: "D1", name: "D1"},
  {pattern: "d1", name: "d_1"},
  {pattern: "D2", name: "D2"},
  {pattern: "d2", name: "d_2"},
  {pattern: "Da", name: "Da_"},
  {pattern: "dA", name: "d_A"},
  {pattern: "Db", name: "Db_"},
  {pattern: "dB", name: "d_B"},
  {pattern: "Dd", name: "Dd_"},
  {pattern: "dD", name: "d_D"},
  {pattern: "D", name: "D"},
  {pattern: "d", name: "d_"},

  {pattern: "E1", name: "E1"},
  {pattern: "e1", name: "e_1"},
  {pattern: "Ea", name: "Ea_"},
  {pattern: "eA", name: "e_A"},
  {pattern: "Ec", name: "Ec_"},
  {pattern: "eC", name: "e_C"},
  {pattern: "E", name: "E"},
  {pattern: "e", name: "e_"},

  {pattern: "F1", name: "F1"},
  {pattern: "f1", name: "f_1"},
  {pattern: "F2", name: "F2"},
  {pattern: "f2", name: "f_2"},
  {pattern: "Fa1", name: "Fa_1"},
  {pattern: "fA1", name: "f_A1"},
  {pattern: "FaA", name: "Fa_A"},
  {pattern: "fAa", name: "f_Aa_"},
  {pattern: "FaB", name: "Fa_B"},
  {pattern: "fAb", name: "f_Ab_"},
  {pattern: "Fa", name: "Fa_"},
  {pattern: "fA", name: "f_A"},
  {pattern: "Fb1", name: "Fb_1"},
  {pattern: "fB1", name: "f_B1"},
  {pattern: "FbA", name: "Fb_A"},
  {pattern: "fBa", name: "f_Ba_"},
  {pattern: "Fb", name: "Fb_"},
  {pattern: "fB", name: "f_B"},
  {pattern: "F", name: "F"},
  {pattern: "f", name: "f_"},

  {pattern: "G1a", name: "G1a_"},
  {pattern: "g1a", name: "g_1a_"},
  {pattern: "G1A", name: "G1A"},
  {pattern: "g1A", name: "g_1A"},
  {pattern: "G1b", name: "G1b_"},
  {pattern: "g1b", name: "g_1b_"},
  {pattern: "G1B", name: "G1B"},
  {pattern: "g1B", name: "g_1B"},
  {pattern: "G1e", name: "G1e_"},
  {pattern: "g1e", name: "g_1e_"},
  {pattern: "G1E", name: "G1E"},
  {pattern: "g1E", name: "g_1E"},
  {pattern: "G1g", name: "G1g_"},
  {pattern: "g1g", name: "g_1g_"},
  {pattern: "G1G", name: "G1G"},
  {pattern: "g1G", name: "g_1G"},
  {pattern: "G1", name: "G1"},
  {pattern: "g1", name: "g_1"},
  {pattern: "G2", name: "G2"},
  {pattern: "g2", name: "g_2"},
  {pattern: "Ga1", name: "Ga_1"},
  {pattern: "gA1", name: "g_A1"},
  {pattern: "GaA1", name: "Ga_A1"},
  {pattern: "gAa1", name: "g_Aa_1"},
  {pattern: "GaAa", name: "Ga_Aa_"},
  {pattern: "gAaA", name: "g_Aa_A"},
  {pattern: "GaAb", name: "Ga_Ab_"},
  {pattern: "gAaB", name: "g_Aa_B"},
  {pattern: "GaA", name: "Ga_A"},
  {pattern: "gAa", name: "g_Aa_"},
  {pattern: "GaBa", name: "Ga_Ba_"},
  {pattern: "gAbA", name: "g_Ab_A"},
  {pattern: "GaBb", name: "Ga_Bb_"},
  {pattern: "gAbB", name: "g_Ab_B"},
  {pattern: "GaB", name: "Ga_B"},
  {pattern: "gAb", name: "g_Ab_"},
  {pattern: "GaC", name: "Ga_C"},
  {pattern: "gAc", name: "g_Ac_"},
  {pattern: "GaD", name: "Ga_D"},
  {pattern: "gAd", name: "g_Ad_"},
  {pattern: "GaF", name: "Ga_F"},
  {pattern: "gAf", name: "g_Af_"},
  {pattern: "Ga", name: "Ga_"},
  {pattern: "gA", name: "g_A"},
  {pattern: "Gb1", name: "Gb_1"},
  {pattern: "gB1", name: "g_B1"},
  {pattern: "GbA", name: "Gb_A"},
  {pattern: "gBa", name: "g_Ba_"},
  {pattern: "Gb", name: "Gb_"},
  {pattern: "gB", name: "g_B"},
  {pattern: "Gc", name: "Gc_"},
  {pattern: "gC", name: "g_C"},
  {pattern: "Gd", name: "Gd_"},
  {pattern: "gD", name: "g_D"},
  {pattern: "G", name: "G"},
  {pattern: "g", name: "g_"},

  {pattern: "h1a", name: "h_1a_"},
  {pattern: "H1a", name: "H1a_"},
  {pattern: "h1A", name: "h_1A"},
  {pattern: "H1A", name: "H1A"},
  {pattern: "h1", name: "h_1"},
  {pattern: "H1", name: "H1"},
  {pattern: "h2", name: "h_2"},
  {pattern: "H2", name: "H2"},
  {pattern: "hA1", name: "h_A1"},
  {pattern: "Ha1", name: "Ha_1"},
  {pattern: "HaAa", name: "Ha_Aa_"},
  {pattern: "hAaA", name: "h_Aa_A"},
  {pattern: "HaAb", name: "Ha_Ab_"},
  {pattern: "hAaB", name: "h_Aa_B"},
  {pattern: "HaAc", name: "Ha_Ac_"},
  {pattern: "hAaC", name: "h_Aa_C"},
  {pattern: "HaA", name: "Ha_A"},
  {pattern: "hAa", name: "h_Aa_"},
  {pattern: "HaB", name: "Ha_B"},
  {pattern: "hAb", name: "h_Ab_"},
  {pattern: "Ha", name: "Ha_"},
  {pattern: "hA", name: "h_A"},
  {pattern: "hB", name: "h_B"},
  {pattern: "Hb", name: "Hb_"},
  {pattern: "hC", name: "h_C"},
  {pattern: "Hc", name: "Hc_"},
  {pattern: "hD", name: "h_D"},
  {pattern: "Hd", name: "Hd_"},
  {pattern: "hE", name: "h_E"},
  {pattern: "He", name: "He_"},
  {pattern: "hFa", name: "h_Fa_"},
  {pattern: "HfA", name: "Hf_A"},
  {pattern: "hF", name: "h_F"},
  {pattern: "Hf", name: "Hf_"},
  {pattern: "H", name: "H"},
  {pattern: "h", name: "h_"},

  {pattern: "I1", name: "I1"},
  {pattern: "i1", name: "i_1"},
  {pattern: "I2", name: "I2"},
  {pattern: "i2", name: "i_2"},
  {pattern: "Ia", name: "Ia_"},
  {pattern: "iA", name: "i_A"},
  {pattern: "IbA", name: "Ib_A"},
  {pattern: "iBa", name: "i_Ba_"},
  {pattern: "Ib", name: "Ib_"},
  {pattern: "iB", name: "i_B"},
  {pattern: "Ic", name: "Ic_"},
  {pattern: "iC", name: "i_C"},
  {pattern: "Id", name: "Id_"},
  {pattern: "iD", name: "i_D"},
  {pattern: "Ie", name: "Ie_"},
  {pattern: "iE", name: "i_E"},
  {pattern: "I", name: "I"},
  {pattern: "i", name: "i_"},

  {pattern: "J1", name: "J1"},
  {pattern: "j1", name: "j_1"},
  {pattern: "J2", name: "J2"},
  {pattern: "j2", name: "j_2"},
  {pattern: "JaA", name: "Ja_A"},
  {pattern: "jAa", name: "j_Aa_"},
  {pattern: "Ja", name: "Ja_"},
  {pattern: "jA", name: "j_A"},
  {pattern: "Jb", name: "Jb_"},
  {pattern: "jB", name: "j_B"},
  {pattern: "Jc", name: "Jc_"},
  {pattern: "jC", name: "j_C"},
  {pattern: "JdA", name: "Jd_A"},
  {pattern: "jDa", name: "j_Da_"},
  {pattern: "Jd1", name: "Jd_1"},
  {pattern: "jD1", name: "j_D1"},
  {pattern: "JdC", name: "Jd_C"},
  {pattern: "jDc", name: "j_Dc_"},
  {pattern: "Jd", name: "Jd_"},
  {pattern: "jD", name: "j_D"},
  {pattern: "Je", name: "Je_"},
  {pattern: "jE", name: "j_E"},
  {pattern: "J", name: "J"},
  {pattern: "j", name: "j_"},

  {pattern: "Ka", name: "Ka_"},
  {pattern: "kA", name: "k_A"},
  {pattern: "K", name: "K"},
  {pattern: "k", name: "k_"},

  {pattern: "L", name: "L"},
  {pattern: "l", name: "l_"},
  {pattern: "Ma", name: "Ma_"},
  {pattern: "mA", name: "m_A"},
  {pattern: "M", name: "M"},
  {pattern: "m", name: "m_"},
  {pattern: "N", name: "N"},
  {pattern: "n", name: "n_"},
  {pattern: "O", name: "O"},
  {pattern: "o", name: "o_"},
  {pattern: "P", name: "P"},
  {pattern: "p", name: "p_"},
  {pattern: "Q", name: "Q"},
  {pattern: "q", name: "q_"},
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
