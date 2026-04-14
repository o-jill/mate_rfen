$from = 2
$to = 12

$inDir = "merged"
$outDir = "split"

# example:
# ruby .\tools\split_by_leading_char.rb .\merged\mate8.txt split01\mate08_

for ($i = $from; $i -le $to; $i++) {
    $inputFile = "$inDir\mate$i.txt"
    $output = "$outDir\mate$(([string]$i).PadLeft(2, "0"))"
    $num = 100 * ($i - $from) / ($to - $from)
    Write-Progress -Activity "processing..." -Status "$inputFile" -PercentComplete $num
    ruby .\tools\split_by_leading_char.rb $inputFile $output
}

Write-Progress -Completed  -Activity "processing..."
