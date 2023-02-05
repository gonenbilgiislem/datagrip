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
          AND GB.KISI_KOD = 33406045870
          --        AND GB.ADA = 746
          --      AND GB.PARSEL = 106
--        AND GB.INSAAT_SINIF_KOD = '16'
        order by GB.KISI_KOD, GB.SIRA_NO, GB.ADA, GB.PARSEL;
    V_Islem_Yapildi_Eh VARCHAR2(1);
    X_TY_GEN_CEVAP     TY_GEN_CEVAP;
    X_Islem_Kod        Gys_Tahakkuk_Ana.Islem_Kod%TYPE;
    X_HATA_KOD         GYS_TAHAKKUK_DBMS_OUTPUT.KOD%TYPE;
BEGIN
    FOR Rc_Bey IN Cr_Bey
        LOOP
            X_TY_GEN_CEVAP := TY_GEN_CEVAP();
            V_Islem_Yapildi_Eh := 'E';
            X_Islem_Kod := 'ERTAN_TUNCEL_GUNCELLEME';
            EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_GYS_TAHAKKUK_LOG DISABLE';
            X_HATA_KOD := 0;
            SELECT MAX(KOD) INTO X_HATA_KOD FROM GYS_TAHAKKUK_DBMS_OUTPUT;
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
                INSERT INTO GYS_TAHAKKUK_DBMS_OUTPUT (KOD, "Alan1", "Alan2", "Alan3", "Alan4", "Alan5")
                VALUES ((X_HATA_KOD + 1), Rc_Bey.Kisi_Kod, Rc_Bey.Sira_No, 'İşlem Yapılmadı_SQLCODE-1',
                        'Ada : ' || Rc_Bey.ADA, 'Parsel : ' || Rc_Bey.PARSEL);
                COMMIT;
                ROLLBACK;
            ELSE
                --X_TY_Gen_Cevap.Kod IS NULL AND X_TY_Gen_Cevap.Aciklama IS  NULL İSE DAVRANIŞ BİÇİMİ
                IF V_Islem_Yapildi_Eh = 'E'
                THEN
                    INSERT INTO GYS_TAHAKKUK_DBMS_OUTPUT (KOD, "Alan1", "Alan2", "Alan3", "Alan4", "Alan5")
                    VALUES ((X_HATA_KOD + 1), Rc_Bey.Kisi_Kod, Rc_Bey.Sira_No, 'İşlem Yapıldı_SQLCODE-2',
                            'Ada : ' || Rc_Bey.ADA, 'Parsel : ' || Rc_Bey.PARSEL);

                        UPDATE GYS_TAHAKKUK_ANA GTA
                        SET GTA.ACIKLAMA = 'Ada : ' || Rc_Bey.ADA || ' Parsel : ' || Rc_Bey.PARSEL || ' ' || X_Islem_Kod
                        WHERE GTA.ISLEM_KOD = X_Islem_Kod
                          AND KOD IN (SELECT GT.TAHAK_KOD
                                      FROM GYS_TAHAKKUK GT
                                      WHERE GT.KISI_KOD = Rc_Bey.Kisi_Kod
                                        and GT.KISI_KOD = gta.KISI_KOD
                                        and GT.BEYAN_KOD = RC_Bey.KOD
                                        AND GT.TAHAK_KOD = GTA.KOD);

                        UPDATE GYS_TERKIN_ANA GTA
                        SET GTA.ACIKLAMA = 'Ada : ' || Rc_Bey.ADA || ' Parsel : ' || Rc_Bey.PARSEL || ' ' || X_Islem_Kod
                        WHERE GTA.ISLEM_KOD = X_Islem_Kod
                          AND KOD IN (SELECT GT.TERKIN_KOD
                                      FROM GYS_TERKIN GT
                                      WHERE GT.KISI_KOD = Rc_Bey.Kisi_Kod
                                        and GT.KISI_KOD = gta.KISI_KOD
                                        and GT.BEYAN_KOD = RC_Bey.KOD
                                        AND GT.TERKIN_KOD = GTA.KOD);

                    COMMIT;
                    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_GYS_TAHAKKUK_LOG ENABLE';

                ELSE
                    insert into GYS_TAHAKKUK_DBMS_OUTPUT (KOD, "Alan1", "Alan2", "Alan3", "Alan4", "Alan5")
                    VALUES ((X_HATA_KOD + 1), Rc_Bey.Kisi_Kod, Rc_Bey.Sira_No,
                            'İşlem Yapılmadı_SQLCODE-3 - MUHTEMELEN TAHAKKUK MEVCUT KONTROL EDİNİZ_SQLCODE-3',
                            'Ada : ' || Rc_Bey.ADA,
                            'Parsel : ' || Rc_Bey.PARSEL);
                    COMMIT;
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
            DBMS_OUTPUT.PUT_LINE('SQLCODE-4_1: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('SQLERRM-4_2: ' || SQLERRM);
    WHEN OTHERS
        THEN
            DBMS_OUTPUT.PUT_LINE('SQLCODE-5_1: ' || SQLCODE);
            DBMS_OUTPUT.PUT_LINE('SQLERRM-5_2: ' || SQLERRM);
            COMMIT;
END;