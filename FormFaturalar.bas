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
	Private tableview1 As TableView
	Private emptytableview1 As B4XView
	Private foda As B4XView
	Private fadsoyad As B4XView
	Private fodetut As B4XView
	Private ftoptut As B4XView
	Private emptylistview1 As B4XView
	Private frez As B4XView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 600, 600)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	database.refreshFaturalar
	frm.RootPane.LoadLayout("faturalar")
	TabPane1.LoadLayout("listView1", "Ödenmemiş Faturalar")
	TabPane1.LoadLayout("tableView1", "Ödeme Geçmişi")
	fillFaturalarList
	fillOdemeler
	frm.Show
End Sub

Public Sub ShowMsg(text As String, title As String)
	Show
	xui.MsgboxAsync(text, title)
End Sub

Private Sub fillFaturalarList
	If database.faturalar.Size > 0 Then
		listview1.Clear
		For i = 0 To database.faturalar.Size-1
			Dim m As Map = database.faturalar.Get(i)
			Dim p As B4XView = xui.CreatePanel("")
			p.LoadLayout("listFaturalar")
			frez.Text = m.Get("rez_id")
			foda.Text = m.Get("oda")
			fadsoyad.Text = m.Get("adsoyad")
			fodetut.Text = m.Get("odenen_tutar")
			ftoptut.Text = m.Get("toplam_tutar")
			p.SetLayoutAnimated(0, 0, 0, listview1.AsView.Width, 150)
			listview1.Add(p, "")
			listview1.AsView.Visible = True
			emptylistview1.Visible = False
		Next
	Else
		emptylistview1.Text = "Ödenmemiş fatura bulunmamaktadır!"
		listview1.AsView.Visible = False
		emptylistview1.Visible = True
	End If
End Sub

Private Sub fillOdemeler
	If database.odemeler.Size > 0 Then
		tableview1.Items.Clear
		tableview1.SetColumns(Array As String("Rezervasyon", "Oda", "Adı", "Soyadı", "Ödeme Tarihi", "Tutar"))
		Main.setTableColumnWidths(tableview1, Array As Double(0,0,-60,-60,-30,0))
		For i = 0 To database.odemeler.Size-1
			Dim m As Map = database.odemeler.Get(i)
			Dim Row() As Object = Array (m.Get("rez_id"), m.Get("oda"), m.Get("adi"), m.Get("soyadi"), DateTime.Date(m.Get("tarih")*DateTime.TicksPerSecond), m.Get("tutar"))
			tableview1.Items.Add(Row)
		Next
		tableview1.Visible = True
		emptytableview1.Visible = False
	Else
		tableview1.Visible = False
		emptytableview1.Text = "Daha önce hiç ödeme yapılmamış!"
		emptytableview1.Visible = True
	End If
End Sub

Private Sub Button1_Click
	FormMenu.Show
	frm.Close
End Sub

Private Sub listview1_ItemClick (Index As Int, Value As Object)
	Dim selectedpanel As B4XView = listview1.GetPanel(Index).GetView(0)
	Dim clRez As String = selectedpanel.GetView(0).Text
	Dim clOda As String = selectedpanel.GetView(1).Text
	Dim clAdsoyad As String = selectedpanel.GetView(2).Text
	Dim clOdetut As Double = selectedpanel.GetView(3).Text
	Dim clToptut As Double = selectedpanel.GetView(4).Text
	Dim clOgtut As Double = clToptut - clOdetut
	
	FormFaturaOde.Show
	FormFaturaOde.rez.Text = clRez
	FormFaturaOde.oda.Text = clOda
	FormFaturaOde.adsoyad.Text = clAdsoyad
	FormFaturaOde.otutar.Text = clOdetut
	FormFaturaOde.ttutar.Text = clToptut
	FormFaturaOde.ogtutar.Text = clOgtut
	frm.Close
End Sub