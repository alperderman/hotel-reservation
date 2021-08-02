B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.8
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Public DBCon1 As SQL
	Public userData As Map
	Public users As List
	Public odalar As List
	Public tipler As List
	Public faturalar As List
	Public odalarRez As List
	Public odalarDolu As List
	Public hizmetCat As List
	Public hizmetGecmis As List
	Public hizmetlerKathiz As List
	Public hizmetlerAktiv As List
	Public hizmetlerYick As List
	Public aktifOdaRez As List
	Public aktifRez As List
	Public gecmisRez As List
	Public ulkeler As List
	Public odemeler As List
End Sub

Public Sub Login(username As String, password As String) As Boolean
	Dim rs As ResultSet = DBCon1.ExecQuery("select * from kullanicilar")
	Dim check As Boolean = False
	Do While rs.NextRow
		If username = rs.GetString("k_adi") And password = rs.GetString("k_sifre") Then
			check = True
			refreshAll
			userData = CreateMap("k_adi": rs.GetString("k_adi"), "k_sifre": rs.GetString("k_sifre"), "adi": rs.GetString("adi"), "soyadi": rs.GetString("soyadi"), "cinsiyet": rs.GetString("cinsiyet"))
			Exit
		End If
	Loop
	rs.Close
	Return check
End Sub

Public Sub addRez(tc_pass As String,ulke As String,adi As String, soyadi As String, d_tarih As Int, cinsiyet As String, tel As String, oda As Int, bas_tarih As Int, bit_tarih As Int, tutar As Double)
	DBCon1.ExecNonQuery2("insert or replace into musteriler (tc_pass, ulke, adi, soyadi, d_tarih, cinsiyet, tel) values (?, ?, ?, ?, ?, ?, ?)", Array As String(tc_pass, ulke, adi, soyadi, d_tarih, cinsiyet, tel))
	DBCon1.ExecNonQuery2("insert into rezervasyonlar (oda, musteri_id, bas_tarih, bit_tarih, odenen_tutar, toplam_tutar) values (?, ?, ?, ?, 0, ?)", Array As String(oda, tc_pass, bas_tarih, bit_tarih, tutar))
End Sub

Public Sub addOda(tip As String)
	Dim tip_id As Int = getTipId(tip)
	DBCon1.ExecNonQuery2("insert into odalar (oda_tipi) values(?)", Array As String(tip_id))
End Sub

Public Sub addTip(ad As String, alt As String, fiyat As Double)
	DBCon1.ExecNonQuery2("insert into oda_tipleri (tip_adi, tip_alt, fiyat) values(?, ? ,?)", Array As String(ad, alt, fiyat))
End Sub

Public Sub addHizmet(ad As String, cat As String, fiyat As Double)
	Dim cat_id As String = getCatId(cat)
	DBCon1.ExecNonQuery2("insert into hizmetler (hizmet_adi, cat, fiyat) values(?, ? ,?)", Array As String(ad, cat_id, fiyat))
End Sub

Public Sub addServis(rez As Int, hizmet As Int, adet As Int, tutar As Double)
	DBCon1.ExecNonQuery2("insert into hizmet_log (rezervasyon, hizmet, adet, tarih) values(?, ? ,?, strftime('%s','now'))", Array As String(rez, hizmet, adet))
	DBCon1.ExecNonQuery2("update rezervasyonlar set toplam_tutar = toplam_tutar + ? where rez_id = ?", Array As String(tutar, rez))
End Sub

Public Sub odeFatura(rez As Int, tutar As Double)
	DBCon1.ExecNonQuery2("update rezervasyonlar set odenen_tutar = odenen_tutar + ? where rez_id = ?", Array As String(tutar, rez))
	DBCon1.ExecNonQuery2("insert into odemeler (rez, tarih, tutar) values(?, strftime('%s','now'), ?)", Array As String(rez, tutar))
End Sub

Public Sub modOda(id As Int, tip As String)
	Dim tip_id As Int = getTipId(tip)
	DBCon1.ExecNonQuery2("update odalar set oda_tipi = ? where oda_id = ?", Array As String(tip_id, id))
End Sub

Public Sub modKullanici(k_adi As String, adi As String, soyadi As String, cinsiyet As String)
	DBCon1.ExecNonQuery2("update kullanicilar set adi = ?, soyadi = ?, cinsiyet = ? where k_adi = ?", Array As String(adi, soyadi, cinsiyet, k_adi))
End Sub

Public Sub modSifre(k_adi As String, sifre As String)
	DBCon1.ExecNonQuery2("update kullanicilar set k_sifre = ? where k_adi = ?", Array As String(sifre, k_adi))
End Sub

Public Sub modTip(id As Int, tip As String, alt As String, fiyat As Double)
	DBCon1.ExecNonQuery2("update oda_tipleri set tip_adi = ?, tip_alt = ?, fiyat = ? where tip_id = ?", Array As String(tip, alt, fiyat, id))
End Sub

Public Sub modHizmet(id As Int, ad As String, cat As String, fiyat As Double)
	Dim cat_id As String = getCatId(cat)
	DBCon1.ExecNonQuery2("update hizmetler set hizmet_adi = ?, cat = ?, fiyat = ? where hizmet_id = ?", Array As String(ad, cat_id, fiyat, id))
End Sub

Public Sub remOda(id As Int)
	DBCon1.ExecNonQuery2("delete from odalar where oda_id = ?", Array As String(id))
End Sub

Public Sub remTip(id As Int)
	DBCon1.ExecNonQuery2("delete from oda_tipleri where tip_id = ?", Array As String(id))
End Sub

Public Sub remHizmet(id As Int)
	DBCon1.ExecNonQuery2("delete from hizmetler where hizmet_id = ?", Array As String(id))
End Sub

Public Sub remRez(rez As Int)
	DBCon1.ExecNonQuery2("delete from rezervasyonlar where rez_id = ?", Array As String(rez))
End Sub

Public Sub getIso(ulke As String) As String
	Dim iso As String = DBCon1.ExecQuerySingleResult2("select iso from ulkeler where nicename = ?", Array As String(ulke))
	Return iso
End Sub

Public Sub getTipId(tip As String) As Int
	Dim tip_id As Int = DBCon1.ExecQuerySingleResult2("select tip_id from oda_tipleri where tip_adi = ?", Array As String(tip))
	Return tip_id
End Sub

Public Sub getCatId(cat As String) As String
	Dim cat_id As String = DBCon1.ExecQuerySingleResult2("select cat_id from hizmet_cat where cat_adi = ?", Array As String(cat))
	Return cat_id
End Sub

Public Sub getAktifOdaRez(oda As Int)
	Dim rs As ResultSet = DBCon1.ExecQuery2("select r.rez_id, r.bas_tarih, r.bit_tarih from odalar as o inner join rezervasyonlar as r on o.oda_id = r.oda where o.oda_id = ? and strftime('%s','now') < r.bit_tarih", Array As String(oda))
	aktifOdaRez = Main.ResultSetToListOfMaps(rs)
	rs.Close
End Sub

Public Sub getOda(oda As Int) As Map
	Dim result As Map
	For i = 0 To odalar.Size-1
		Dim m As Map = odalar.Get(i)
		If oda = m.Get("oda_id") Then
			result = m
			Exit
		End If
	Next
	Return result
End Sub

Public Sub checkServis(rez As Int, hizmet As Int) As Boolean
	Dim check As Boolean = False
	Dim servis As String = DBCon1.ExecQuerySingleResult2("select log_id from hizmet_log where rezervasyon = ? and hizmet = ?", Array As String(rez, hizmet))
	If Not(servis = Null) Then
		check = True
	End If
	Return check
End Sub

Public Sub checkSifre(sifre As String) As Boolean
	Dim check As Boolean = False
	If sifre = userData.Get("k_sifre") Then
		check = True
	End If
	Return check
End Sub

Public Sub refreshAll()
	refreshUsers
	refreshOdalar
	refreshTipler
	refreshUlkeler
	refreshRezervasyonlar
	refreshHizmetCat
	refreshHizmetler
	refreshFaturalar
	refreshHizmetGecmis
End Sub

Public Sub refreshUsers()
	Dim rs As ResultSet = DBCon1.ExecQuery("select * from kullanicilar")
	users = Main.ResultSetToListOfMaps(rs)
	rs.Close
End Sub

Public Sub refreshRezervasyonlar()
	Dim rsRez As ResultSet = DBCon1.ExecQuery("select r.rez_id, r.oda, m.tc_pass, m.ulke, m.adi, m.soyadi, m.d_tarih, m.cinsiyet, m.tel, r.bas_tarih, r.bit_tarih, r.odenen_tutar, r.toplam_tutar from rezervasyonlar as r inner join musteriler as m on r.musteri_id = m.tc_pass where strftime('%s','now') < r.bit_tarih")
	Dim rsGecmis As ResultSet = DBCon1.ExecQuery("select r.rez_id, r.oda, m.tc_pass, m.ulke, m.adi, m.soyadi, m.d_tarih, m.cinsiyet, m.tel, r.bas_tarih, r.bit_tarih, r.odenen_tutar, r.toplam_tutar from rezervasyonlar as r inner join musteriler as m on r.musteri_id = m.tc_pass")
	Dim rsDolu As ResultSet = DBCon1.ExecQuery("select o.oda_id from odalar as o where o.oda_id in (select oda from rezervasyonlar as r where strftime('%s','now') >= r.bas_tarih and strftime('%s','now') <= r.bit_tarih)")
	odalarRez = Main.ResultSetToListOfMaps(rsRez)
	odalarDolu = Main.ResultSetToListOfMaps(rsDolu)
	gecmisRez = Main.ResultSetToListOfMaps(rsGecmis)
	rsRez.Close
	rsGecmis.Close
	rsDolu.Close
End Sub

Public Sub refreshAktifRez()
	Dim rsAktifRez As ResultSet = DBCon1.ExecQuery("select r.oda, m.adi, m.soyadi from rezervasyonlar as r inner join musteriler as m on m.tc_pass = r.musteri_id where strftime('%s','now') >= r.bas_tarih and strftime('%s','now') <= r.bit_tarih")
	aktifRez = Main.ResultSetToListOfMaps(rsAktifRez)
	rsAktifRez.Close
End Sub

Public Sub refreshOdalar()
	Dim rsOdalar As ResultSet = DBCon1.ExecQuery("select o.oda_id, t.tip_adi, t.fiyat, t.tip_alt from odalar as o, oda_tipleri as t where o.oda_tipi = t.tip_id")
	odalar = Main.ResultSetToListOfMaps(rsOdalar)
	rsOdalar.Close
End Sub

Public Sub refreshFaturalar()
	Dim rsFaturalar As ResultSet = DBCon1.ExecQuery("select r.rez_id, r.oda, m.adi || ' ' || m.soyadi as adsoyad, r.odenen_tutar, r.toplam_tutar from rezervasyonlar as r inner join musteriler as m on m.tc_pass = r.musteri_id where r.odenen_tutar < r.toplam_tutar")
	Dim rsOdemeler As ResultSet = DBCon1.ExecQuery("select r.rez_id, r.oda, m.adi, m.soyadi, o.tarih, o.tutar from odemeler as o inner join rezervasyonlar as r on r.rez_id = o.rez inner join musteriler as m on m.tc_pass = r.musteri_id")
	Dim rsHizmetGecmis As ResultSet = DBCon1.ExecQuery("select r.rez_id, r.oda, m.adi || ' ' || m.soyadi as adsoyad, h.hizmet_adi, h.cat, hl.adet, h.fiyat from hizmet_log as hl inner join rezervasyonlar as r on r.rez_id = hl.rezervasyon inner join musteriler as m on m.tc_pass = r.musteri_id inner join hizmetler as h on h.hizmet_id = hl.hizmet")
	faturalar = Main.ResultSetToListOfMaps(rsFaturalar)
	odemeler = Main.ResultSetToListOfMaps(rsOdemeler)
	hizmetGecmis = Main.ResultSetToListOfMaps(rsHizmetGecmis)
	rsFaturalar.Close
	rsOdemeler.Close
	rsHizmetGecmis.Close
End Sub

Public Sub refreshHizmetGecmis()
	Dim rsHizmetGecmis As ResultSet = DBCon1.ExecQuery("select r.rez_id, r.oda, m.adi, m.soyadi, h.hizmet_adi, h.cat, hl.adet, h.fiyat from hizmet_log as hl inner join rezervasyonlar as r on r.rez_id = hl.rezervasyon inner join musteriler as m on m.tc_pass = r.musteri_id inner join hizmetler as h on h.hizmet_id = hl.hizmet")
	hizmetGecmis = Main.ResultSetToListOfMaps(rsHizmetGecmis)
	rsHizmetGecmis.Close
End Sub

Public Sub refreshHizmetCat()
	Dim rsHizmetCat As ResultSet = DBCon1.ExecQuery("select * from hizmet_cat")
	hizmetCat = Main.ResultSetToListOfMaps(rsHizmetCat)
	rsHizmetCat.Close
End Sub

Public Sub refreshHizmetler()
	Dim rsHizmetlerKathiz As ResultSet = DBCon1.ExecQuery("select * from hizmetler where cat = 'kathiz'")
	Dim rsHizmetlerAktiv As ResultSet = DBCon1.ExecQuery("select * from hizmetler where cat = 'aktiv'")
	Dim rsHizmetlerYick As ResultSet = DBCon1.ExecQuery("select * from hizmetler where cat = 'yick'")
	
	hizmetlerKathiz = Main.ResultSetToListOfMaps(rsHizmetlerKathiz)
	hizmetlerAktiv = Main.ResultSetToListOfMaps(rsHizmetlerAktiv)
	hizmetlerYick = Main.ResultSetToListOfMaps(rsHizmetlerYick)
	
	rsHizmetlerKathiz.Close
	rsHizmetlerAktiv.Close
	rsHizmetlerYick.Close
End Sub

Public Sub refreshTipler()
	Dim rsTipler As ResultSet = DBCon1.ExecQuery("select * from oda_tipleri")
	tipler = Main.ResultSetToListOfMaps(rsTipler)
	rsTipler.Close
End Sub

Public Sub refreshUlkeler()
	Dim rs As ResultSet = DBCon1.ExecQuery("select * from ulkeler")
	ulkeler = Main.ResultSetToListOfMaps(rs)
	rs.Close
End Sub