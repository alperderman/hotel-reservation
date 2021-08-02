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
	Public frm As Form
	Private neweditform As ScrollPane
	Public btnaction As B4XView
	Public oda As B4XView
	Public tipler As ComboBox
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 400, 300)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	frm.RootPane.LoadLayout("yeniDuzenle")
	neweditform.LoadLayout("yeniDuzenleOda", -1, -1)
	For i = 0 To database.tipler.Size-1
		Dim m As Map = database.tipler.Get(i)
		tipler.Items.Add(m.Get("tip_adi"))
	Next
	
	frm.Show
End Sub

Private Sub btngeri_Click
	FormOdalar.Show
	frm.Close
End Sub

Private Sub btnaction_Click
	If tipler.SelectedIndex >= 0 Then
		If btnaction.Tag = "yeni" Then
			wait for(xui.Msgbox2Async("Yeni bir oda oluşturmak istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
			If confirm = xui.DialogResponse_Positive Then
				database.addOda(tipler.Items.Get(tipler.SelectedIndex))
				FormOdalar.ShowMsg("Oda başarıyla oluşturuldu!", "Uyarı!")
				frm.close
			End If
		Else If btnaction.Tag = "duzenle" Then
			wait for(xui.Msgbox2Async("Odayı düzenlemek istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
			If confirm = xui.DialogResponse_Positive Then
				database.modOda(oda.Text, tipler.Items.Get(tipler.SelectedIndex))
				FormOdalar.ShowMsg("Oda başarıyla düzenlendi!", "Uyarı!")
				frm.close
			End If
		End If
	Else
		xui.MsgboxAsync("Lütfen bir oda tipi seçiniz", "Uyarı!")
		Return
	End If
End Sub