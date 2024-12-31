tableextension 50169 "Gen Jnl Ext" extends "Gen. Journal Line"
{

    //Created by Salaam Azeez
    fields
    {
        modify("External Document No.")
        {
            Caption = 'Document Reference No.';
        }
        field(50002; "Description 2"; Text[100])
        {

        }
        field(50004; "Transaction type"; Option)
        {
            OptionMembers = " ",Loan,"Staff Adv";
        }
        field(50005; "Loan ID"; Code[20]) { }
        field(50010; "Balance Posted"; Boolean)
        {

        }
        field(50011; "Net Amount to Pay"; Decimal)
        {

        }

        field(50111; Comments; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50112; "Actual User"; Text[100])
        {
            Enabled = false;
            DataClassification = ToBeClassified;
        }
        field(50000; "1% NCDF Amount"; Decimal) { }
        // field(50105; "WHT Amount"; Decimal)
        // {

        //     trigger OnValidate()
        //     var
        //         DetVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        //         VendorLedgerEntry: Record "Vendor Ledger Entry";

        //     begin
        //         VendorLedgerEntry.SetRange("VendGLentry WHT Treated", false);
        //         VendorLedgerEntry.SetRange("Document Type", VendorLedgerEntry."Document Type"::Invoice);
        //         VendorLedgerEntry.SetRange("WHT Code", '<>%1', '');




        //     end;

        // }
        // field(50102; "WHT Amount(LCY)"; Decimal)
        // {
        //     TableRelation = "Tariff Codes".Code;

        // }
        // field(50104; "WHT Code"; Code[20])
        // {
        //     TableRelation = "Tariff Codes".Code;

        // }

        // field(50100; "With-Held from Vendor Name"; Text[100]) { }
        // field(50101; "VendGLentry WHT Treated"; Boolean)
        // {

        // }
        // field(50103; "WHT Treated"; Boolean)
        // {

        // }

        // Add changes to table fields here
        field(50001; "P/SInv Order No"; Code[20])
        {
            //  Caption = 'Document Ref No.';
            //  TableRelation = "Sales Header"."No." where("Document Type" = filter(Order));
        }
        field(50003; "Cashier Name"; Code[100])
        {
        }
    }

    var
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";






    procedure PostPayment()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        GenJournalLine3: Record "Gen. Journal Line";
        GenJournalLine4: Record "Gen. Journal Line";
    begin
        //IF ("Approved Purch. Requisition" = '') AND ("System-Generated" = FALSE) THEN
        //  ERROR('Approved Requisition is required')
        // ELSE BEGIN

        GenJournalLine2.SETRANGE("Journal Template Name", 'GENERAL');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF GenJournalLine2.FINDFIRST THEN
            GenJournalLine2.DELETEALL;

        GenJournalLine3.SETRANGE("Journal Template Name", 'GENERAL');
        GenJournalLine3.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF GenJournalLine3.FINDFIRST THEN
            GenJournalLine3.DELETEALL;

        GenJournalLine4.SETRANGE("Journal Template Name", 'GENERAL');
        GenJournalLine4.SETRANGE("Journal Batch Name", 'DEFAULT2');
        GenJournalLine4.SETCURRENTKEY("Document No.", "Line No.");
        GenJournalLine4.SETRANGE("Document No.", GenJournalLine3."Document No.");
        IF GenJournalLine4.FINDFIRST THEN BEGIN
            REPEAT
                IF GenJournalLine4."Account Type" = GenJournalLine4."Account Type"::"G/L Account" THEN BEGIN
                    GenJournalLine4.TESTFIELD("Net Amount to Pay");
                    GenJournalLine4.VALIDATE("Net Amount to Pay");
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'DEFAULT2';
                    GenJournalLine."Line No." := GenJournalLine4."Line No.";
                    GenJournalLine."Posting Date" := GenJournalLine4."Posting Date";
                    GenJournalLine."Document No." := GenJournalLine4."Document No.";
                    GenJournalLine."Account Type" := GenJournalLine4."Account Type"::"G/L Account";
                    GenJournalLine.VALIDATE("Account No.", GenJournalLine4."Account No.");
                    GenJournalLine.Description := GenJournalLine4.Description;

                    //GenJournalLine."Dimension Set ID" := GenJournalLine4."Dimension Set ID";
                    GenJournalLine.VALIDATE(Amount, GenJournalLine4.Amount);
                    IF GenJournalLine4."Bal. Account Type" = GenJournalLine4."Bal. Account Type"::"Bank Account" THEN
                        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account"
                    ELSE
                        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                    GenJournalLine.VALIDATE("Bal. Account No.", GenJournalLine4."Bal. Account No.");
                    GenJournalLine.VALIDATE("Currency Code", GenJournalLine4."Currency Code");
                    GenJournalLine."Gen. Bus. Posting Group" := '';
                    GenJournalLine."Gen. Prod. Posting Group" := '';
                    GenJournalLine."VAT Bus. Posting Group" := '';
                    GenJournalLine."VAT Prod. Posting Group" := '';
                    GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                    GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                    GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                    GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                    GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                    GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", GenJournalLine4."Shortcut Dimension 1 Code");
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GenJournalLine4."Shortcut Dimension 2 Code");
                    IF GenJournalLine4.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                END ELSE BEGIN
                    GenJournalLine4.TESTFIELD("Net Amount to Pay");
                    GenJournalLine4.VALIDATE("Net Amount to Pay");
                    // //VendorPaymentJnlLines();
                    // //////////////////
                    PaymentMgtSetup.GET;
                    PaymentMgtSetup.TESTFIELD("VAT Payable Account");
                    PaymentMgtSetup.TESTFIELD("WHT Payable Account");
                    PaymentMgtSetup.TESTFIELD("NCDF Payable Account");

                    //  GenJournalLine4.TESTFIELD(Amount);
                    // GenJournalLine4.VALIDATE(Amount);
                    //VendorPaymentJnlLines();
                    //////////////////



                    //Line 1: Debit Vendor Account with Invoice Amount
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'DEFAULT2';
                    GenJournalLine."Line No." := GenJournalLine4."Line No.";
                    GenJournalLine."Posting Date" := GenJournalLine4."Posting Date";
                    GenJournalLine."Document No." := GenJournalLine4."Document No.";
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                    GenJournalLine.VALIDATE("Account No.", GenJournalLine4."Account No.");
                    GenJournalLine.Description := GenJournalLine4.Description;

                    GenJournalLine."Dimension Set ID" := GenJournalLine4."Dimension Set ID";
                    //IF (GenJournalLine4."Account Type"= GenJournalLine4."Account Type"::Vendor) AND (GenJournalLine4."Vendor Invoice No." = '') THEN 
                    GenJournalLine.VALIDATE(Amount, GenJournalLine4.Amount);
                    //ELSE
                    //GenJournalLine.VALIDATE(Amount,GenJournalLine4."Vendor Invoice Amount");
                    GenJournalLine.VALIDATE("Currency Code", GenJournalLine4."Currency Code");
                    GenJournalLine."External Document No." := GenJournalLine4."Applies-to Doc. No.";
                    GenJournalLine."Applies-to Doc. Type" := GenJournalLine4."Applies-to Doc. Type"::Invoice;
                    GenJournalLine.VALIDATE("Applies-to Doc. No.", GenJournalLine4."Applies-to Doc. No.");
                    GenJournalLine."Gen. Bus. Posting Group" := '';
                    GenJournalLine."Gen. Prod. Posting Group" := '';
                    GenJournalLine."VAT Bus. Posting Group" := '';
                    GenJournalLine."VAT Prod. Posting Group" := '';
                    GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                    GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                    GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                    GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                    GenJournalLine."Gen. Posting Type" := GenJournalLine4."Gen. Posting Type"::" ";
                    GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine4."Bal. Gen. Posting Type"::" ";
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", GenJournalLine4."Shortcut Dimension 1 Code");
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GenJournalLine4."Shortcut Dimension 2 Code");
                    IF GenJournalLine.Amount <> 0 THEN
                        GenJournalLine.INSERT;
                    //Line 2: Credit VAT Payable with VAT Amount
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'DEFAULT2';
                    GenJournalLine."Line No." := GenJournalLine4."Line No." + 1;
                    GenJournalLine."Posting Date" := GenJournalLine4."Posting Date";
                    GenJournalLine."Document No." := GenJournalLine4."Document No.";
                    GenJournalLine."Account Type" := GenJournalLine4."Account Type"::"G/L Account";
                    GenJournalLine.VALIDATE("Account No.", PaymentMgtSetup."VAT Payable Account");
                    GenJournalLine.Description := GenJournalLine4.Description;
                    GenJournalLine.VALIDATE(Amount, -GenJournalLine4."VAT Amount");
                    GenJournalLine.VALIDATE("Currency Code", GenJournalLine4."Currency Code");
                    GenJournalLine."External Document No." := GenJournalLine4."Applies-to Doc. No.";
                    GenJournalLine."Gen. Bus. Posting Group" := '';
                    GenJournalLine."Gen. Prod. Posting Group" := '';
                    GenJournalLine."VAT Bus. Posting Group" := '';
                    GenJournalLine."VAT Prod. Posting Group" := '';
                    GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                    GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                    GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                    GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                    GenJournalLine."Gen. Posting Type" := GenJournalLine4."Gen. Posting Type"::" ";
                    GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine4."Bal. Gen. Posting Type"::" ";
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", GenJournalLine4."Shortcut Dimension 1 Code");
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GenJournalLine4."Shortcut Dimension 2 Code");
                    IF GenJournalLine4."VAT Amount" <> 0 THEN
                        GenJournalLine.INSERT;

                    //Line 3: Credit WHT Payable with WHT Amount
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'DEFAULT2';
                    GenJournalLine."Line No." := GenJournalLine4."Line No." + 2;
                    GenJournalLine."Posting Date" := GenJournalLine4."Posting Date";
                    GenJournalLine."Document No." := GenJournalLine4."Document No.";
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                    GenJournalLine.VALIDATE("Account No.", PaymentMgtSetup."WHT Payable Account");
                    GenJournalLine.Description := GenJournalLine4.Description;
                    GenJournalLine."Dimension Set ID" := GenJournalLine4."Dimension Set ID";
                    // GenJournalLine.VALIDATE(Amount, -GenJournalLine4."WHT Amount");
                    GenJournalLine.VALIDATE("Currency Code", GenJournalLine4."Currency Code");
                    GenJournalLine."External Document No." := GenJournalLine4."Applies-to Doc. No.";
                    GenJournalLine."Gen. Bus. Posting Group" := '';
                    GenJournalLine."Gen. Prod. Posting Group" := '';
                    GenJournalLine."VAT Bus. Posting Group" := '';
                    GenJournalLine."VAT Prod. Posting Group" := '';
                    GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                    GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                    GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                    GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                    GenJournalLine."Gen. Posting Type" := GenJournalLine4."Gen. Posting Type"::" ";
                    GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine4."Bal. Gen. Posting Type"::" ";
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", GenJournalLine4."Shortcut Dimension 1 Code");
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GenJournalLine4."Shortcut Dimension 2 Code");
                    // IF GenJournalLine4."WHT Amount" <> 0 THEN
                    //     GenJournalLine.INSERT;

                    //Line 4: Credit NCDF Payable with NCDF Amount
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'DEFAULT2';
                    GenJournalLine."Line No." := GenJournalLine4."Line No." + 3;
                    GenJournalLine."Posting Date" := GenJournalLine4."Posting Date";
                    GenJournalLine."Document No." := GenJournalLine4."Document No.";
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                    GenJournalLine.VALIDATE("Account No.", PaymentMgtSetup."NCDF Payable Account");
                    GenJournalLine.Description := GenJournalLine4.Description;
                    GenJournalLine."Dimension Set ID" := GenJournalLine4."Dimension Set ID";
                    GenJournalLine.VALIDATE(Amount, -GenJournalLine4."1% NCDF Amount");
                    GenJournalLine.VALIDATE("Currency Code", GenJournalLine4."Currency Code");
                    GenJournalLine."External Document No." := GenJournalLine4."Applies-to Doc. No.";
                    GenJournalLine."Gen. Bus. Posting Group" := '';
                    GenJournalLine."Gen. Prod. Posting Group" := '';
                    GenJournalLine."VAT Bus. Posting Group" := '';
                    GenJournalLine."VAT Prod. Posting Group" := '';
                    GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                    GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                    GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                    GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                    GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                    GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", GenJournalLine4."Shortcut Dimension 1 Code");
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GenJournalLine4."Shortcut Dimension 2 Code");
                    IF GenJournalLine4."1% NCDF Amount" <> 0 THEN
                        GenJournalLine.INSERT;

                    //Line 5: Credit Bank with Pay Cheque Amount
                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := 'GENERAL';
                    GenJournalLine."Journal Batch Name" := 'DEFAULT2';
                    GenJournalLine."Line No." := GenJournalLine4."Line No." + 4;
                    GenJournalLine."Posting Date" := GenJournalLine4."Posting Date";
                    GenJournalLine."Document No." := GenJournalLine4."Document No.";
                    IF GenJournalLine4."Bal. Account Type" = GenJournalLine4."Bal. Account Type"::"Bank Account" THEN
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account"
                    ELSE
                        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                    //GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
                    GenJournalLine.VALIDATE("Account No.", GenJournalLine4."Bal. Account No.");
                    GenJournalLine.Description := GenJournalLine4.Description;
                    GenJournalLine.VALIDATE(Amount, -GenJournalLine4."Net Amount to Pay");
                    GenJournalLine.VALIDATE("Currency Code", GenJournalLine4."Currency Code");
                    GenJournalLine."Gen. Bus. Posting Group" := '';
                    GenJournalLine."Gen. Prod. Posting Group" := '';
                    GenJournalLine."VAT Bus. Posting Group" := '';
                    GenJournalLine."VAT Prod. Posting Group" := '';
                    GenJournalLine."Bal. Gen. Bus. Posting Group" := '';
                    GenJournalLine."Bal. Gen. Prod. Posting Group" := '';
                    GenJournalLine."Bal. VAT Bus. Posting Group" := '';
                    GenJournalLine."Bal. VAT Prod. Posting Group" := '';
                    GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
                    GenJournalLine."Bal. Gen. Posting Type" := GenJournalLine."Bal. Gen. Posting Type"::" ";
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", GenJournalLine4."Shortcut Dimension 1 Code");
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GenJournalLine4."Shortcut Dimension 2 Code");
                    IF GenJournalLine4."Net Amount to Pay" <> 0 THEN
                        GenJournalLine.INSERT;

                    //////////////////
                END;
            UNTIL GenJournalLine4.NEXT = 0;
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);
        END;

        //  CheckPostedJnl;

        //Update Purchase Requisition as Treated
        // IF "Purchase Requisition No." <> '' THEN BEGIN
        //     PurchaseReqRec.GET("Purchase Requisition No.");
        //     PurchaseReqRec.Treated := TRUE;
        //     PurchaseReqRec.MODIFY(TRUE);
        // END;

        //END;

    end;

    procedure UpdateSalesOrderNO()
    var
        GenJnl: Record "Gen. Journal Line";
        PurchHdr: Record "Purch. Inv. Header";
        SalesHdr: Record "Sales Invoice Header";
    begin

        GenJnl.SetRange("Document No.");
        GenJnl.SetRange("Applies-to Doc. Type", GenJnl."Applies-to Doc. Type"::Invoice);
        if GenJnl.FindFirst() then begin
            repeat
                if GenJnl."Account Type" = GenJnl."Account Type"::Vendor then begin
                    PurchHdr.SetRange("No.", GenJnl."Applies-to Doc. No.");
                    if PurchHdr.FindFirst() then
                        GenJnl."P/SInv Order No" := PurchHdr."PInv Order No";
                    // Message('GenJnl."Applies-to Doc. No."=%1', GenJnl."Applies-to Doc. No.");
                    // Message('PurchHdr."PInv Order No"=%1', PurchHdr."PInv Order No");
                    GenJnl.Modify();
                end;
            until GenJnl.Next() = 0
        end;
        if GenJnl."Account Type" = GenJnl."Account Type"::Customer then begin
            SalesHdr.SetRange("No.", GenJnl."Applies-to Doc. No.");
            if SalesHdr.FindFirst() then
                // GenJnl."P/SInv Order No" := SalesHdr."SInv Order No";
                /// Message(PurchHdr."PInv Order No");
                GenJnl.Modify()
        end;
    end;

    // procedure TestField()
    // begin
    //     TestField("Shortcut Dimension 1 Code");
    //     TestField("Shortcut Dimension 2 Code");
    // end;

    procedure TestMandatoryFields()
    var
        GenJournalLine: Record "Gen. Journal Line";
        Error001: Label '%1 cannot be empty on the line %2';
    //Error002: Label '%1 cannot be 0';
    //Err001: Label 'Kindly select a %1 value';
    //Err002: Label 'Kindly input a %1 value';
    begin
        GenJournalLine.SetRange("Document No.", Rec."Document No.");
        GenJournalLine.FindFirst();
        repeat
            if GenJournalLine.Amount = 0 then
                Error(Error001, GenJournalLine.FieldCaption(Amount), GenJournalLine.FieldCaption("Line No."));
            if GenJournalLine."Account No." = '' then
                Error(Error001, GenJournalLine.FieldCaption("Account No."), GenJournalLine.FieldCaption("Line No."));
            if GenJournalLine."Shortcut Dimension 1 Code" = '' then
                Error(Error001, GenJournalLine.FieldCaption("Shortcut Dimension 1 Code"), GenJournalLine.FieldCaption("Line No."));
            if GenJournalLine."Shortcut Dimension 2 Code" = '' then
                Error(Error001, GenJournalLine.FieldCaption("Shortcut Dimension 2 Code"), GenJournalLine.FieldCaption("Line No."));
        until GenJournalLine.Next() = 0;
    end;

    var
        PaymentMgtSetup: Record "Payment Mgt Setup";

}