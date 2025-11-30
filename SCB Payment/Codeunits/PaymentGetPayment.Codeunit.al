codeunit 90210 "Payment - Get Payment"
{
    TableNo = "Payment Schedule Header";
    /*     trigger OnRun()
        var
            GeneralJournalLine: Record "Gen. Journal Line";
            GenJnlLine: Record "Gen. Journal Line";
        begin
            PaymentTransHeader.Get(Rec."Batch Number");
            PaymentTransHeader.TestField("Bank Account Code");
            PaymentTransHeader.TestField("General Journal Template");
            PaymentTransHeader.TestField("General Journal Batch");
            PaymentTransHeader.TestField("Payment Method");
            GeneralJournalLine.Reset();
            GeneralJournalLine.SetFilter("Journal Template Name", '%1', PaymentTransHeader."General Journal Template");
            GeneralJournalLine.SetFilter("Journal Batch Name", '%1', PaymentTransHeader."General Journal Batch");
            GeneralJournalLine.SetRange("Bal. Account No.", PaymentTransHeader."Bank Account Code");
            GeneralJournalLine.SetRange("Payment Method Code", PaymentTransHeader."Payment Method");
            //GeneralJournalLine.SetFilter("Payment ID", '%1', '');
            if not GeneralJournalLine.FindSet() then begin
                GenJnlLine."Journal Template Name" := PaymentTransHeader."General Journal Template";
                GenJnlLine."Journal Batch Name" := PaymentTransHeader."General Journal Batch";
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"Bank Account";
                GenJnlLine."Bal. Account No." := PaymentTransHeader."Bank Account Code";
                GenJnlLine."Payment Method Code" := PaymentTransHeader."Payment Method";
                if GenJnlLine.Insert() then;
                GeneralJournalLine := GenJnlLine;
                Commit();
            end;
            GetPaymentList.LookupMode := true;
            GetPaymentList.SetPaymentJournal(PaymentTransHeader);
            GetPaymentList.SetPaymentJnlRec(GeneralJournalLine);
            GetPaymentList.SetTableview(GeneralJournalLine);
            GetPaymentList.RunModal();
        end;
     */
    var
        PaymentTransHeader: Record "Payment Schedule Header";
        PaymentTransLine: Record "Payment Schedule Line";
        VendorBankAcc: Record "Vendor Bank Account";
        VendorRec: Record Vendor;
        CustBankAcc: Record "Customer Bank Account";
        CustomerRec: Record Customer;
        //EmpBankAcc: Record "Employee Bank Account";
        EmployeeRec: Record Employee;
        //GetPaymentList: Page "Payment Journal";
        BatchLbl: label ' Payment Batch';
        NewBatchNumber: Code[20];
        CheckIsChargeLine: Boolean;
        LineNo: Integer;
        PayeeName: Text[100];
        BankName: Text[100];
        Batch: label ' Payment Batch';
        NoSeriesMgt: Codeunit "No. Series";
    //v:Record venpay
    /* 
        procedure CreatePaymentJnlLines(var GeneralJournalLine: Record "Gen. Journal Line")
        var

            PaymentScheduleLine: Record "Payment Schedule";
            PmtTranSetup: Record "Payment Trans Setup";
            RecdRef: RecordRef;
            CountOnLine: Integer;
            PaymentBatch: Integer;
            PaymentBatchTex: Text[100];
            FirstPaymentHeader: Code[20];
            PageNo: Integer;
            SerialNo: Integer;

        begin
            PaymentTransLine.SetRange("Batch Number", PaymentTransHeader."Batch Number");
            PmtTranSetup.Get();
            if PaymentTransLine.Find('+') then
                LineNo := PaymentTransLine."Line No." + 10000
            else
                LineNo := 10000;
            PageNo := 1;
            SerialNo := 1;
            if GeneralJournalLine.FindSet() then
                repeat
                    RecdRef.GetTable(GeneralJournalLine);
                    GeneralJournalLine.CalcFields("Schedule Amount");
                    if GeneralJournalLine."Schedule Amount" = 0 then begin
                        if GeneralJournalLine."Account Type" = GeneralJournalLine."Account Type"::Vendor then begin
                            VendorBankAcc.SetRange("Vendor No.", GeneralJournalLine."Account No.");
                            VendorBankAcc.FindFirst();
                            VendorRec.Get(GeneralJournalLine."Account No.");
                            PayeeName := VendorRec.Name;
                            BankName := VendorBankAcc.Name;
                        end;
                        if GeneralJournalLine."Account Type" = GeneralJournalLine."Account Type"::Customer then begin
                            CustBankAcc.SetRange("Customer No.", GeneralJournalLine."Account No.");
                            CustBankAcc.FindFirst();
                            CustomerRec.Get(GeneralJournalLine."Account No.");
                            PayeeName := CustomerRec.Name;
                            BankName := CustBankAcc.Name;
                        end;
                        if GeneralJournalLine."Account Type" = GeneralJournalLine."Account Type"::Employee then begin
                            EmpBankAcc.SetRange("Employee No.", GeneralJournalLine."Account No.");
                            EmpBankAcc.FindFirst();
                            EmployeeRec.Get(GeneralJournalLine."Account No.");
                            PayeeName := EmployeeRec.FullName();
                            BankName := EmpBankAcc."Bank Name";
                        end;
                        LineNo := LineNo + 10000;
                        PaymentTransLine.Init();
                        PaymentTransLine."Batch Number" := PaymentTransHeader."Batch Number";
                        PaymentTransLine."Line No." := LineNo;
                        PaymentTransLine."Bank CBN Code" := VendorBankAcc."CBN Code";
                        PaymentTransLine."To Account Number" := VendorBankAcc."Bank Account No.";
                        PaymentTransLine.Amount := GeneralJournalLine.Amount;
                        PaymentTransLine.Description := GeneralJournalLine."Description";
                        PaymentTransLine."Payee No." := GeneralJournalLine."Account No.";
                        PaymentTransLine.Payee := PayeeName;
                        PaymentTransLine."Reference Type" := PaymentTransLine."reference type"::"Gen Journal";
                        PaymentTransLine."Record ID" := RecdRef.RecordId;
                        PaymentTransLine."Bank Name" := BankName;
                        if Format(SerialNo) = PmtTranSetup." Nibss Schedule Size " then begin
                            PageNo := PageNo + 1;
                            SerialNo := 1;
                        end;
                        if GeneralJournalLine."Account Type" = GeneralJournalLine."Account Type"::"Bank Account" then
                            PaymentTransLine."Source Type" := PaymentTransLine."Source Type"::"Bank Account";
                        if GeneralJournalLine."Account Type" = GeneralJournalLine."Account Type"::Employee then
                            PaymentTransLine."Source Type" := PaymentTransLine."Source Type"::Staff;
                        if GeneralJournalLine."Account Type" = GeneralJournalLine."Account Type"::Vendor then
                            PaymentTransLine."Source Type" := PaymentTransLine."Source Type"::Vendor;
                        PaymentTransLine."Source No." := GeneralJournalLine."Document No.";
                        PaymentTransLine."Schedule Page No." := PageNo;
                        PaymentTransLine."Schedule Serial No." := SerialNo;
                        SerialNo := SerialNo + 1;
                        PaymentTransLine.Insert(true);
                        SerialNo := SerialNo + 1;
                    end else begin
                        GeneralJournalLine.SetRange("Document Type", GeneralJournalLine."Document Type");
                        GeneralJournalLine.SetRange("Document No.", GeneralJournalLine."Document No.");
                        GeneralJournalLine.Find('-');
                        repeat
                            GeneralJournalLine.CalcFields("Schedule Amount");
                            if GeneralJournalLine."Schedule Amount" <> 0 then begin
                                PaymentScheduleLine.SetRange("Source Document No.", GeneralJournalLine."Document No.");
                                PaymentScheduleLine.SetRange("Source Line No.", GeneralJournalLine."Line No.");
                                PaymentScheduleLine.FindSet();
                                if PaymentScheduleLine.Count > 8000 then begin
                                    PaymentBatch := PaymentBatch + 1;
                                    PaymentBatchTex := '001';
                                    FirstPaymentHeader := PaymentTransHeader."Batch Number";
                                    PaymentTransHeader.Description := GeneralJournalLine.Description;
                                    PaymentTransHeader.Modify();
                                    PaymentBatchTex := PaymentTransHeader.Description;
                                end;
                                NewBatchNumber := PaymentTransHeader."Batch Number";
                                repeat
                                    CountOnLine += 1;
                                    PaymentScheduleLine.TestField("Payee Account No.");
                                    PaymentScheduleLine.TestField("Payee Name");
                                    PaymentTransLine.Init();
                                    PaymentTransLine."Reference Number" := '';
                                    if CountOnLine = 8000 then begin
                                        PaymentBatchTex := IncStr(PaymentBatchTex);
                                        PaymentBatch := PaymentBatch + 1;
                                        NewBatchNumber := CreateHeaderBatch(FirstPaymentHeader, PaymentBatchTex);
                                        LineNo := 0;
                                        CountOnLine := 0;
                                    end;
                                    LineNo := LineNo + 1000;
                                    PaymentTransLine."Source Type" := PaymentTransLine."Source Type"::Import;
                                    PaymentTransLine."Batch Number" := NewBatchNumber;
                                    PaymentTransLine."Payment Batch" := CopyStr(BatchLbl + ' ' + PaymentBatchTex, 1, MaxStrLen(PaymentTransLine."Payment Batch"));
                                    PaymentTransLine."Line No." := LineNo;
                                    PaymentTransLine."Bank CBN Code" := PaymentScheduleLine."CBN Bank Code";
                                    PaymentTransLine.Payee := VendorRec.Name;
                                    PaymentTransLine."To Account Number" := PaymentScheduleLine."Payee Account No.";
                                    PaymentTransLine.Amount := (PaymentScheduleLine.Amount);
                                    PaymentTransLine.Description := PaymentScheduleLine."Posting Description";
                                    PaymentTransLine."Reference Type" := PaymentTransLine."reference type"::"Gen Journal";
                                    PaymentTransLine."Record ID" := RecdRef.RecordId;
                                    PaymentTransLine."Source No." := GeneralJournalLine."Document No.";
                                    PaymentTransLine."Payee No." := PaymentScheduleLine."Payee No.";
                                    PaymentTransLine."Payee BVN" := PaymentScheduleLine."Payee BVN";
                                    if Format(SerialNo) = PmtTranSetup." Nibss Schedule Size " then begin
                                        PageNo := PageNo + 1;
                                        SerialNo := 1;
                                    end;
                                    PaymentTransLine."Schedule Page No." := PageNo;
                                    PaymentTransLine."Schedule Serial No." := SerialNo;
                                    PaymentTransLine.Insert(true);
                                    SerialNo := SerialNo + 1;
                                    CountOnLine := CountOnLine + 1;
                                until PaymentScheduleLine.Next() = 0;
                            end;
                        until GeneralJournalLine.Next() = 0;
                    end;
                    GeneralJournalLine."Payment ID" := PaymentTransHeader."Batch Number";
                    GeneralJournalLine.Modify();
                until GeneralJournalLine.Next() = 0;
            if CheckIsChargeLine then begin
                PaymentTransHeader.Submitted := true;
                PaymentTransHeader.Modify();
            end;
        end;

     */
    procedure SetPaymentTranHeader(var PaymentTransHeader2: Record "Payment Schedule Header")
    begin
        PaymentTransHeader.Get(PaymentTransHeader2."Batch Number");
        if CheckIsChargeLine then begin
            PaymentTransHeader.Submitted := false;
            PaymentTransHeader.Modify();
        end;
        PaymentTransHeader.TestField(Submitted, false);
    end;

    procedure CreateHeaderBatch(PaymentHeader: Code[20]; BatchName: Text) "Batch Number": Code[20]
    var
        PaymentTransHeaderRec: Record "Payment Schedule Header";
        NewPaymentTransHeaderRec: Record "Payment Schedule Header";
    begin
        PaymentTransHeaderRec.Get(PaymentHeader);
        NewPaymentTransHeaderRec.Init();
        NewPaymentTransHeaderRec.TransferFields(PaymentTransHeaderRec);
        NewPaymentTransHeaderRec."Batch Number" := '';
        NewPaymentTransHeaderRec.Insert(true);
        "Batch Number" := NewPaymentTransHeaderRec."Batch Number";
        if PaymentTransHeaderRec."Related Batches" = '' then begin
            PaymentTransHeaderRec."Related Batches" := NewPaymentTransHeaderRec."Batch Number";
            NewPaymentTransHeaderRec.Description := Format(BatchName);
            NewPaymentTransHeaderRec.Modify();
            PaymentTransHeaderRec.Modify();
        end else begin
            PaymentTransHeaderRec."Related Batches" := CopyStr(PaymentTransHeaderRec."Related Batches" + '|' + NewPaymentTransHeaderRec."Batch Number", 1, MaxStrLen(PaymentTransHeaderRec."Related Batches"));  //PaymentTransHeaderRec."Related Batches" + '|' + NewPaymentTransHeaderRec."Batch Number";
            NewPaymentTransHeaderRec.Description := Format(BatchName);
            NewPaymentTransHeaderRec.Modify();
            PaymentTransHeaderRec.Modify();
        end;
        exit;
    end;

    procedure GetPaymentVoucher(var Rec: Record "Payment Schedule Header")
    var
        PaymentHeader: Record "Payment Voucher Header";
        PaymentSchedule: Record "Payment Schedule";
        GetPaymentList: Page "Get Payment Voucher";
    begin
        PaymentTransHeader.Get(Rec."Batch Number");
        PaymentTransHeader.TestField("Bank Account Code");
        PaymentHeader.SetRange("Status", PaymentHeader."Status"::Approved);
        PaymentHeader.SetRange("Payment Method", PaymentHeader."payment method"::"E-Payment");
        PaymentHeader.SetRange(PaymentHeader."Bal Account No.", PaymentTransHeader."Bank Account Code");
        PaymentHeader.SetFilter(PaymentHeader."Payment ID", '%1', '');

        if PaymentHeader.Find('-') then begin
            PaymentSchedule.SetRange(PaymentSchedule."Source Document No.", PaymentHeader."No.");
            repeat
                //if (PaymentHeader."Payment Type" = PaymentHeader."payment type"::"Supp. Invoice") then begin
                //PaymentHeader.TestField("Payee Bank Code");
                PaymentHeader.TestField("Bal Account No.");
            //PaymentHeader.TestField("Payee");
            //end;
            until PaymentHeader.Next = 0;
            // PaymentTransHeader."Attached to Entity" := PaymentTransHeader."Attached to Entity"::PV;
            // PaymentTransHeader.Modify();
        end;

        GetPaymentList.LookupMode := true;
        GetPaymentList.SetTableview(PaymentHeader);

        GetPaymentList.SetPaymentHeader(PaymentTransHeader);
        GetPaymentList.RunModal;
    end;

    procedure CreatePaymentLines(var PaymentHeader: Record "Payment Voucher Header")
    var
        RecdRef: RecordRef;
        PaymentLine: Record "Payment Voucher Line";
        GLSetup: Record "General Ledger Setup";
        PaymentScheduleLine: Record "Payment Schedule";
        CountOnLine: Integer;
        PaymentBatch: Integer;
        PaymentBatchTex: Text[100];
        FirstPaymentHeader: Code[10];
        PageNo: Integer;
        SerialNo: Integer;
        PmtTranSetup: Record "Payment Schedule Setup";
        Vendor: Record Vendor;
    begin
        PaymentTransLine.SetRange("Batch Number", PaymentTransHeader."Batch Number");
        PmtTranSetup.Get;
        if PaymentTransLine.Find('+') then
            LineNo := PaymentTransLine."Line No." + 10000
        else
            LineNo := 10000;
        PageNo := 1;
        SerialNo := 1;
        with PaymentHeader do begin
            if PaymentHeader.Find('-') then begin
                repeat

                    PaymentHeader.CalcFields("Voucher Amount", "Schedule Amount");
                    RecdRef.GetTable(PaymentHeader);
                    if PaymentHeader."Schedule Amount" = 0 then begin
                        //PaymentHeader.TestField("Payee Bank Code");
                        PaymentHeader.TestField("Bal Account No.");
                        //PaymentHeader.TestField("Payee");
                        //PaymentHeader.TestField("Payee CBN Bank Code");
                        PaymentLine.SetRange("Document No.",PaymentHeader."No.");
                        PaymentLine.FindFirst();
                        VendorRec.Get(PaymentLine."Account No.");
                        LineNo := LineNo + 10000;
                        PaymentTransLine.Init;
                        PaymentTransLine."Batch Number" := PaymentTransHeader."Batch Number";
                        PaymentTransLine."Line No." := LineNo;
                        if PaymentLine."Account Type" = PaymentLine."Account Type"::Vendor then
                            if VendorBankAcc.Get(PaymentLine."Account No.", VendorRec."Preferred Bank Account Code") then
                                PaymentTransLine."To Account Number" := VendorBankAcc."Bank Account No.";
                        PaymentTransLine.Amount := (PaymentHeader."Voucher Amount");
                        PaymentTransLine.Description := PaymentHeader."Request Description";
                        PaymentTransLine."Payee No." := PaymentLine."Account No.";
                        //VendorRec.Get( PaymentTransLine."Payee No.");
                        PaymentTransLine.Payee := VendorRec.Name;
                        PaymentTransLine."Bank Name" := VendorBankAcc.Name;
                        PaymentTransLine."Bank CBN Code" := VendorBankAcc."CBN Code";
                        PaymentTransLine. "Branch Code":= VendorBankAcc."Bank Branch No.";
                        PaymentTransLine."Reference Type" := PaymentTransLine."reference type"::Voucher;
                        PaymentTransLine."Source Type" := PaymentTransLine."Source Type"::Vendor;
                        PaymentTransLine."Record ID" := RecdRef.RecordId;
                     PaymentTransLine.   "Reference Number" := NoSeriesMgt.GetNextNo(PmtTranSetup."Reference No. Series");
                        // if Format(SerialNo) = PmtTranSetup."Nibss Schedule Size" then begin
                        //     PageNo := PageNo + 1;
                        //     SerialNo := 1;
                        // end;
                        PaymentTransLine."Creditor BIC" := VendorBankAcc."SWIFT Code";
                        PaymentTransLine."Source No." := PaymentHeader."No.";
                        PaymentTransLine."Schedule Page No." := PageNo;
                        PaymentTransLine."Schedule Serial No." := SerialNo;
                        SerialNo := SerialNo + 1;
                        PaymentTransLine.Insert();
                        SerialNo := SerialNo + 1;
                    end else begin
                        //PaymentLine.SetRange("Document Type", PaymentHeader."Document Type");
                        PaymentLine.SetRange("Document No.", PaymentHeader."No.");
                        PaymentLine.Find('-');
                        repeat
                            PaymentLine.CalcFields("Schedule Amount");
                            if PaymentLine."Schedule Amount" <> 0 then begin
                                PaymentScheduleLine.SetRange("Source Document No.", PaymentLine."Document No.");
                                PaymentScheduleLine.SetRange("Source Line No.", PaymentLine."Line No.");
                                PaymentScheduleLine.FindSet;
                                if PaymentScheduleLine.Count > 8000 then begin
                                    PaymentBatch := PaymentBatch + 1;
                                    PaymentBatchTex := '001';
                                    FirstPaymentHeader := PaymentTransHeader."Batch Number";
                                    PaymentTransHeader.Description := PaymentHeader."Request Description" + '' + Batch + '-' + PaymentBatchTex;
                                    PaymentTransHeader.Modify;
                                    PaymentBatchTex := PaymentTransHeader.Description;
                                end;
                                NewBatchNumber := PaymentTransHeader."Batch Number";
                                repeat
                                    PaymentScheduleLine.TestField("Payee Account No.");
                                    PaymentScheduleLine.TestField("Payee Name");
                                    //PaymentScheduleLine.TESTFIELD("CBN Bank Code");
                                    PaymentTransLine.Init;
                                    PaymentTransLine."Reference Number" := '';
                                    if CountOnLine = 8000 then begin
                                        PaymentBatchTex := IncStr(PaymentBatchTex);
                                        PaymentBatch := PaymentBatch + 1;
                                        //PaymentBatchTex:= FORMAT(PaymentBatch);
                                        NewBatchNumber := CreateHeaderBatch(FirstPaymentHeader, PaymentBatchTex);
                                        LineNo := 0;
                                        CountOnLine := 0;
                                    end;
                                    LineNo := LineNo + 1000;
                                    PaymentTransLine."Batch Number" := NewBatchNumber;
                                    PaymentTransLine."Payment Batch" := Batch + ' ' + PaymentBatchTex;
                                    PaymentTransLine."Line No." := LineNo;
                                    PaymentTransLine.Validate("Bank CBN Code", PaymentScheduleLine."CBN Bank Code");
                                    //PaymentTransLine.TransactionType := 50;
                                    PaymentTransLine."To Account Number" := PaymentScheduleLine."Payee Account No.";
                                    //PaymentTransLine."To Account Type" := 10;
                                    PaymentTransLine.Amount := (PaymentScheduleLine.Amount);
                                    PaymentTransLine.Description := PaymentScheduleLine."Posting Description";
                                    //PaymentTransLine."Bank Name" := PaymentHeader."Bank Account Name";
                                    PaymentTransLine.Payee := PaymentScheduleLine."Payee Name";
                                    PaymentTransLine."Reference Type" := PaymentTransLine."reference type"::Voucher;
                                    PaymentTransLine."Record ID" := RecdRef.RecordId;
                                    PaymentTransLine."Source No." := PaymentHeader."No.";
                                    // if PaymentHeader."Payment Type" = PaymentHeader."payment type"::"Supp. Invoice" then
                                    //     PaymentTransLine."Source Type" := PaymentTransLine."source type"::Vendor;



                                    // if PaymentHeader."Payment Type" = PaymentHeader."payment type"::Others then
                                    //     PaymentTransLine."Source Type" := PaymentTransLine."source type"::"Bank Account";

                                    PaymentTransLine."Payee No." := PaymentScheduleLine."Payee No.";
                                    PaymentTransLine."Payee BVN" := PaymentScheduleLine."Payee BVN";
                                    // if Format(SerialNo) = PmtTranSetup."Nibss Schedule Size" then begin
                                    //     PageNo := PageNo + 1;
                                    //     SerialNo := 1;
                                    // end;
                                    PaymentTransLine."Schedule Page No." := PageNo;
                                    PaymentTransLine."Schedule Serial No." := SerialNo;
                                    PaymentTransLine.Insert(true);
                                    SerialNo := SerialNo + 1;
                                    CountOnLine := CountOnLine + 1;
                                until PaymentScheduleLine.Next = 0;
                            end;
                        until PaymentLine.Next = 0;
                    end;
                // PaymentHeader."Payment ID" := PaymentTransHeader."Batch Number";
                // PaymentHeader.Modify;
                until PaymentHeader.Next = 0;
            end;
        end
    end;

}

