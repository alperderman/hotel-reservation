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
	Public ad As B4XView
	Public cat As ComboBox
	Public fiyat As B4XView
	Public id As B4XView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 400, 400)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	frm.RootPane.LoadLayout("yeniDuzenle")
	neweditform.LoadLayout("yeniDuzenleHizmet", -1, -1)
	For i = 0 To database.hizmetCat.Size-1
		Dim m As Map = database.hizmetCat.Get(i)
		cat.Items.Add(m.Get("cat_adi"))
	Next
	
	frm.Show
End Sub

Private Sub btngeri_Click
	FormHizmetler.Show
	frm.Close
End Sub

Private Sub btnaction_Click
	If ad.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen hizmet adını giriniz!", "Uyarı!")
		Return
	End If
	
	If cat.SelectedIndex < 0 Then
		xui.MsgboxAsync("Lütfen bir hizmet kategorisi seçiniz!", "Uyarı!")
		Return
	End If
	
	If fiyat.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen hizmetin fiyatını giriniz!", "Uyarı!")
		Return
	End If
	
	If Not(IsNumber(fiyat.Text)) Then
		xui.MsgboxAsync("Hizmet fiyatı sadece sayılardan oluşabilir!", "Uyarı!")
		Return
	End If
	
	If btnaction.Tag = "yeni" Then
		wait for(xui.Msgbox2Async("Yeni bir hizmet oluşturmak istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
		If confirm = xui.DialogResponse_Positive Then
			database.addHizmet(ad.Text, cat.Items.Get(cat.SelectedIndex), fiyat.Text)
			FormHizmetler.ShowMsg("Hizmet başarıyla oluşturuldu!", "Uyarı!")
			frm.close
		End If
	Else If btnaction.Tag = "duzenle" Then
		wait for(xui.Msgbox2Async("Hizmeti düzenlemek istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
		If confirm = xui.DialogResponse_Positive Then
			database.modHizmet(id.Text, ad.Text, cat.Items.Get(cat.SelectedIndex), fiyat.Text)
			FormHizmetler.ShowMsg("Hizmet başarıyla düzenlendi!", "Uyarı!")
			frm.close
		End If
	End If
End Sub