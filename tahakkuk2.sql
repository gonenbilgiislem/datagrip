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
--        AND GB.KISI_KOD = 80920
          AND GB.ADA = 1038
          AND GB.PARSEL = 127
--        AND GB.INSAAT_SINIF_KOD = '16'
        order by GB.KISI_KOD, GB.SIRA_NO, GB.ADA, GB.PARSEL;
    V_Islem_Yapildi_Eh VARCHAR2(1);
    X_TY_GEN_CEVAP     TY_GEN_CEVAP;
    X_Islem_Kod        Gys_Tahakkuk_Ana.Islem_Kod%TYPE;
    VAR_ROWS           NUMBER;
BEGIN
    FOR Rc_Bey IN Cr_Bey
        LOOP
            X_TY_GEN_CEVAP := TY_GEN_CEVAP();
            V_Islem_Yapildi_Eh := 'E';
            X_Islem_Kod := 'II_SINIF_TERKINI';
            EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_GYS_TAHAKKUK_LOG DISABLE';
            VAR_ROWS := SQL%ROWCOUNT;
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
                DBMS_OUTPUT.PUT_LINE('Kod1: ' || X_TY_Gen_Cevap.Kod || ' Aciklama1: ' || X_TY_Gen_Cevap.Aciklama);
                DBMS_OUTPUT.PUT_LINE('SQLCODE-1_1: ' || SQLCODE);
                DBMS_OUTPUT.PUT_LINE('SQLERRM-1_2: ' || SQLERRM);
                ROLLBACK;
            ELSE
                IF V_Islem_Yapildi_Eh = 'E'
                THEN
                    DBMS_OUTPUT.put_line('Kişi Kod: ' || Rc_Bey.Kisi_Kod || ', Sıra No: ' || Rc_Bey.Sira_No ||
                                         ', Sıra No: ' || Rc_Bey.Sira_No || ' İşlem Yapıldı');
                    DBMS_OUTPUT.PUT_LINE(VAR_ROWS);
                    COMMIT;
                    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_GYS_TAHAKKUK_LOG ENABLE';
                ELSE
                    DBMS_OUTPUT.put_line('Kişi Kod: ' || Rc_Bey.Kisi_Kod || ', Sıra No: ' || Rc_Bey.Sira_No ||
                                         ' İşlem Yapılmadı - MUHTEMELEN TAHAKKUK MEVCUT KONTROL EDİNİZ');
                    DBMS_OUTPUT.PUT_LINE(VAR_ROWS);
                    ROLLBACK;
                    COMMIT;
                END IF;
            END IF;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('Döngü Bitti');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('işlem tamamlandı');
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            DBMS_OUTPUT.PUT_LINE('Kod5: ' || X_TY_Gen_Cevap.Kod || ' Aciklama5: ' || X_TY_Gen_Cevap.Aciklama);
            DBMS_OUTPUT.PUT_LINE('SQLCODE-5_1: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('SQLERRM-5_2: ' || SQLERRM);
    WHEN OTHERS
        THEN
            DBMS_OUTPUT.put_line('ERROR!');
            DBMS_OUTPUT.PUT_LINE('Kod6: ' || X_TY_Gen_Cevap.Kod || ' Aciklama6: ' || X_TY_Gen_Cevap.Aciklama);
            DBMS_OUTPUT.PUT_LINE('SQLCODE-6_1: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('SQLERRM-6_2: ' || SQLERRM);
            COMMIT;
END;