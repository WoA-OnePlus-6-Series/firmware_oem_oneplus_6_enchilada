@echo off

echo.
echo.  _______        __  _____      _                  _             
echo. ^|  ___\ \      / / ^| ____^|_  _^| ^|_ _ __ __ _  ___^| ^|_ ___  _ __ 
echo. ^| ^|_   \ \ /\ / /  ^|  _^| \ \/ / __^| '__/ _` ^|/ __^| __/ _ \^| '__^|
echo. ^|  _^|   \ V  V /   ^| ^|___ ^>  ^<^| ^|_^| ^| ^| ^(_^| ^| ^(__^| ^|^| ^(_^) ^| ^|   
echo. ^|_^|      \_/\_/    ^|_____/_/\_\\__^|_^|  \__,_^|\___^|\__\___/^|_^|   
echo.                                                                 

REM Enchilada Root Key Hash
set RKH=DD7C5F2E53176BEE91747B53900CCEC33DD30FA4DED0DFE9BAF9156E6910862F

set SOC=850

echo.
echo Target: Enchilada
echo SoC   : SDM%SOC%
echo RKH   : %RKH% (QUALCOMM Attestation CA) (From: Nov 25 2021 GMT To: Nov 20 2041 GMT)
echo.

echo Checking MBN files validity... (This may take a while!)

for /f %%f in ('dir /b /s extracted\*.mbn') do (
    call :checkRKH %%f
)

echo Checking ELF files validity... (This may take a while!)

for /f %%f in ('dir /b /s extracted\*.elf') do (
    call :checkRKH %%f
)

echo Cleaning up Output Directory...
rmdir /Q /S output

mkdir output
mkdir output\Drivers
mkdir output\Extensions

REM BTFM
mkdir output\Drivers\Bluetooth\BTFMUART

echo Copying Blueooth Firmware Files...
xcopy /qcheriky /-i extracted\BTFM\image\crbtfw21.tlv output\Drivers\Bluetooth\BTFMUART
xcopy /qcheriky /-i extracted\BTFM\image\crnv21.bin output\Drivers\Bluetooth\BTFMUART

REM ICP
mkdir output\Drivers\Camera\ISP

xcopy /qchky /-i extracted\vendor\firmware\CAMERA_ICP.elf output\Drivers\Camera\ISP\CAMERA_ICP_AAAAAA.elf

REM IPA
mkdir output\Drivers\Cellular\IPA

echo Converting IPA Subsystem image...
python tools\pil-squasher.py .\output\Drivers\Cellular\IPA\ipa_fws.elf .\extracted\vendor\firmware\ipa_fws.mdt

REM VENUS
mkdir output\Drivers\Graphics\DXKM

echo Converting Video Encoding Subsystem DSP Image...
python tools\pil-squasher.py .\output\Drivers\Graphics\DXKM\qcvss%SOC%.mbn .\extracted\NON-HLOS\image\venus.mdt

REM ZAP
echo Converting GPU ZAP Shader Micro Code DSP Image...
python tools\pil-squasher.py .\output\Drivers\Graphics\DXKM\qcdxkmsuc%SOC%.mbn .\extracted\vendor\firmware\a630_zap.mdt

REM CombinedSubsystem
mkdir output\Drivers\Subsystems\CombinedSubsystem

echo Converting Analog DSP Image...
python tools\pil-squasher.py .\output\Drivers\Subsystems\CombinedSubsystem\qcadsp%SOC%.mbn .\extracted\NON-HLOS\image\adsp.mdt

echo Converting Compute DSP Image...
python tools\pil-squasher.py .\output\Drivers\Subsystems\CombinedSubsystem\qccdsp%SOC%.mbn .\extracted\NON-HLOS\image\cdsp.mdt

echo Copying DSP1v2 Image...
xcopy /qchky /-i extracted\NON-HLOS\image\mba.mbn output\Drivers\Subsystems\CombinedSubsystem\qcdsp1v2%SOC%.mbn

echo Converting DSP2 Image...
python tools\pil-squasher.py .\output\Drivers\Subsystems\CombinedSubsystem\qcdsp2%SOC%.mbn .\extracted\NON-HLOS\image\modem.mdt

echo Converting SLPI Image...
python tools\pil-squasher.py .\output\Drivers\Subsystems\CombinedSubsystem\qcslpi%SOC%.mbn .\extracted\NON-HLOS\image\slpi.mdt

echo Copying WLAN MDSP Image...
xcopy /qchky /-i extracted\NON-HLOS\image\wlanmdsp.mbn output\Drivers\Subsystems\CombinedSubsystem\wlanmdsp.mbn

REM BDWLAN
mkdir output\Drivers\WLAN\WCNSS

echo Copying BDWLAN Files...
xcopy /qchky /i extracted\NON-HLOS\image\bdwlan.* output\Drivers\WLAN\WCNSS\

echo Copying WLAN Data file...
xcopy /qchky /-i extracted\NON-HLOS\image\data.msc output\Drivers\WLAN\WCNSS\data.msc

REM Sensor Config
mkdir output\Extensions\Sensors\MTP

xcopy /qchky /i extracted\vendor\etc\sensors\config\*.json output\Extensions\Sensors\MTP

REM Subsystem Extensions
mkdir output\Extensions\Subsystems\DSPs

REM ADSP
xcopy /qchky /-i extracted\dsp\adsp\AlacDecoderModule.so.1 output\Extensions\Subsystems\DSPs\AlacDecoderModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\ApeDecoderModule.so.1 output\Extensions\Subsystems\DSPs\ApeDecoderModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\AudioContextDetection.so.1 output\Extensions\Subsystems\DSPs\AudioContextDetection.so.1
xcopy /qchky /-i extracted\dsp\adsp\AudioSphereModule.so.1 output\Extensions\Subsystems\DSPs\AudioSphereModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\CFCMModule.so.1 output\Extensions\Subsystems\DSPs\CFCMModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\EtsiAmrWbPlusDecModule.so.1 output\Extensions\Subsystems\DSPs\EtsiAmrWbPlusDecModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\EtsiEaacPlusEncAndCmnModule.so.1 output\Extensions\Subsystems\DSPs\EtsiEaacPlusEncAndCmnModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\fastrpc_shell_0 output\Extensions\Subsystems\DSPs\fastrpc_shell_0
xcopy /qchky /-i extracted\dsp\adsp\FlacDecoderModule.so.1 output\Extensions\Subsystems\DSPs\FlacDecoderModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\fluence_voiceplus_module.so.1 output\Extensions\Subsystems\DSPs\fluence_voiceplus_module.so.1
xcopy /qchky /-i extracted\dsp\adsp\HeaacDecoderModule.so.1 output\Extensions\Subsystems\DSPs\HeaacDecoderModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\LdacModule.so.1 output\Extensions\Subsystems\DSPs\LdacModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\libstabilitydomain_skel.so output\Extensions\Subsystems\DSPs\libstabilitydomain_skel.so
xcopy /qchky /-i extracted\dsp\adsp\libsysmon_skel.so output\Extensions\Subsystems\DSPs\libsysmon_skel.so
xcopy /qchky /-i extracted\dsp\adsp\libsysmondomain_skel.so output\Extensions\Subsystems\DSPs\libsysmondomain_skel.so
xcopy /qchky /-i extracted\dsp\adsp\map_AVS_SHARED_LIBS_845.adsp.prodQ.txt output\Extensions\Subsystems\DSPs\map_AVS_SHARED_LIBS_845.adsp.prodQ.txt
xcopy /qchky /-i extracted\dsp\adsp\map_SHARED_LIBS_845.adsp.prodQ.txt output\Extensions\Subsystems\DSPs\map_SHARED_LIBS_845.adsp.prodQ.txt
xcopy /qchky /-i extracted\dsp\adsp\mmecns_module.so.1 output\Extensions\Subsystems\DSPs\mmecns_module.so.1
xcopy /qchky /-i extracted\dsp\adsp\SAPlusCmnModule.so.1 output\Extensions\Subsystems\DSPs\SAPlusCmnModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\SVACmnModule.so.1 output\Extensions\Subsystems\DSPs\SVACmnModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\VoiceWakeup_V2_Module.so.1 output\Extensions\Subsystems\DSPs\VoiceWakeup_V2_Module.so.1
xcopy /qchky /-i extracted\dsp\adsp\VorbisDecoderModule.so.1 output\Extensions\Subsystems\DSPs\VorbisDecoderModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\WmaProDecoderModule.so.1 output\Extensions\Subsystems\DSPs\WmaProDecoderModule.so.1
xcopy /qchky /-i extracted\dsp\adsp\WmaStdDecoderModule.so.1 output\Extensions\Subsystems\DSPs\WmaStdDecoderModule.so.1

REM CDSP
xcopy /qchky /-i extracted\dsp\cdsp\fastrpc_shell_3 output\Extensions\Subsystems\DSPs\fastrpc_shell_3
xcopy /qchky /-i extracted\dsp\cdsp\libbenchmark_skel.so output\Extensions\Subsystems\DSPs\libbenchmark_skel.so
xcopy /qchky /-i extracted\dsp\cdsp\libc++.so.1 output\Extensions\Subsystems\DSPs\libc++.so.1
xcopy /qchky /-i extracted\dsp\cdsp\libc++abi.so.1 output\Extensions\Subsystems\DSPs\libc++abi.so.1
xcopy /qchky /-i extracted\dsp\cdsp\libhcp_rpc_skel.so output\Extensions\Subsystems\DSPs\libhcp_rpc_skel.so
xcopy /qchky /-i extracted\dsp\cdsp\libvpp_aie.so output\Extensions\Subsystems\DSPs\libvpp_aie.so
xcopy /qchky /-i extracted\dsp\cdsp\libvpp_diagtools.so output\Extensions\Subsystems\DSPs\libvpp_diagtools.so
xcopy /qchky /-i extracted\dsp\cdsp\libvpp_frc.so output\Extensions\Subsystems\DSPs\libvpp_frc.so
xcopy /qchky /-i extracted\dsp\cdsp\libvpp_mvp.so output\Extensions\Subsystems\DSPs\libvpp_mvp.so
xcopy /qchky /-i extracted\dsp\cdsp\libvpp_nr.so output\Extensions\Subsystems\DSPs\libvpp_nr.so
xcopy /qchky /-i extracted\dsp\cdsp\libvpp_qbr.so output\Extensions\Subsystems\DSPs\libvpp_qbr.so
xcopy /qchky /-i extracted\dsp\cdsp\libvpp_svc_skel.so output\Extensions\Subsystems\DSPs\libvpp_svc_skel.so
xcopy /qchky /-i extracted\dsp\cdsp\map_SHARED_LIBS_845.cdsp.prodQ.txt output\Extensions\Subsystems\DSPs\map_SHARED_LIBS_845.cdsp.prodQ.txt
xcopy /qchky /-i extracted\dsp\cdsp\ubwcdma_dynlib.so output\Extensions\Subsystems\DSPs\ubwcdma_dynlib.so

REM QDSP
xcopy /qchky /-i extracted\NON-HLOS\image\qdsp6m.qdb output\Extensions\Subsystems\DSPs\qdsp6m.qdb

REM UEFI Extraction
mkdir output\UEFI

echo Extracting XBL Image...
tools\UEFIReader.exe extracted\xbl.elf output\UEFI

mkdir output\UEFI\ABL

echo Extracting ABL Image...
tools\UEFIReader.exe extracted\abl.elf output\UEFI\ABL

REM TODO: Get list of supported PM resources from AOP directly
REM TODO: Extract QUP FW individual files
REM TODO: devcfg parser?

:eof
exit /b 0

:checkRKH
set x=INVALID
for /F "eol=; tokens=1-2 delims=" %%a in ('tools\RKHReader.exe %1 2^>^&1') do (set x=%%a)

echo.
echo File: %1
echo RKH : %x%
echo.
set directory=%~dp1
call set directory=%%directory:%cd%=%%

if %x%==%RKH% (
    exit /b 1
)

if %x%==FAIL! (
    exit /b 2
)

if %x%==EXCEPTION! (
    exit /b 2
)

echo %1 is a valid MBN file and is not production signed (%x%). Moving...
mkdir unsigned\%directory%
move %1 unsigned\%directory%
exit /b 0

:moveUnsigned
echo.
echo File: %1
echo.
set directory=%~dp1
call set directory=%%directory:%cd%=%%

echo %1 is a valid MBN file and is not signed. Moving...
mkdir unsigned\%directory%
move %1 unsigned\%directory%
exit /b 0