If X_Izin_Turu = 'S' Or X_Izin_Turu = 'M' Then V_Yil := V_Kontrol;
Else If  X_Izin_Turu = 'T' THEN V_Yil := V_Kontrol-1;
Else If PI_Belediye_Kod <> 1014 Then V_Yil := V_Kontrol;
Else V_Yil := V_Kontrol;
End If;
End If;
End If;