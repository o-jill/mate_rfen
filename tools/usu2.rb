# 2つの入力テキストファイルを結合し、大文字小文字を区別して重複行を削除し、
# ソートした結果を UTF-8 BOM なし・LF 改行で出力するスクリプトです。

if ARGV.length != 3
  puts "使用方法: ruby merge_files.rb <入力ファイル1> <入力ファイル2> <出力ファイル>"
  exit 1
end

file1_path, file2_path, output_path = ARGV

# 進捗トラッキング機能付きの行リーダー
class FastLineReader
  attr_reader :read_bytes

  def initialize(file_path, buffer_size = 40 * 1024 * 1024, &on_progress) # 40MBバッファ
    @file = File.open(file_path, "r:UTF-8")
    @buffer_size = buffer_size
    @buffer = ""
    @lines = []
    @eof = false
    @read_bytes = 0
    @on_progress = on_progress
    # puts("opened #{file_path}.")
  end

  def next_line
    fill_buffer if @lines.empty? && !@eof
    @lines.shift
  end

  def close
    @file.close
  end

  private

  def fill_buffer
    chunk = @file.read(@buffer_size)
    if chunk.nil?
      @eof = true
      return
    end

    # 読み込んだバイト数を加算
    @read_bytes += chunk.bytesize
    # コールバック関数が設定されていれば進捗を通知
    @on_progress.call(@read_bytes) if @on_progress

    @buffer << chunk
    last_newline = @buffer.rindex("\n")

    if last_newline
      ready_text = @buffer[0..last_newline]
      @buffer = @buffer[(last_newline + 1)..-1] || ""
      @lines = ready_text.split("\n", -1)
      @lines.pop if @lines.last == ""
    elsif @file.eof?
      @lines = @buffer.split("\n", -1)
      @buffer = ""
      @eof = true
    end
  end
end

# バイト数をMB単位などの読みやすい形式に変換するヘルパー関数
def format_bytes(bytes)
  if bytes >= 1024 * 1024 * 1024
    format("%.2f GB", bytes.to_f / (1024 * 1024 * 1024))
  elsif bytes >= 1024 * 1024
    format("%.2f MB", bytes.to_f / (1024 * 1024))
  elsif bytes >= 1024
    format("%.2f KB", bytes.to_f / 1024)
  else
    "#{bytes} B"
  end
end

begin
  start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  # ファイル1の総サイズを取得
  file1_total_bytes = File.size(file1_path)
  file2_total_bytes = File.size(file2_path)

  # 進捗表示用のブロック（ラムダ）を定義
  print_progress1 = lambda do |current_bytes|
    percent = (current_bytes.to_f / file1_total_bytes * 100).clamp(0, 100)
    current_str = format_bytes(current_bytes)
    total_str = format_bytes(file1_total_bytes)
    # \r でコンソール上の同じ行を上書き表示
    print "\r[file1] #{current_str} / #{total_str} (#{format('%.1f', percent)}%)"
    $stdout.flush
  end
  print_progress2 = lambda do |current_bytes|
    percent = (current_bytes.to_f / file2_total_bytes * 100).clamp(0, 100)
    current_str = format_bytes(current_bytes)
    total_str = format_bytes(file2_total_bytes)
    # \r でコンソール上の同じ行を上書き表示
    print "\r[file2] #{current_str} / #{total_str} (#{format('%.1f', percent)}%)"
    $stdout.flush
  end

  # ファイルサイズの大きい方で進捗を表示する
  if file1_total_bytes >= file1_total_bytes
    # reader1に進捗通知用ブロックを渡す
    reader1 = FastLineReader.new(file1_path, &print_progress1)
    reader2 = FastLineReader.new(file2_path)

    # 初期表示 (0%)
    print_progress1.call(0)
  else
    # reader2に進捗通知用ブロックを渡す
    reader1 = FastLineReader.new(file1_path)
    reader2 = FastLineReader.new(file2_path, &print_progress2)

    # 初期表示 (0%)
    print_progress2.call(0)
  end

  WRITE_BUFFER_SIZE = 10 * 1024 * 1024  # 10MBバッファ
  out_buffer = String.new(capacity: WRITE_BUFFER_SIZE)

  # 直前に出力した行を保持する変数（重複チェック用）
  last_emitted_line = nil

  File.open(output_path, "w:UTF-8", newline: :lf) do |out|
    line1 = reader1.next_line
    line2 = reader2.next_line

    # 出力処理用のヘルパーヘルパーメソッド（重複除外してバッファへ追加）
    emit = lambda do |line|
      # 大文字小文字を区別して完全一致する場合は書き出さない
      if last_emitted_line != line
        out_buffer << line << "\n"
        last_emitted_line = line

        if out_buffer.bytesize >= WRITE_BUFFER_SIZE
          out.write(out_buffer)
          out_buffer.clear
        end
      end
    end

    # 2つのファイルを比較しながらマージ
    while line1 && line2
      if line1 <= line2
        emit.call(line1)
        line1 = reader1.next_line
      else
        emit.call(line2)
        line2 = reader2.next_line
      end
    end

    # 残りの行を出力
    while line1
      emit.call(line1)
      line1 = reader1.next_line
    end

    while line2
      emit.call(line2)
      line2 = reader2.next_line
    end

    out.write(out_buffer) unless out_buffer.empty?
  end

  # 読み込み完了時に確実に100%表示にする
  if file1_total_bytes  >= file2_total_bytes 
    print_progress1.call(file1_total_bytes)
  else
    print_progress2.call(file2_total_bytes)
  end
  puts "" # 改行

  reader1.close
  reader2.close

  end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  elapsed_time = end_time - start_time

  puts "done: #{output_path}"
  puts "processing time: #{format('%.3f', elapsed_time)} sec"

rescue => e
  puts "an error happened: #{e.message}"
end
