@ ECHO OFF
IF NOT EXIST .\tools\wget.exe GOTO x1
IF NOT EXIST .\tools\fart.exe GOTO x1
IF NOT EXIST .\tools\mkisofs.exe GOTO x2
IF NOT EXIST .\tools\7z.exe GOTO x3
IF NOT EXIST krd.iso GOTO x4
IF EXIST .\krdusb RMDIR /s .\krdusb /q
IF EXIST .\krdusb.iso DEL .\krdusb.iso

ECHO.
ECHO =================================================
ECHO    Kaspersky Rescue Disk Updater by Marcus Zou
ECHO                  EzDone Studio
ECHO.
ECHO  https://github.com/marcuszou/KasperskyRD-Updater
ECHO.
ECHO ==================================================
ECHO.
ECHO Please enable a good Internet conection now...
ECHO. 
ECHO Do you want to update Virus Definition Files from the Internet? y/n
SET /p choc=
)
IF "%choc%"=="n" GOTO NodlMSG
ECHO.
ECHO Next Step: Download Kaspersky Virus Definition Files from Internet.
ECHO.
PAUSE

CLS
ECHO.
TITLE Downloading Kaspersky Virus Definition Files from Internet
IF EXIST .\downloaded\042-freshbases.srm DEL .\downloaded\042-freshbases.srm
IF EXIST .\downloaded\hashes.txt DEL .\downloaded\hashes.txt
ECHO Downloading Kaspersky Virus Definition Update - SRM file ==> in progress...
.\tools\wget.exe https://rescuedisk.s.kaspersky-labs.com/updatable/2018/bases/042-freshbases.srm -P ".\downloaded"
ECHO Downloading Kaspersky Virus Definition Update  - Hash file ==> in progress...
.\tools\wget.exe https://rescuedisk.s.kaspersky-labs.com/updatable/2018/bases/hashes.txt -P ".\downloaded"
ECHO.
IF errorlevel 4 GOTO :UpdERR
ECHO.
ECHO Successfully Downloaded Kaspersky Virus Definition Files to downloaded folder
ECHO.
ECHO.
ECHO Next Step: Extract the contents of Kaspersky Rescue Disk
ECHO.
PAUSE

CLS
ECHO.
TITLE Extracting Kaspersky Rescue Disk - krd.iso
.\tools\7z x -o"krdusb" -y -x"![BOOT]\*.img" "krd.iso"
IF errorlevel 1 GOTO :ExtERR
ECHO Kaspersky Files Extracted in %~dp0krdusb
ECHO.
ECHO Next Step: Copy and process the Updated Virus Definition Files to your Rescue Disk
ECHO.
PAUSE

CLS
TITLE Copying the Updated Virus Definition Files to your Rescue Disk
IF EXIST .\krdusb\data\005-bases.srm DEL .\krdusb\data\005-bases.srm
IF EXIST .\krdusb\data\005-bases.srm.sha512 DEL .\krdusb\data\005-bases.srm.sha512
copy .\downloaded\042-freshbases.srm .\krdusb\data\ > nul
copy .\downloaded\hashes.txt .\krdusb\data\ > nul
ECHO.

ECHO.
ECHO Successfully Copied Definition Files to your Rescue Disk folder
ECHO.
ECHO.
TITLE Processing Definition Hash File
.\tools\fart.exe -i ".\krdusb\data\hashes.txt" 042-freshbases.srm 005-bases.srm
REN .\krdusb\data\042-freshbases.srm 005-bases.srm
REN .\krdusb\data\hashes.txt 005-bases.srm.sha512
ECHO.
ECHO Update the file of .\krdusb\krd_bases_timestamp.txt
FOR %%a IN (.\krdusb\data\005-bases.srm) DO SET FileDate=%%~ta
ECHO %FileDate% > .\krdusb\krd_bases_timestamp.txt
ECHO.
ECHO Next Step: Creating Kaspersky USB Rescue Disk ISO Image
ECHO.
PAUSE

:iso
CLS
ECHO.
ECHO Creating Kaspersky USB Rescue Disk ISO Image
ECHO.
SET CDBOOT=
IF EXIST .\krdusb\boot\grub\i386-pc\eltorito.img SET CDBOOT=boot/grub/i386-pc/eltorito.img 
IF EXIST .\krdusb\boot\grub\grub_eltorito SET CDBOOT=boot/grub/grub_eltorito 
IF "%CDBOOT%"=="" GOTO BtsecERR
.\tools\mkisofs -R -J -joliet-long -o krdusb.iso -b %CDBOOT% -c boot\boot.cat -no-emul-boot -boot-info-table -V "KasperskyRD" -boot-load-size 4 krdusb
IF errorlevel 1 GOTO :ERR
ECHO NO ERRORS - new krdusb.iso IS MADE!
ECHO.
ECHO Feel free to write the krdusb.iso image onto a USB drive
ECHO.
ECHO Please be advised to use a decent ISO image writer.
ECHO.
GOTO end


:NodlMSG
ECHO.
ECHO No downloading is taken, please use an Image writer to write curRENt krd.iso to USB drive.
ECHO.
GOTO end

:ExtERR
ECHO.
ECHO ERROR! Some problem when extracting occurred!
ECHO.
GOTO end

:UpdERR
ECHO.
ECHO Mission aborted due to no Internet Connection, please ensure the availability.
ECHO.
GOTO end

:BtsecERR
ECHO.
ECHO !! Bootsector Missing !! .\krdusb\boot\grub\i386-pc\eltorito.img - please use correct version of ISO!
ECHO.
GOTO end

:x1
ECHO Missing file %~dp0tools\wget.exe or %~dp0tools\fart.exe
GOTO end
:x2
ECHO Missing file %~dp0tools\mkisofs.exe
GOTO end
:x3
ECHO Missing file(s)  %~dp0tools\7z.exe, %~dp0tools\FORmats\iso.dll
GOTO end
:x4
ECHO !! Kaspersky Rescue Disk Not Found !!.
ECHO Missing File %~dp0krd.iso
ECHO Please download Rescue Disk from:
ECHO http://rescuedisk.kaspersky-labs.com/rescuedisk/updatable/kav_rescue_10.iso
ECHO and REName it to krd.iso
GOTO end

:end
PAUSE
GOTO :EOF
