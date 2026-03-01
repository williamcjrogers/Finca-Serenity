$gs = "C:\Program Files\gs\gs10.06.0\bin\gswin64c.exe"
$input = "C:\Users\William\Desktop\Projects\Finca-Serenity-Brochure.pdf"
$output = "C:\Users\William\Desktop\Projects\Finca-Serenity-Brochure-final.pdf"

& $gs "-sDEVICE=pdfwrite" "-dCompatibilityLevel=1.4" "-dPDFSETTINGS=/ebook" "-dNOPAUSE" "-dBATCH" "-dQUIET" "-dColorImageResolution=150" "-dGrayImageResolution=150" "-dDownsampleColorImages=true" "-dDownsampleGrayImages=true" "-sOutputFile=$output" "$input"

$size = [math]::Round((Get-Item $output).Length / 1MB, 2)
Remove-Item $input -Force
Rename-Item $output "Finca-Serenity-Brochure.pdf"
Write-Host "Done: $size MB"
