DECLARE
    CURSOR Cr_Bey IS
          SELECT B.*
            FROM Gys_Beyan B
           WHERE     B.modul_kod = 1
                 AND B.mukellef_bitis_tarih IS NULL
                                AND B.KISI_KOD BETWEEN '80920' AND '80920'
                 AND B.ADA = 338
                 AND B.PARSEL = 12
                 AND KOD NOT IN
                         (SELECT KOD
                           FROM GYS_BEYAN B
                          WHERE     B.MUKELLEF_BITIS_TARIH IS NULL
                                AND B.MODUL_KOD = 1
                                AND B.DAIMI_MUAFIYET_EH = 'E'
                                AND B.K_BASLANGIC_TARIH IS NOT NULL
                                AND B.K_BITIS_TARIH IS NOT NULL)
        ORDER BY B.Kisi_Kod, B.Kod;

    V_Islem_Yapildi_Eh   VARCHAR2 (1);
    X_TY_GEN_CEVAP       TY_GEN_CEVAP;
    X_Islem_Kod          Gys_Tahakkuk_Ana.Islem_Kod%TYPE;
    v_code  NUMBER;
    v_errm  VARCHAR2(64);
BEGIN
    FOR Rc_Bey IN Cr_Bey
    LOOP
        X_TY_GEN_CEVAP := TY_GEN_CEVAP ();
        V_Islem_Yapildi_Eh := 'E';
        X_Islem_Kod := 'II_SINIF_TERKINI';


 EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_GYS_TAHAKKUK_LOG DISABLE';


        PG_GYS_EMLAK_SERVIS.Sp_Emlak_Tahakkuk (
            'I',
            Rc_Bey.Kisi_Kod,
            1014,
            Rc_Bey.Emlak_Beyan_Turu,
            Rc_Bey.Kabul_Tarih,
            TO_DATE ('31/12/2023', 'DD/MM/YYYY'),
            X_Islem_Kod,
            Rc_Bey.Sira_No,
            Rc_Bey.Sira_No,
            2023,
            2023,
            'H',
            V_Islem_Yapildi_Eh,
            27,
            X_TY_GEN_CEVAP);


        IF     X_TY_Gen_Cevap.Kod IS NOT NULL
           AND X_TY_Gen_Cevap.Aciklama IS NOT NULL
        THEN
          --  raise_application_error(-2300, 'Hata');

        ROLLBACK;
      --  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_GYS_TAHAKKUK_LOG ENABLE';
        ELSE
            IF V_Islem_Yapildi_Eh = 'E'
            THEN
                COMMIT;
                EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_GYS_TAHAKKUK_LOG ENABLE';
            ELSE
                ROLLBACK;
            END IF;
        END IF;
    END LOOP;

    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQLERRM: ' || SQLERRM);

END;