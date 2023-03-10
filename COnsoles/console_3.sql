        SELECT GB.*
        FROM GONSON.GEN_MAHALLE_CADDE_SOKAK GMCS
                 INNER JOIN GONSON.GEN_MAHALLE_KOY GMK ON
            GMCS.MAHALLE_KOD = GMK.KOD
                 INNER JOIN GONSON.GYS_BEYAN GB ON
            GMCS.KOD = GB.MAHALLE_CADDE_KOD
                 INNER JOIN GONSON.GEN_CADDE_SOKAK GCS ON
            GMCS.CADDE_SOKAK_KOD = GCS.KOD
                 INNER JOIN GONSON.GEN_MODUL GM ON
            GB.MODUL_KOD = GM.KOD
        WHERE GB.MODUL_KOD = 1
          AND GB.MUKELLEF_BITIS_TARIH IS NULL
          AND GMK.AKTIF_EH = 'E'
          AND GMK.KOY_EH = 'H'
          AND GB.ADA = :ADA
          and GB.PARSEL = :PARSEL;