#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <TrayConstants.au3>
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <AutoItConstants.au3>
#include <Misc.au3>

Opt("TrayAutoPause", 0)
Opt("GUIOnEventMode", 1)
Opt("WinTitleMatchMode", 2)

;search-ms:query=a query kind:Picture folder:\ -folder:"My Pictures" size:>=512kb<=8mb

If _Singleton(@ScriptName, 1) = 0 Then
   MsgBox(0, "Advanced Search", "Another instance of this tool is already running!")
   Exit
EndIf

FileInstall('assets\License.jpg', @TempDir & '\License.jpg', 1)
Global $link = '\'

Func searchPressed()
   $Query = GUICtrlRead($Query)
   $Kind = GUICtrlRead($Kind)
   $Folder = GUICtrlRead($Folder)
   $Exclude = GUICtrlRead($Exclude)
   $Size = GUICtrlRead($Size)

   $oldClip = ClipGet()
   $Search = $Query & ' kind:' & $Kind & ' folder:' & $Folder & ' -folder:' & $Exclude & ' size:' & $Size
   ClipPut($Search)

   BlockInput(1)
   Send("#f")
   WinWaitActive("Search Results")
   Send("^v")
   ClipPut($oldClip)
   BlockInput(0)

   Exit
EndFunc

Func hideAboutGUI()
   GUISetState(0, $hwAbout)
EndFunc

Func hideMainGUI()
   GUISetState(0, $hwMain)
EndFunc

Func graceQuit()
   Exit
EndFunc

Func aboutGUI()
   global $hwAbout = GUICreate("About", 286, 232)
   GUICtrlCreatePic(@TempDir & "\License.jpg", 0, 0, 286, 232)

   GUISetOnEvent($GUI_EVENT_CLOSE, "hideAboutGUI")
   GUISetState(1)
EndFunc

Func mainGUI()
   Global $hwMain = GUICreate("Advanced Search", 240, 300)
   ;GUISetBkColor(0xFFFFFF)

   GUICtrlCreateLabel("Search Query:", 20, 15)
   Global $Query = GUICtrlCreateInput("", 20, 30, 200, 20)

   GUICtrlCreateLabel("Kind:", 20, 60)
   Global $rawList[7] = ["Picture", "Movie", "Music", "Document", "Folder", "Video", "Program"]
   $kindList = ""
   For $i = 0 To UBound($rawList) - 1
	  $kindList &= "|" & $rawList[$i]
   Next
   Global $Kind = GUICtrlCreateCombo("", 20, 75, 200, 20)
   GUICtrlSetData($Kind, $kindList, "")
   ;global $Kind = GUICtrlCreateInput("Picture", 20, 75, 200, 20)

   GUICtrlCreateLabel("Search Folder:", 20, 105)
   Global $Folder = GUICtrlCreateInput($link, 20, 120, 200, 20)

   GUICtrlCreateLabel("Exclude Directory:", 20, 150)
   Global $Exclude = GUICtrlCreateInput("", 20, 165, 200, 20)

   GUICtrlCreateLabel("Size Range:", 20, 195)
   Global $Size = GUICtrlCreateInput(">=512kb<=8mb", 20, 210, 200, 20)

   GUICtrlCreateButton("Start", 140, 250, 75, 30)
   GUICtrlSetOnEvent(-1, "searchPressed")
   GUICtrlSetState(-1, $GUI_FOCUS)

   GUICtrlCreateButton("About", 20, 250, 75, 30)
   GUICtrlSetOnEvent(-1, "aboutGUI")

   GUISetOnEvent($GUI_EVENT_CLOSE, "graceQuit")
   GUISetState(1)
EndFunc

mainGUI()

While 1
   Sleep(10)
WEnd
