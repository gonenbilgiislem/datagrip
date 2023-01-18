Select B.ODEME_ACIKLAMA,b.KISI_KOD,b.TASINMAZ_KOD
From Eis_Kira_Sozlesme B
Where B.Belediye_Kod = 1014
  And B.Kisi_Kod Between '10000' And '9999999'
  AND B.KAC_AY = 12
AND (EXTRACT(YEAR FROM B.BITIS_TARIH) > 2022)
AND B.ODEME_ACIKLAMA LIKE 'HER YIL AĞUSTOS AYI SONUNA KADAR ÖDENECEKTİR'
--AND B.ACIKLAMA LIKE '%ARAL%'
(SELECT * FROM GYS_TAHAKKUK GT )