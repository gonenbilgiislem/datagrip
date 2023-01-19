Select B.ODEME_ACIKLAMA
From Eis_Kira_Sozlesme B
Where B.Belediye_Kod = 1014
  And B.Kisi_Kod Between '10000' And '9999999'
  AND B.KAC_AY = 12
AND (EXTRACT(YEAR FROM B.BITIS_TARIH) > 2022)
--AND B.ODEME_ACIKLAMA LIKE 'HER YIL MART AYI SONUNA KADAR ÖDENECEKTİR'
--AND B.ACIKLAMA LIKE '%ARAL%'
GROUP BY B.ODEME_ACIKLAMA
ORDER BY B.ODEME_ACIKLAMA;