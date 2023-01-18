select GT.*
from GYS_TAHAKKUK_ANA GTA
         INNER JOIN GYS_TAHAKKUK GT on GTA.KOD = GT.TAHAK_KOD
    AND GT.KISI_KOD = GTA.KISI_KOD
where GTA.KISI_KOD IN (5234)
  and GT.MODUL_KOD = 15
  and GT.YIL = 2023;

select GTA.*
from GYS_TAHAKKUK GTA
where not exists(select *
                 from GYS_TAHAKKUK_ANA GT
                 where GT.KOD = GTA.TAHAK_KOD
                   AND GT.KISI_KOD = GTA.KISI_KOD)
  and GTA.KISI_KOD IN (72399)
  AND GTA.MODUL_KOD = 15;



Select B.ODEME_ACIKLAMA,b.KISI_KOD,b.TASINMAZ_KOD
From Eis_Kira_Sozlesme B
Where B.Belediye_Kod = 1014
  And B.Kisi_Kod Between '10000' And '9999999'
  AND B.KAC_AY = 12
AND (EXTRACT(YEAR FROM B.BITIS_TARIH) > 2022)
AND B.ODEME_ACIKLAMA LIKE 'HER YIL AĞUSTOS AYI SONUNA KADAR ÖDENECEKTİR'
--AND B.ACIKLAMA LIKE '%ARAL%'
GROUP BY B.ODEME_ACIKLAMA,b.KISI_KOD,b.TASINMAZ_KOD
ORDER BY B.ODEME_ACIKLAMA,b.KISI_KOD,b.TASINMAZ_KOD;


update EIS_KIRA_SOZLESME B
set B.ODEME_ACIKLAMA = 'HER YIL MART AYI SONUNA KADAR ÖDENECEKTİR'
where B.KAC_AY = 12
AND (EXTRACT(YEAR FROM B.BITIS_TARIH) > 2022)
And Kisi_Kod Between '10000' And '9999999'
 AND B.ODEME_ACIKLAMA LIKE 'HER YIL 29 MART TARİHİNE KADAR'
--AND B.ACIKLAMA LIKE '%HER YIL 15 NİSANA KADAR%';