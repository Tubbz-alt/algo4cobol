       IDENTIFICATION DIVISION.
       PROGRAM-ID.  CreditCard-Sample.
      * AUTHOR:  nacho.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
          *>Cupons
          SELECT Cupon1_file ASSIGN TO '..\files\CUPON1.dat'
          ORGANIZATION IS LINE SEQUENTIAL.

          SELECT Cupon2_file ASSIGN TO '..\files\CUPON2.dat'
          ORGANIZATION IS LINE SEQUENTIAL.

          SELECT Cupon3_file ASSIGN TO '..\files\CUPON3.dat'
          ORGANIZATION IS LINE SEQUENTIAL.

          *> Debts
          SELECT SaldoFile ASSIGN TO "..\files\SALDOS.DAT"
          ORGANIZATION IS INDEXED
          ACCESS MODE IS DYNAMIC
          RECORD KEY IS SALD-KEY
          FILE STATUS IS SaldoStatus.

          *> Sort temp file
          SELECT WorkFile ASSIGN TO "..\files\workfile.dat"
          ORGANIZATION IS LINE SEQUENTIAL.

          *> Output
          SELECT ReportFile ASSIGN TO "..\files\cc_report.dat"
          ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD Cupon1_file.
       01 Cupon1_Record.
         88 EOF-CUPON-1 VALUE HIGH-VALUE.
        03 C1-NRO-TARJ                   PIC 9(10).
        03 C1-NRO-CUPON                  PIC 9(5).
        03 C1-FECHA-COMPRA.
          06 C1-FILLER                   PIC X(2).
          06 C1-DAY                      PIC X(2).
          06 C1-MONTH                    PIC X(2).
          06 C1-YEAR                     PIC X(4).
        03 C1-IMPORTE                    PIC 9(6)V99.

       FD Cupon2_file.
       01 Cupon2_Record.
         88 EOF-CUPON-2 VALUE HIGH-VALUE.
        03 C2-NRO-TARJ                   PIC 9(10).
        03 C2-NRO-CUPON                  PIC 9(5).
        03 C2-FECHA-COMPRA.
          06 C2-FILLER                   PIC X(2).
          06 C2-DAY                      PIC X(2).
          06 C2-MONTH                    PIC X(2).
          06 C2-YEAR                     PIC X(4).
        03 C2-IMPORTE                    PIC 9(6)V99.

       FD Cupon3_file.
       01 Cupon3_Record.
         88 EOF-CUPON-3 VALUE HIGH-VALUE.
        03 C3-NRO-TARJ                   PIC 9(10).
        03 C3-NRO-CUPON                  PIC 9(5).
        03 C3-FECHA-COMPRA.
          06 C3-FILLER                   PIC X(2).
          06 C3-DAY                      PIC X(2).
          06 C3-MONTH                    PIC X(2).
          06 C3-YEAR                     PIC X(4).
        03 C3-IMPORTE                    PIC 9(6)V99.

       FD SaldoFile.
       01 SaldoRecord.
         88 EOF-SALDO VALUE HIGH-VALUE.
         02 SALD-KEY.
           04 SALD-NRO-TARJ            PIC 9(10).
           04 SALD-FECHA               PIC X(10).
         02 SALD-IMPORTE                 PIC 9(6)V99.

       SD WorkFile.
       01 SortRecord.
          88 EOF-WorkFile VALUE HIGH-VALUE.
          02 sort-titular                PIC X(30).
          02 sort-documento              PIC 9(11).
          02 sort-nro-tarjeta            PIC 9(10).
          *>02 sort-saldo                PIC Z(3),Z(2)9V99.
          02 sort-saldo                  PIC 9(6)V99.
          02 sort-nro-cupon              PIC 9(5).
          02 sort-fecha.
             06 FILLER                   PIC X(2).
             06 sort-fecha-DAY           PIC X(2).
             06 sort-fecha-MONTH         PIC X(2).
             06 sort-fecha-YEAR          PIC X(4).
          02 sort-importe                PIC 9(6)V99.

       FD ReportFile.
       01 ReportRecord                   PIC X(60).

       WORKING-STORAGE SECTION.
       *> WS prefix stands for "working storage"
       01   SaldoStatus                  PIC X(2).
           88 SaldoSuccess   VALUE "00".
           88 SaldoNotFound  VALUE "23".

       01   TarjetaStatus                PIC X(2).
       01   WS-CreditCardValid           PIC X(1).
          88 CC-VALID VALUE HIGH-VALUE.
          88 CC-INVALID VALUE LOW-VALUE.
       01   WS-CC-Key                    PIC 9(10).
       01   WS-Saldo-amount              PIC 9(10)V99.
       01   WS-total-amount              PIC 9(10)V99.
       01   WS-cupon-counter             PIC 9(2).

       01 Cupon_Record.
        03 WS-nro-tarjeta                PIC 9(10).
        03 WS-NRO-CUPON                  PIC 9(5).
        03 WS-FECHA-COMPRA.
          06 WS-FILLER                   PIC X(2).
          06 WS-DAY                      PIC X(2).
          06 WS-MONTH                    PIC X(2).
          06 WS-YEAR                     PIC X(4).
        03 WS-IMPORTE                    PIC 9(6)V99.

       01 WS-C1-IMPORTE                  PIC 9(6)V99.

       01 WS-TJ-KEY.
         03 WS-TJ-NRO-TARJ               PIC 9(10).

       01 WS-SALD-KEY.
          02 WS-SALD-NRO-TARJ            PIC 9(10).
          02 WS-SALD-FECHA               PIC X(10).

       01 TarjetaRecord.
         88 EOF-TARJETA VALUE HIGH-VALUE.
         02 TJ-KEY.
           03 TJ-NRO-TARJ        PIC 9(10).
         02 TJ-TITULAR                   PIC X(30).
         02 TJ-DOCUMENTO                 PIC 9(11).

       01 ReportLine.
          02 FILLER                      PIC X(58).
          02 ReportPage                  PIC X(02).

       01 Report_page_num                PIC 9(2).

        01  WS-CURRENT-DATE-FIELDS.
           05  WS-CURRENT-DATE.
               10 WS-CURRENT-YEAR        PIC X(04).
               10 WS-CURRENT-MONTH       PIC X(02).
               10 WS-CURRENT-DAY         PIC X(02).
           05  WS-CURRENT-TIME.
               10 WS-CURRENT-HOUR        PIC  9(2).
               10  WS-CURRENT-MINUTE     PIC  9(2).
               10  WS-CURRENT-SECOND     PIC  9(2).
               10  WS-CURRENT-MS         PIC  9(2).
               10  WS-GMT-SIGN           PIC X(01).
               10  WS-GMT-TIME           PIC X(04).

       01 ReportSecondLine.
         02 RSL_date_title               PIC X(7) VALUE "Fecha: ".
         02 RSL_date_day                 PIC X(2).
         02 FILLER                       PIC X(2) VALUE "/".
         02 RSL_date_month               PIC X(2).
         02 FILLER                       PIC X(2) VALUE "/".
         02 RSL_date_year                PIC X(4).

       01 Empty_line.
           03 FILLER                     PIC X(60) VALUE SPACES.

       01 ws-titular                     PIC X(30).

       PROCEDURE DIVISION.
       Begin.
          SORT WorkFile ON ASCENDING KEY sort-titular
                              INPUT PROCEDURE IS Input_Process
                              OUTPUT PROCEDURE IS Output_Process.


          STOP RUN.
      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Input_Process SECTION.
          PERFORM Open_All_Files.
          PERFORM Read_Sequential_Files.
          PERFORM Process_All_Files.
          PERFORM Close_All_Files.

       Output_Process SECTION.
         OPEN OUTPUT ReportFile.
         *> Set Report_page_num to zero
         INITIALIZE Report_page_num.

         PERFORM Get_record_from_sort_file.

         PERFORM Print_header.

         PERFORM UNTIL EOF-WorkFile

           PERFORM Print_first_section

           *> Process all record for cc holder
           WRITE ReportRecord FROM SortRecord

           PERFORM Get_record_from_sort_file

           ADD 1 TO Report_page_num

         END-PERFORM.
         CLOSE ReportFile.
       EXIT SECTION.

       Get_record_from_sort_file.
         RETURN WorkFile AT END SET EOF-WorkFile TO TRUE.


       Print_header.
          *> To do...

       Print_first_section.
          MOVE
       "Nro                       Hoja:                            X"
          TO ReportLine.
          MOVE Report_page_num TO ReportPage.


          WRITE ReportRecord FROM ReportLine.

          *> Write date
          MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-FIELDS.
          MOVE WS-CURRENT-DAY TO RSL_date_day.
          MOVE WS-CURRENT-MONTH TO RSL_date_month.
          MOVE WS-CURRENT-YEAR TO RSL_date_year.

          WRITE ReportRecord FROM ReportSecondLine.
          INITIALIZE ReportLine.
          MOVE "                       LISTA DE CUPONES"
       TO ReportLine.

       WRITE ReportRecord FROM ReportLine.

       Open_All_Files.
          OPEN INPUT SaldoFile.
          OPEN INPUT Cupon1_file.
          OPEN INPUT Cupon2_file.
          OPEN INPUT Cupon3_file.

      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Read_Sequential_Files.
          READ Cupon1_file NEXT RECORD
             AT END SET EOF-CUPON-1 TO TRUE
          END-READ.

          READ Cupon2_file NEXT RECORD
             AT END SET EOF-CUPON-2 TO TRUE
          END-READ.

          READ Cupon3_file NEXT RECORD
             AT END SET EOF-CUPON-3 TO TRUE
          END-READ.

      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Process_All_Files.

         PERFORM UNTIL EOF-CUPON-1 AND EOF-CUPON-2 AND EOF-CUPON-3
             PERFORM Find_lowest_CC_Key

             DISPLAY "Processing CC -> " WS-CC-Key
             PERFORM Process-CreditCard

          END-PERFORM.
      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Find_lowest_CC_Key.
        INITIALIZE WS-CC-Key.
        MOVE C1-NRO-TARJ TO WS-CC-Key.
        *> A=1 B=2 C=3

        IF C1-NRO-TARJ > C2-NRO-TARJ THEN
           IF C2-NRO-TARJ > C3-NRO-TARJ THEN
              MOVE C3-NRO-TARJ TO WS-CC-Key
           ELSE
              MOVE C2-NRO-TARJ TO WS-CC-Key
           END-IF
        ELSE
           IF C1-NRO-TARJ > C3-NRO-TARJ THEN
              MOVE C3-NRO-TARJ TO WS-CC-Key
           END-IF
        END-IF.
      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Process-CreditCard.
          PERFORM Check_CreditCard.

          IF CC-VALID
                DISPLAY "VALID CC"
                PERFORM Copy_CreditCard_Details
                PERFORM Copy_Saldo
                PERFORM Process_All_Cupons_For_CC
                *>PERFORM Print_Amounts
          ELSE
                DISPLAY "INVALID CC"
                PERFORM Move_to_Next_CC
          END-IF.

      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Print_Amounts.
           DISPLAY "------------------------------------".
           DISPLAY "Total de la tarjeta: " WS-total-amount.
           COMPUTE WS-Saldo-amount = FUNCTION NUMVAL(WS-Saldo-amount)
           END-COMPUTE
           COMPUTE WS-total-amount = WS-total-amount + WS-Saldo-amount.
           DISPLAY "Saldo final: " WS-total-amount.
           DISPLAY "------------------------------------".
      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Process_All_Cupons_For_CC.
         MOVE 1 TO WS-cupon-counter.
         MOVE 0 TO WS-total-amount.

         PERFORM Process_CuponFile_1.
         PERFORM Process_CuponFile_2.
         PERFORM Process_CuponFile_3.

      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Process_CuponFile_1.
         DISPLAY "Processing file 1".
         PERFORM UNTIL C1-NRO-TARJ <> WS-CC-Key

            MOVE Cupon1_Record TO Cupon_Record
            PERFORM Copy_Cupon_Details

            *> Send record to work (sort) file
            RELEASE SortRecord

            MOVE C1-IMPORTE TO WS-C1-IMPORTE
            COMPUTE WS-C1-IMPORTE = FUNCTION NUMVAL(WS-C1-IMPORTE)
            END-COMPUTE

            COMPUTE WS-total-amount = (WS-total-amount + WS-C1-IMPORTE)

            READ Cupon1_file NEXT RECORD
             AT END SET EOF-CUPON-1 TO TRUE
            END-READ

            ADD 1 TO WS-cupon-counter

         END-PERFORM.
      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Process_CuponFile_2.
         DISPLAY "Processing file 2".
         PERFORM UNTIL C2-NRO-TARJ <> WS-CC-Key

            MOVE Cupon2_Record TO Cupon_Record
            PERFORM Copy_Cupon_Details

            *> Send record to work (sort) file
            RELEASE SortRecord

            MOVE C2-IMPORTE TO WS-C1-IMPORTE
            COMPUTE WS-C1-IMPORTE = FUNCTION NUMVAL(WS-C1-IMPORTE)
            END-COMPUTE
            COMPUTE WS-total-amount = (WS-total-amount + WS-C1-IMPORTE)

            READ Cupon2_file NEXT RECORD
             AT END SET EOF-CUPON-2 TO TRUE
            END-READ

            ADD 1 TO WS-cupon-counter

         END-PERFORM.
      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Process_CuponFile_3.
         DISPLAY "Processing file 3".
         PERFORM UNTIL C3-NRO-TARJ <> WS-CC-Key

            MOVE Cupon3_Record TO Cupon_Record
            PERFORM Copy_Cupon_Details

            *> Send record to work (sort) file
            RELEASE SortRecord

            MOVE C3-IMPORTE TO WS-C1-IMPORTE
            COMPUTE WS-C1-IMPORTE = FUNCTION NUMVAL(WS-C1-IMPORTE)
            END-COMPUTE
            COMPUTE WS-total-amount = (WS-total-amount + WS-C1-IMPORTE)

            READ Cupon3_file NEXT RECORD
             AT END SET EOF-CUPON-3 TO TRUE
            END-READ

            ADD 1 TO WS-cupon-counter

         END-PERFORM.
      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Copy_Cupon_Details.
         MOVE WS-NRO-CUPON TO sort-nro-cupon.
         MOVE WS-FECHA-COMPRA TO sort-fecha.
         MOVE WS-IMPORTE TO sort-importe.
      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Move_to_Next_CC.
        *>MOVE C1-NRO-TARJ TO WS-nro-tarjeta.
        PERFORM UNTIL C1-NRO-TARJ <> WS-CC-Key
             READ Cupon1_file NEXT RECORD
              AT END SET EOF-CUPON-1 TO TRUE
             END-READ
        END-PERFORM.

        PERFORM UNTIL C2-NRO-TARJ <> WS-CC-Key
             READ Cupon2_file NEXT RECORD
              AT END SET EOF-CUPON-2 TO TRUE
             END-READ
        END-PERFORM.

        PERFORM UNTIL C3-NRO-TARJ <> WS-CC-Key
             READ Cupon3_file NEXT RECORD
              AT END SET EOF-CUPON-3 TO TRUE
             END-READ
        END-PERFORM.

      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Check_CreditCard.
        *> Call subroutine "checkcc"
        *> defined in checkcc.cob file
        CALL 'checkcc' USING BY CONTENT WS-CC-Key,
        BY REFERENCE WS-CreditCardValid,
        BY REFERENCE TarjetaRecord.

      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Copy_CreditCard_Details.
        MOVE TJ-TITULAR TO sort-titular.
        MOVE TJ-DOCUMENTO TO sort-documento.
        MOVE TJ-NRO-TARJ TO sort-nro-tarjeta.

      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Copy_Saldo.

         MOVE WS-CC-Key TO SALD-NRO-TARJ.
         MOVE "  10062016" TO SALD-FECHA.

         START SaldoFile KEY IS EQUAL TO SALD-KEY
          *>INVALID KEY DISPLAY "Invalid Saldo Key :- ", SaldoStatus
          *>NOT INVALID KEY DISPLAY "Saldo Pointer Updated :- "SaldoStatus
         END-START.

        IF SaldoSuccess
           READ SaldoFile NEXT RECORD
              AT END SET EOF-SALDO TO TRUE
           END-READ
           MOVE SALD-IMPORTE TO WS-Saldo-amount
           MOVE WS-Saldo-amount TO sort-saldo
        ELSE
           MOVE 0 TO WS-Saldo-amount
           MOVE WS-Saldo-amount TO sort-saldo
        END-IF.

      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       Close_All_Files.
         CLOSE SaldoFile.
         CLOSE Cupon1_file.
         CLOSE Cupon2_file.
         CLOSE Cupon3_file.
      *-----------------------------------------------------------*
      *-----------------------------------------------------------*
       END PROGRAM CreditCard-Sample.
