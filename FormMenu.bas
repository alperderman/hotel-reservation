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
	Private Label2 As B4XView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 600, 600)
		frm.RootPane.LoadLayout("menu")
	End If
	Label2.Text = database.userData.Get("adi") & " " & database.userData.Get("soyadi")
	frm.Show
	CallSubDelayed(Me, "setTextSize")
End Sub

Public Sub ShowMsg(text As String, title As String)
	Show
	xui.MsgboxAsync(text, title)
End Sub

Private Sub setTextSize
	Label2.Width = Main.MeasureTextWidth(CreateMap("text": Label2.Text, "font": Label2.Font))+15
	Label2.Left = frm.RootPane.Width - Label2.Width
End Sub

Private Sub Button7_Click
	database.userData.Clear
	FormLogin.Show
	frm.Close
End Sub

Private Sub Button1_Click
	FormRezervasyonlar.Show
	frm.Close
End Sub

Private Sub Button2_Click
	FormOdalar.Show
	frm.Close
End Sub

Private Sub Button3_Click
	FormHizmetler.Show
	frm.Close
End Sub

Private Sub Button4_Click
	FormHizmetServis.Show
	frm.Close
End Sub

Private Sub Button5_Click
	FormFaturalar.Show
	frm.Close
End Sub

Private Sub Button6_Click
	FormKullanici.Show
	frm.Close
End Sub