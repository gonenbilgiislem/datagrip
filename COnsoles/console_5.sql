Select B.KAC_AY, B.ODEME_ACIKLAMA, COUNT(*),B.ACIKLAMA
From Eis_Kira_Sozlesme B
Where B.Belediye_Kod = 1014
  And B.Kisi_Kod Between '10000' And '9999999'
  AND B.KAC_AY = 12
AND (EXTRACT(YEAR FROM B.BITIS_TARIH) > 2022)
--AND B.ODEME_ACIKLAMA LIKE 'PEŞİN' AND B.ACIKLAMA LIKE '%EKİM%'
GROUP BY ODEME_ACIKLAMA, KAC_AY,B.ACIKLAMA
ORDER BY ODEME_ACIKLAMA, KAC_AY,B.ACIKLAMA;