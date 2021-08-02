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
	Private lv As CustomListView
	Private oda As Label
	Private tip As Label
	Private fiyat As Label
	Private alt As Label
	Private durum As Label
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 600, 600)
		frm.RootPane.LoadLayout("rezervasyon")
	End If
	fillList
	frm.Show
End Sub

Private Sub fillList
	database.refreshOdalar
	lv.Clear
	For i = 0 To Main.odalarBos.Size-1
		Dim m As Map = Main.odalar.Get(i)
		Dim p As B4XView = xui.CreatePanel("")
		p.LoadLayout("listRezervasyon")
		oda.Text = m.Get("oda_id")
		tip.Text = m.Get("tip_adi")
		fiyat.Text = m.Get("fiyat")
		durum.Text = "Boş"
		alt.Text = m.Get("tip_alt")
		p.SetLayoutAnimated(0, 0, 0, lv.AsView.Width, 120)
		lv.Add(p, "")
	Next
	For i = 0 To Main.odalarRez.Size-1
		Dim m As Map = Main.odalar.Get(i)
		Dim p As B4XView = xui.CreatePanel("")
		p.LoadLayout("listRezervasyon")
		oda.Text = m.Get("oda_id")
		tip.Text = m.Get("tip_adi")
		fiyat.Text = m.Get("fiyat")
		durum.Text = "Şuan Boş"
		alt.Text = m.Get("tip_alt")
		p.SetLayoutAnimated(0, 0, 0, lv.AsView.Width, 120)
		lv.Add(p, "")
	Next
	For i = 0 To Main.odalarDolu.Size-1
		Dim m As Map = Main.odalar.Get(i)
		Dim p As B4XView = xui.CreatePanel("")
		p.LoadLayout("listRezervasyon")
		oda.Text = m.Get("oda_id")
		tip.Text = m.Get("tip_adi")
		fiyat.Text = m.Get("fiyat")
		durum.Text = "Dolu"
		alt.Text = m.Get("tip_alt")
		p.SetLayoutAnimated(0, 0, 0, lv.AsView.Width, 120)
		lv.Add(p, "")
	Next
End Sub

Private Sub Button1_Click
	FormMenu.Show
	frm.Close
End Sub