#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=InternetSwitch
#AutoIt3Wrapper_Res_Fileversion=1.0.1.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductName=Khieudeptrai
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © Khieudeptrai
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>

_Singleton(@ScriptName)

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1) ; Enable TrayOnEventMode.

; Write a key run.
Local $sfilePath
$sfilePath = @ScriptDir & "\" & @ScriptName
RegWrite("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run", "InternetSwitch", "REG_SZ", $sfilePath)

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

Func EnableEthernet()
    RunWait('netsh interface set interface "Ethernet" enable',"",@SW_Hide)
	RunWait('netsh interface set interface "Wi-Fi 2" disable',"",@SW_Hide)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD","0x000001")
EndFunc

Func EnableWifi()
    RunWait('netsh interface set interface "Ethernet" disable',"",@SW_Hide)
	RunWait('netsh interface set interface "Wi-Fi 2" enable',"",@SW_Hide)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD","0x000000")
EndFunc

Func EnableAll()
    RunWait('netsh interface set interface "Ethernet" enable',"",@SW_Hide)
	RunWait('netsh interface set interface "Wi-Fi 2" enable',"",@SW_Hide)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD","0x000001")
EndFunc

Func OnAbout()
	MsgBox($MB_SYSTEMMODAL, "About", "Khieudeptrai")
EndFunc   ;==>About

Func OnExit()
    Exit
EndFunc
