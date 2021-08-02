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
	Private TabPane1 As TabPane
	Private kathizselected As Int
	Private aktivselected As Int
	Private yickselected As Int
	Private tabkathiztext As String = "Kat Hizmetleri"
	Private tabaktivtext As String = "Otel İçi Aktiviteler"
	Private tabyicktext As String = "Yiyecek ve İçecekler"
	Private listview1 As CustomListView
	Private listview2 As CustomListView
	Private listview3 As CustomListView
	Private id As B4XView
	Private adi As B4XView
	Private fiyat As B4XView
	Private btnduzenle As B4XView
	Private btnsil As B4XView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 600, 600)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	kathizselected = -1
	aktivselected = -1
	yickselected = -1
	database.refreshHizmetler
	frm.RootPane.LoadLayout("hizmetler")
	TabPane1.LoadLayout("listView1", tabkathiztext)
	TabPane1.LoadLayout("listView2", tabaktivtext)
	TabPane1.LoadLayout("listView3", tabyicktext)
	fillKathizList
	fillAktivList
	fillYickList
	frm.Show
End Sub

Public Sub ShowMsg(text As String, title As String)
	Show
	xui.MsgboxAsync(text, title)
End Sub

Private Sub fillKathizList
	listview1.Clear
	For i = 0 To database.hizmetlerKathiz.Size-1
		Dim m As Map = database.hizmetlerKathiz.Get(i)
		Dim p As B4XView = xui.CreatePanel("")
		p.LoadLayout("listHizmetler")
		id.Text = m.Get("hizmet_id")
		adi.Text = m.Get("hizmet_adi")
		fiyat.Text = m.Get("fiyat")
		p.SetLayoutAnimated(0, 0, 0, listview1.AsView.Width, 90)
		listview1.Add(p, "")
	Next
End Sub

Private Sub fillAktivList
	listview2.Clear
	For i = 0 To database.hizmetlerAktiv.Size-1
		Dim m As Map = database.hizmetlerAktiv.Get(i)
		Dim p As B4XView = xui.CreatePanel("")
		p.LoadLayout("listHizmetler")
		id.Text = m.Get("hizmet_id")
		adi.Text = m.Get("hizmet_adi")
		fiyat.Text = m.Get("fiyat")
		p.SetLayoutAnimated(0, 0, 0, listview2.AsView.Width, 90)
		listview2.Add(p, "")
	Next
End Sub

Private Sub fillYickList
	listview3.Clear
	For i = 0 To database.hizmetlerYick.Size-1
		Dim m As Map = database.hizmetlerYick.Get(i)
		Dim p As B4XView = xui.CreatePanel("")
		p.LoadLayout("listHizmetler")
		id.Text = m.Get("hizmet_id")
		adi.Text = m.Get("hizmet_adi")
		fiyat.Text = m.Get("fiyat")
		p.SetLayoutAnimated(0, 0, 0, listview3.AsView.Width, 90)
		listview3.Add(p, "")
	Next
End Sub

Private Sub listview1_ItemClick (Index As Int, Value As Object)
	If kathizselected >= 0 Then
		CSSUtils.SetBackgroundColor(listview1.GetPanel(kathizselected), fx.Colors.Transparent)
	End If
	CSSUtils.SetBackgroundColor(listview1.GetPanel(Index), fx.Colors.RGB(102, 170, 223))
	kathizselected = Index
	btnduzenle.Visible = True
	btnsil.Visible = True
End Sub

Private Sub listview2_ItemClick (Index As Int, Value As Object)
	If aktivselected >= 0 Then
		CSSUtils.SetBackgroundColor(listview2.GetPanel(aktivselected), fx.Colors.Transparent)
	End If
	CSSUtils.SetBackgroundColor(listview2.GetPanel(Index), fx.Colors.RGB(102, 170, 223))
	aktivselected = Index
	btnduzenle.Visible = True
	btnsil.Visible = True
End Sub

Private Sub listview3_ItemClick (Index As Int, Value As Object)
	If yickselected >= 0 Then
		CSSUtils.SetBackgroundColor(listview3.GetPanel(yickselected), fx.Colors.Transparent)
	End If
	CSSUtils.SetBackgroundColor(listview3.GetPanel(Index), fx.Colors.RGB(102, 170, 223))
	yickselected = Index
	btnduzenle.Visible = True
	btnsil.Visible = True
End Sub

Private Sub TabPane1_TabChanged (SelectedTab As TabPage)
	If (SelectedTab.Text = tabkathiztext And kathizselected >= 0) Or (SelectedTab.Text = tabaktivtext And aktivselected >= 0) Or (SelectedTab.Text = tabyicktext And yickselected >= 0) Then
		btnduzenle.Visible = True
		btnsil.Visible = True
	Else
		btnduzenle.Visible = False
		btnsil.Visible = False
	End If
End Sub

Private Sub btnyeni_Click
	FormYeniDuzenleHizmet.Show
	FormYeniDuzenleHizmet.frm.Title = "Hizmet Oluştur | Otel Rezervasyon Sistemi"
	FormYeniDuzenleHizmet.id.Text = "Otomatik oluşturulucak!"
	FormYeniDuzenleHizmet.btnaction.Text = "Oluştur"
	FormYeniDuzenleHizmet.btnaction.Tag = "yeni"
	frm.Close
End Sub

Private Sub btnduzenle_Click
	Dim selectedpanel As B4XView
	Dim cattext As String
	If TabPane1.SelectedItem.Text = tabkathiztext Then
		selectedpanel = listview1.GetPanel(kathizselected).GetView(0)
		cattext = "Kat Hizmeti"
	Else If TabPane1.SelectedItem.Text = tabaktivtext Then
		selectedpanel = listview2.GetPanel(aktivselected).GetView(0)
		cattext = "Otel İçin Aktivite"
	Else If TabPane1.SelectedItem.Text = tabyicktext Then
		selectedpanel = listview3.GetPanel(yickselected).GetView(0)
		cattext = "Yiyecek İçecek"
	End If
	FormYeniDuzenleHizmet.Show
	FormYeniDuzenleHizmet.frm.Title = "Hizmeti Düzenle | Otel Rezervasyon Sistemi"
	
	Dim selectedhizmetid As String = selectedpanel.GetView(0).Text
	Dim selectedhizmetad As String = selectedpanel.GetView(1).Text
	Dim selectedhizmetfiyat As String = selectedpanel.GetView(2).Text
	FormYeniDuzenleHizmet.id.Text = selectedhizmetid
	FormYeniDuzenleHizmet.ad.Text = selectedhizmetad
	FormYeniDuzenleHizmet.fiyat.Text = selectedhizmetfiyat
	
	For i = 0 To FormYeniDuzenleHizmet.cat.Items.Size-1
		Dim item As String = FormYeniDuzenleHizmet.cat.Items.Get(i)
		If item = cattext Then
			FormYeniDuzenleHizmet.cat.SelectedIndex = i
			Exit
		End If
	Next
	FormYeniDuzenleHizmet.btnaction.Text = "Kaydet"
	FormYeniDuzenleHizmet.btnaction.Tag = "duzenle"
	
	frm.Close
End Sub

Private Sub Button1_Click
	FormMenu.Show
	frm.Close
End Sub

Private Sub btnsil_Click
	Dim selectedpanel As B4XView
	wait for(xui.Msgbox2Async("Hizmeti silmek istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
	If confirm = xui.DialogResponse_Positive Then
		If TabPane1.SelectedItem.Text = tabkathiztext Then
			selectedpanel = listview1.GetPanel(kathizselected).GetView(0)
			Dim hizmet_id As Int = selectedpanel.GetView(0).Text
			database.remHizmet(hizmet_id)
			xui.MsgboxAsync("Hizmet başarıyla silindi!", "Uyarı!")
			database.refreshHizmetler
			fillKathizList
		Else If TabPane1.SelectedItem.Text = tabaktivtext Then
			selectedpanel = listview2.GetPanel(aktivselected).GetView(0)
			Dim hizmet_id As Int = selectedpanel.GetView(0).Text
			database.remHizmet(hizmet_id)
			xui.MsgboxAsync("Hizmet başarıyla silindi!", "Uyarı!")
			database.refreshHizmetler
			fillAktivList
		Else If TabPane1.SelectedItem.Text = tabyicktext Then
			selectedpanel = listview3.GetPanel(yickselected).GetView(0)
			Dim hizmet_id As Int = selectedpanel.GetView(0).Text
			database.remHizmet(hizmet_id)
			xui.MsgboxAsync("Hizmet başarıyla silindi!", "Uyarı!")
			database.refreshHizmetler
			fillYickList
		End If
	End If
End Sub