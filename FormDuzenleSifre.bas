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
	Private neweditform As ScrollPane
	Private btnaction As B4XView
	Private esifre As B4XView
	Private ysifre As B4XView
	Private ysifre2 As B4XView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 350, 300)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	frm.RootPane.LoadLayout("yeniDuzenle")
	frm.Title = "Şifre Değiştir | Otel Rezervasyon Sistemi"
	neweditform.LoadLayout("yeniDuzenleSifre", -1, 210)
	btnaction.Text = "Değiştir"
	frm.Show
End Sub

Private Sub btngeri_Click
	FormKullanici.Show
	frm.Close
End Sub

Private Sub btnaction_Click
	If esifre.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen eski şifrenizi giriniz!", "Uyarı!")
		Return
	End If
	
	If Not(database.checkSifre(esifre.Text)) Then
		xui.MsgboxAsync("Eski şifreniz yanlış, Lütfen eski şifrenizi doğru giriniz!", "Uyarı!")
		Return
	End If
	
	If ysifre.Text.Length < 1 Or ysifre2.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen yeni şifrenizi ve tekrarını giriniz!", "Uyarı!")
		Return
	End If
	
	If Not(ysifre2.Text = ysifre.Text) Then
		xui.MsgboxAsync("Yeni şifre ile tekrarı, birbiriyle uyuşmuyor!", "Uyarı!")
		Return
	End If
	
	wait for(xui.Msgbox2Async("Şifrenizi değiştirmek istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
	If confirm = xui.DialogResponse_Positive Then
		database.modSifre(database.userData.Get("k_adi"), ysifre.Text)
		FormLogin.ShowMsg("Şifreniz başarıyla değiştirildi. Lütfen tekrar giriş yapınız!", "Uyarı!")
		frm.close
	End If
End Sub