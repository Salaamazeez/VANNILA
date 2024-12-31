table 60021 "Cash Advance"
{
    //Created by Salaam Azeez
    DataClassification = CustomerContent;
    LookupPageId = "Cash Advance List Dummy";
    DrillDownPageId = "Approved Cash Advance List";

    fields
    {

        field(1; "No."; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; "Date"; Date)
        {
            DataClassification = CustomerContent;

        }
        field(4; "Requester"; Text[60])
        {
            DataClassification = CustomerContent;
            Editable = true;
            TableRelation = "User Setup"."User ID";
        }

        field(7; "No. Series"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series"."Code";
        }
        field(8; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,"Approved","Pending Approval","Rejected";
            Editable = false;
        }
        field(9; "Treated"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'Voucher Created';

        }
        field(11; Posted; Boolean)
        {
            Editable = false;
            Caption = 'Voucher Posted';
        }
        field(3; "Total Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Cash Advance Line".Amount where("Document No." = field("No.")));

        }
        field(5; "Total Amount (LCY)"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Cash Advance Line"."Amount (LCY)" where("Document No." = field("No.")));
        }
        // field(10; Type; Option)
        // {
        //     Editable = false;
        //     InitValue = "Cash Advance";
        //     DataClassification = CustomerContent;
        //     // OptionCaptionML = ENU = '" ","Cash Advance","Imprest","Expense","Maintenance"';
        //     // OptionCaption =  ',Cash Advance,Imprest,Expense,Maintenance';
        //     OptionMembers = " ","Cash Advance","Imprest","Expense","Maintenance";
        // }

        field(6; "Pmt Vouch. Code"; Code[20])
        {

        }
        field(22; "Retired"; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;

        }
        field(12; "Retirement No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Retirement."No." where("Retirement Ref." = field("No.")));
        }
        field(13; "Voucher No"; Code[20])
        {

        }
        field(14; "Actual User"; Text[250])
        {

        }
        field(15; "Debit  Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "G/L Account",Vendor,Staff,"Bank Account";
            InitValue = Staff;
        }
        field(16; "Debit Account No."; Code[20])
        {
            Caption = 'Payee No.';
            DataClassification = ToBeClassified;

            TableRelation = IF ("Debit  Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true)) ELSE
            IF ("Debit  Account Type" = CONST(Staff)) Customer where(Type = const(Staff)) else
            if ("Debit  Account Type" = const(Vendor)) Vendor;

            trigger OnValidate()
            begin
                CASE "Debit  Account Type" OF
                    "Debit  Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Debit Account No.");
                            "Debit Account Name" := GLAcc.Name;
                            Validate("Shortcut Dimension 1 Code", GLAcc."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", GLAcc."Global Dimension 2 Code");
                        END;
                    "Debit  Account Type"::Vendor:
                        BEGIN
                            Vend.GET("Debit Account No.");
                            "Debit Account Name" := Vend.Name;
                            Validate("Shortcut Dimension 1 Code", Vend."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", Vend."Global Dimension 2 Code");
                        END;
                    "Debit  Account Type"::Staff:
                        BEGIN
                            Cust.GET("Debit Account No.");
                            "Debit Account Name" := Cust.Name;
                            Validate("Shortcut Dimension 1 Code", Cust."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", Cust."Global Dimension 2 Code");
                        END;
                END;
            end;

        }
        field(18; "Debit Account Name"; Text[50])
        {
            Caption = 'Payee Name';
            DataClassification = ToBeClassified;
            //Editable = false;

        }

        field(35; "Currency Code"; Code[10])
        {
            TableRelation = currency.Code;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //CashAdvance.GET("Document No.");
                IF "Currency Code" <> '' THEN BEGIN
                    IF ("Currency Code" <> xRec."Currency Code") OR
                       (CurrFieldNo = FIELDNO("Currency Code")) OR
                       ("Currency Factor" = 0)
                    THEN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate(Date, "Currency Code");
                END ELSE
                    "Currency Factor" := 0;
                if CashAdvanceLinesExist() then
                    IF CONFIRM('Do you want to recalcute the lcy amount?', FALSE) THEN
                        UpdateAllLineCurrencyCode()
            end;
        }
        field(36; "Currency Factor"; Decimal)
        {
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                //VALIDATE(Amount);
            end;
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            Editable = false;
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            Editable = false;
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));
            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }

        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                Rec.ShowDocDim();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(37; "Payee No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(50000; Description; Text[100]) { }
        field(50001; "Due Date"; Date) { }
        field(50004; "Transaction type"; Option)
        {
            OptionMembers = " ",Loan,"Staff Adv";

            trigger OnValidate()
            var
                GenSetup: Record "General Ledger Setup";
            begin
                if "Transaction type" = "Transaction type"::Loan then begin
                    GenSetup.Get;
                    "Loan ID" := NoSeriesMgt.GetNextNo(GenSetup."Loan Nos", Date, TRUE)
                end else
                    "Loan ID" := '';
            end;
        }
        field(50005; "Loan ID"; Code[20])
        {
            Editable = false;
        }
        field(50100; "Retired Amount"; Decimal) { }

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        CashAdvanceLine: Record "Cash Advance Line";
        PaymentMgtSetup: Record "Payment Mgt Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        BankAccount: Record "Bank Account";
        CurrExchRate: Record "Currency Exchange Rate";
        UserSetup: Record "User Setup";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        GLEntry: Record "G/L Entry";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        TestReportPrint: Codeunit "Test Report-Print";
        Employee: Record "Employee";
        GLAccount: Record "G/L Account";
        Text002: TextConst ENU = 'cannot be specified without %1';
        Cust: Record Customer;
        Vend: Record Vendor;
        GLAcc: Record "G/L Account";


    trigger OnInsert()
    begin
        //  TestField("User Code");

        UserSetup.GET(USERID);
        Requester := UserSetup."User ID";
        Date := TODAY;

        IF "No." = '' THEN BEGIN
            PaymentMgtSetup.GET;
            PaymentMgtSetup.TESTFIELD("Cash Advance Nos.");
            NoSeriesMgt.InitSeries(PaymentMgtSetup."Cash Advance Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    trigger OnModify()
    begin
        //  TestField("User Code");
    end;

    trigger OnDelete()
    begin
        CashAdvanceLine.Reset();
        CashAdvanceLine.SetRange("Document No.", "No.");
        if CashAdvanceLine.FindFirst() then

            //Message(PaymentReqLine."Document No.");
            CashAdvanceLine.DeleteAll();
        //Message(PaymentReqLine."Document No.");

    end;
    // ERROR('You can not delete this record!');
    //end;

    trigger OnRename()
    begin

    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify();

        if OldDimSetID <> "Dimension Set ID" then begin
            if not IsNullGuid(Rec.SystemId) then
                Modify();
            if CashAdvanceLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;

    end;

    procedure CashAdvanceLinesExist(): Boolean
    var
        IsHandled, Result : Boolean;

    begin
        IsHandled := false;
        Result := false;
        if IsHandled then
            exit(Result);

        CashAdvanceLine.Reset();
        CashAdvanceLine.SetRange("Document No.", "No.");
        exit(not CashAdvanceLine.IsEmpty);
    end;

    procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        ConfirmManagement: Codeunit "Confirm Management";
        NewDimSetID: Integer;
        ReceivedShippedItemLineDimChangeConfirmed: Boolean;
        IsHandled: Boolean;
    begin

        if NewParentDimSetID = OldParentDimSetID then
            exit;

        CashAdvanceLine.Reset();
        CashAdvanceLine.SetRange("Document No.", "No.");
        CashAdvanceLine.LockTable();
        if CashAdvanceLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(CashAdvanceLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if CashAdvanceLine."Dimension Set ID" <> NewDimSetID then begin
                    CashAdvanceLine."Dimension Set ID" := NewDimSetID;


                    DimMgt.UpdateGlobalDimFromDimSetID(
                      CashAdvanceLine."Dimension Set ID", CashAdvanceLine."Shortcut Dimension 1 Code", CashAdvanceLine."Shortcut Dimension 2 Code");
                    CashAdvanceLine.Modify();
                end;
            until CashAdvanceLine.Next() = 0;
    end;

    // procedure ShowDocDim()
    // var
    //     OldDimSetID: Integer;
    //     IsHandled: Boolean;
    // begin
    //     OldDimSetID := "Dimension Set ID";
    //     "Dimension Set ID" :=
    //       DimMgt.EditDimensionSet(
    //         Rec, "Dimension Set ID", StrSubstNo('%1', "No."),
    //         "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

    //     if OldDimSetID <> "Dimension Set ID" then begin
    //         Modify();
    //         if CashAdvanceLinesExist() then
    //             UpdateAllLineDim("Dimension Set ID", OldDimSetID);
    //     end;
    // end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=

DimMgt.EditDimensionSet(
             "Dimension Set ID", StrSubstNo('%1 %2', 0, "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if CashAdvanceLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure TestMandatoryFields()
    var
        CashAdvanceLineLine: Record "Cash Advance Line";
        Error001: Label '%1 cannot be empty on line no. %2';
        Error002: Label '%1 cannot be 0';
        Err001: Label 'Kindly select a %1 value';
        Err002: Label 'Kindly input a %1 value';
    begin
        Rec.TestField(Status, Rec.Status::Open);
        // if Rec."Transaction type" = Rec."Transaction type"::" " then
        //     Error(Err001, Rec.FieldCaption("Transaction type"));
        if Rec."Transaction type" = Rec."Transaction type"::Loan then
            TestField("Loan ID");
        Rec.TestField(Description);
        //Rec.TestField("Debit Account No.");
        Rec.TestField("Shortcut Dimension 1 Code");
        Rec.TestField("Shortcut Dimension 2 Code");
        Rec.CalcFields("Total Amount");
        if Rec."Total Amount" = 0 then
            Error(Error002, Rec.FieldCaption("Total Amount"));
        CashAdvanceLineLine.SetRange("Document No.", Rec."No.");
        CashAdvanceLineLine.FindFirst();
        repeat
            // if CashAdvanceLineLine."Account No." = '' then
            //     Error(Error001, CashAdvanceLineLine.FieldCaption("Account No."), CashAdvanceLineLine.FieldCaption("Line No."));
            if CashAdvanceLineLine."Shortcut Dimension 1 Code" = '' then
                Error(Error001, CashAdvanceLineLine.FieldCaption("Shortcut Dimension 1 Code"), CashAdvanceLineLine.FieldCaption("Line No."));
            if CashAdvanceLineLine."Shortcut Dimension 2 Code" = '' then
                Error(Error001, CashAdvanceLineLine.FieldCaption("Shortcut Dimension 2 Code"), CashAdvanceLineLine.FieldCaption("Line No."));
            if CashAdvanceLineLine."Payment Details" = '' then
                Error(Error001, CashAdvanceLineLine.FieldCaption("Payment Details"), CashAdvanceLineLine.FieldCaption("Line No."));
        until CashAdvanceLineLine.Next() = 0;

    end;

    procedure MarkAllWhereUserisUserIDOrDepartment()
    var
        UserSetup: Record "User Setup";
        IsHandled: Boolean;
    begin
        if UserSetup.Get(UserId) and UserSetup."Finance Admin" then
            exit;

        FilterGroup(-1); //Used to support the cross-column search
        SetRange(Requester, UserId);
        if FindSet() then
            repeat
                Mark(true);
            until Next() = 0;
        MarkedOnly(true);
        FilterGroup(0);
    end;

    [IntegrationEvent(false, false)]
    procedure OnMoveDocAttachFromCashAdvanceToVoucher(var Rec1: Record "Cash Advance"; var Rec2: Record "Payment Voucher Header")
    begin
    end;



    procedure CreateVoucher()
    var
        CustSetup: Record "Payment Mgt Setup";
        CAdvHeader: Record "Cash Advance";
        PVHeader: Record "Payment Voucher Header";
        PVHeaderNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CAdvLine: Record "Cash Advance Line";
        PVLine: Record "Payment Voucher Line";
    begin
        //Transfer Payment Requisition Header to Payment Voucher Header
        CustSetup.GET;
        CustSetup.TESTFIELD("Cash Advance Nos.");
        CAdvHeader.SetRange("No.", Rec."No.");
        if CAdvHeader.FindFirst() then begin
            CAdvHeader.TestField(Status, 1);
            if CAdvHeader.Treated then
                Error('Voucher as been Created already');
            PVHeaderNo := NoSeriesMgt.GetNextNo(CustSetup."Payment Voucher No.", TODAY, TRUE);
            PVHeader."No." := PVHeaderNo;
            PVHeader.Date := Rec.Date;
            PVHeader.Requester := Rec.Requester;
            PVHeader."No. Series" := Rec."No. Series";
            PVHeader.Status := PVHeader.Status::Open;
            PVHeader."Transaction type" := Rec."Transaction type";
            PVHeader."Request Description" := Rec.Description;
            PVHeader."Bal Account Type" := Rec."Debit  Account Type";
            PVHeader."Bal Account No." := Rec."Debit Account No.";
            PVHeader."Bal Account Name" := Rec."Debit Account Name";
            PVHeader."Former PR No." := Rec."No.";
            PVHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
            PVHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
            PVHeader."Dimension Set ID" := Rec."Dimension Set ID";
            PVHeader."Due Date" := Rec."Due Date";
            PVHeader."Currency Code" := "Currency Code";
            PVHeader."Currency Factor" := "Currency Factor";
            PVHeader."Transaction type" := Rec."Transaction type";
            PVHeader."Loan ID" := Rec."Loan ID";
            PVHeader.Beneficiary := Rec."Debit Account No.";
            PVHeader."Beneficiary Name" := Rec."Debit Account Name";
            PVHeader.Insert();
        end;

        //Transfer Payment Requisition Line to Payment Voucher Line
        CAdvLine.SetRange("Document No.", Rec."No.");
        if CAdvLine.FindFirst() then begin
            repeat
                PVLine.TransferFields(CAdvLine);
                // PVLine."Document No." := NoSeriesMgt.GetNextNo(CustSetup."Payment Voucher No.", TODAY, TRUE);
                PVLine."Document No." := PVHeaderNo;
                PVLine."Shortcut Dimension 1 Code" := rec."Shortcut Dimension 1 Code";
                PVLine."Shortcut Dimension 2 Code" := rec."Shortcut Dimension 2 Code";
                PVLine."Dimension Set ID" := rec."Dimension Set ID";
                PVLine."Payment Details" := rec.Description;
                PVLine.Insert();
            until CAdvLine.Next() = 0;
        end;
        CAdvHeader.Treated := true;
        CAdvHeader."Voucher No" := PVHeaderNo;
        CAdvHeader.Modify();
        Rec.OnMoveDocAttachFromCashAdvanceToVoucher(Rec, PVHeader);
        IF CONFIRM('Do you want to open Payment Voucher %1?', FALSE, Rec."No.") THEN
            page.Run(60002, PVHeader)
        ELSE
            EXIT;

    end;

    local procedure UpdateAllLineCurrencyCode()
    var
        CashAdvAmt: Decimal;
    begin

        if "Currency Code" = xRec."Currency Code" then
            exit;

        CashAdvanceLine.Reset();
        CashAdvanceLine.SetRange("Document No.", "No.");
        CashAdvanceLine.LockTable();
        if CashAdvanceLine.Find('-') then
            repeat
                CashAdvAmt := CashAdvanceLine.Amount;
                CashAdvanceLine.Validate("Currency Code", "Currency Code");
                CashAdvanceLine.Validate(Amount, CashAdvAmt);
                CashAdvanceLine.Modify();
            until CashAdvanceLine.Next() = 0;
    end;


    // procedure PostCashAdavanceImprest()
    // var
    //     GenJournalLine: Record "Gen. Journal Line";
    //     GenJournalLine2: Record "Gen. Journal Line";
    // begin
    //     GenJournalLine2.SETRANGE("Journal Template Name", 'PAYMENT');
    //     GenJournalLine2.SETRANGE("Journal Batch Name", 'BANK');
    //     IF GenJournalLine2.FINDFIRST THEN
    //         GenJournalLine2.DELETEALL;

    //     GenJournalLine.INIT;
    //     GenJournalLine."Journal Template Name" := 'PAYMENT';
    //     GenJournalLine."Journal Batch Name" := 'BANK';
    //     GenJournalLine."Posting Date" := Date;
    //     GenJournalLine."Line No." := 10000;
    //     GenJournalLine."Document No." := "No.";
    //     IF "Debit Account Type" = "Debit Account Type"::Vendor THEN BEGIN
    //         GenJournalLine."Account Type" := GenJournalLine."Account Type"::Employee;
    //         GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
    //     END
    //     ELSE
    //         GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
    //     GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
    //     //  GenJournalLine.Description := Purpose;
    //     GenJournalLine.VALIDATE(Amount, Amount);
    //     GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
    //     GenJournalLine.VALIDATE("Bal. Account No.", "Bank No.");
    //     GenJournalLine.VALIDATE("Currency Code", "Currency Code");
    //     GenJournalLine.VALIDATE("Dimension Set ID", "Dimension Set ID");
    //     GenJournalLine.INSERT;
    //     CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);
    //     CheckPostedJnl;
    // end;

    // procedure PreviewPosting()
    // var
    //     GenJournalLine: Record "Gen. Journal Line";
    //     GenJournalLine2: Record "Gen. Journal Line";
    // begin
    //     GenJournalLine2.SETRANGE("Journal Template Name", 'PAYMENT');
    //     GenJournalLine2.SETRANGE("Journal Batch Name", 'BANK');
    //     IF GenJournalLine2.FINDFIRST THEN
    //         GenJournalLine2.DELETEALL;

    //     GenJournalLine.INIT;
    //     GenJournalLine."Journal Template Name" := 'PAYMENT';
    //     GenJournalLine."Journal Batch Name" := 'BANK';
    //     GenJournalLine."Posting Date" := Date;
    //     GenJournalLine."Line No." := 10000;
    //     GenJournalLine."Document No." := "No.";
    //     IF "Debit Account Type" = "Debit Account Type"::Vendor THEN BEGIN
    //         GenJournalLine."Account Type" := GenJournalLine."Account Type"::Employee;
    //         GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
    //     END
    //     ELSE
    //         GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
    //     GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
    //     // GenJournalLine.Description := COPYSTR(Purpose, 1, 50);
    //     GenJournalLine.VALIDATE(Amount, Amount);
    //     GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
    //     GenJournalLine.VALIDATE("Bal. Account No.", "Bank No.");
    //     GenJournalLine.VALIDATE("Currency Code", "Currency Code");
    //     GenJournalLine.VALIDATE("Dimension Set ID", "Dimension Set ID");
    //     GenJournalLine.INSERT;
    //     COMMIT;
    //     GenJnlPost.Preview(GenJournalLine);
    // end;

    // procedure TestReport()
    // var
    //     GenJournalLine: Record "Gen. Journal Line";
    //     GenJournalLine2: Record "Gen. Journal Line";
    // begin
    //     GenJournalLine2.SETRANGE("Journal Template Name", 'PAYMENTS');
    //     GenJournalLine2.SETRANGE("Journal Batch Name", 'BANK');
    //     IF GenJournalLine2.FINDFIRST THEN
    //         GenJournalLine2.DELETEALL;

    //     GenJournalLine.INIT;
    //     GenJournalLine."Journal Template Name" := 'PAYMENTS';
    //     GenJournalLine."Journal Batch Name" := 'BANK';
    //     GenJournalLine."Posting Date" := Date;
    //     GenJournalLine."Line No." := 10000;
    //     GenJournalLine."Document No." := "No.";
    //     IF "Debit Account Type" = "Debit Account Type"::Vendor THEN BEGIN
    //         GenJournalLine."Account Type" := GenJournalLine."Account Type"::Employee;
    //         GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
    //     END
    //     ELSE
    //         GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
    //     GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
    //     //  GenJournalLine.Description := COPYSTR(Purpose, 1, 50);
    //     GenJournalLine.VALIDATE(Amount, Amount);
    //     GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
    //     GenJournalLine.VALIDATE("Bal. Account No.", "Bank No.");
    //     GenJournalLine.VALIDATE("Currency Code", "Currency Code");
    //     GenJournalLine.VALIDATE("Dimension Set ID", "Dimension Set ID");
    //     GenJournalLine.INSERT;
    //     COMMIT;
    //     TestReportPrint.PrintGenJnlLine(GenJournalLine);
    // end;

    // procedure PostPrint()
    // var
    //     GenJournalLine: Record "Gen. Journal Line";
    //     GenJournalLine2: Record "Gen. Journal Line";
    // begin
    //     GenJournalLine2.SETRANGE("Journal Template Name", 'PAYMENTS');
    //     GenJournalLine2.SETRANGE("Journal Batch Name", 'BANK');
    //     IF GenJournalLine2.FINDFIRST THEN
    //         GenJournalLine2.DELETEALL;

    //     GenJournalLine.INIT;
    //     GenJournalLine."Journal Template Name" := 'PAYMENTS';
    //     GenJournalLine."Journal Batch Name" := 'BANK';
    //     GenJournalLine."Posting Date" := Date;
    //     GenJournalLine."Line No." := 10000;
    //     GenJournalLine."Document No." := "No.";
    //     IF "Debit Account Type" = "Debit Account Type"::Vendor THEN BEGIN
    //         GenJournalLine."Account Type" := GenJournalLine."Account Type"::Employee;
    //         GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
    //     END
    //     ELSE
    //         GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
    //     GenJournalLine.VALIDATE("Account No.", "Debit Account No.");
    //     // GenJournalLine.Description := COPYSTR(Purpose, 1, 50);
    //     GenJournalLine.VALIDATE(Amount, Amount);
    //     GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
    //     GenJournalLine.VALIDATE("Bal. Account No.", "Bank No.");
    //     GenJournalLine.VALIDATE("Currency Code", "Currency Code");
    //     GenJournalLine.VALIDATE("Dimension Set ID", "Dimension Set ID");
    //     GenJournalLine.INSERT;
    //     CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print", GenJournalLine);
    //     CheckPostedJnl;
    // end;

    // procedure CheckPostedJnl()
    // begin
    //     GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
    //     GLEntry.SETRANGE("Document No.", "No.");
    //     IF GLEntry.FINDFIRST THEN BEGIN
    //         Posted := TRUE;
    //         MODIFY;
    //     END;
    // end;
}