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
	Private Pane2 As Pane
	Private tableview1 As TableView
	Private emptytableview1 As B4XView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 600, 600)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	frm.RootPane.LoadLayout("hizmetServis")
	database.refreshHizmetGecmis
	Pane2.LoadLayout("tableView1")
	fillHizlog
	frm.Show
End Sub

Public Sub ShowMsg(text As String, title As String)
	Show
	xui.MsgboxAsync(text, title)
End Sub

Private Sub fillHizlog
	If database.hizmetGecmis.Size > 0 Then
		tableview1.Items.Clear
		tableview1.SetColumns(Array As String("Rezervasyon", "Oda", "Adı", "Soyadı", "Hizmet", "Tutar"))
		Main.setTableColumnWidths(tableview1, Array As Double(0,0,-60,-60,-100,0))
		For i = 0 To database.hizmetGecmis.Size-1
			Dim m As Map = database.hizmetGecmis.Get(i)
			Dim hizadi As String
			If m.Get("cat") = "kathiz" Or m.Get("cat") = "aktiv" Then
				hizadi = m.Get("hizmet_adi")
			Else
				hizadi = m.Get("adet")&" adet "&m.Get("hizmet_adi")
			End If
			Dim Row() As Object = Array (m.Get("rez_id"), m.Get("oda"), m.Get("adi"), m.Get("soyadi"), hizadi, (m.Get("adet") * m.Get("fiyat")))
			tableview1.Items.Add(Row)
		Next
		tableview1.Visible = True
		emptytableview1.Visible = False
	Else
		tableview1.Visible = False
		emptytableview1.Text = "Daha önce hiç hizmet servisi yapılmamış!"
		emptytableview1.Visible = True
	End If
End Sub

Private Sub Button1_Click
	FormMenu.Show
	frm.Close
End Sub

Private Sub btnservis_Click
	FormHizmetServisYap.Show
	frm.Close
End Sub