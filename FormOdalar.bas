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
	Private listview1 As CustomListView
	Private odalarselected As Int
	Private oda As B4XView
	Private tabodalartext As String = "Odaları Düzenle"
	Private tabtiplertext As String = "Oda Tiplerini Düzenle"
	Private btnduzenle As B4XView
	Private btnsil As B4XView
	Private listview2 As CustomListView
	Private tiplerselected As Int
	Private otip As B4XView
	Private ttip As B4XView
	Private fiyat As B4XView
	Private alt As B4XView
	Private btnyeni As B4XView
	Private tid As B4XView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 600, 600)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	odalarselected = -1
	tiplerselected = -1
	database.refreshOdalar
	database.refreshTipler
	frm.RootPane.LoadLayout("odalar")
	TabPane1.LoadLayout("listView1", tabodalartext)
	TabPane1.LoadLayout("listView2", tabtiplertext)
	fillTiplerList
	fillOdalarList
	frm.Show
End Sub

Public Sub ShowMsg(text As String, title As String)
	Show
	xui.MsgboxAsync(text, title)
End Sub

Private Sub fillTiplerList
	listview2.Clear
	For i = 0 To database.tipler.Size-1
		Dim m As Map = database.tipler.Get(i)
		Dim p As B4XView = xui.CreatePanel("")
		p.LoadLayout("listTipler")
		ttip.Text = m.Get("tip_adi")
		alt.Text = m.Get("tip_alt")
		fiyat.Text = m.Get("fiyat")
		tid.Text = m.Get("tip_id")
		p.SetLayoutAnimated(0, 0, 0, listview2.AsView.Width, 90)
		listview2.Add(p, "")
	Next
End Sub

Private Sub fillOdalarList
	listview1.Clear
	For i = 0 To database.odalar.Size-1
		Dim m As Map = database.odalar.Get(i)
		Dim p As B4XView = xui.CreatePanel("")
		p.LoadLayout("listOdalar")
		oda.Text = m.Get("oda_id")
		otip.Text = m.Get("tip_adi")
		p.SetLayoutAnimated(0, 0, 0, listview1.AsView.Width, 60)
		listview1.Add(p, "")
	Next
End Sub

Private Sub listview1_ItemClick (Index As Int, Value As Object)
	If odalarselected >= 0 Then
		CSSUtils.SetBackgroundColor(listview1.GetPanel(odalarselected), fx.Colors.Transparent)
	End If
	CSSUtils.SetBackgroundColor(listview1.GetPanel(Index), fx.Colors.RGB(102, 170, 223))
	odalarselected = Index
	btnduzenle.Visible = True
	btnsil.Visible = True
End Sub

Private Sub listview2_ItemClick (Index As Int, Value As Object)
	If tiplerselected >= 0 Then
		CSSUtils.SetBackgroundColor(listview2.GetPanel(tiplerselected), fx.Colors.Transparent)
	End If
	CSSUtils.SetBackgroundColor(listview2.GetPanel(Index), fx.Colors.RGB(102, 170, 223))
	tiplerselected = Index
	btnduzenle.Visible = True
	btnsil.Visible = True
End Sub

Private Sub Button1_Click
	FormMenu.Show
	frm.Close
End Sub

Private Sub TabPane1_TabChanged (SelectedTab As TabPage)
	If (SelectedTab.Text = tabodalartext And odalarselected >= 0) Or (SelectedTab.Text = tabtiplertext And tiplerselected >= 0) Then
		btnduzenle.Visible = True
		btnsil.Visible = True
	Else
		btnduzenle.Visible = False
		btnsil.Visible = False
	End If
	
	If SelectedTab.Text = tabodalartext Then
		btnyeni.Text = "Yeni Oda"
	Else If SelectedTab.Text = tabtiplertext Then
		btnyeni.Text = "Yeni Oda Tipi"
	End If
End Sub


Private Sub btnyeni_Click
	If TabPane1.SelectedItem.Text = tabodalartext Then
		FormYeniDuzenleOda.Show
		FormYeniDuzenleOda.frm.Title = "Oda Oluştur | Otel Rezervasyon Sistemi"
		FormYeniDuzenleOda.oda.Text = "Otomatik oluşturulucak!"
		FormYeniDuzenleOda.btnaction.Text = "Oluştur"
		FormYeniDuzenleOda.btnaction.Tag = "yeni"
	Else If TabPane1.SelectedItem.Text = tabtiplertext Then
		FormYeniDuzenleTip.Show
		FormYeniDuzenleTip.frm.Title = "Oda Tipi Oluştur | Otel Rezervasyon Sistemi"
		FormYeniDuzenleTip.btnaction.Text = "Oluştur"
		FormYeniDuzenleTip.btnaction.Tag = "yeni"
	End If
	
	frm.Close
End Sub

Private Sub btnduzenle_Click
	Dim selectedpanel As B4XView
	If TabPane1.SelectedItem.Text = tabodalartext Then
		FormYeniDuzenleOda.Show
		FormYeniDuzenleOda.frm.Title = "Odayı Düzenle | Otel Rezervasyon Sistemi"
		selectedpanel = listview1.GetPanel(odalarselected).GetView(0)
		Dim selectedodano As String = selectedpanel.GetView(0).Text
		Dim selectedodatip As String = selectedpanel.GetView(1).Text
		FormYeniDuzenleOda.oda.Text = selectedodano
		For i = 0 To FormYeniDuzenleOda.tipler.Items.Size-1
			Dim item As String = FormYeniDuzenleOda.tipler.Items.Get(i)
			If item = selectedodatip Then
				FormYeniDuzenleOda.tipler.SelectedIndex = i
				Exit
			End If
		Next
		FormYeniDuzenleOda.btnaction.Text = "Kaydet"
		FormYeniDuzenleOda.btnaction.Tag = "duzenle"
	Else If TabPane1.SelectedItem.Text = tabtiplertext Then
		FormYeniDuzenleTip.Show
		FormYeniDuzenleTip.frm.Title = "Oda Tipini Düzenle | Otel Rezervasyon Sistemi"
		selectedpanel = listview2.GetPanel(tiplerselected).GetView(0)
		Dim selectedtipadi As String = selectedpanel.GetView(0).Text
		Dim selectedtipalt As String = selectedpanel.GetView(1).Text
		Dim selectedtipfiyat As String = selectedpanel.GetView(2).Text
		Dim selectedtipid As String = selectedpanel.GetView(3).Text
		FormYeniDuzenleTip.ad.Text = selectedtipadi
		FormYeniDuzenleTip.alt.Text = selectedtipalt
		FormYeniDuzenleTip.fiyat.Text = selectedtipfiyat
		FormYeniDuzenleTip.Pane1.Tag = selectedtipid
		FormYeniDuzenleTip.btnaction.Text = "Kaydet"
		FormYeniDuzenleTip.btnaction.Tag = "duzenle"
	End If
	
	frm.Close
End Sub

Private Sub btnsil_Click
	Dim selectedpanel As B4XView
	If TabPane1.SelectedItem.Text = tabodalartext Then
		wait for(xui.Msgbox2Async("Odayı silmek istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
		If confirm = xui.DialogResponse_Positive Then
			selectedpanel = listview1.GetPanel(odalarselected).GetView(0)
			Dim oda_id As Int = selectedpanel.GetView(0).Text
			database.remOda(oda_id)
			xui.MsgboxAsync("Oda başarıyla silindi!", "Uyarı!")
			database.refreshOdalar
			fillOdalarList
		End If
	Else If TabPane1.SelectedItem.Text = tabtiplertext Then
		wait for(xui.Msgbox2Async("Oda tipini silmek istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
		If confirm = xui.DialogResponse_Positive Then
			selectedpanel = listview2.GetPanel(tiplerselected).GetView(0)
			Dim tip_id As Int = selectedpanel.GetView(3).Text
			database.remTip(tip_id)
			xui.MsgboxAsync("Oda tipi başarıyla silindi!", "Uyarı!")
			database.refreshTipler
			fillTiplerList
		End If
	End If
End Sub