SELECT *
FROM GYS_TAHAKKUK GT
WHERE GT.YIL = 2023
  AND GT.KAYIT_KULLANICI_KOD = '27'
  AND GT.REFERANS_KOD IN (SELECT EKS.TASINMAZ_KOD
                          FROM EIS_KIRA_SOZLESME EKS
                          WHERE EKS.TASINMAZ_KOD > 10000
                            AND EKS.BITIS_TARIH BETWEEN TO_DATE('01/01/2023', 'DD/MM/YYYY') AND TO_DATE('31/12/2023', 'DD/MM/YYYY')
                            AND EKS.TASINMAZ_KOD = GT.REFERANS_KOD
                            AND EKS.KISI_KOD = GT.KISI_KOD
                            AND EKS.KOD IN (SELECT EKA.SOZLESME_KOD
                                            FROM EIS_KIRA_ARTIS EKA
                                            WHERE EXTRACT(YEAR FROM TO_DATE(EKA.ARTIS_TARIH, 'DD/MM/YYYY')) = 2022
                                              AND EKS.KOD = EKA.SOZLESME_KOD))