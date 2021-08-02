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
	Private ad As TextField
	Private soyad As TextField
	Private cine As RadioButton
	Private cink As RadioButton
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 350, 300)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	frm.RootPane.LoadLayout("yeniDuzenle")
	frm.Title = "Kullanıcı Ayarları | Otel Rezervasyon Sistemi"
	neweditform.LoadLayout("kullanici", -1, 230)
	ad.Text = database.userData.Get("adi")
	soyad.Text = database.userData.Get("soyadi")
	If database.userData.Get("cinsiyet") = "E" Then
		cine.Selected = True
	Else
		cink.Selected = True
	End If
	btnaction.Text = "Kaydet"
	frm.Show
	CallSubDelayed(Me,"resetTF")
End Sub

Private Sub resetTF
	ad.SetSelection(ad.Text.Length, ad.Text.Length)
End Sub

Public Sub ShowMsg(text As String, title As String)
	Show
	xui.MsgboxAsync(text, title)
End Sub

Private Sub btngeri_Click
	FormMenu.Show
	frm.Close
End Sub

Private Sub btnaction_Click
	If ad.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen isim giriniz!", "Uyarı!")
		Return
	End If
	
	If soyad.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen soyisim giriniz!", "Uyarı!")
		Return
	End If
	
	Dim newcinsiyet As String
	
	If cine.Selected Or cink.Selected Then
		If cine.Selected Then
			newcinsiyet = "E"
		Else
			newcinsiyet = "K"
		End If
	Else
		xui.MsgboxAsync("Lütfen bir cinsiyet seçiniz!", "Uyarı!")
		Return
	End If
	
	wait for(xui.Msgbox2Async("Kullanıcı ayarlarını değiştirmek istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
	If confirm = xui.DialogResponse_Positive Then
		database.modKullanici(database.userData.Get("k_adi"), ad.Text, soyad.Text, newcinsiyet)
		FormLogin.ShowMsg("Kullanıcı ayarları başarıyla değiştirildi. Lütfen tekrar giriş yapınız!", "Uyarı!")
		frm.close
	End If
End Sub

Private Sub sifred_Click
	FormDuzenleSifre.Show
	frm.Close
End Sub