# 1. ターゲットパスを設定
# 入力ファイルがあるフォルダ
$TargetPath = "merged"

# 出力フォルダ
$ZstdPath = "zstd"

# zstdのパス
$ZstdExePath = "zstd.exe"


# 2. mate*.txtのファイル名（Nameプロパティ）を取得
$FileNames = Get-ChildItem -Path $TargetPath -Filter "mate*.txt"

# 3. ターゲットパスと各フォルダ名を結合し、カンマ区切りで出力
$KifuData =
    $FileNames | ForEach-Object {
        # Join-Pathでパスを結合
        Join-Path -Path $TargetPath -ChildPath $_ 
    }

Write-Output $KifuData

# 3. ターゲットパスと各フォルダ名を結合し、カンマ区切りで出力
# $ZstdData =
#     $FileNames | ForEach-Object {
#         # Join-Pathでパスを結合
#         Join-Path -Path $ZstdPath -ChildPath $_ 
#     }

$nowstr = Get-Date -Format "yyyyMMddHHmmss"
$listName = "filelist$nowstr.txt"
$fileList = @()

foreach ($path in $FileNames) {
    $inputPath = Join-Path -Path $TargetPath -ChildPath $path 
    $newPath = $path -replace "\.txt$", ".zst"
    $outputPath = Join-Path -Path $ZstdPath -ChildPath $newPath 
    $ZstdOptions = ("-19", "-k", $inputPath, "-o" , $outputPath)

    Write-Output ($path, $inputPath, $outputPath) -join ","

    Start-Process -FilePath $ZstdExePath -ArgumentList $ZstdOptions -Wait

    $fileList += $outputPath;
}

$files = $fileList -join ','
Write-Output $files >> $listName
Write-Host $files
