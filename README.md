# Kaspersky Rescue Disk Offline EzUpdater

Version 1.1

Source:	https://github.com/MarcusZou/kasperskyResDsk-Updater/



## Section 1 - Intro

**Kaspersky Rescue Disk Offline EzUpdater** is a toolkit developed by **EzDone Studio** which fabricates a unique offline applet to update the virus definitions of the Kaspersky Rescue Disk 2018 ISO.



Kaspersky Rescue Disk 2018 is very powerful in the industry because -

* It can scan and remove viruses without booting into windows.

* It is free even though you have not paid a single penny for Kaspersky Anti-virus Suite.

The main issues of Kaspersky Rescue Disk 2018 are as below:

* It is not updated regularly (then the virus definitions become out of date very soon). Even when Kaspersky Anti-virus Suite is updated daily there is no option to update your existing ISO. Re-downloading the entire ISO takes a lot of network bandwidth.

* Even though the Rescue Disk has an option to update the virus definitions from the Internet once you boot it on a computer, it is not very useful as the updates are saved to a local HDD of the computer you are running the Rescue Disk on. You have to download all the updates every time you move the Rescue Disk to a different computer.



## Section 2 - How-to

This tool fixes the above problems by updating your existing Kaspersky Rescue Disk ISO with the latest virus definitions from the Kaspersky Servers (they update the virus database daily, believe me or not). This helps in keeping your Kaspersky Recue Disk up-to-date without having to download a lot of files. Hence saving a lot of time and bandwidth.

1. Download Kaspersky Rescue Disk from the [official website](http://rescuedisk.kaspersky-labs.com/rescuedisk/updatable/2018/krd.iso)

2. Download the EzUpdater as a zip from [here](http://github.com/MarcusZou/KasperskyResDsk-Updater) and extract it to a local directory.

3. Copy the just downloaded krd.iso to the above directory.

4. Run KRDISO_EzUpdater.bat.

5. After the update is done you will see a new ISO image - krdusb.iso.

6. You can either burn krdusb.iso to a CD or write it into USB Drive.

7. Booting the Rescue Disk from a USB Drive (preferred) or CD (if you still have a DVD writer).



## Section 3 - Helper

The toolbox you can manually make your USB Drive bootable are -

* [Rufus](https://rufus.ie/) (preferred and always better)
* [Win32 Disk Imager](https://sourceforge.net/projects/win32diskimager)



Please refer to the official website of Kaspersky Rescue Disk 18 at http://support.kaspersky.com/14226



## Section 4 - Mindset

Lastly but most importantly - Interested in the mindset how to develop this small EzUpdater? Please move to the [Document](Kaspersky Rescue Disk - Update definitions offline.pdf) for a peek.



## Section 5 - Outro

Outperformance is never an issue



============================

EzDone Studio

June 15, 2020
