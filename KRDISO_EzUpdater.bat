@ echo off
if not exist .\tools\wget.exe goto x1
if not exist .\tools\fart.exe goto x1
if not exist .\tools\mkisofs.exe goto x2
if not exist .\tools\7z.exe goto x3
if not exist krd.iso goto x4
if exist .\krdusb rmdir /s .\krdusb /q
if exist .\krdusb.iso del .\krdusb.iso

echo.
ECHO =================================================
ECHO    Kaspersky Rescue Disk Updater by Marcus Zou
echo                  EzDone Studio
echo.
echo  https://github.com/marcuszou/KasperskyRD-Updater
echo.
echo ==================================================
echo.
echo Please enable a good Internet conection now...
echo. 
echo Do you want to update Virus Definition Files from the Internet? y/n
set /p choc=
)
if "%choc%"=="n" goto NodlMSG
echo.
Echo Next Step: Download Kaspersky Virus Definition Files from Internet.
echo.
pause

cls
echo.
title Downloading Kaspersky Virus Definition Files from Internet
if exist .\downloaded\042-freshbases.srm del .\downloaded\042-freshbases.srm
if exist .\downloaded\hashes.txt del .\downloaded\hashes.txt
ECHO Downloading Kaspersky Virus Definition Update - SRM file ==> in progress...
.\tools\wget.exe https://rescuedisk.s.kaspersky-labs.com/updatable/2018/bases/042-freshbases.srm -P ".\downloaded"
ECHO Downloading Kaspersky Virus Definition Update  - Hash file ==> in progress...
.\tools\wget.exe https://rescuedisk.s.kaspersky-labs.com/updatable/2018/bases/hashes.txt -P ".\downloaded"
echo.
if errorlevel 4 goto :UpdERR
echo.
echo Successfully Downloaded Kaspersky Virus Definition Files to downloaded folder
echo.
echo.
echo Next Step: Extract the contents of Kaspersky Rescue Disk
echo.
pause

cls
Echo.
Title Extracting Kaspersky Rescue Disk - krd.iso
.\tools\7z x -o"krdusb" -y -x"![BOOT]\*.img" "krd.iso"
if errorlevel 1 goto :ExtERR
echo Kaspersky Files Extracted in %~dp0krdusb
echo.
Echo Next Step: Copy and process the Updated Virus Definition Files to your Rescue Disk
echo.
pause

cls
title Copying the Updated Virus Definition Files to your Rescue Disk
if exist .\krdusb\data\005-bases.srm del .\krdusb\data\005-bases.srm
if exist .\krdusb\data\005-bases.srm.sha512 del .\krdusb\data\005-bases.srm.sha512
copy .\downloaded\042-freshbases.srm .\krdusb\data\ > nul
copy .\downloaded\hashes.txt .\krdusb\data\ > nul
echo.

echo.
echo Successfully Copied Definition Files to your Rescue Disk folder
echo.
echo.
title Processing Definition Hash File
.\tools\fart.exe -i ".\krdusb\data\hashes.txt" 042-freshbases.srm 005-bases.srm
ren .\krdusb\data\042-freshbases.srm 005-bases.srm
ren .\krdusb\data\hashes.txt 005-bases.srm.sha512
echo.
Echo Next Step: Creating Kaspersky USB Rescue Disk ISO Image
echo.
pause

:iso
cls
echo.
Echo Creating Kaspersky USB Rescue Disk ISO Image
echo.
SET CDBOOT=
if exist .\krdusb\boot\grub\i386-pc\eltorito.img set CDBOOT=boot/grub/i386-pc/eltorito.img 
if exist .\krdusb\boot\grub\grub_eltorito set CDBOOT=boot/grub/grub_eltorito 
if "%CDBOOT%"=="" goto BtsecERR
.\tools\mkisofs -R -J -joliet-long -o krdusb.iso -b %CDBOOT% -c boot\boot.cat -no-emul-boot -boot-info-table -V "KasperskyRD" -boot-load-size 4 krdusb
if errorlevel 1 goto :ERR
echo NO ERRORS - new krdusb.iso IS MADE!
echo.
echo Feel free to write the krdusb.iso image onto a USB drive
echo.
echo Please be advised to use a decent ISO image writer.
echo.
goto end


:NodlMSG
echo.
echo No downloading is taken, please use an Image writer to write current krd.iso to USB drive.
echo.
goto end

:ExtERR
echo.
echo ERROR! Some problem when extracting occurred!
echo.
goto end

:UpdERR
echo.
echo Mission aborted due to no Internet Connection, please ensure the availability.
echo.
goto end

:BtsecERR
echo.
echo !! Bootsector Missing !! .\krdusb\boot\grub\i386-pc\eltorito.img - please use correct version of ISO!
echo.
goto end

:x1
echo Missing file %~dp0tools\wget.exe or %~dp0tools\fart.exe
goto end
:x2
echo Missing file %~dp0tools\mkisofs.exe
goto end
:x3
echo Missing file(s)  %~dp0tools\7z.exe, %~dp0tools\Formats\iso.dll
goto end
:x4
echo !! Kaspersky Rescue Disk Not Found !!.
echo Missing File %~dp0krd.iso
echo Please download Rescue Disk from:
echo http://rescuedisk.kaspersky-labs.com/rescuedisk/updatable/kav_rescue_10.iso
echo and rename it to krd.iso
goto end

:end
pause
goto :EOF
