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
select count(*),td1.SICIL_KOD,td1.TASINIR_KOD from TMS_DEMIRBAS td1
where td1.TASINIR_KOD in (select td2.TASINIR_KOD from TMS_DEMIRBAS td2 where td2.TASINIR_KOD = td1.TASINIR_KOD
                                                                  and td2.SICIL_KOD <> td1.SICIL_KOD)
--and td1.TASINIR_KOD  = '2530201030104'
having count(td1.SICIL_KOD)>=1
group by td1.TASINIR_KOD,td1.SICIL_KOD
order by td1.SICIL_KOD,td1.TASINIR_KOD;
----------------------------------------------------------------------------------------------------------------------------
select count(*),td1.SICIL_KOD,td1.TASINIR_KOD from TMS_DEMIRBAS td1
                                            where td1.TASINIR_KOD  = '2530201030104'
having count(td1.SICIL_KOD)>1
group by td1.SICIL_KOD,td1.TASINIR_KOD;
----------------------------------------------------------------------------------------------------------------------------
select count(*),td1.DAYANIKLI_SICIL_KOD,td1.TASINIR_KOD from TMS_TIF_GIRIS_DETAY td1
where td1.DAYANIKLI_SICIL_KOD in (select td2.DAYANIKLI_SICIL_KOD from TMS_TIF_GIRIS_DETAY td2 where td2.TASINIR_KOD = td1.TASINIR_KOD
                                                                  and td2.DAYANIKLI_SICIL_KOD <> td1.DAYANIKLI_SICIL_KOD)
--and td1.TASINIR_KOD  = '2530201030104'
having count(td1.SICIL_KOD)>1
group by td1.TASINIR_KOD,td1.SICIL_KOD
order by td1.SICIL_KOD,td1.TASINIR_KOD;