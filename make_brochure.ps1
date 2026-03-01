$projectDir = "C:\Users\William\Desktop\Projects"
$rawPdf = "$projectDir\raw-brochure.pdf"
$compressedPdf = "$projectDir\compressed-brochure.pdf"
$gs = "C:\Program Files\gs\gs10.06.0\bin\gswin64c.exe"
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

# Clean any previous attempts
Remove-Item $rawPdf -Force -ErrorAction SilentlyContinue
Remove-Item $compressedPdf -Force -ErrorAction SilentlyContinue

# Step 1: Generate with Edge
Write-Host "Generating PDF with Edge..."
$url = "file:///$($projectDir -replace '\\','/')/brochure.html"
& $edge --headless --disable-gpu --no-pdf-header-footer "--print-to-pdf=$rawPdf" $url 2>&1 | Out-Null
Start-Sleep -Seconds 5

if (-not (Test-Path $rawPdf)) {
    Write-Host "ERROR: Edge did not create PDF"
    exit 1
}
$rawMB = [math]::Round((Get-Item $rawPdf).Length / 1MB, 2)
Write-Host "Raw: $rawMB MB"

# Step 2: Compress with Ghostscript
Write-Host "Compressing..."
& $gs "-sDEVICE=pdfwrite" "-dCompatibilityLevel=1.4" "-dPDFSETTINGS=/ebook" "-dNOPAUSE" "-dBATCH" "-dQUIET" "-dColorImageResolution=150" "-dGrayImageResolution=150" "-dDownsampleColorImages=true" "-dDownsampleGrayImages=true" "-sOutputFile=$compressedPdf" "$rawPdf" 2>&1 | Out-Null

if (Test-Path $compressedPdf) {
    $finalMB = [math]::Round((Get-Item $compressedPdf).Length / 1MB, 2)
    Write-Host "Compressed: $finalMB MB"

    # Swap into final name
    Remove-Item "$projectDir\Finca-Serenity-Brochure.pdf" -Force -ErrorAction SilentlyContinue
    Move-Item $compressedPdf "$projectDir\Finca-Serenity-Brochure.pdf"
    Remove-Item $rawPdf -Force
    Write-Host "Saved: Finca-Serenity-Brochure.pdf ($finalMB MB)"
} else {
    Write-Host "Compression failed -- using raw PDF"
    Remove-Item "$projectDir\Finca-Serenity-Brochure.pdf" -Force -ErrorAction SilentlyContinue
    Move-Item $rawPdf "$projectDir\Finca-Serenity-Brochure.pdf"
    Write-Host "Saved: Finca-Serenity-Brochure.pdf ($rawMB MB)"
}
