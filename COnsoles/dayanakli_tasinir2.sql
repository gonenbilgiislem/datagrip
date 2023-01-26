SELECT D.KOD,D.AMBAR_GIRIS_ANA_KOD,D.DONEM,D.AMBAR_KOD,D.TASINIR_KOD,D.ADET,D.DAYANIKLI_SICIL_KOD,D.CIKIS_KOD,D.KAYIT_TARIH,TT.KOD,D.TASINIR_KOD,TT.AD
         FROM TMS_TIF_GIRIS_DETAY D, TMS_TIF_GIRIS A, TMS_DEMIRBAS C ,TMS_TASINIR tt
         WHERE D.AMBAR_GIRIS_ANA_KOD = A.KOD
         AND   D.AMBAR_KOD           = C.AMBAR_KOD
         AND   D.DAYANIKLI_SICIL_KOD = C.SICIL_KOD
         and   D.TASINIR_KOD = TT.TASINIR_KOD
         AND   A.DEVIR_EH            = 'H'
      --   AND   A.CIKIS_AMBAR_KOD IS null
         and   D.DAYANIKLI_SICIL_KOD = '25401050801041400003';

----------------------------------------------------------------------------------------------------------------------------
select count(*),td1.SICIL_KOD,td1.TASINIR_KOD,tt.AD,td1.YIL,ttgd.NOTLAR from TMS_DEMIRBAS td1
                                              inner join TMS_TASINIR tt on td1.TASINIR_KOD = tt.TASINIR_KOD
                                                            inner join TMS_TIF_GIRIS_DETAY ttgd on ttgd.TASINIR_KOD = td1.TASINIR_KOD and
                                                                            ttgd.DONEM= td1.yil
where td1.SICIL_KOD in (select td2.SICIL_KOD from TMS_DEMIRBAS td2 where td2.SICIL_KOD = td1.SICIL_KOD
                                                                  and td2.TASINIR_KOD <> td1.TASINIR_KOD)
--and td1.TASINIR_KOD  = '2530201030104'
having count(td1.SICIL_KOD)>=1
group by td1.TASINIR_KOD,td1.SICIL_KOD,tt.AD,td1.YIL,ttgd.NOTLAR
order by td1.SICIL_KOD,td1.TASINIR_KOD;
----------------------------------------------------------------------------------------------------------------------------
select count(*),td1.SICIL_KOD,td1.TASINIR_KOD from TMS_DEMIRBAS td1
                                            where td1.TASINIR_KOD  = '2530201030104'
having count(td1.SICIL_KOD)>1
group by td1.SICIL_KOD,td1.TASINIR_KOD;
----------------------------------------------------------------------------------------------------------------------------
select
    --  count(*),
    td1.SICIL_KOD,
    td1.TASINIR_KOD,
    tt.AD,
    ttgd.DONEM,
    td1.YIL
    ,ttgd.NOTLAR
from TMS_DEMIRBAS td1
        inner join TMS_TASINIR tt on td1.TASINIR_KOD = tt.TASINIR_KOD
        inner join TMS_TIF_GIRIS_DETAY ttgd on ttgd.TASINIR_KOD = td1.TASINIR_KOD and ttgd.DONEM= td1.yil and ttgd.AMBAR_KOD = td1.AMBAR_KOD and ttgd.DAYANIKLI_SICIL_KOD = td1.SICIL_KOD
where td1.SICIL_KOD in (select td2.SICIL_KOD
                        from TMS_DEMIRBAS td2
                        where td2.SICIL_KOD = td1.SICIL_KOD
                          and td2.TASINIR_KOD <> td1.TASINIR_KOD)
--and td1.TASINIR_KOD  = '2530201030104'
--having count(td1.SICIL_KOD)>=1
--group by td1.TASINIR_KOD, td1.SICIL_KOD, tt.AD, td1.YIL,ttgd.NOTLAR
order by td1.SICIL_KOD, td1.TASINIR_KOD;