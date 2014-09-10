call "rsvars.bat"
msbuild.exe /target:Build /p:config=Release /p:Platform=Win64 %~dp0\DelphiLogger_XE2.dproj
msbuild.exe /target:Build /p:config=Debug   /p:Platform=Win64 %~dp0\DelphiLogger_XE2.dproj