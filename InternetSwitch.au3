#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=InternetSwitch
#AutoIt3Wrapper_Res_Fileversion=1.0.1.2
#AutoIt3Wrapper_Res_ProductName=Khieudeptrai
#AutoIt3Wrapper_Res_ProductVersion=1.0.1.2
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © Khieudeptrai
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>

_Singleton(@ScriptName)

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1) ; Enable TrayOnEventMode.

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
Main()

Func Main()
	TrayCreateItem("Enable Only Wifi")
	TrayItemSetOnEvent(-1, "EnableWifi")

	TrayCreateItem("Enable Only Ethernet")
	TrayItemSetOnEvent(-1, "EnableEthernet")

	TrayCreateItem("Enable All")
	TrayItemSetOnEvent(-1, "EnableAll")

	TrayCreateItem("About")
	TrayItemSetOnEvent(-1, "OnAbout")

	TrayCreateItem("Exit")
	TrayItemSetOnEvent(-1, "OnExit")

	TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.
	TraySetClick(16) ; Show the tray menu when the mouse if hovered over the tray icon.

	TraySetToolTip("InternetSwitch")
	TraySetIcon("icon.ico")
	While 1			;loop forever
		sleep(1000)
	WEnd
EndFunc

Func ReadIniFile()
   $Ethernet_Name = IniRead($IniFile, "Config", "Enthernet_Name", $Ethernet_Name_Default)
   $Wifi_Name = IniRead($IniFile, "Config", "Wifi_Name", $Wifi_Name_Default)
EndFunc

Func EnableEthernet()
    RunWait('netsh interface set interface "' & $Ethernet_Name & '" enable',"",@SW_Hide)
	RunWait('netsh interface set interface "' & $Wifi_Name & '" disable',"",@SW_Hide)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD","0x000001")
EndFunc

Func EnableWifi()
    RunWait('netsh interface set interface "' & $Ethernet_Name & '" disable',"",@SW_Hide)
	RunWait('netsh interface set interface "' & $Wifi_Name & '" enable',"",@SW_Hide)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD","0x000000")
EndFunc

Func EnableAll()
    RunWait('netsh interface set interface "' & $Ethernet_Name & '" enable',"",@SW_Hide)
	RunWait('netsh interface set interface "' & $Wifi_Name & '" enable',"",@SW_Hide)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD","0x000001")
EndFunc

Func OnAbout()
	MsgBox($MB_SYSTEMMODAL, "About", "Khieudeptrai")
EndFunc   ;==>About

Func OnExit()
    Exit
EndFunc
