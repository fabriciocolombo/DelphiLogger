call "rsvars.bat"
msbuild.exe /target:Clean /p:config=Release /p:Platform=Win32 DelphiLogger_XE2.dproj
msbuild.exe /target:Clean /p:config=Debug   /p:Platform=Win32 DelphiLogger_XE2.dproj
msbuild.exe /target:Clean /p:config=Release /p:Platform=Win64 DelphiLogger_XE2.dproj
msbuild.exe /target:Clean /p:config=Debug   /p:Platform=Win64 DelphiLogger_XE2.dproj

msbuild.exe /target:Build /p:config=Release /p:Platform=Win32 DelphiLogger_XE2.dproj
msbuild.exe /target:Build /p:config=Debug   /p:Platform=Win32 DelphiLogger_XE2.dproj
msbuild.exe /target:Build /p:config=Release /p:Platform=Win64 DelphiLogger_XE2.dproj
msbuild.exe /target:Build /p:config=Debug   /p:Platform=Win64 DelphiLogger_XE2.dproj