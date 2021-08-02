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
	Public oda As B4XView
	Public adsoyad As B4XView
	Public otutar As B4XView
	Public ttutar As B4XView
	Public ogtutar As B4XView
	Public rez As B4XView
	Private tutar As B4XView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 450, 410)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	frm.RootPane.LoadLayout("yeniDuzenle")
	neweditform.LoadLayout("yeniDuzenleFatura", -1, 340)
	btnaction.Text = "Faturayı Öde"
	frm.Title = "Fatura Ödeme | Otel Rezervasyon Sistemi"
	frm.Show
End Sub

Private Sub btngeri_Click
	FormFaturalar.Show
	frm.Close
End Sub

Private Sub btnaction_Click
	If tutar.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen ödenecek tutarı giriniz!", "Uyarı!")
		Return
	End If
	
	If Not(IsNumber(tutar.Text)) Or tutar.Text < 1 Then
		xui.MsgboxAsync("Ödenecek tutar sadece sayılardan oluşabilir ve 0'dan büyük olmalıdır!", "Uyarı!")
		Return
	End If
	
	If tutar.Text > ogtutar.Text Then
		xui.MsgboxAsync("Ödenecek tutar, ödenmesi gereken tutardan büyük olamaz!", "Uyarı!")
		Return
	End If

	wait for(xui.Msgbox2Async("Müşterinin faturasını ödemek istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
	If confirm = xui.DialogResponse_Positive Then
		database.odeFatura(rez.Text, tutar.Text)
		FormFaturalar.ShowMsg("Müşterinin faturası başarıyla ödendi!", "Uyarı!")
		frm.close
	End If
End Sub

Private Sub tutar_TextChanged (Old As String, New As String)
	If IsNumber(New) And New > ogtutar.Text Then
		tutar.Text = ogtutar.Text
	End If
End Sub