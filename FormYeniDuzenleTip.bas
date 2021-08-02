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
	Public alt As B4XView
	Public fiyat As B4XView
	Public Pane1 As B4XView
End Sub

Public Sub Show
	If frm.IsInitialized = False Then
		frm.Initialize("frm", 400, 300)
	Else
		frm.RootPane.RemoveAllNodes
	End If
	frm.RootPane.LoadLayout("yeniDuzenle")
	neweditform.LoadLayout("yeniDuzenleTip", -1, -1)
	frm.Show
End Sub

Private Sub btngeri_Click
	FormOdalar.Show
	frm.Close
End Sub

Private Sub btnaction_Click
	If ad.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen oda tipinin adını giriniz!", "Uyarı!")
		Return
	End If
	
	If alt.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen oda tipinin açıklamasını giriniz!", "Uyarı!")
		Return
	End If
	
	If fiyat.Text.Length < 1 Then
		xui.MsgboxAsync("Lütfen oda tipinin fiyatını giriniz!", "Uyarı!")
		Return
	End If
	
	If Not(IsNumber(fiyat.Text)) Then
		xui.MsgboxAsync("Oda tipi fiyatı sadece sayılardan oluşabilir!", "Uyarı!")
		Return
	End If
	
	If btnaction.Tag = "yeni" Then
		wait for(xui.Msgbox2Async("Yeni bir oda tipi oluşturmak istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
		If confirm = xui.DialogResponse_Positive Then
			database.addTip(ad.Text, alt.Text, fiyat.Text)
			FormOdalar.ShowMsg("Oda tipi başarıyla oluşturuldu!", "Uyarı!")
			frm.close
		End If
	Else If btnaction.Tag = "duzenle" Then
		wait for(xui.Msgbox2Async("Oda tipini düzenlemek istediğinize emin misiniz?", "Uyarı!", "Evet", "", "Hayır", Null)) Msgbox_Result (confirm As Int)
		If confirm = xui.DialogResponse_Positive Then
			database.modTip(Pane1.Tag, ad.Text, alt.Text, fiyat.Text)
			FormOdalar.ShowMsg("Oda tipi başarıyla düzenlendi!", "Uyarı!")
			frm.close
		End If
	End If
End Sub