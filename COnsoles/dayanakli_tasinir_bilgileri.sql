select /*tt.TASINIR_KOD,
       tt.AD,
       tgd.TASINIR_KOD,
       tgd.ADET*/
       *
from TMS_TASINIR tt
inner join TMS_TIF_GIRIS_DETAY tgd on tt.TASINIR_KOD = tgd.TASINIR_KOD
EXISTS (select 1 from TMS_TIF_CIKIS_DETAY tcd where tcd.TASINIR_KOD = tt.TASINIR_KOD)
where
    --SUBSTR(TT.HESAP_KOD,1,3) LIKE '254'
    tgd.AMBAR_KOD = 115
        and
        tt.tasinir_kod = '2540102')