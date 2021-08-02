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
	Private yabanci As B4XView
	Private yerli As B4XView
	Public oda As B4XView
	Public tip As B4XView
	Public fiyat As B4XView
	Public tutar As B4XView
	Public aktifrez As TableView
	Public rezempty As B4XView
	Private bastarih As DatePicker
	Private bittarih As DatePicker
	Private ulke As ComboBox
	Private pass As TextField
	Private tc As TextField
	Private ad As TextField
	Private soyad As TextField
	Private tel As TextField
	Private uyrukyabanci As RadioButton
	Private uyrukyerli As RadioButton
	Private cine As RadioButton
	Private cink As RadioButton
	Private dtarih As DatePicker
	Private neweditform As ScrollPane
	Private btnaction As B4XView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 610, 600)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	frm.RootPane.LoadLayout("yeniDuzenle")
	neweditform.LoadLayout("yeniRezervasyon", 580, 640)
	btnaction.Text = "Oluştur"
	frm.Title = "Rezervasyon Oluştur | Otel Rezervasyon Sistemi"
	bastarih.DateTicks = DateTime.Now
	bittarih.DateTicks = DateTime.Add(DateTime.Now, 0, 0, 1)
	dtarih.DateTicks = DateTime.Add(DateTime.Now, -18, 0, 0)
	
	For i = 0 To database.ulkeler.Size-1
		Dim m As Map = database.ulkeler.Get(i)
		ulke.Items.Add(m.Get("nicename"))
	Next
	
	frm.Show
End Sub

Public Sub checkTarih As Boolean
	Dim result As Boolean = True
	If database.aktifOdaRez.Size > 0 Then
		For i = 0 To database.aktifOdaRez.Size-1
			Dim m As Map = database.aktifOdaRez.Get(i)
			Dim tanbastarih As Long = bastarih.DateTicks/DateTime.TicksPerSecond
			Dim tanbittarih As Long = bittarih.DateTicks/DateTime.TicksPerSecond
			Dim aktifbastarih As Long = m.Get("bas_tarih")
			Dim aktifbittarih As Long = m.Get("bit_tarih")
			If (tanbastarih >= aktifbastarih And tanbastarih <= aktifbittarih) Or (tanbittarih >= aktifbastarih And tanbittarih <= aktifbittarih) Then
				result = False
				Exit
			End If
		Next
	End If
	Return result
End Sub

Private Sub calcTutar
	Dim gun As Int = (bittarih.DateTicks - bastarih.DateTicks)/DateTime.TicksPerDay
	tutar.Text = gun * fiyat.Text
End Sub

Private Sub btngeri_Click
	FormRezervasyonlar.Show
	frm.Close
End Sub

Private Sub btnaction_Click
	If Not(checkTarih) Then
		xui.MsgboxAsync("Bu tarih aralığında aktif bir rezervasyon bulunmaktadır, lütfen başka bir tarih aralığı belirleyiniz!", "Uyarı!")
		Return
	End If
	Dim newiso As String
	Dim newoda As Int = oda.Text
	Dim newbas_tarih As Int = bastarih.DateTicks/DateTime.TicksPerSecond
	Dim newbit_tarih As Int = bittarih.DateTicks/DateTime.TicksPerSecond
	Dim newtutar As Double = tutar.Text
	Dim newtc_pass As String
	Dim newulke As String
	Dim newadi As String
	Dim newsoyadi As String
	Dim newd_tarih As Long
	Dim newcinsiyet As String
	Dim newtel As String
	If uyrukyerli.Selected Or uyrukyabanci.Selected Then
		If uyrukyerli.Selected Then
			If tc.Text.Length < 11 Then
				xui.MsgboxAsync("Lütfen rezervasyon yapan kişinin T.C. kimlik numarasını giriniz!", "Uyarı!")
				Return
			End If
			newulke = "Turkey"
			newtc_pass = tc.Text
		End If
		If uyrukyabanci.Selected Then
			If pass.Text.Length < 1 Then
				xui.MsgboxAsync("Lütfen rezervasyon yapan kişinin pasaport numarasını giriniz!", "Uyarı!")
				Return
			End If
			If ulke.SelectedIndex >= 0 Then
				newulke = ulke.Items.Get(ulke.SelectedIndex)
				newiso = database.getIso(newulke)
			Else
				xui.MsgboxAsync("Lütfen rezervasyon yapan kişinin ülkesini seçiniz!", "Uyarı!")
				Return
			End If
			newtc_pass = newiso&pass.Text
		End If
	Else
		xui.MsgboxAsync("Lütfen rezervasyon yapan kişinin uyruğunu belirleyiniz!", "Uyarı!")
		Return
	End If
	
	If cine.Selected Or cink.Selected Then
		If cine.Selected Then
			newcinsiyet = "E"
		Else
			newcinsiyet = "K"
		End If
	Else
		xui.MsgboxAsync("Lütfen rezervasyon yapan kişinin cinsiyetini belirleyiniz!", "Uyarı!")
		Return
	End If
	
	If dtarih.DateTicks >= DateTime.Add(DateTime.Now, -18, 0, 0) Then
		xui.MsgboxAsync("Rezervasyonu yapan kişi, 18 yaşını doldurmuş olmalıdır!", "Uyarı!")
		Return
	End If
	
	If ad.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen rezervasyon yapan kişinin adını giriniz!", "Uyarı!")
		Return
	End If
	If soyad.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen rezervasyon yapan kişinin soyadını giriniz!", "Uyarı!")
		Return
	End If
	If tel.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen rezervasyon yapan kişinin telefon numarasını giriniz!", "Uyarı!")
		Return
	End If
	newadi = ad.Text
	newsoyadi = soyad.Text
	newtel = tel.Text
	newd_tarih = dtarih.DateTicks/DateTime.TicksPerSecond
	
	wait for(xui.Msgbox2Async("Rezervasyonu oluşturmak istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
	If confirm = xui.DialogResponse_Positive Then
		database.addRez(newtc_pass, newulke, newadi, newsoyadi, newd_tarih, newcinsiyet, newtel, newoda, newbas_tarih, newbit_tarih, newtutar)
		FormRezervasyonlar.ShowMsg("Rezervasyon başarıyla oluşturuldu!", "Uyarı!")
		frm.close
	End If
End Sub

Private Sub uyrukyabanci_SelectedChange(Selected As Boolean)
	If Selected Then
		yabanci.Visible = True
		yerli.Visible = False
	Else
		yabanci.Visible = False
		yerli.Visible = True
	End If
End Sub

Private Sub bittarih_ValueChanged (Value As Long)
	If Value <= bastarih.DateTicks Then
		xui.MsgboxAsync("Ayrılış tarihi, geliş tarihinden önce yada aynı olamaz!", "Uyarı!")
		bittarih.DateTicks = DateTime.Add(bastarih.DateTicks, 0, 0, 1)
	End If
	calcTutar
End Sub

Private Sub bastarih_ValueChanged (Value As Long)
	If Value < DateTime.Now Then
		If Not(DateTime.Date(Value) = DateTime.Date(DateTime.Now)) Then
			xui.MsgboxAsync("Geliş tarihi, bugünün tarihinden önce olamaz!", "Uyarı!")
			bastarih.DateTicks = DateTime.Now
		End If
	End If
	If Value >= bittarih.DateTicks Then
		xui.MsgboxAsync("Geliş tarihi, ayrılış tarihinden sonra yada aynı olamaz!", "Uyarı!")
		bittarih.DateTicks = DateTime.Add(Value, 0, 0, 1)
	End If
	calcTutar
End Sub

Private Sub pass_TextChanged (Old As String, New As String)
	If New.Length > 9 Then
		pass.Text = Old
	End If
End Sub

Private Sub tc_TextChanged (Old As String, New As String)
	If New.Length > 11 Then
		tc.Text = Old
	End If
End Sub

Private Sub ad_TextChanged (Old As String, New As String)
	If New.Length > 32 Then
		ad.Text = Old
	End If
End Sub

Private Sub soyad_TextChanged (Old As String, New As String)
	If New.Length > 32 Then
		soyad.Text = Old
	End If
End Sub

Private Sub tel_TextChanged (Old As String, New As String)
	If New.Length > 32 Then
		tel.Text = Old
	End If
End Sub