param(
    [string] $type 
)

$rootPath = $PSScriptRoot
$flutterBuildPath = "$rootPath/flutter/build/windows/x64/runner/Release"


function Build_x64(){
    Set-Location $rootPath
    & python3 .\build.py --portable --hwcodec --flutter --vram --skip-portable-pack
    Write-Host "生成文件所在目录为： $flutterBuildPath" -ForegroundColor Green
}

function Build_x64_portable(){
    Set-Location "$rootPath/libs/portable"
    & pip3 install -r requirements.txt
    & python3 ./generate.py -f "$flutterBuildPath" -o . -e "$flutterBuildPath/rustdesk.exe"
    Write-Host "生成文件所在目录为： $PSScriptRoot\target\release" -ForegroundColor Green
    Set-Location "$rootPath"
}

function Build_settings(){
    Set-Location "$rootPath/../rustdesk_confg_generator/dist"
    & ./rdcfggen.exe -s -k key/private.b64 -i data/custom.json -o "$flutterBuildPath/custom.txt"
}

try {
    if($type -eq "x64") {
        Build_x64
    } elseif($type -eq "x64_portable") {
        Build_x64_portable
    } elseif($type -eq "settings") {
        Build_settings
    } else {
        Write-Host ""
        Write-Host "未指定正确的参数" -ForegroundColor Red
        Write-Host ""
        Write-Host "脚本使用方法："
        Write-Host "  .\make.ps1 x64             生成x64程序"        -ForegroundColor Green
        Write-Host "  .\make.ps1 x64_portable    生成x64便携版程序"   -ForegroundColor Green
        Write-Host "  .\make.ps1 settings         生成 custom.txt 配置程序"   -ForegroundColor Green
        Write-Host ""
    }
}
finally {
    Set-Location "$rootPath"
}