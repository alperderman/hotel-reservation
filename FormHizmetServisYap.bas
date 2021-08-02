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
	Private hizmetcat As ComboBox
	Private catkathiztext As String = "Kat Hizmeti"
	Private cataktivtext As String = "Otel İçi Aktivite"
	Private catyicktext As String = "Yiyecek İçecek"
	Private adet As B4XView
	Private tutar As B4XView
	Private rezempty As B4XView
	Private adetpane As B4XView
	Private reztable As TableView
	Private hizmettable As TableView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 450, 600)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	frm.RootPane.LoadLayout("yeniDuzenle")
	neweditform.LoadLayout("hizmetServisYap", -1, 450)
	btnaction.Text = "Servis Yap"
	database.refreshAktifRez
	database.refreshHizmetler
	frm.Title = "Hizmet Servisi Yap | Otel Rezervasyon Sistemi"
	For i = 0 To database.hizmetCat.Size-1
		Dim m As Map = database.hizmetCat.Get(i)
		hizmetcat.Items.Add(m.Get("cat_adi"))
	Next
	fillRez
	fillHizmet(database.hizmetlerYick)
	hizmetcat.SelectedIndex = 0
	frm.Show
End Sub

Public Sub ShowMsg(text As String, title As String)
	Show
	xui.MsgboxAsync(text, title)
End Sub

Private Sub fillRez
	If database.aktifRez.Size > 0 Then
		reztable.Items.Clear
		reztable.SetColumns(Array As String("Oda", "Adı", "Soyadı"))
		Main.setTableColumnWidths(reztable, Array As Double(0,-60,-60))
		For i = 0 To database.aktifRez.Size-1
			Dim m As Map = database.aktifRez.Get(i)
			Dim Row() As Object = Array (m.Get("oda"), m.Get("adi"), m.Get("soyadi"))
			reztable.Items.Add(Row)
		Next
		reztable.Visible = True
		rezempty.Visible = False
	Else
		reztable.Visible = False
		rezempty.Visible = True
	End If
End Sub

Public Sub fillHizmet(catlist As List)
	hizmettable.Items.Clear
	hizmettable.SetColumns(Array As String("ID", "Hizmet Adı", "Fiyat"))
	Main.setTableColumnWidths(hizmettable, Array As Double(0,-60,0))
	For i = 0 To catlist.Size-1
		Dim m As Map = catlist.Get(i)
		Dim Row() As Object = Array (m.Get("hizmet_id"), m.Get("hizmet_adi"), m.Get("fiyat"))
		hizmettable.Items.Add(Row)
	Next
End Sub

Private Sub btngeri_Click
	FormHizmetServis.Show
	frm.Close
End Sub

Private Sub hizmetcat_SelectedIndexChanged(Index As Int, Value As Object)
	If Value = catkathiztext Then
		fillHizmet(database.hizmetlerKathiz)
		adetpane.Visible = False
	Else If Value = cataktivtext Then
		fillHizmet(database.hizmetlerAktiv)
		adetpane.Visible = False
	Else If Value = catyicktext Then
		fillHizmet(database.hizmetlerYick)
		adetpane.Visible = True
	End If
	adet.Text = ""
	adet.Enabled = False
	tutar.Text = ""
End Sub

Private Sub adet_TextChanged (Old As String, New As String)
	Dim toplam As Double = 0
	If hizmettable.SelectedRow >= 0 Then
		Dim itemfiyat As Int = hizmettable.SelectedRowValues(2)
		If IsNumber(New) And New > 0 Then
			toplam = New * itemfiyat
		End If
	End If
	tutar.Text = toplam
End Sub

Private Sub btnaction_Click
	If Not(reztable.SelectedRow >= 0) Then
		xui.MsgboxAsync("Lütfen bir oda seçiniz!", "Uyarı!")
		Return
	End If
	
	If hizmetcat.SelectedIndex < 0 Then
		xui.MsgboxAsync("Lütfen bir hizmet kategorisi seçiniz!", "Uyarı!")
		Return
	End If
	
	If Not(hizmettable.SelectedRow >= 0) Then
		xui.MsgboxAsync("Lütfen bir hizmet seçiniz!", "Uyarı!")
		Return
	End If
	
	If adet.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen hizmetin adetini giriniz!", "Uyarı!")
		Return
	End If
	
	If Not(IsNumber(adet.Text)) Or adet.Text < 1 Then
		xui.MsgboxAsync("Hizmet adeti sadece sayılardan oluşabilir ve 0'dan büyük olmalıdır!", "Uyarı!")
		Return
	End If
	
	Dim odaid As Int = reztable.SelectedRowValues(0)
	Dim hizmetid As Int = hizmettable.SelectedRowValues(0)
	Dim hizmetadi As String= hizmettable.SelectedRowValues(1)
	
	If hizmetcat.Items.Get(hizmetcat.SelectedIndex) = catkathiztext Or hizmetcat.Items.Get(hizmetcat.SelectedIndex) = cataktivtext Then
		If database.checkServis(odaid, hizmetid) Then
			xui.MsgboxAsync("Bu odanın müşterisi için, daha önceden "&hizmetadi&" hizmetinin faturası eklenmiş. Kat hizmeti ve otel içi aktiviteler için müşteriler sadece tek ödeme yapabilir!", "Uyarı!")
			Return
		End If
	End If
	
	wait for(xui.Msgbox2Async("Hizmet servisi yapmak istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
	If confirm = xui.DialogResponse_Positive Then
		database.addServis(odaid, hizmetid, adet.Text, tutar.Text)
		FormHizmetServis.ShowMsg("Hizmet başarıyla servis edildi ve müşterinin faturasına eklendi!", "Uyarı!")
		frm.close
	End If
End Sub

Private Sub hizmettable_SelectedRowChanged(Index As Int, Row() As Object)
	If Index >= 0 Then
		Dim itemfiyat As Int = hizmettable.SelectedRowValues(2)
		adet.Text = 1
		tutar.Text = itemfiyat
		adet.Enabled = True
	End If
End Sub