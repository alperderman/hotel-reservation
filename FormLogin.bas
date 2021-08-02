B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.8
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private xui As XUI
	Private frm As Form
	Private TextField2 As B4XView
	Private TextField1 As B4XView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 600, 600)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	frm.RootPane.LoadLayout("login")
	frm.Show
End Sub

Public Sub ShowMsg(text As String, title As String)
	Show
	xui.MsgboxAsync(text, title)
End Sub

Sub Button1_Click
	Dim username As String = TextField1.Text
	Dim password As String = TextField2.Text
	Dim check As Boolean = database.Login(username, password)
	If check Then
		FormMenu.Show
		frm.Close
	Else
		xui.MsgboxAsync("Kullanıcı adı veya şifre yanlış!", "Uyarı!")
	End If
End Sub
