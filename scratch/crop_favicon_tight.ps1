Add-Type -AssemblyName System.Drawing
try {
    $imgPath = Join-Path (Get-Location) "assets/favicon2.png"
    $img = [System.Drawing.Bitmap]::FromFile($imgPath)
    $minX = $img.Width
    $minY = $img.Height
    $maxX = 0
    $maxY = 0

    for ($x = 0; $x -lt $img.Width; $x += 2) {
        for ($y = 0; $y -lt $img.Height; $y += 2) {
            $color = $img.GetPixel($x, $y)
            if ($color.A -gt 20) {
                if ($x -lt $minX) { $minX = $x }
                if ($x -gt $maxX) { $maxX = $x }
                if ($y -lt $minY) { $minY = $y }
                if ($y -gt $maxY) { $maxY = $y }
            }
        }
    }

    $width = $maxX - $minX + 1
    $height = $maxY - $minY + 1

    if ($width -gt 0) {
        # NO PADDING this time
        $size = [int]([Math]::Max($width, $height))
        if ($size -gt [Math]::Min($img.Width, $img.Height)) { $size = [Math]::Min($img.Width, $img.Height) }
        $centerX = $minX + ($width / 2)
        $centerY = $minY + ($height / 2)
        $cropX = [int][Math]::Max(0, [Math]::Min($img.Width - $size, $centerX - ($size / 2)))
        $cropY = [int][Math]::Max(0, [Math]::Min($img.Height - $size, $centerY - ($size / 2)))
        $cropRect = [System.Drawing.Rectangle]::new($cropX, $cropY, $size, $size)
        $croppedImg = $img.Clone($cropRect, $img.PixelFormat)
        $img.Dispose()
        $croppedImg.Save($imgPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $croppedImg.Dispose()
        Write-Host "Favicon2 cropped with ZERO padding successfully"
    }
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
