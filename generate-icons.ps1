$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

function New-Icon {
    param(
        [int]$w,
        [int]$h,
        [string]$path,
        [int]$fontSize
    )
    $bmp = New-Object System.Drawing.Bitmap $w, $h
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = 'HighQuality'
    $g.Clear([System.Drawing.Color]::FromArgb(255,0,51,102)) # #003366 brand color
    $brushWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $font = New-Object System.Drawing.Font('Arial', $fontSize, [System.Drawing.FontStyle]::Bold)
    $fmt = New-Object System.Drawing.StringFormat
    $fmt.Alignment = [System.Drawing.StringAlignment]::Center
    $fmt.LineAlignment = [System.Drawing.StringAlignment]::Center
    $g.DrawString('GG', $font, $brushWhite, [System.Drawing.RectangleF]::new(0,0,$w,$h), $fmt)
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
}

New-Icon 192 192 'icon-192.png' 64
New-Icon 512 512 'icon-512.png' 160

Write-Host "Icons generated: icon-192.png, icon-512.png"