*&---------------------------------------------------------------------*
*&  Include           ZFI_P101N_STDN
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
FORM GET_DATA .
*&========== VARIABLE
  DATA : LV_SCPREP     TYPE HROBJID,
         LV_PESIN(1), LV_PESIN1(1), LV_PESIN2(1), LV_PESIN3(1), LV_PESIN4(1),
         LV_ERKEN(1), LV_ERKEN1(1), LV_ERKEN2(1), LV_ERKEN3(1), LV_ERKEN4(1),
         LV_PORAN      TYPE ZCAD_PESIN,
         LV_ORAN       TYPE ZCAD_ERKYUZDE,
         LV_EGT_170    TYPE CMACDB_FEEHD-DOCAMT,
         LV_BRUT       TYPE ZCAT_ODEME_DURUM-UCRET,
         LV_INDIRIM    TYPE ZCAT_ODEME_DURUM-UCRET,
         LV_TUTAR      TYPE ZCAD_TUTAR,
         LV_BENCAT     TYPE PIQBENCAT,
         LV_FNAME(30)  TYPE C,
         LV_FNAME2(30) TYPE C,
         LS_STYLEROW   TYPE LVC_S_STYL,
         LT_STYLETAB   TYPE LVC_T_STYL,
         LV_PRESTNO    TYPE PIQSTUDENT12.

  DATA : GV_BASLANGIC TYPE BEGDA,
         GV_BITIS     TYPE ENDDA.

*&========== LOCAL DATA
  DATA : LT_9203 TYPE STANDARD TABLE OF HRP9203,
         LS_9203 LIKE LINE  OF          LT_9203,
         LT_DATA TYPE TABLE OF          TY_DATAXX,
         LS_DATA TYPE                   TY_DATAXX,
         LT_506  TYPE TABLE OF          HRPAD506,
         LS_506  LIKE LINE  OF          LT_506.
*&=====================================================================*
  LV_SCPREP = '50074579'. " HAZIRLIK SCSÝ
*&=====================================================================*
  SELECT *
    FROM ZCAT_INDIRIM_ORN
    INTO CORRESPONDING FIELDS OF TABLE GT_INDIRIM
    WHERE PERSL EQ P_PERSL.
*&=====================================================================*
  SELECT SINGLE BEGDA ENDDA
    FROM HRT1750     " DÖNEM BAÞLANGIÇ VE BÝTÝÞ TARÝHÝNÝ ALIYORUZ
    INTO ( GV_BASLANGIC , GV_BITIS )
    WHERE TIMELIMIT EQ '0100'
      AND PERYR EQ GV_PERYR
      AND PERID EQ GV_PERID.
*&=====================================================================*
  SELECT *  "LOOP ÝÇÝNDE MALÝYET VE KAR MERKEZÝNÝ ALMAK ÝÇÝN KULLANACAÐIZ
    FROM HRP9203
    INTO TABLE LT_9203
    WHERE PLVAR EQ '01'
    AND   OTYPE EQ 'SC'
    AND   BEGDA LE SY-DATUM
*    AND   BEGDA LE P_SORGU
    AND   ENDDA GE SY-DATUM.
*    AND   ENDDA GE P_SORGU.

  SORT  LT_9203 BY OBJID.
*&=====================================================================*

  SELECT A~STUDENT_STOBJID  A~STUDENT_NO
         A~PROGRAM_TYPE     A~PROGRAM_TYPE_TXT
         A~KAYIT_TURU       A~KAYIT_TURU_TANIM
         A~DAL_KODU         A~DAL_KODU_TEXT
         A~FACULTY_ID       A~FACULTY_CODE
         A~FACULTY_NAME     A~PROGRAM_CS
         A~PROGRAM_ID       A~PROGRAM_CODE
         A~PROGRAM_NAME     A~DEPARTMENT_ID
         A~DEPARTMENT_CODE  A~DEPARTMENT_NAME
         E~OBJID            C~ENRCATEG
         F~OBJID            F~SHORT            F~STEXT
         H~FEECALCMODE      H~DOCNR            H~DOCAMT
         H~DOCCUKY          H~CMSTCAT          H~PARTNER
         J~DOCAMT           J~DOCCUKY
         G~VORNA            G~NACHN            G~PRDNI
         K~STGRP
         L~STGRPT
    FROM ZSM_STDNT_SEARCH     AS A
    INNER JOIN HRP1001        AS B ON B~OBJID  EQ A~STUDENT_STOBJID
    INNER JOIN HRP1770        AS C ON C~OBJID  EQ B~SOBID
    INNER JOIN HRP1771        AS D ON D~OBJID  EQ B~SOBID
    INNER JOIN HRP1001        AS E ON E~OBJID  EQ B~SOBID
    INNER JOIN HRP1000        AS F ON F~OBJID  EQ E~SOBID
    INNER JOIN CMACDB_FEEHD   AS H ON H~CMSTID EQ A~STUDENT_STOBJID
    INNER JOIN CMACDB_ITEMRES AS J ON J~DOCNR  EQ H~DOCNR
    INNER JOIN HRP1702        AS G ON G~OBJID  EQ A~STUDENT_STOBJID
    INNER JOIN HRP1705        AS K ON K~OBJID  EQ A~STUDENT_STOBJID
    INNER JOIN T7PIQSTGRPT    AS L ON L~STGRP  EQ K~STGRP
    INTO TABLE GT_STDN
    WHERE A~PROGRAM_TYPE    IN ( 'ZLP' , 'ZOL' , 'ZHZ' )
      AND A~DAL_KODU        IN ( 'ZL'  , 'ZO'  , 'ZH'  )
      AND A~AYRIL_TARIH     GT GV_BASLANGIC
      AND A~KAYIT_TURU      NOT IN ( '20' , '21' ) " ERASMUS WORLDEXCHANGE ÖÐRENCÝLERÝ HARÝÇ
      AND A~FACULTY_ID      IN S_FAC               " FAKÜLTEYE GÖRE SORGU
      AND A~STUDENT_NO      IN S_ST                " ÖÐRENCÝYE GÖRE SORGU
      AND B~PLVAR           EQ '01'
      AND B~OTYPE           EQ 'ST'
      AND B~SCLAS           EQ 'CS'
      AND B~RSIGN           EQ 'A'
      AND B~RELAT           EQ '517'               " AKTÝF CS ALINDI
      AND C~PLVAR           EQ '01'
      AND C~OTYPE           EQ 'CS'
      AND C~BEGDA           LE GV_BITIS
      AND C~ENDDA           GE GV_BASLANGIC
*      AND C~BEGDA           LE P_SORGU
*      AND C~ENDDA           GE P_SORGU
      AND C~ENRCATEG        NOT IN ( '04', '05', '14', '15' , '21' ) " DÖNEM DURUMUNU ALDIK
      AND D~PLVAR           EQ '01'
      AND D~OTYPE           EQ 'CS'
      AND D~PRS_STATE       EQ 'A'
      AND D~BEGDA           LE GV_BITIS
      AND D~ENDDA           GE GV_BASLANGIC
      AND D~CANCPROCESS     NE 'RM03'
      AND E~PLVAR           EQ '01'
      AND E~OTYPE           EQ 'CS'
      AND E~SCLAS           EQ 'SC'                " AKTÝF SC ALINDI
      AND F~PLVAR           EQ '01'
      AND F~OTYPE           EQ 'SC'
      AND F~LANGU           EQ SY-LANGU            " AKTÝF SC, BÖLÜM ADI VE KODU ALINDI
      AND H~PERSL           EQ P_PERSL
      AND H~CMSTCAT         EQ 'TMTL'              " TMTL ÖÐRENCÝLERÝ
      AND H~FEECALCMODE     IN ( '1' , '5' )       " KÝP
      AND J~ACC_KEY         EQ 'EGT'
      AND G~PLVAR           EQ '01'
      AND G~OTYPE           EQ 'ST'
      AND G~ENDDA           EQ '99991231'
      AND G~PRDNI           IN S_PRDNI             " TC YE GÖRE SORGU
      AND K~OTYPE           EQ 'ST'
      AND K~ENDDA           EQ '99991231'
      AND K~PLVAR             EQ '01'
      AND L~SPRAS           EQ 'T'.

  SELECT A~STUDENT_STOBJID  A~STUDENT_NO
         A~PROGRAM_TYPE     A~PROGRAM_TYPE_TXT
         A~KAYIT_TURU       A~KAYIT_TURU_TANIM
         A~DAL_KODU         A~DAL_KODU_TEXT
         A~FACULTY_ID       A~FACULTY_CODE
         A~FACULTY_NAME     A~PROGRAM_CS
         A~PROGRAM_ID       A~PROGRAM_CODE
         A~PROGRAM_NAME     A~DEPARTMENT_ID
         A~DEPARTMENT_CODE  A~DEPARTMENT_NAME
         E~OBJID            C~ENRCATEG
         F~OBJID            F~SHORT            F~STEXT
         H~FEECALCMODE      H~DOCNR            H~DOCAMT
         H~DOCCUKY          H~CMSTCAT          H~PARTNER
         J~DOCAMT           J~DOCCUKY
         G~VORNA            G~NACHN            G~PRDNI
         K~STGRP
         L~STGRPT
    FROM ZSM_STDNT_SEARCH     AS A
    INNER JOIN HRP1001        AS B ON B~OBJID  EQ A~STUDENT_STOBJID
    INNER JOIN HRP1770        AS C ON C~OBJID  EQ B~SOBID
    INNER JOIN HRP1771        AS D ON D~OBJID  EQ B~SOBID
    INNER JOIN HRP1001        AS E ON E~OBJID  EQ B~SOBID
    INNER JOIN HRP1000        AS F ON F~OBJID  EQ E~SOBID
    INNER JOIN CMACDB_FEEHD   AS H ON H~CMSTID EQ A~STUDENT_STOBJID
    INNER JOIN CMACDB_ITEMRES AS J ON J~DOCNR  EQ H~DOCNR
    INNER JOIN HRP1702        AS G ON G~OBJID  EQ A~STUDENT_STOBJID
    INNER JOIN HRP1705        AS K ON K~OBJID  EQ A~STUDENT_STOBJID
    INNER JOIN T7PIQSTGRPT    AS L ON L~STGRP  EQ K~STGRP
    APPENDING TABLE GT_STDN
    WHERE A~PROGRAM_TYPE    IN ( 'ZLP' , 'ZOL' , 'ZHZ' )
      AND A~DAL_KODU        IN ( 'ZL'  , 'ZO'  , 'ZH'  )
      AND A~AYRIL_YIL       EQ ''
      AND A~KAYIT_TURU      NOT IN ( '20' , '21' ) " ERASMUS WORLDEXCHANGE ÖÐRENCÝLERÝ HARÝÇ
      AND A~FACULTY_ID      IN S_FAC               " FAKÜLTEYE GÖRE SORGU
      AND A~STUDENT_NO      IN S_ST                " ÖÐRENCÝYE GÖRE SORGU
      AND B~PLVAR           EQ '01'
      AND B~OTYPE           EQ 'ST'
      AND B~SCLAS           EQ 'CS'
      AND B~RSIGN           EQ 'A'
      AND B~RELAT           EQ '517'               " AKTÝF CS ALINDI
      AND C~PLVAR           EQ '01'
      AND C~OTYPE           EQ 'CS'
      AND C~BEGDA           LE GV_BITIS
      AND C~ENDDA           GE GV_BASLANGIC
      AND C~ENRCATEG        NOT IN ( '04', '05', '14', '15' , '21' ) " DÖNEM DURUMUNU ALDIK
      AND D~PLVAR           EQ '01'
      AND D~OTYPE           EQ 'CS'
      AND D~PRS_STATE       EQ 'A'
      AND D~BEGDA           LE GV_BITIS
      AND D~ENDDA           GE GV_BASLANGIC
      AND D~CANCPROCESS     NE 'RM03'
      AND E~PLVAR           EQ '01'
      AND E~OTYPE           EQ 'CS'
      AND E~SCLAS           EQ 'SC'                " AKTÝF SC ALINDI
      AND F~PLVAR           EQ '01'
      AND F~OTYPE           EQ 'SC'
      AND F~LANGU           EQ SY-LANGU            " AKTÝF SC, BÖLÜM ADI VE KODU ALINDI
      AND H~PERSL           EQ P_PERSL
      AND H~CMSTCAT         EQ 'TMTL'              " TMTL ÖÐRENCÝLERÝ
      AND H~FEECALCMODE     IN ( '1' , '5' )
      AND J~ACC_KEY         EQ 'EGT'
      AND G~PLVAR           EQ '01'
      AND G~OTYPE           EQ 'ST'
      AND G~ENDDA           EQ '99991231'
      AND G~PRDNI           IN S_PRDNI             " TC YE GÖRE SORGU
      AND K~OTYPE           EQ 'ST'
      AND K~ENDDA           EQ '99991231'
      AND K~PLVAR           EQ '01'
      AND L~SPRAS           EQ 'T'.

  IF GT_STDN IS NOT INITIAL.

    SORT GT_STDN BY STUDENT_STOBJID ASCENDING AKTIF_SC_ID ASCENDING CMAC_DOCNR DESCENDING.
    DELETE ADJACENT DUPLICATES FROM GT_STDN COMPARING STUDENT_STOBJID AKTIF_SC_ID. " CMAC_DOCNR.
    SORT GT_STDN BY STUDENT_STOBJID AKTIF_SC_CODE.
*&=====================================================================*  " FATURA PROGRAMI LOG TABLOSUNDAN KAYITLARI ÇEKÝYORUZ.
    SELECT *
      FROM ZFI_OGRFAT_LOG
      INTO CORRESPONDING FIELDS OF TABLE GT_LOG
      FOR ALL ENTRIES IN GT_STDN
      WHERE OGRENCI EQ GT_STDN-STUDENT_NO
        AND PROGRAM_ID   EQ GT_STDN-AKTIF_SC_ID
        AND UCRET_DONEM  EQ P_PERSL
        AND TAKSIT_DONEM EQ P_TDONEM.

    SORT GT_LOG BY OGRENCI.

*&=====================================================================*
*&========== LOOP
*&=====================================================================*

    LOOP AT GT_STDN INTO GS_STDN.

      CLEAR : LV_BRUT, LV_EGT_170 , LV_INDIRIM , LV_TUTAR , LS_DATA , LV_ERKEN , LV_PESIN ,
              LV_ERKEN1, LV_ERKEN2, LV_ERKEN3, LV_ERKEN4 , LV_PESIN1, LV_PESIN2, LV_PESIN3, LV_PESIN4.

      IF LV_PRESTNO EQ GS_STDN-STUDENT_NO.

        SELECT * FROM HRPAD506
            INTO CORRESPONDING FIELDS OF TABLE LT_506
            WHERE ASTOBJID EQ GS_STDN-STUDENT_STOBJID
              AND PERYR    EQ GV_PERYR
              AND SMSTATUS BETWEEN '1' AND '3'.

        CASE GV_PERID.

          WHEN '001'.

            READ TABLE LT_506 INTO LS_506 WITH KEY PERID = '001'.
            IF SY-SUBRC EQ 0.
              CONTINUE.
            ENDIF.

          WHEN '002'.

            READ TABLE LT_506 INTO LS_506 WITH KEY PERID = '002'.
            IF SY-SUBRC EQ 0.
              CONTINUE.
            ENDIF.

        ENDCASE.

      ENDIF.

      ls_data-TARIH          = P_DATUM.
      LS_DATA-OBJID          = GS_STDN-STUDENT_STOBJID.
      LS_DATA-STUDENT12      = GS_STDN-STUDENT_NO.
      LS_DATA-VORNA          = GS_STDN-VORNA.
      LS_DATA-NACHN          = GS_STDN-NACHN.
      LS_DATA-PRDNI          = GS_STDN-PRDNI.
      LS_DATA-O_OBJID        = GS_STDN-FACULTY_ID.
      LS_DATA-O_SHORT        = GS_STDN-FACULTY_CODE.
      LS_DATA-O_TEXT         = GS_STDN-FACULTY_NAME.
      LS_DATA-SC_OBJID       = GS_STDN-AKTIF_SC_ID.
      LS_DATA-SC_SHORT       = GS_STDN-AKTIF_SC_CODE.
      LS_DATA-SC_TEXT        = GS_STDN-AKTIF_SC_NAME.
      LS_DATA-CS_OBJID       = GS_STDN-AKTIF_CS.
      LS_DATA-STFEECAT       = GS_STDN-CMSTCAT.
      LS_DATA-TAHTUTAR       = GS_STDN-CMAC_DOCAMT.
      LS_DATA-PROGRAM_PBIRIM = GS_STDN-CMAC_DOCCURR.
      LS_DATA-DOCNR          = GS_STDN-CMAC_DOCNR.
      LS_DATA-PARTNER        = GS_STDN-PARTNER.
      LS_DATA-PERSL          = P_PERSL.
      LS_DATA-PERYR          = GV_PERYR.
      LS_DATA-O_SHORT2       = GS_STDN-FACULTY_CODE+0(2).

      CONCATENATE GS_STDN-DEPARTMENT_NAME 'EÐÝTÝM BEDELÝ' INTO LS_DATA-BLM_TEXT SEPARATED BY SPACE.

*&=====================================================================*
      IF GS_STDN-FEECALCMODE EQ '1'.
        SELECT SINGLE PESINTAKSIT TUR
          FROM ZCAT_THSLT_HEAD
          INTO ( LV_PESIN1 , LV_ERKEN1 )
          WHERE KIP       EQ GS_STDN-FEECALCMODE
            AND MUHASEBE  EQ 'X'
*        AND PROGRAMID EQ GS_STDN-AKTIF_SC_ID
            AND OGRNO     EQ GS_STDN-STUDENT_NO
            AND SOZKO     EQ 'EGTM'
            AND DONEM     EQ P_PERSL.

        SELECT SINGLE PESINTAKSIT TUR
          FROM ZCAT_HAVALE_GRS
          INTO ( LV_PESIN2 , LV_ERKEN2 )
*          WHERE FEECALCMODE IN ( '1', '5' )
          WHERE FEECALCMODE EQ GS_STDN-FEECALCMODE
            AND PERSL       EQ P_PERSL
            AND GPART       EQ GS_STDN-PARTNER
            AND OPBEL       IS NOT NULL
            AND SILME       EQ ''
            AND PSOBTYP     EQ 'EGTM'.


        SELECT SINGLE ERKEN_KAYIT KAYIT_TIPI
        INTO ( LV_ERKEN3 , LV_PESIN3 )
          FROM ZCAT_DNZ_SRG_LG2                    " ÖDEME TÜRKLERÝNÝ AL
          WHERE TC_ID EQ LS_DATA-PRDNI
            AND KIP IN ( '1', '5' )
            AND TAKSIT_DURUMU EQ 'OD'
            AND SEZON EQ P_PERSL.


        SELECT SINGLE PESINTAKSIT INDIRIM_TUR
          INTO ( LV_PESIN4 , LV_ERKEN4 )
          FROM ZCAT_PAYU_LOG
          WHERE STUDENT_NO EQ GS_STDN-STUDENT_NO
            AND OPBEL      IS NOT NULL
            AND KAYIT_TIPI EQ GS_STDN-FEECALCMODE
*                AND KAYIT_TIPI IN ( '1' , '5' )
            AND PERSL      EQ P_PERSL.
*            AND PROGRAMID  EQ GS_STDN-AKTIF_SC_ID.

        IF   LV_ERKEN1 EQ 'E'
          OR LV_ERKEN2 EQ 'E'
          OR LV_ERKEN3 EQ 'E'
          OR LV_ERKEN4 EQ 'E'.

          LV_ERKEN = 'E'.
        ELSE.

          LV_ERKEN = 'N'.

        ENDIF.

        IF   LV_PESIN1 EQ 'P'
          OR LV_PESIN2 EQ 'P'
          OR LV_PESIN3 EQ 'P'
          OR LV_PESIN3 EQ '1'
          OR LV_PESIN4 EQ 'P'.

          LV_PESIN = 'P'.

        ELSE.

          LV_PESIN = 'T'.

        ENDIF.

      ELSE.

        LV_ERKEN = 'N'.
        LV_PESIN = 'K'.

      ENDIF.

      LS_DATA-PSN_TKST = LV_PESIN.
      LS_DATA-ERKENKYT = LV_ERKEN.

*&========== PEÞÝN TAKSÝT KONTOLÜ - KONTROL EDÝLECEK BÝTMEDÝ
*&=====================================================================*

*&=====================================================================*
      SELECT SINGLE GSBER " ÝÞ ALANI
        FROM ZCA_WS_GSBER
        INTO LS_DATA-GSBER
        WHERE FAKULTE EQ LS_DATA-O_SHORT2.

*&========== BURS
      SELECT SINGLE BENCAT
        FROM ZSMT_BURS
        INTO LS_DATA-BENCAT
        WHERE STOBJID EQ GS_STDN-STUDENT_STOBJID
          AND FEECALCMODE EQ GS_STDN-FEECALCMODE.

*      IF SY-SUBRC EQ 0.
*        IF LS_DATA-BENCAT EQ ''.
*          LS_DATA-BENCAT = '00'.
*        ENDIF.
*      ENDIF.
*&========== FATURALANMAYACAK OLANLARA ÝÞARET KOYULDU
      SELECT SINGLE FATURALANMAYACAK
        FROM ZCAT_NONFTR_OGR
        INTO LS_DATA-FTRSIZ
        WHERE STUDENT12 EQ LS_DATA-STUDENT12
          AND SC_OBJID  EQ LS_DATA-SC_OBJID
          AND PERSL     EQ P_PERSL
          AND TDONEM    EQ P_TDONEM.

*&========== LOG TABLOSUNDAN VERÝLERÝN ALIMI
      CLEAR GS_LOG.
      READ TABLE GT_LOG INTO GS_LOG WITH KEY OGRENCI = LS_DATA-STUDENT12
                                             PROGRAM_ID = LS_DATA-SC_OBJID
                                             UCRET_DONEM = P_PERSL
                                             TAKSIT_DONEM = P_TDONEM.
      LS_DATA-BELGE_NO   = GS_LOG-BELGE_NO.
      LS_DATA-SIRA_NO    = GS_LOG-SIRA_NO.
      LS_DATA-YAZDIRILDI = GS_LOG-YAZDIRILDI.
      LS_DATA-HESAP      = GS_LOG-HESAP.
      LS_DATA-KDVSIZ     = GS_LOG-KDVSIZ.

*&========== ÖÐRENCÝ ENRCATEG E GÖRE KDVSÝZ OLARAK BASILMASI GEREKEN ÖÐRENCÝLER
      IF    GS_STDN-ENRCATEG EQ '06'
        AND GS_STDN-ENRCATEG EQ '07'
        AND GS_STDN-ENRCATEG EQ '08'
        AND GS_STDN-ENRCATEG EQ '09'
        AND GS_STDN-ENRCATEG EQ '10'
        AND GS_STDN-ENRCATEG EQ '11'
        AND GS_STDN-ENRCATEG EQ '12'
        AND GS_STDN-ENRCATEG EQ '13'
        AND GS_STDN-ENRCATEG EQ '20'.

        LS_DATA-KDVSIZ = 'X'.

      ENDIF.

*&========== ÜCRET HESAPLAMA DETAY VERÝLERÝ ÝNCELEME

      SELECT SUM( DOCAMT )                    " ÜCRET HESAPLAMADA OLAN 170 VE EGT ALANLARINDA OLAN DOCAMT I TOPLA
        FROM CMACDB_ITEMRES
        INTO LV_EGT_170
        WHERE ACC_KEY IN ( '170', 'EGT' )
          AND DOCNR   EQ GS_STDN-CMAC_DOCNR.

      IF P_IPTAL NE 'X'.
        IF LV_EGT_170 EQ '0.00'.                " 0 A EÞÝTSE GEÇ

          CONTINUE.

        ENDIF.
      ENDIF.

      SELECT SUM( DOCAMT )                     " ÜCRET HESAPLAMADA 0 DAN BÜYÜK OLAN DOCAMT I TOPLA
       FROM CMACDB_ITEMRES
       INTO LS_DATA-BUCRET
       WHERE DOCAMT GT '0.00'
         AND DOCNR  EQ GS_STDN-CMAC_DOCNR.

      SELECT SUM( DOCAMT )                     " ÜCRET HESAPLAMADA 0 DAN KÜÇÜK OLAN DOCAMT I TOPLA
        FROM CMACDB_ITEMRES
        INTO LS_DATA-INDIRIM
        WHERE DOCAMT LT '0.00'
          AND DOCNR  EQ GS_FEEHD-DOCNR.

      SELECT SUM( DOCAMT )                     " ÜCRET HESAPLAMADA  DOCAMT I TOPLA
        FROM CMACDB_ITEMRES
        INTO LV_TUTAR
        WHERE DOCNR  EQ GS_FEEHD-DOCNR.

*&========== ÖÐRENCÝ TAHSÝLATLARI - TMTL -

      SELECT SUM( BETRH )
        INTO LS_DATA-THSLTUTAR
        FROM DFKKOP
        WHERE GPART EQ   GS_STDN-PARTNER
          AND HVORG EQ   'ET00'
          AND BLART EQ   'ET'
          AND PERSL EQ   P_PERSL.

*&========== ÖÐRENCÝ ÜCRET HESAPLAMASINDAN TAHAKKUK EDEN TUTARIN BULUNMASI

      LS_DATA-TAHTUTAR2 = LS_DATA-TAHTUTAR.

      IF LS_DATA-TAHTUTAR2 NE '0.00'.

        READ TABLE GT_INDIRIM INTO GS_INDIRIM WITH KEY KIP = GS_STDN-FEECALCMODE.

        IF LS_DATA-PSN_TKST EQ 'P'.                                                         " ücret peþin ise
          LS_DATA-TAHTUTAR2 = LS_DATA-TAHTUTAR2 - ( LS_DATA-TAHTUTAR2 *  ( GS_INDIRIM-PESIN  / 100 ) ).  " yüzde 6 indirim saðla
        ENDIF.

        IF LS_DATA-ERKENKYT  EQ 'E'.                                                         " ücret erken ise
          LS_DATA-TAHTUTAR2 = LS_DATA-TAHTUTAR2 - ( LS_DATA-TAHTUTAR2 *  ( GS_INDIRIM-ERKEN  / 100 ) ).  " yüzde 4 indirim saðla
        ENDIF.

      ENDIF.

*        LS_DATA-THSLTUTAR = LV_THSTUTAR.                                                  " tahsilat tutarý ls_data-thstutar a aktar


*&=====================================================================*

      IF LS_DATA-BUCRET NE '0.00'.

        LS_DATA-INDIRIM_ORAN  = LS_DATA-INDIRIM * 100 / LS_DATA-BUCRET. " ÝNDÝRÝM ORANI

      ELSE.

        LS_DATA-INDIRIM_ORAN = '00'.

      ENDIF.

      IF GS_STDN-CMAC_DOCAMT EQ '0.00'.                              " ücret hesaplama 0 a eþit ise yüzde 100 burslu

        LS_DATA-THSLTUTAR = '0.00'.                              " % 100 burslu
        LS_DATA-TAHTUTAR2 = '0.00'.                              " tahtutar2 yi 0 a eþitledik

        CLEAR LV_INDIRIM.

      ENDIF.

      LS_DATA-TDONEM = P_TDONEM.                                                     " taksit dönemi tdoneme attýk
      LV_BENCAT = LS_DATA-BENCAT.

      CASE LS_DATA-BENCAT.                                                       " bursu yoksa yada boþsa

        WHEN '0' OR SPACE.

          LV_FNAME = 'MALIYETMRKZ00'.                                            " 00 maliyetmerkezi ve yöksis kodunu verdik
          LV_FNAME2 = 'YOKSISK00'.

        WHEN OTHERS.                                                             " bursu varsa

          SHIFT LV_BENCAT LEFT DELETING LEADING '0'.                        " bencatýn baþýnda olan 0 ý sildik
          CONCATENATE 'MALIYETMRKZ' LV_BENCAT INTO LV_FNAME.                " bunuda maliyet merkezi ve yöksis kodunun sonuna ekledik
          CONCATENATE 'YOKSISK' LV_BENCAT INTO LV_FNAME2.

      ENDCASE.

      IF   LV_FNAME EQ 'MALIYETMRKZ00' OR                                               " maliyet00 merkezlerine göre
           LV_FNAME EQ 'MALIYETMRKZ25' OR                                               " maliyet25 merkezlerine göre
           LV_FNAME EQ 'MALIYETMRKZ50' OR                                               " maliyet50 merkezlerine göre
           LV_FNAME EQ 'MALIYETMRKZ75' OR                                               " maliyet75 merkezlerine göre
           LV_FNAME EQ 'MALIYETMRKZ100'  .                                              " maliyet100 merkezlerine göre

        READ TABLE LT_9203 ASSIGNING <FS_9203> WITH KEY OBJID                           " lt_9203 de gereken veriyi field symbol e aktardýk
                                  = GS_STDN-PROGRAM_ID BINARY SEARCH.
        IF SY-SUBRC EQ 0.

          ASSIGN COMPONENT LV_FNAME OF STRUCTURE <FS_9203> TO <FS_VALUE>.               " iþlem baþarýlý ise prctr yi yani kar merkezini ilgili kolondan aldýk
          LS_DATA-PRCTR = <FS_VALUE>.

        ENDIF.

      ENDIF.

      IF LV_FNAME2 EQ 'YOKSISK00' OR                                                    " yöksis00 a göre
         LV_FNAME2 EQ 'YOKSISK25' OR                                                    " yöksis25 a göre
         LV_FNAME2 EQ 'YOKSISK50' OR                                                    " yöksis50 a göre
         LV_FNAME2 EQ 'YOKSISK75' OR                                                    " yöksis75 a göre
         LV_FNAME2 EQ 'YOKSISK100' .                                                    " yöksis100 a göre

        READ TABLE LT_9203 ASSIGNING <FS_9203> WITH KEY OBJID                           " lt_9203 de gereken veriyi field symbol e aktardýk
                                 = GS_STDN-PROGRAM_ID BINARY SEARCH.
*                                   = LV_SCOBJID BINARY SEARCH.

        IF SY-SUBRC EQ 0.

          ASSIGN COMPONENT LV_FNAME2 OF STRUCTURE <FS_9203> TO <FS_VALUE2>.             " maliyet merkezlerine göre
          LS_DATA-YOKSISKD = <FS_VALUE2>.                                               " iþlem baþarýlý ise yöksis kodunu ilgili kolondan aldýk

        ENDIF.

      ENDIF.

      APPEND LS_DATA TO LT_DATA.

*&=====================================================================*
      CLEAR : GS_DATA.

      MOVE-CORRESPONDING LS_DATA TO GS_DATA.

      IF GS_DATA-BELGE_NO IS NOT INITIAL.                                  " gs_data da belge numarasý varsa

        LS_STYLEROW-FIELDNAME = 'FTRSIZ' .                                 " faturasýz alanýný
        LS_STYLEROW-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.            "     giriþe kapalý hale getir
        APPEND LS_STYLEROW  TO GS_DATA-FIELD_STYLE.                        " deðiþikliði gs_datada field_style alanýna kaydet

        LS_STYLEROW-FIELDNAME = 'HESAP' .                                  " hesap alanýný
        LS_STYLEROW-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.
        APPEND LS_STYLEROW  TO GS_DATA-FIELD_STYLE.

        LS_STYLEROW-FIELDNAME = 'KDVSIZ' .                                 " kdvsiz alanýný
        LS_STYLEROW-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.
        APPEND LS_STYLEROW  TO GS_DATA-FIELD_STYLE.

        LS_STYLEROW-FIELDNAME = 'SIRA_NO' .                                " sýra_no alanýný
        LS_STYLEROW-STYLE = CL_GUI_ALV_GRID=>MC_STYLE_DISABLED.
        APPEND LS_STYLEROW  TO GS_DATA-FIELD_STYLE.

      ENDIF.
      IF P_IPTAL NE 'X'.

        IF GS_DATA-TAHTUTAR     IS INITIAL                                   " tahtutar boþ ise
             AND GS_DATA-TAHTUTAR2 IS INITIAL                                " tahtutar2 boþ ise
             AND GS_DATA-THSLTUTAR IS INITIAL                                " thslttutar boþ ise
             AND GS_DATA-BUCRET    IS INITIAL                                " bucret boþ ise
             AND GS_DATA-INDIRIM   IS INITIAL.                               " indirim boþ ise

          CONTINUE.

        ELSE.

          APPEND GS_DATA TO GT_DATA.                                                       " yukarda olan alanlar boþ deðil ise gt_data ya append et
          LV_PRESTNO = GS_STDN-STUDENT_NO.
        ENDIF.

      ELSE.

        APPEND GS_DATA TO GT_DATA.                                                       " yukarda olan alanlar boþ deðil ise gt_data ya append et
        LV_PRESTNO = GS_STDN-STUDENT_NO.

      ENDIF.

      CLEAR LS_DATA.                                                                     " iþlemler sonunda ls_datayý temizle

*&=====================================================================*
    ENDLOOP.

  ENDIF.

ENDFORM.
