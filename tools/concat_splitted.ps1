#
# 分割したファイルを統合する。
#

$from = 2
# $from = 10
$to = 12

$inDir = "split"
$outDir = "concat"

for ($i = $from; $i -le $to; $i++) {
    # inDirにあるmateXX*.txtを列挙する
    $inputFiles = Get-ChildItem "$inDir\mate$(([string]$i).PadLeft(2, "0"))*.txt"
    # プログレスバーの更新
    $num = 100 * ($i - $from) / ($to - $from)
    Write-Output "$num percent..."
    # Write-Progress -Activity "concatenate mate$i..." -Status "loading..." -PercentComplete $num
    # ファイルを順番につなげる
    foreach ($fpath in $inputFiles) {
        Write-Output "$fpath"
        # Write-Progress -Activity "concatenate mate$i..." -Status "$fpath" -PercentComplete $num
        Get-Content "$fpath" | Out-File -FilePath "$outDir\mate$i.txt" -Append -Encoding Utf8
        # Get-Content "$fpath" >> "$outDir\mate$i.txt"
    }
}

# Write-Progress -Completed  -Activity "processing..."
