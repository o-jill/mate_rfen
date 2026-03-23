# 2つの入力テキストファイルを結合し、大文字小文字を区別して重複行を削除し、
# ソートした結果を UTF-8 BOM なし・LF 改行で出力するスクリプトです。
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$InputPath1,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$InputPath2,

    [Parameter(Mandatory = $true, Position = 2)]
    [string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$LineEnding = "`n"

function Write-Utf8NoBomFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string[]]$Lines
    )

    $content = [string]::Join($LineEnding, $Lines)

    if ($Lines.Length -gt 0) {
        $content += $LineEnding
    }

    [System.IO.File]::WriteAllText($Path, $content, $Utf8NoBom)
}

if (-not (Test-Path -LiteralPath $InputPath1 -PathType Leaf)) {
    Write-Error "`"$InputPath1`" does not exist!"
}

if (-not (Test-Path -LiteralPath $InputPath2 -PathType Leaf)) {
    Write-Error "`"$InputPath2`" does not exist!"
}

$start = Get-Date

$mergedLines = @(
    Get-Content -LiteralPath $InputPath1
    Get-Content -LiteralPath $InputPath2
)

Write-Utf8NoBomFile -Path $OutputPath -Lines $mergedLines
Write-Host "merged."

$uniqueSortedLines = $mergedLines | Sort-Object -CaseSensitive -Unique
Write-Utf8NoBomFile -Path $OutputPath -Lines $uniqueSortedLines

Write-Host "done."

$end = Get-Date
$duration = $end - $start
Write-Host "processing time: $($duration.TotalSeconds) sec"
