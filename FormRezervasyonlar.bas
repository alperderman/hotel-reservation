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
	Private oda As Label
	Private tip As Label
	Private fiyat As B4XView
	Private alt As Label
	Private durum As Label
	Private listview2 As CustomListView
	Private TabPane1 As TabPane
	Private tableview1 As TableView
	Private tableview2 As TableView
	Private emptytableview1 As B4XView
	Private emptytableview2 As B4XView
	Private tabaktiftext As String = "Aktif Rezervasyonlar"
	Private tabyenitext As String = "Yeni Rezervasyon"
	Private tabgecmistext As String = "Rezervasyon Geçmişi"
	Private btnsil As B4XView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 600, 600)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	frm.RootPane.LoadLayout("rezervasyonlar")
	TabPane1.LoadLayout("tableView1", tabaktiftext)
	TabPane1.LoadLayout("listView2", tabyenitext)
	TabPane1.LoadLayout("tableView2", tabgecmistext)
	database.refreshOdalar
	database.refreshRezervasyonlar
	fillAktif
	fillGecmis
	fillList
	frm.Show
End Sub

Public Sub ShowMsg(text As String, title As String)
	Show
	xui.MsgboxAsync(text, title)
End Sub

Private Sub fillAktif
	If database.odalarRez.Size > 0 Then
		tableview1.Items.Clear
		tableview1.SetColumns(Array As String("ID", "Oda", "Geliş", "Ayrılış", "Adı", "Soyadı", "Cinsiyet"))
		Main.setTableColumnWidths(tableview1, Array As Double(0,0,-60,-60,-60,-60,0))
		For i = 0 To database.odalarRez.Size-1
			Dim m As Map = database.odalarRez.Get(i)
			Dim Row() As Object = Array (m.Get("rez_id"), m.Get("oda"), DateTime.Date(m.Get("bas_tarih")*DateTime.TicksPerSecond), DateTime.Date(m.Get("bit_tarih")*DateTime.TicksPerSecond), m.Get("adi"), m.Get("soyadi"), m.Get("cinsiyet"))
			tableview1.Items.Add(Row)
		Next
		tableview1.Visible = True
		emptytableview1.Visible = False
	Else
		tableview1.Visible = False
		emptytableview1.Text = "Aktif rezervasyon bulunmamaktadır!"
		emptytableview1.Visible = True
	End If
End Sub

Private Sub fillGecmis
	If database.gecmisRez.Size > 0 Then
		tableview2.Items.Clear
		tableview2.SetColumns(Array As String("ID", "Oda", "Geliş", "Ayrılış", "Adı", "Soyadı", "Cinsiyet"))
		Main.setTableColumnWidths(tableview2, Array As Double(0,0,-60,-60,-60,-60,0))
		For i = 0 To database.gecmisRez.Size-1
			Dim m As Map = database.gecmisRez.Get(i)
			Dim Row() As Object = Array (m.Get("rez_id"), m.Get("oda"), DateTime.Date(m.Get("bas_tarih")*DateTime.TicksPerSecond), DateTime.Date(m.Get("bit_tarih")*DateTime.TicksPerSecond), m.Get("adi"), m.Get("soyadi"), m.Get("cinsiyet"))
			tableview2.Items.Add(Row)
		Next
		tableview2.Visible = True
		emptytableview2.Visible = False
	Else
		tableview2.Visible = False
		emptytableview2.Text = "Daha önce hiç rezervasyon yapılmamış!"
		emptytableview2.Visible = True
	End If
End Sub

Private Sub fillList
	listview2.Clear
	For i = 0 To database.odalar.Size-1
		Dim m As Map = database.odalar.Get(i)
		Dim p As B4XView = xui.CreatePanel("")
		p.LoadLayout("listRezervasyonlar")
		oda.Text = m.Get("oda_id")
		tip.Text = m.Get("tip_adi")
		fiyat.Text = m.Get("fiyat")
		durum.Text = "Boş"
		For j = 0 To database.odalarDolu.Size-1
			Dim mj As Map = database.odalarDolu.Get(j)
			If mj.Get("oda_id") = m.Get("oda_id") Then
				durum.Text = "Dolu"
				Exit
			End If
		Next
		alt.Text = m.Get("tip_alt")
		p.SetLayoutAnimated(0, 0, 0, listview2.AsView.Width, 120)
		listview2.Add(p, "")
	Next
End Sub

Private Sub Button1_Click
	FormMenu.Show
	frm.Close
End Sub

Private Sub listview2_ItemClick (Index As Int, Value As Object)
	Dim clOda As String = listview2.GetPanel(Index).GetView(0).GetView(2).Text
	Dim odaProp As Map = database.getOda(clOda)
	Dim clTip As String = odaProp.Get("tip_adi")
	Dim clFiyat As String = odaProp.Get("fiyat")
	
	database.getAktifOdaRez(clOda)
	FormYeniRezervasyon.Show
	If database.aktifOdaRez.Size > 0 Then
		FormYeniRezervasyon.aktifrez.Items.Clear
		FormYeniRezervasyon.aktifrez.SetColumns(Array As String("ID", "Geliş", "Ayrılış"))
		Main.setTableColumnWidths(FormYeniRezervasyon.aktifrez, Array As Double(0,-60,-60))
		For i = 0 To database.aktifOdaRez.Size-1
			Dim m As Map = database.aktifOdaRez.Get(i)
			Dim Row() As Object = Array (m.Get("rez_id"), DateTime.Date(m.Get("bas_tarih")*DateTime.TicksPerSecond), DateTime.Date(m.Get("bit_tarih")*DateTime.TicksPerSecond))
			FormYeniRezervasyon.aktifrez.Items.Add(Row)
		Next
		FormYeniRezervasyon.aktifrez.Visible = True
		FormYeniRezervasyon.rezempty.Visible = False
	Else
		FormYeniRezervasyon.aktifrez.Visible = False
		FormYeniRezervasyon.rezempty.Visible = True
	End If
	FormYeniRezervasyon.oda.Text = clOda
	FormYeniRezervasyon.tip.Text = clTip
	FormYeniRezervasyon.fiyat.Text = clFiyat
	frm.Close
End Sub

Private Sub tableview1_SelectedRowChanged(Index As Int, Row() As Object)
	If tableview1.SelectedRow >= 0 Then
		btnsil.Visible = True
	Else
		btnsil.Visible = False
	End If
End Sub

Private Sub TabPane1_TabChanged (SelectedTab As TabPage)
	If SelectedTab.Text = tabaktiftext And tableview1.SelectedRow >= 0 Then
		btnsil.Visible = True
	Else
		btnsil.Visible = False
	End If
End Sub

Private Sub btnsil_Click
	wait for(xui.Msgbox2Async("Rezervasyonu silmek istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
	If confirm = xui.DialogResponse_Positive Then
		Dim rez_id As Int = tableview1.SelectedRowValues(0)
		database.remRez(rez_id)
		xui.MsgboxAsync("Rezervasyon başarıyla silindi!", "Uyarı!")
		database.refreshRezervasyonlar
		tableview1.ClearSelection
		fillAktif
		fillGecmis
		fillList
	End If
End Sub