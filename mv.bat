:: Allows using mv command on Windows to rename resulting box
@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
SET "PARAM_1=%~1"
SET "PARAM_2=%~2"
MOVE "%PARAM_1:/=\%" "%PARAM_2:/=\%"
ENDLOCAL