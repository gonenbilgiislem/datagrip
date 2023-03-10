DECLARE
    CURSOR Cr_Bey IS
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
          AND GB.ADA = 751
          and GB.PARSEL = 1
          and GB.KISI_KOD = 80920;
    V_Islem_Yapildi_Eh VARCHAR2(1);
    X_TY_GEN_CEVAP     TY_GEN_CEVAP;
    X_Islem_Kod        Gys_Tahakkuk_Ana.Islem_Kod%TYPE;
BEGIN
    FOR Rc_Bey IN Cr_Bey
        LOOP
            X_TY_GEN_CEVAP := TY_GEN_CEVAP();
            V_Islem_Yapildi_Eh := 'E';
            X_Islem_Kod := 'II_SINIF_TERKINI';
            EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_GYS_TAHAKKUK_LOG DISABLE';
            PG_GYS_EMLAK_SERVIS.Sp_Emlak_Tahakkuk(
                    'I',
                    Rc_Bey.Kisi_Kod,
                    1014,
                    Rc_Bey.Emlak_Beyan_Turu,
                    Rc_Bey.Kabul_Tarih,
                    TO_DATE('31/12/2023', 'DD/MM/YYYY'),
                    X_Islem_Kod,
                    Rc_Bey.Sira_No,
                    Rc_Bey.Sira_No,
                    2023,
                    2023,
                    'H',
                    V_Islem_Yapildi_Eh,
                    27,
                    X_TY_GEN_CEVAP);
            IF X_TY_Gen_Cevap.Kod IS NOT NULL
                AND X_TY_Gen_Cevap.Aciklama IS NOT NULL
            THEN
                DBMS_OUTPUT.PUT_LINE('Kod1: ' || X_TY_Gen_Cevap.Kod || ' Aciklama1: ' || X_TY_Gen_Cevap.Aciklama ||
                                     'Parametre veya Log Trigger Kontrol Ediniz.!');
                ROLLBACK;
                IF V_Islem_Yapildi_Eh = 'E'
                THEN
                    COMMIT;
                    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_GYS_TAHAKKUK_LOG ENABLE';
                ELSE
                    DBMS_OUTPUT.PUT_LINE('Kod2: ' || X_TY_Gen_Cevap.Kod || ' Aciklama2: ' || X_TY_Gen_Cevap.Aciklama);
                    ROLLBACK;
                END IF;
            END IF;
        END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('i??lem tamamland??');
END;
--