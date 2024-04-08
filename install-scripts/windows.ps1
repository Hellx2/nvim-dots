if (Get-Command git -errorAction SilentlyContinue)
{
    Write-Output "Found git, installing..."
    git clone --depth=1 "https://github.com/Hellx2/nvim-dots" "C:\tmp-hellx2"
    cp C:\tmp-hellx2\config $env:USERPROFILE\AppData\Local\nvim
    cp C:\tmp-hellx2\plugins $env:USERPROFILE\AppData\Local\nvim-data
    rmdir C:\tmp-hellx2
} else {
    Write-Output "git was not found, please install it."
}
