@echo off
setlocal enableextensions enabledelayedexpansion

rem Windows bypasses Meson for now because Meson's llvm-flang support still has
rem unresolved upstream issues; track https://github.com/mesonbuild/meson/issues/12306

if defined FC (
  set "FC_EXE=%FC%"
) else (
  set "FC_EXE=flang-new"
)

if defined CC (
  set "CC_EXE=%CC%"
) else (
  set "CC_EXE=cl.exe"
)

if not defined SP_DIR (
  echo SP_DIR is not defined
  exit /b 1
)
set "PKG_DIR=%SP_DIR%\pfapack"

if not exist build mkdir build
if not exist "%PKG_DIR%" mkdir "%PKG_DIR%"

pushd build
(
  echo EXPORTS
  echo skpfa_s
  echo skpfa_d
  echo skpfa_c
  echo skpfa_z
  echo skpf10_s
  echo skpf10_d
  echo skpf10_c
  echo skpf10_z
  echo skbpfa_s
  echo skbpfa_d
  echo skbpfa_c
  echo skbpfa_z
  echo skbpf10_s
  echo skbpf10_d
  echo skbpf10_c
  echo skbpf10_z
  echo sktrf_s
  echo sktrf_d
  echo sktrf_c
  echo sktrf_z
  echo sktrd_s
  echo sktrd_d
  echo sktrd_c
  echo sktrd_z
  echo skbtrd_s
  echo skbtrd_d
  echo skbtrd_c
  echo skbtrd_z
) > cpfapack.def
if errorlevel 1 exit /b 1

for %%F in (..\original_source\fortran\*.f) do (
  "%FC_EXE%" -c "%%F" -o "%%~nF.obj" -O2 -funderscoring -fms-runtime-lib=dll -I. -module-dir .
  if errorlevel 1 exit /b 1
)

call :compile_fortran ..\original_source\fortran\precision.f90 precision.obj
call :compile_fortran ..\original_source\fortran\f77_interface.f90 f77_interface.obj
call :compile_fortran ..\original_source\fortran\f95_interface.f90 f95_interface.obj
call :compile_fortran ..\original_source\fortran\message.f90 message.obj
call :compile_fortran ..\original_source\fortran\skpfa.f90 skpfa.obj
call :compile_fortran ..\original_source\fortran\skpf10.f90 skpf10.obj
call :compile_fortran ..\original_source\fortran\skbpfa.f90 skbpfa.obj
call :compile_fortran ..\original_source\fortran\skbpf10.f90 skbpf10.obj
call :compile_fortran ..\original_source\fortran\sktrd.f90 sktrd.obj
call :compile_fortran ..\original_source\fortran\sktd2.f90 sktd2.obj
call :compile_fortran ..\original_source\fortran\sktrf.f90 sktrf.obj
call :compile_fortran ..\original_source\fortran\sktf2.f90 sktf2.obj
call :compile_fortran ..\original_source\fortran\skbtrd.f90 skbtrd.obj
if errorlevel 1 exit /b 1

for %%F in (skpfa skpf10 skbpfa skbpf10 sktrf sktrd skbtrd) do (
  "%CC_EXE%" /c /O2 /MD /nologo /utf-8 ^
    /I"..\original_source\c_interface" ^
    /I"..\original_source\c_interface\TESTING" ^
    /Fo"c_%%F.obj" "..\original_source\c_interface\%%F.c"
  if errorlevel 1 exit /b 1
)

dir /b *.obj > objects.rsp
"%FC_EXE%" @objects.rsp -o cpfapack.dll -funderscoring -fms-runtime-lib=dll -fuse-ld=lld ^
  -Wl,/DLL -Wl,/DEF:cpfapack.def ^
  "%PREFIX%\Library\lib\lapack.lib" "%PREFIX%\Library\lib\blas.lib"
if errorlevel 1 exit /b 1

for %%F in (__init__.py _version.py ctypes.py exceptions.py pfaffian.py) do (
  copy /Y "..\pfapack\%%F" "%PKG_DIR%\%%F"
  if errorlevel 1 exit /b 1
)
copy /Y "cpfapack.dll" "%PKG_DIR%\"
if errorlevel 1 exit /b 1

popd
exit /b 0

:compile_fortran
"%FC_EXE%" -c "%~1" -o "%~2" -O2 -funderscoring -fms-runtime-lib=dll -I. -module-dir .
exit /b %ERRORLEVEL%
