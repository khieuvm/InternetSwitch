#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=InternetSwitch
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductName=Khieudeptrai
#AutoIt3Wrapper_Res_CompanyName=KhieuVM
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © KhieuVM
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>

_Singleton(@ScriptName)

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1) ; Enable TrayOnEventMode.
Opt("GUIOnEventMode", 1) ; Change to OnEvent mode

Main()

Func Main()
	Local $idConfig = TrayCreateItem("Enable Wifi")
	TrayItemSetOnEvent(-1, "EnableWifi")

	Local $idExit = TrayCreateItem("Disable Wifi")
	TrayItemSetOnEvent(-1, "DisableWifi")

	Local $idAbout = TrayCreateItem("About")
	TrayItemSetOnEvent(-1, "OnAbout")

	Local $idExit = TrayCreateItem("Exit")
	TrayItemSetOnEvent(-1, "OnExit")

	TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.
	TraySetClick(16) ; Show the tray menu when the mouse if hovered over the tray icon.

	TraySetToolTip("InternetSwitch")
	TraySetIcon("icon.ico")
	While 1			;loop forever
		sleep(1000)
	WEnd
EndFunc

Func DisableWifi()
    RunWait('netsh interface set interface "Ethernet" enable',"",@SW_Hide)
	RunWait('netsh interface set interface "Wi-Fi 2" disable',"",@SW_Hide)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD","0x000001")
EndFunc

Func EnableWifi()
    RunWait('netsh interface set interface "Ethernet" disable',"",@SW_Hide)
	RunWait('netsh interface set interface "Wi-Fi 2" enable',"",@SW_Hide)
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD","0x000000")
EndFunc

Func OnAbout()
	MsgBox($MB_SYSTEMMODAL, "About", "Khieudeptrai")
EndFunc   ;==>About

Func OnExit()
    Exit
EndFunc
