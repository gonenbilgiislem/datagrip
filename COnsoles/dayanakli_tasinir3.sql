select
    --  count(*),
    td1.SICIL_KOD,
    td1.TASINIR_KOD,
    tt.AD,
--    ttgd.DONEM,
    td1.YIL
 --   ,ttgd.NOTLAR
from TMS_DEMIRBAS td1
        inner join TMS_TASINIR tt on td1.TASINIR_KOD = tt.TASINIR_KOD
   --     inner join TMS_TIF_GIRIS_DETAY ttgd on ttgd.TASINIR_KOD = td1.TASINIR_KOD and ttgd.DONEM= td1.yil and ttgd.AMBAR_KOD = td1.AMBAR_KOD and ttgd.DAYANIKLI_SICIL_KOD = td1.SICIL_KOD
where td1.SICIL_KOD in (select td2.SICIL_KOD
                        from TMS_DEMIRBAS td2
                        where td2.SICIL_KOD = td1.SICIL_KOD
                          and td2.TASINIR_KOD <> td1.TASINIR_KOD)
--and td1.TASINIR_KOD  = '2530201030104'
--having count(td1.SICIL_KOD)>=1
--group by td1.TASINIR_KOD, td1.SICIL_KOD, tt.AD, td1.YIL,ttgd.NOTLAR
order by td1.SICIL_KOD, td1.TASINIR_KOD;