$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

function New-LogoIcon {
    param(
        [int]$size,
        [string]$path,
        [double]$padding = 0.1
    )
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = 'HighQuality'

    $blue = [System.Drawing.Color]::FromArgb(0, 60, 126)
    $white = [System.Drawing.Color]::White

    $g.FillEllipse((New-Object System.Drawing.SolidBrush $blue), 0, 0, $size-1, $size-1)

    function New-RoundPen([System.Drawing.Color]$color, [float]$thick) {
        $p = New-Object System.Drawing.Pen($color, $thick)
        $p.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
        $p.EndCap   = [System.Drawing.Drawing2D.LineCap]::Round
        $p.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
        return $p
    }

    $m = [int]($size * $padding)
    $outerW = [int]($size - (2 * $m))
    $rectOuter = New-Object System.Drawing.Rectangle($m, $m, $outerW, $outerW)

    $penA = New-RoundPen $white ([float]($size * 0.16))
    $penB = New-RoundPen $white ([float]($size * 0.14))
    $penC = New-RoundPen $white ([float]($size * 0.12))

    $g.DrawArc($penA, $rectOuter, 340, 140)
    $g.DrawArc($penB, $rectOuter, 160, 160)

    $innerSize = [int]($size * 0.32)
    $innerOffset = [int](($size - $innerSize) / 2)
    $rectInner = New-Object System.Drawing.Rectangle($innerOffset, $innerOffset, $innerSize, $innerSize)
    $g.DrawArc($penC, $rectInner, 300, 210)

    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)

    $penA.Dispose(); $penB.Dispose(); $penC.Dispose();
    $g.Dispose(); $bmp.Dispose()
}

New-LogoIcon -size 192 -path 'icon-192.png' -padding 0.08
New-LogoIcon -size 512 -path 'icon-512.png' -padding 0.16

Write-Host "Icons generated with Go-Global circular logo: icon-192.png, icon-512.png"