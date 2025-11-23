table 60000 "Payment Requisition"
{
    //Created by Akande
    DataClassification = ToBeClassified;
    LookupPageId = "Payment Req. List Dummy";

    fields
    {
        field(1; "No."; code[13])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Requester"; Text[60])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }

        field(7; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(8; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,Approved,"Pending Approval",Rejected;
            OptionCaption = 'Open,Approved,Pending Approval,Rejected';
            Editable = false;
        }
        field(9; Posted; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(11; "Bal Account Name"; Text[50])
        {

            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), "Dimension Value Type" = CONST(Standard), Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 4 Code");
            end;
        }
        field(13; "Request Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }

        field(17; "Current Pending Approver"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; "Purchase Requisition No."; Code[10])
        {

            TableRelation = "Purch. Requistion" where(Status = const(Approved));

            trigger OnValidate()
            begin
                //  PurchaseReqRec.SETFILTER(Status, '%1', PurchaseReqRec.Status::Approved);
                // IF PAGE.RUNMODAL(50097, PurchaseReqRec) = ACTION::LookupOK THEN BEGIN
                // "Purchase Requisition No." := PurchaseReqRec."No.";
                PurchaseReqRec.SetRange("No.", "Purchase Requisition No.");
                PurchaseReqRec.CALCFIELDS("Requisition Amount");
                //"Purchase Requisition Amount" := PurchaseReqRec."Requisition Amount";
                //Message('%1', PurchaseReqRec."Requisition Amount");
                //populate payment line with lines from approved purch. req
                PurchaseReqLineRec.SETRANGE("Document No.", "Purchase Requisition No.");
                IF PurchaseReqLineRec.FINDSET THEN BEGIN
                    LineNo := 1;
                    REPEAT //  Message('%1', PurchaseReqLineRec.Quantity);
                           // PaymentRequisitionLine.INIT;
                        PaymentRequisitionLine."Document No." := "No.";
                        PaymentRequisitionLine."Line No." := LineNo;
                        // PaymentRequisitionLine.INSERT;
                        //PaymentRequisitionLine.VALIDATE("Account No.",PurchaseReqLineRec."Cost Account No.");
                        PaymentRequisitionLine.Amount := PurchaseReqLineRec.Amount;
                        PaymentRequisitionLine."Payment Details" := COPYSTR(STRSUBSTNO('Payment for %1', PurchaseReqLineRec."Required Item/Service"), 1, MAXSTRLEN(PaymentRequisitionLine."Payment Details"));
                        PaymentRequisitionLine.VALIDATE("Amount (LCY)", PurchaseReqLineRec."Amount (LCY)");
                        PaymentRequisitionLine.Insert();
                        LineNo += 1;
                    UNTIL PurchaseReqLineRec.NEXT = 0;
                END;
            END;
            //  end;
        }
        field(19; "Request Amount (LCY)"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Payment Requisition Line"."Amount (LCY)" WHERE("Document No." = FIELD("No.")));
        }

        field(21; "Request Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Payment Requisition Line"."Amount" WHERE("Document No." = FIELD("No.")));

        }
        field(24; "Bal Account Type"; Option)
        {
            Editable = false;
            OptionMembers = "G/L Account",Vendor,Staff,"Bank Account";
            InitValue = "Bank Account";
        }

        field(25; "Bal Account No."; Code[20])
        {
            DataClassification = CustomerContent;

            TableRelation = IF ("Bal Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true)) ELSE
            IF ("Bal Account Type" = CONST(Vendor)) Vendor else
            if ("Bal Account Type" = const(Staff)) Customer where(Type = const(Staff))
            else
            if ("Bal Account Type" = const("Bank Account")) "Bank Account" where("Currency Code" = field("Currency Code"));

            trigger OnValidate()
            begin
                CASE "Bal Account Type" OF
                    "Bal Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Bal Account No.");
                            "Bal Account Name" := GLAcc.Name;
                            Validate("Shortcut Dimension 1 Code", GLAcc."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", GLAcc."Global Dimension 2 Code");
                        END;
                    "Bal Account Type"::Vendor:
                        BEGIN
                            Vend.GET("Bal Account No.");
                            "Bal Account Name" := Vend.Name;
                            Validate("Shortcut Dimension 1 Code", Vend."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", Vend."Global Dimension 2 Code");
                        END;
                    "Bal Account Type"::Staff:
                        BEGIN
                            Cust.GET("Bal Account No.");
                            "Bal Account Name" := Cust.Name;
                            Validate("Shortcut Dimension 1 Code", Cust."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", Cust."Global Dimension 2 Code");
                        END;
                    "Bal Account Type"::"Bank Account":
                        BEGIN
                            BankAccount.GET("Bal Account No.");
                            "Bal Account Name" := BankAccount.Name;
                            Validate("Shortcut Dimension 1 Code", BankAccount."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", BankAccount."Global Dimension 2 Code");
                        END;
                END;

            end;

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
                if PmtReqLinesExist() then
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
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            CaptionML = ENU = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(50000; "Detailed Pay Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }

        field(3; "Pmt Req Code"; Code[20])
        {

        }

        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,1';
            CaptionML = ENU = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(6; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(50001; "Voucher Created?"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50004; "Transaction type"; Option)
        {
            Editable = false;
            OptionMembers = " ",Loan,"Staff Adv";
            //InitValue = Expense;
        }
        field(50005; "Loan ID"; Code[20])
        {
            Editable = false;
        }

        field(50007; "Beneficiary"; Code[20])
        {
            DataClassification = CustomerContent;

            TableRelation = Employee;
            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                begin
                    Employee.GET(Beneficiary);
                    "Beneficiary Name" := Employee.FullName();
                    Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
                    Validate("Shortcut Dimension 2 Code", Employee."Global Dimension 2 Code");
                end;
            end;


        }
        field(50009; "Beneficiary Name"; Text[100])
        {
            Caption = 'Beneficiary Name';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }



    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        UserSetup: Record "User Setup";
        DimMgt: Codeunit DimensionManagement;
        PaymentMgtSetup: record "Payment Mgt Setup";
        NoSeriesMgt: Codeunit "No. Series";
        Cust: Record Customer;
        Vend: Record Vendor;
        GLAcc: Record "G/L Account";
        BankAccount: Record "Bank Account";
        PmtReqHeader: Record "Payment Requisition";
        PaymentRequisitionLine: Record "Payment Requisition Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        TestReportPrint: Codeunit "Test Report-Print";
        GLEntry: Record "G/L Entry";
        PurchaseReqRec: Record "Purch. Requistion";
        PurchaseReqLineRec: Record "Purchase Requisition Line";
        LineNo: Integer;
        PaymentReqLine: Record "Payment Requisition Line";
        CurrExchRate: Record "Currency Exchange Rate";
        Text002: TextConst ENU = 'cannot be specified without %1';




    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=

DimMgt.EditDimensionSet(
             "Dimension Set ID", StrSubstNo('%1 %2', 0, "No."),
           Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
        end;
    end;



    procedure PostPrint()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
    begin
        GenJournalLine2.SETRANGE("Journal Template Name", 'GENERAL');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF GenJournalLine2.FINDFIRST THEN
            GenJournalLine2.DELETEALL;

        PaymentRequisitionLine.SETCURRENTKEY("Document No.", "Line No.");
        PaymentRequisitionLine.SETRANGE("Document No.", "No.");
        IF PaymentRequisitionLine.FINDFIRST THEN BEGIN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'DEFAULT';
                GenJournalLine."Line No." := PaymentRequisitionLine."Line No.";
                GenJournalLine."Posting Date" := Date;
                GenJournalLine."Document No." := "No.";
                IF PaymentRequisitionLine."Account Type" = PaymentRequisitionLine."Account Type"::"G/L Account" THEN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                IF PaymentRequisitionLine."Account Type" = PaymentRequisitionLine."Account Type"::Vendor THEN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                IF PaymentRequisitionLine."Account Type" = PaymentRequisitionLine."Account Type"::Staff THEN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                IF PaymentRequisitionLine."Account Type" = PaymentRequisitionLine."Account Type"::Vendor THEN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                IF PaymentRequisitionLine."Account Type" = PaymentRequisitionLine."Account Type"::"Fixed Asset" THEN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine.VALIDATE("Account No.", PaymentRequisitionLine."Account No.");
                GenJournalLine.Description := PaymentRequisitionLine."Payment Details";

                GenJournalLine."Dimension Set ID" := PaymentRequisitionLine."Dimension Set ID";
                GenJournalLine.VALIDATE(Amount, PaymentRequisitionLine.Amount);

                IF PaymentRequisitionLine."Bal. Account Type" = PaymentRequisitionLine."Bal. Account Type"::"G/L Account" THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                IF PaymentRequisitionLine."Bal. Account Type" = PaymentRequisitionLine."Bal. Account Type"::Vendor THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::Vendor;
                IF PaymentRequisitionLine."Bal. Account Type" = PaymentRequisitionLine."Bal. Account Type"::Customer THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::Customer;
                IF PaymentRequisitionLine."Bal. Account Type" = PaymentRequisitionLine."Bal. Account Type"::"Bank Account" THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                IF PaymentRequisitionLine."Bal. Account Type" = PaymentRequisitionLine."Bal. Account Type"::"Fixed Asset" THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Fixed Asset";
                GenJournalLine.VALIDATE("Bal. Account No.", PaymentRequisitionLine."Bal. Account No.");
                GenJournalLine.VALIDATE("Currency Code", PaymentRequisitionLine."Currency Code");
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
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentRequisitionLine."Shortcut Dimension 1 Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentRequisitionLine."Shortcut Dimension 2 Code");
                GenJournalLine.INSERT;
            UNTIL PaymentRequisitionLine.NEXT = 0;
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print", GenJournalLine);
        END;
        CheckPostedJnl;
    end;

    procedure CheckPostedJnl()
    begin
        GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
        GLEntry.SETRANGE("Document No.", "No.");
        IF GLEntry.FINDFIRST THEN BEGIN
            Posted := TRUE;
            MODIFY;
        END;
    end;

    // procedure CreateNewPaymentReq(UserID: Code[30]; BankNo: Code[10])
    // var
    //     PaymentReqLocal: Record "Payment Requisition";
    // begin
    //     PaymentReqLocal.INIT;
    //     PaymentReqLocal.VALIDATE("Bank No.", BankNo);
    //     PaymentReqLocal.INSERT;
    // end;

    procedure VendorPaymentJnlLines()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
    begin
        PaymentMgtSetup.GET;
        //PaymentMgtSetup.TESTFIELD("VAT Payable Account");
        //PaymentMgtSetup.TESTFIELD("WHT Payable Account");
        //PaymentMgtSetup.TESTFIELD("NCDF Payable Account");

        //Line 1: Debit Vendor Account with Invoice Amount
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DEFAULT';
        GenJournalLine."Line No." := PaymentRequisitionLine."Line No.";
        GenJournalLine."Posting Date" := Date;
        GenJournalLine."Document No." := "No.";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        GenJournalLine.VALIDATE("Account No.", PaymentRequisitionLine."Account No.");
        GenJournalLine.Description := PaymentRequisitionLine."Payment Details";
        GenJournalLine."Dimension Set ID" := PaymentRequisitionLine."Dimension Set ID";
        //IF (PaymentRequisitionLine."Account Type"= PaymentRequisitionLine."Account Type"::Vendor) AND (PaymentRequisitionLine."Vendor Invoice No." = '') THEN 
        GenJournalLine.VALIDATE(Amount, PaymentRequisitionLine.Amount);
        //ELSE
        //GenJournalLine.VALIDATE(Amount,PaymentRequisitionLine."Vendor Invoice Amount");
        GenJournalLine.VALIDATE("Currency Code", PaymentRequisitionLine."Currency Code");
        //  GenJournalLine."External Document No." := PaymentRequisitionLine."Vendor Invoice No.";
        GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
        //    GenJournalLine.VALIDATE("Applies-to Doc. No.", PaymentRequisitionLine."Vendor Invoice No.");
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentRequisitionLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentRequisitionLine."Shortcut Dimension 2 Code");
        IF PaymentRequisitionLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
        //Line 2: Credit VAT Payable with VAT Amount
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DEFAULT';
        GenJournalLine."Line No." := PaymentRequisitionLine."Line No." + 1;
        GenJournalLine."Posting Date" := Date;
        GenJournalLine."Document No." := "No.";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine.VALIDATE("Account No.", PaymentMgtSetup."VAT Payable Account");
        GenJournalLine.Description := COPYSTR(('VAT Deduction on ' + PaymentRequisitionLine."Payment Details"), 1, 150);
        GenJournalLine."Dimension Set ID" := PaymentRequisitionLine."Dimension Set ID";
        // GenJournalLine.VALIDATE(Amount, -PaymentRequisitionLine."VAT Amount");
        GenJournalLine.VALIDATE("Currency Code", PaymentRequisitionLine."Currency Code");
        //  GenJournalLine."External Document No." := PaymentRequisitionLine."Vendor Invoice No.";
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentRequisitionLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentRequisitionLine."Shortcut Dimension 2 Code");
        GenJournalLine.INSERT;

        //Line 3: Credit WHT Payable with WHT Amount
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DEFAULT';
        GenJournalLine."Line No." := PaymentRequisitionLine."Line No." + 2;
        GenJournalLine."Posting Date" := Date;
        GenJournalLine."Document No." := "No.";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine.VALIDATE("Account No.", PaymentMgtSetup."WHT Payable Account");
        GenJournalLine.Description := COPYSTR(('WHT Deduction on ' + PaymentRequisitionLine."Payment Details"), 1, 150);
        GenJournalLine."Dimension Set ID" := PaymentRequisitionLine."Dimension Set ID";
        //  GenJournalLine.VALIDATE(Amount, -PaymentRequisitionLine."WHT Amount");
        GenJournalLine.VALIDATE("Currency Code", PaymentRequisitionLine."Currency Code");
        //  GenJournalLine."External Document No." := PaymentRequisitionLine."Vendor Invoice No.";
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentRequisitionLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentRequisitionLine."Shortcut Dimension 2 Code");
        GenJournalLine.INSERT;

        //Line 4: Credit NCDF Payable with NCDF Amount
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DEFAULT';
        GenJournalLine."Line No." := PaymentRequisitionLine."Line No." + 3;
        GenJournalLine."Posting Date" := Date;
        GenJournalLine."Document No." := "No.";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine.VALIDATE("Account No.", PaymentMgtSetup."NCDF Payable Account");
        GenJournalLine.Description := COPYSTR(('NCDF Deduction on ' + PaymentRequisitionLine."Payment Details"), 1, 150);

        GenJournalLine."Dimension Set ID" := PaymentRequisitionLine."Dimension Set ID";
        // GenJournalLine.VALIDATE(Amount, -PaymentRequisitionLine."1% NCDF Amount");
        GenJournalLine.VALIDATE("Currency Code", PaymentRequisitionLine."Currency Code");
        //  GenJournalLine."External Document No." := PaymentRequisitionLine."Vendor Invoice No.";
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentRequisitionLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentRequisitionLine."Shortcut Dimension 2 Code");
        //  IF PaymentRequisitionLine."1% NCDF Amount" <> 0 THEN
        GenJournalLine.INSERT;

        //Line 5: Credit Bank with Pay Cheque Amount
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DEFAULT';
        GenJournalLine."Line No." := PaymentRequisitionLine."Line No." + 4;
        GenJournalLine."Posting Date" := Date;
        GenJournalLine."Document No." := "No.";
        IF PaymentRequisitionLine."Bal. Account Type" = PaymentRequisitionLine."Bal. Account Type"::"Bank Account" THEN
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account"
        ELSE
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";

        GenJournalLine.VALIDATE("Account No.", PaymentRequisitionLine."Bal. Account No.");
        GenJournalLine.Description := PaymentRequisitionLine."Payment Details";
        GenJournalLine."Dimension Set ID" := PaymentRequisitionLine."Dimension Set ID";
        GenJournalLine.VALIDATE(Amount, -PaymentRequisitionLine.Amount);
        GenJournalLine.VALIDATE("Currency Code", PaymentRequisitionLine."Currency Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentRequisitionLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentRequisitionLine."Shortcut Dimension 2 Code");
        IF PaymentRequisitionLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
    end;

    procedure GenerateNewPaymentRequisition(PaymentDetail: Text; AccountType: Option "G/L Account","Vendor"; AccountNo: Code[20]; Amt: Decimal; ProjectCode: Code[20]; ActivationCode: Code[20]; DeptCode: Code[20]; BranchCode: Code[20]; CargoRef: Code[20]) PVNumber: Code[20]//é //the e is in the nav function
    var
        PaymentReqHeader: Record "Payment Requisition";
        PaymentReqLine: Record "Payment Requisition Line";
    begin
        PaymentReqHeader.INIT;
        PaymentReqHeader.INSERT(TRUE);
        PaymentReqHeader."Request Description" := PaymentDetail;
        PaymentReqHeader.MODIFY(TRUE);

        PaymentReqLine.INIT;
        PaymentReqLine."Document No." := PaymentReqHeader."No.";
        PaymentReqLine."Payment Details" := COPYSTR('Payment for ' + PaymentDetail, 1, 150);
        PaymentReqLine."Account Type" := AccountType;
        PaymentReqLine.VALIDATE("Account No.", AccountNo);
        //    PaymentReqLine."WHT %" := PaymentReqLine."WHT %"::"0%";
        PaymentReqLine.VALIDATE(Amount, Amt);
        PaymentReqLine.VALIDATE(Amount, Amt);
        PaymentReqLine."Shortcut Dimension 1 Code" := DeptCode;
        PaymentReqLine."Shortcut Dimension 2 Code" := BranchCode;
        PaymentReqLine."Shortcut Dimension 4 Code" := CargoRef;
        //    PaymentReqLine."System-Generated" := TRUE;
        PaymentReqLine.INSERT(TRUE);

        EXIT(PaymentReqHeader."No.");
    end;

    procedure CreateVoucher()
    var
        PaymentMgtSetup: Record "Payment Mgt Setup";
        PRHeader: Record "Payment Requisition";
        PVHeader: Record "Payment Voucher Header";
        PVHeaderNo: Code[20];
        PRLine: Record "Payment Requisition Line";
        PVLine: Record "Payment Voucher Line";
    begin
        if Rec."Voucher Created?" = true then
            Error('Voucher cannot be created more than once for each Payment Requisition');
        //Transfer Payment Requisition Header to Payment Voucher Header
        PaymentMgtSetup.GET;
        PaymentMgtSetup.TESTFIELD("Payment Voucher No.");
        PRHeader.SetRange("No.", Rec."No.");
        if PRHeader.FindFirst() then begin
            PVHeader.TransferFields(PRHeader);
            PVHeaderNo := NoSeriesMgt.GetNextNo(PaymentMgtSetup."Payment Voucher No.", TODAY, TRUE);
            PVHeader."Former PR No." := PRHeader."No.";
            PVHeader."No." := PVHeaderNo;
            PVHeader.Insert();
            Rec."Voucher Created?" := true;
            Rec.Modify();
        end;
        //Transfer Payment Requisition Line to Payment Voucher Line
        PRLine.SetRange("Document No.", Rec."No.");
        if PRLine.FindFirst() then begin
            repeat
                PVLine.TransferFields(PRLine);
                PVLine."Document No." := PVHeaderNo;
                PVLine.Insert();
            until PRLine.Next() = 0;
        end;
        OnMoveDocAttachFromPaymentReqToVoucher(Rec, PVHeader);
        IF CONFIRM('Do you want to open Payment Voucher %1?', FALSE, PVHeaderNo) THEN
            page.Run(60002, PVHeader)
        ELSE
            EXIT;
        page.Run(60002, PVHeader);
    end;

    procedure TestMandatoryFields()
    var
        PaymentReqLine: Record "Payment Requisition Line";
        Error001: Label '%1 cannot be empty on the line %2';
        Error002: Label '%1 cannot be 0';
        Err001: Label 'Kindly select a %1 value';
        Err002: Label 'Kindly input a %1 value';
    begin

        // if Rec."Transaction type" = Rec."Transaction type"::" " then
        //     Error(Err001, Rec.FieldCaption("Transaction type"));
        if Rec."Transaction type" = Rec."Transaction type"::Loan then
            TestField("Loan ID");
        Rec.TestField("Request Description");
        //Rec.TestField("Bal Account No.");
        Rec.TestField("Shortcut Dimension 1 Code");
        Rec.TestField("Shortcut Dimension 2 Code");
        Rec.CalcFields("Request Amount");
        if Rec."Request Amount" = 0 then
            Error(Error002, Rec.FieldCaption("Request Amount"));
        PaymentReqLine.SetRange("Document No.", Rec."No.");
        PaymentReqLine.FindFirst();
        repeat
            if PaymentReqLine.Amount = 0 then
                Error(Error001, PaymentReqLine.FieldCaption(Amount), PaymentReqLine.FieldCaption("Line No."));
            if PaymentReqLine."Account No." = '' then
                Error(Error001, PaymentReqLine.FieldCaption("Account No."), PaymentReqLine.FieldCaption("Line No."));
            if PaymentReqLine."Shortcut Dimension 1 Code" = '' then
                Error(Error001, PaymentReqLine.FieldCaption("Shortcut Dimension 1 Code"), PaymentReqLine.FieldCaption("Line No."));
            if PaymentReqLine."Shortcut Dimension 2 Code" = '' then
                Error(Error001, PaymentReqLine.FieldCaption("Shortcut Dimension 2 Code"), PaymentReqLine.FieldCaption("Line No."));
            if PaymentReqLine."Payment Details" = '' then
                Error(Error001, PaymentReqLine.FieldCaption("Payment Details"), PaymentReqLine.FieldCaption("Line No."));
        until PaymentReqLine.Next() = 0;

    end;

    trigger OnInsert()
    begin
        UserSetup.GET(USERID);
        Requester := UserSetup."User ID";

        Date := TODAY;

        IF "No." = '' THEN BEGIN
            PaymentMgtSetup.GET;
            PaymentMgtSetup.TESTFIELD("Payment Requisition Nos.");
            //NoSeriesMgt.InitSeries(PaymentMgtSetup."Payment Requisition Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            If NoSeriesMgt.AreRelated(PaymentMgtSetup."Payment Requisition Nos.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo(PaymentMgtSetup."Payment Requisition Nos.");
        END;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        PaymentReqLine.Reset();
        PaymentReqLine.SetRange("Document No.", "No.");
        if PaymentReqLine.FindFirst() then
            PaymentReqLine.DeleteAll();
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
            if PmtReqLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;

    end;

    procedure PmtReqLinesExist(): Boolean
    var
        IsHandled, Result : Boolean;

    begin
        IsHandled := false;
        Result := false;
        if IsHandled then
            exit(Result);

        PaymentRequisitionLine.Reset();
        PaymentRequisitionLine.SetRange("Document No.", "No.");
        exit(not PaymentRequisitionLine.IsEmpty);
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

        PaymentRequisitionLine.Reset();
        PaymentRequisitionLine.SetRange("Document No.", "No.");
        PaymentRequisitionLine.LockTable();
        if PaymentRequisitionLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(PaymentRequisitionLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if PaymentRequisitionLine."Dimension Set ID" <> NewDimSetID then begin
                    PaymentRequisitionLine."Dimension Set ID" := NewDimSetID;


                    DimMgt.UpdateGlobalDimFromDimSetID(
                      PaymentRequisitionLine."Dimension Set ID", PaymentRequisitionLine."Shortcut Dimension 1 Code", PaymentRequisitionLine."Shortcut Dimension 2 Code");
                    PaymentRequisitionLine.Modify();
                end;
            until PaymentRequisitionLine.Next() = 0;
    end;


    // procedure MarkAllWhereUserisUserIDOrDepartment()
    // var
    //     UserSetup: Record "User Setup";
    //     IsHandled: Boolean;
    // begin
    //     if UserSetup.Get(UserId) and UserSetup."Finance Admin" then
    //         exit;

    //     FilterGroup(-1); //Used to support the cross-column search
    //     SetRange(Requester, UserId);
    //     if FindSet() then
    //         repeat
    //             Mark(true);
    //         until Next() = 0;
    //     MarkedOnly(true);
    //     FilterGroup(0);
    // end;

    local procedure UpdateAllLineCurrencyCode()
    var
        PmtReqAmt: Decimal;
    begin

        if "Currency Code" = xRec."Currency Code" then
            exit;

        PaymentRequisitionLine.Reset();
        PaymentRequisitionLine.SetRange("Document No.", "No.");
        PaymentRequisitionLine.LockTable();
        if PaymentRequisitionLine.Find('-') then
            repeat
                PmtReqAmt := PaymentRequisitionLine.Amount;
                PaymentRequisitionLine.Validate("Currency Code", "Currency Code");
                PaymentRequisitionLine.Validate(Amount, PmtReqAmt);
                PaymentRequisitionLine.Modify();
            until PaymentRequisitionLine.Next() = 0;
    end;

    [IntegrationEvent(false, false)]
    procedure OnMoveDocAttachFromPaymentReqToVoucher(var Rec1: Record "Payment Requisition"; var Rec2: Record "Payment Voucher Header")
    begin
    end;
}