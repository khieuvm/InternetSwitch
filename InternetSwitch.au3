#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=InternetSwitch
#AutoIt3Wrapper_Res_Fileversion=1.0.1.3
#AutoIt3Wrapper_Res_ProductName=Khieudeptrai
#AutoIt3Wrapper_Res_ProductVersion=1.0.1.3
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © Khieudeptrai
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>
#include <Constants.au3>

_Singleton(@ScriptName)

Opt("TrayMenuMode", 3)

Global Const $IniFile = "Config.ini"
Global $Ethernet_Name
Global $Ethernet_Name_Default = "Ethernet"
Global $Wifi_Name
Global $Wifi_Name_Default = "Wi-Fi"

; Write a key run.
Local $sfilePath
$sfilePath = @ScriptDir & "\" & @ScriptName
RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run", "InternetSwitch", "REG_SZ", $sfilePath)

ReadIniFile()

Global $idCheckWifi		= TrayCreateItem("Wifi")
TrayCreateItem("")

Global $idCheckEthernet	= TrayCreateItem("Ethernet")
TrayCreateItem("")

Global $idCheckProxy	= TrayCreateItem("Proxy")
TrayCreateItem("")

Global $idAbout			= TrayCreateItem("About")
TrayCreateItem("")

Global $idExit			= TrayCreateItem("Exit")

TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.
TraySetClick(16) ; Show the tray menu when the mouse if hovered over the tray icon.

TraySetToolTip("InternetSwitch")
TraySetIcon("icon.ico")

CheckStatus()

While 1
	Switch TrayGetMsg()
        Case $idCheckWifi
            CheckWifi()

        Case $idCheckEthernet
            CheckEthernet()

        Case $idCheckProxy
            CheckProxy()

        Case $idAbout
			OnAbout()

        Case $idExit
            OnExit()
	EndSwitch
	Sleep(20)
WEnd

Exit

Func ReadIniFile()
   $Ethernet_Name = IniRead($IniFile, "Config", "Enthernet_Name", $Ethernet_Name_Default)
   $Wifi_Name = IniRead($IniFile, "Config", "Wifi_Name", $Wifi_Name_Default)
EndFunc

Func CheckStatus()
	$sttWifi = Run(@ComSpec & ' /c netsh interface show interface "' & $Wifi_Name & '" | findstr Enable',"",@SW_Hide, $STDOUT_CHILD)
	While 1
		$line = StdoutRead($sttWifi)
		If @error Then ExitLoop
		If $line Then TrayItemSetState($idCheckWifi, $TRAY_CHECKED)
	Wend
	$sttEthernet = Run(@ComSpec & ' /c netsh interface show interface "' & $Ethernet_Name & '" | findstr Enable',"",@SW_Hide, $STDOUT_CHILD)
	While 1
		$line = StdoutRead($sttEthernet)
		If @error Then ExitLoop
		If $line Then TrayItemSetState($idCheckEthernet, $TRAY_CHECKED)
	Wend
	$sttProxy = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable")
	If $sttProxy = 1 Then TrayItemSetState($idCheckProxy, $TRAY_CHECKED)
EndFunc

Func CheckWifi()
	If BitAND(TrayItemGetState($idCheckWifi), $TRAY_CHECKED) = $TRAY_CHECKED Then
		TrayItemSetState($idCheckWifi, $TRAY_UNCHECKED)
        RunWait('netsh interface set interface "' & $Wifi_Name & '" disable',"",@SW_Hide)
    Else
        TrayItemSetState($idCheckWifi, $TRAY_CHECKED)
        RunWait('netsh interface set interface "' & $Wifi_Name & '" enable',"",@SW_Hide)
    EndIf
EndFunc

Func CheckEthernet()
	If BitAND(TrayItemGetState($idCheckEthernet), $TRAY_CHECKED) = $TRAY_CHECKED Then
		TrayItemSetState($idCheckEthernet, $TRAY_UNCHECKED)
        RunWait('netsh interface set interface "' & $Ethernet_Name & '" disable',"",@SW_Hide)
    Else
        TrayItemSetState($idCheckEthernet, $TRAY_CHECKED)
        RunWait('netsh interface set interface "' & $Ethernet_Name & '" enable',"",@SW_Hide)
    EndIf
EndFunc

Func CheckProxy()
	If BitAND(TrayItemGetState($idCheckProxy), $TRAY_CHECKED) = $TRAY_CHECKED Then
		TrayItemSetState($idCheckProxy, $TRAY_UNCHECKED)
		RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD","0x000000")
    Else
        TrayItemSetState($idCheckProxy, $TRAY_CHECKED)
		RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD","0x000001")
    EndIf
EndFunc

Func OnAbout()
	MsgBox($MB_SYSTEMMODAL, "About", "Khieudeptrai")
EndFunc

Func OnExit()
    Exit
EndFunc
