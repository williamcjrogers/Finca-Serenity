$gs = "C:\Program Files\gs\gs10.06.0\bin\gswin64c.exe"
$rawPdf = "C:\Users\William\Desktop\Projects\brochure-raw.pdf"
$tempOut = "C:\Users\William\Desktop\Projects\brochure-final.pdf"

& $gs "-sDEVICE=pdfwrite" "-dCompatibilityLevel=1.4" "-dPDFSETTINGS=/ebook" "-dNOPAUSE" "-dBATCH" "-dColorImageResolution=150" "-dGrayImageResolution=150" "-dDownsampleColorImages=true" "-dDownsampleGrayImages=true" "-sOutputFile=$tempOut" "$rawPdf"

if (Test-Path $tempOut) {
    $size = [math]::Round((Get-Item $tempOut).Length / 1MB, 2)
    Remove-Item $rawPdf -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Users\William\Desktop\Projects\Finca-Serenity-Brochure.pdf" -Force -ErrorAction SilentlyContinue
    Rename-Item $tempOut "Finca-Serenity-Brochure.pdf"
    Write-Host "Done: Finca-Serenity-Brochure.pdf -- $size MB"
} else {
    Write-Host "Ghostscript failed"
}
