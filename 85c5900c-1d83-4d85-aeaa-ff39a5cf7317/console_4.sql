DECLARE
    CURSOR Cr_Eis is
        SELECT eks.*
        FROM EIS_KIRA_SOZLESME eks
        WHERE eks.KAC_AY = 12
      --    and eks.KISI_KOD = 54252
          AND (EXTRACT(YEAR FROM eks.BITIS_TARIH) > 2022)
    and eks.ODEME_ACIKLAMA like 'HER YIL AĞUSTOS AYI SONUNA KADAR ÖDENECEKTİR'
    and eks.ODEME_SEKLI = 'P';
    V_Islem_Yapildi_Eh VARCHAR2(1);
    X_TY_GEN_CEVAP     TY_GEN_CEVAP;
    X_Islem_Kod        Gys_Tahakkuk_Ana.Islem_Kod%TYPE;
    X_VADE_TARIH      DATE;
BEGIN
    FOR Rc_Eis IN Cr_Eis
        LOOP
            X_TY_GEN_CEVAP := TY_GEN_CEVAP();
            V_Islem_Yapildi_Eh := 'E';
            X_Islem_Kod := '2023_KIRA_TAHAKKUK';
            X_VADE_TARIH := '31/08/2023';
            EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_GYS_TAHAKKUK_LOG DISABLE';

            PG_EIS_GENEL_SERVIS.Sp_Kira_Tahakkuk(
                    'I',
                    1014,
                    X_Islem_Kod,
                    Rc_Eis.Kisi_Kod,
                    Rc_Eis.Kisi_Kod,
                    2023,
                    1,
                    12,
                    Rc_Eis.Kac_Ay,
                    Rc_Eis.TASINMAZ_KOD,
                    186,
                    NULL,
                    'E',
                    'V',
                    TO_DATE('31/12/2023', 'DD/MM/YYYY'),
                    TO_DATE(X_VADE_TARIH, 'DD/MM/YYYY'),
                    Rc_Eis.ACIKLAMA || ' - 2023 Otomatik Kira Tahakkuk',
                    V_ISLEM_YAPILDI_EH,
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
                    DBMS_OUTPUT.PUT_LINE('Kod2: ' || X_TY_Gen_Cevap.Kod || ' Aciklama2: ' || X_TY_Gen_Cevap.Aciklama);
                    DBMS_OUTPUT.put_line('SQLCODE-2_1: ' || SQLCODE);
                    DBMS_OUTPUT.put_line('SQLERRM-2_2: ' || SQLERRM);
                    COMMIT;

                    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_GYS_TAHAKKUK_LOG ENABLE';
                ELSE
                    DBMS_OUTPUT.PUT_LINE('Kod3: ' || X_TY_Gen_Cevap.Kod || ' Aciklama3: ' || X_TY_Gen_Cevap.Aciklama);
                    DBMS_OUTPUT.PUT_LINE('SQLCODE-3_1: ' || SQLCODE);
                    DBMS_OUTPUT.PUT_LINE('SQLERRM-3_2: ' || SQLERRM);
                    ROLLBACK;
                END IF;
            END IF;
        END LOOP;
    DBMS_OUTPUT.put_line('Alinan Hata Kodu : ' || SQLCODE);
    DBMS_OUTPUT.put_line('Alinan Hata Mesaji : ' || SQLERRM);
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            DBMS_OUTPUT.put_line('Alinan Hata Kodu : ' || SQLCODE);
            DBMS_OUTPUT.put_line('Alinan Hata Mesaji : ' || SQLERRM);
    WHEN OTHERS
        THEN
            DBMS_OUTPUT.put_line('ERROR!');


            --DBMS_OUTPUT.PUT_LINE ('Kod: '|| X_TY_Gen_Cevap.Kod|| ' Aciklama: '|| X_TY_Gen_Cevap.Aciklama);
--                DBMS_OUTPUT.PUT_LINE ('SQLCODE-2_1: ' || SQLCODE);
--                DBMS_OUTPUT.PUT_LINE ('SQLERRM-2_2: ' || SQLERRM);
            COMMIT;
    --EXCEPTION
--    WHEN NO_DATA_FOUND
--    THEN
--        DBMS_OUTPUT.put_line ('Alinan Hata Kodu : ' || SQLCODE);
--        DBMS_OUTPUT.put_line ('Alinan Hata Mesaji : ' || SQLERRM);
--    WHEN OTHERS
--    THEN
--        DBMS_OUTPUT.put_line ('ERROR!');
END;