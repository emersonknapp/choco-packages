choco install -y msys2
rem call RefreshEnv.cmd
rem start /b /wait \tools\msys64\msys2_shell.cmd %cd%/fetch_and_patch_source.sh %cd%
start /b /wait \tools\msys64\msys2_shell.cmd %cd%/test.sh %cd%

echo "HELLO THIS SHOULD HAPPEND LAST"
rem start devenv log4cxx_ws\log4cxx\projects\log4cxx.dsw