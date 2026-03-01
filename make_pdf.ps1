$projectDir = "C:\Users\William\Desktop\Projects"
$rawPdf = "$projectDir\brochure-raw.pdf"
$finalPdf = "$projectDir\Finca-Serenity-Brochure.pdf"
$gs = "C:\Program Files\gs\gs10.06.0\bin\gswin64c.exe"
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"

Write-Host "=== Step 1: Chrome PDF ==="
$url = "file:///$($projectDir -replace '\\','/')/brochure.html"
& $chrome --headless=new --disable-gpu --no-pdf-header-footer --user-data-dir="$env:TEMP\chrome_pdf" "--print-to-pdf=$rawPdf" $url 2>&1
Start-Sleep -Seconds 4

if (-not (Test-Path $rawPdf)) {
    Write-Host "FATAL: Chrome did not produce PDF"
    exit 1
}
$rawMB = [math]::Round((Get-Item $rawPdf).Length / 1MB, 2)
Write-Host "Raw PDF: $rawMB MB"

Write-Host "`n=== Step 2: Ghostscript compress ==="
& $gs "-sDEVICE=pdfwrite" "-dCompatibilityLevel=1.4" "-dPDFSETTINGS=/ebook" "-dNOPAUSE" "-dBATCH" "-dColorImageResolution=150" "-dGrayImageResolution=150" "-dDownsampleColorImages=true" "-dDownsampleGrayImages=true" "-sOutputFile=$finalPdf" "$rawPdf" 2>&1

if (Test-Path $finalPdf) {
    $finalMB = [math]::Round((Get-Item $finalPdf).Length / 1MB, 2)
    Write-Host "`nFinal PDF: $finalMB MB"
    Remove-Item $rawPdf -Force
} else {
    Write-Host "`nGhostscript failed -- keeping raw PDF"
    Rename-Item $rawPdf "Finca-Serenity-Brochure.pdf"
    $finalMB = $rawMB
}

Remove-Item "$env:TEMP\chrome_pdf" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Done: Finca-Serenity-Brochure.pdf ($finalMB MB)"
