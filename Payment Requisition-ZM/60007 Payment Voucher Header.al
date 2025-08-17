table 60009 "Payment Voucher Header"
{
    //Created by Akande
    DataClassification = CustomerContent;
    LookupPageId = "Payment Voucher List";
    fields
    {
        field(1; "No."; code[10])
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
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            //Editable = false;
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
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            //Editable = false;
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(7; "No. Series"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series".Code;
        }
        field(8; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Open,Approved,"Pending Approval",Rejected;
            OptionCaption = 'Open,Approved,Pending Approval,Rejected';
            Editable = false;
        }
        field(9; Posted; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;

        }
        // field(24; "Account Type"; Option)
        // {
        //     OptionMembers = Bank;
        // }
        field(3; "Pay Mode"; Code[20])
        {

            Caption = 'Payment Plan';
            TableRelation = "Pay Mode";

            trigger OnValidate()
            var
                PVLine: Record "Payment Voucher Line";
                PayModePVBName: Code[50];
                PayModePVBNo: Code[50];
            begin
                IF PayMode.GET("Pay Mode") THEN begin
                    PayModePVBName := PayMode."Bal. Account Name";
                    PayModePVBNo := PayMode."Bal. Account No.";
                    "Bal Account No." := PayModePVBNo;
                    "Bal Account Name" := PayModePVBName;
                end;
                //populating PVLine
                // PVLine.Init();
                // PVLine.SetRange("Document No.", "No.");
                // if PVLine.FindFirst() then begin
                //     PVLine."Bal. Account Type" := PVLine."Bal. Account Type"::Bank;
                //     PVLine."Bal. Account No." := PayModePVBNo;
                //     PVLine."Bal. Account Name" := PayModePVBName;
                //end;


            end;
        }
        field(10; "Type"; Option)
        {
            DataClassification = CustomerContent;
            // OptionCaptionML = ENU = '" ","Cash Advance","Imprest","Expense","Maintenance"';
            // OptionCaption =  ',Cash Advance,Imprest,Expense,Maintenance';
            OptionMembers = " ","Cash Advance","Imprest","Expense","Maintenance";
        }
        field(24; "Bal Account Type"; Option)
        {
            OptionMembers = "G/L Account",Vendor,Staff,"Bank Account","Fixed Asset";
            InitValue = "Bank Account";
            Editable = false;
        }

        field(25; "Bal Account No."; Code[20])
        {
            DataClassification = CustomerContent;


            TableRelation = IF ("Bal Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true)) ELSE
            IF ("Bal Account Type" = CONST(Vendor)) Vendor else
            if ("Bal Account Type" = const(Staff)) Customer where(Type = const(Staff))
            else
            if ("Bal Account Type" = const("Bank Account")) "Bank Account" where("Suspense/Clearing" = field("Suspense/Clearing"));

            trigger OnValidate()
            var
                Err001: Label 'You cannot edit a voucher of staff advance type directly on this page';
            begin
                if "Transaction type" = "Transaction type"::"Staff Adv" then
                    Error(Err001);
                CASE "Bal Account Type" OF
                    "Bal Account Type"::"G/L Account":
                        BEGIN
                            if not GLAcc.GET("Bal Account No.") then
                                exit;
                            "Bal Account Name" := GLAcc.Name;
                            Validate("Shortcut Dimension 1 Code", GLAcc."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", GLAcc."Global Dimension 2 Code");

                        END;
                    "Bal Account Type"::Vendor:
                        BEGIN
                            if not Vend.GET("Bal Account No.") then
                                exit;
                            Vend.GET("Bal Account No.");
                            "Bal Account Name" := Vend.Name;
                            //Validate("Currency Code", Vend."Currency Code");
                            Validate("Shortcut Dimension 1 Code", Vend."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", Vend."Global Dimension 2 Code");

                        END;
                    "Bal Account Type"::Staff:
                        BEGIN
                            if not Cust.GET("Bal Account No.") then
                                exit;
                            Cust.GET("Bal Account No.");
                            "Bal Account Name" := Cust.Name;
                            Validate("Currency Code", Cust."Currency Code");
                            Validate("Shortcut Dimension 1 Code", Cust."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", Cust."Global Dimension 2 Code");

                        END;
                    "Bal Account Type"::"Bank Account":
                        BEGIN
                            // if not BankAccount.GET("Bal Account No.") then
                            //     exit;
                            // BankAccount.GET("Bal Account No.");
                            // "Bal Account Name" := BankAccount.Name;
                            // Validate("Currency Code", Vend."Currency Code");
                            // Validate("Shortcut Dimension 1 Code", BankAccount."Global Dimension 1 Code");
                            // Validate("Shortcut Dimension 2 Code", BankAccount."Global Dimension 2 Code");
                            //TestField(Beneficiary);
                            // if not EmpRec.GET("Bal Account No.") then
                            //     exit;
                            BankAccount.GET("Bal Account No.");
                            "Bal Account Name" := BankAccount.Name;
                            //Validate("Currency Code", BankAccount."Currency Code");
                            Validate("Shortcut Dimension 1 Code", EmpRec."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", EmpRec."Global Dimension 2 Code");

                        END;
                END;

            end;
        }
        field(11; "Bal Account Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
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
        // field(18; "Purchase Requisition No."; Code[10])
        // {
        //     //DataClassification = ToBeClassified;
        //     // Description = 'Approved Purchase Requisition';
        //     TableRelation = "Purch. Requistion" where(Status = const(Approved));
        //     trigger OnValidate()
        //     begin
        //         //  PurchaseReqRec.SETFILTER(Status, '%1', PurchaseReqRec.Status::Approved);
        //         // IF PAGE.RUNMODAL(50097, PurchaseReqRec) = ACTION::LookupOK THEN BEGIN
        //         // "Purchase Requisition No." := PurchaseReqRec."No.";
        //         PurchaseReqRec.SetRange("No.", "Purchase Requisition No.");
        //         PurchaseReqRec.CALCFIELDS("Requisition Amount");
        //         "Purchase Requisition Amount" := PurchaseReqRec."Requisition Amount";
        //         // Message('%1', PurchaseReqRec."Requisition Amount");
        //         //populate payment line with lines from approved purch. req
        //         PurchaseReqLineRec.SETRANGE("Document No.", "Purchase Requisition No.");
        //         IF PurchaseReqLineRec.FINDSET THEN BEGIN
        //             LineNo := 1;
        //             REPEAT
        //                 //  Message('%1', PurchaseReqLineRec.Quantity);
        //                 PaymentVouchLine.INIT;
        //                 PaymentVouchLine."Document No." := "No.";
        //                 PaymentVouchLine."Line No." := LineNo;
        //                 PaymentVouchLine.INSERT;
        //                 //PaymentRequisitionLine.VALIDATE("Account No.",PurchaseReqLineRec."Cost Account No.");
        //                 PaymentVouchLine.Amount := PurchaseReqLineRec.Amount;
        //                 PaymentVouchLine."Payment Details" := COPYSTR(STRSUBSTNO('Payment for %1', PurchaseReqLineRec."Required Item/Service"), 1, MAXSTRLEN(PaymentVouchLine."Payment Details"));
        //                 PaymentVouchLine.VALIDATE("Amount (LCY)", PurchaseReqLineRec."Amount (LCY)");
        //                 PaymentVouchLine.MODIFY;
        //                 LineNo += 1;
        //             UNTIL PurchaseReqLineRec.NEXT = 0;
        //         END;
        //     END;
        //     //  end;
        // }
        field(19; "Request Amount (LCY)"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Payment Voucher Line"."Amount (LCY)" WHERE("Document No." = FIELD("No.")));
        }
        field(20; "Request Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Payment Voucher Line".Amount WHERE("Document No." = FIELD("No.")));
        }
        // field(21; "Purchase Requisition Amount"; Decimal)
        // {
        //     Description = 'Approved Purchase Requisition';
        //     // Editable = false;
        //     DataClassification = ToBeClassified;
        // }

        field(23; "Former PR No."; Code[20])
        {
            Caption = 'Former PR/Cash Adv No.';
            DataClassification = ToBeClassified;
            Editable = false;
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
                if "Currency Code" <> '' then
                    if PaymentVoucherLinesExist() then
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
        field(480; "Dimension Set ID"; Integer)
        {
            CaptionML = ENU = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                Rec.ShowDocDim();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(14; "Retirement No"; Code[20])
        {

        }
        field(50000; "Detailed Pay Description"; Text[200])
        {
            DataClassification = ToBeClassified;
        }

        field(50002; "Balance Posted"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50003; "Due Date"; Date) { }
        field(50004; "Transaction type"; Option)
        {
            OptionMembers = " ",Loan,"Staff Adv";
        }
        field(50005; "Loan ID"; Code[20]) { }
        field(50008; "Applies-to Invoice No."; Code[20])
        {
            Enabled = false;

            trigger OnLookup()
            var
                VendLedgerEntryList: Page "Vendor Ledger Entries";
            begin
                CalledFromLkup := true;
                TestField("Bal Account Type", "Bal Account Type"::Vendor);
                VendLedgerEntry.SetCurrentkey("Vendor No.", Open, Positive, "Due Date");
                VendLedgerEntry.Ascending(true);

                VendLedgerEntry.SetRange("Document Type", VendLedgerEntry."document type"::Invoice);
                VendLedgerEntry.SetRange(Open, true);
                if Rec."Bal Account No." <> '' then
                    VendLedgerEntry.SetRange("Vendor No.", "Bal Account No.");
                VendLedgerEntry.SetRange(Open, true);
                VendLedgerEntryList.SetTableview(VendLedgerEntry);
                VendLedgerEntryList.LookupMode := true;
                if VendLedgerEntryList.RunModal = Action::LookupOK then begin
                    VendLedgerEntryList.GetRecord(VendLedgerEntry);
                    VendLedgerEntry.SetRange("Document No.", "Applies-to Invoice No.");
                    VendLedgerEntryList.SetSelectionFilter(VendLedgerEntry);
                    Validate("Bal Account No.", VendLedgerEntry."Vendor No.");
                    "Request Description" := StrSubstNo(Text501, VendLedgerEntry."Document No.");
                    "Applies-to Invoice No." := VendLedgerEntry."Document No.";
                    InsertVoucherLine();
                end;
                Clear(VendLedgerEntryList);
                Clear(VendLedgerEntry);
            end;

            trigger OnValidate()
            begin
                if "Applies-to Invoice No." <> '' then begin
                    if not CalledFromLkup then begin
                        VendLedgerEntry.Reset;
                        VendLedgerEntry.SetCurrentkey("Document No.");
                        VendLedgerEntry.SetRange("Document No.", "Applies-to Invoice No.");
                        if VendLedgerEntry.FindFirst then begin
                            VendLedgerEntry.CalcFields("Remaining Amount");
                            if VendLedgerEntry."Remaining Amount" <> 0 then
                                "Request Description" := StrSubstNo(Text501, VendLedgerEntry."Document No.");
                        end;
                        InsertVoucherLine();
                    end;

                end;
            end;
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
                    //Employee.GET(Beneficiary);
                    //"Beneficiary Name" := Employee.FullName();
                end;
            end;


        }
        field(50009; "Beneficiary Name"; Text[100])
        {
            Caption = 'Beneficiary Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50060; "Suspense/Clearing"; Option)
        {
            OptionMembers = " ","Bank Payment","Bank Receipts","Main Bank";
            InitValue = "Bank Payment";
        }
        field(50061; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = "Gen. Journal Template";
        }
        field(50062; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));

            trigger OnValidate()
            begin
                // UpdateJournalBatchID();
            end;
        }
        field(50063; "Payment Method"; Option)
        {
            OptionMembers = " ","Manual Payment","E-Payment";
        }
        field(50064; "Payee No."; Code[30])
        {
            DataClassification = EndUserIdentifiableInformation;
            //TableRelation = if ("Source Type" = filter(Staff)) Employee
            //else
            TableRelation = Vendor;
            // else
            // if ("Source Type" = filter(Customer)) Customer
            // else
            //if ("Source Type" = filter("Bank Account")) "Bank Account";
            // else
            // if ("Source Type" = filter("Pension Fund Administrator")) "Pension Administrator";
        }
        field(50065; "Payment ID"; Code[20]) { }
        field(50066; "Schedule Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Payment Schedule".Amount where("Source Document No." = field("No.")));
        }
        field(50067; "Voucher Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Payment Voucher Line".Amount where("Document No." = field("No.")));
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
        PayMode: Record "Pay Mode";
        PaymentReqRec: Record "Payment Requisition";
        CashAdvance: Record "Cash Advance";
        PaymentVouchLine: Record "Payment Voucher Line";
        PurchaseReqRec: Record "Purch. Requistion";
        PurchaseReqLineRec: Record "Purchase Requisition Line";
        GLAccount: Record "G/L Account";
        Employee: Record Employee;
        UserSetup: Record "User Setup";
        DimMgt: Codeunit DimensionManagement;
        PaymentMgtSetup: record "Payment Mgt Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        BankAcc: Record "Bank Account";
        PaymentVoucherHeader: Record "Payment Voucher Header";
        PaymentVoucherLine: Record "Payment Voucher Line";
        PaymentVoucherLine2: Record "Payment Voucher Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        TestReportPrint: Codeunit "Test Report-Print";
        GLEntry: Record "G/L Entry";
        LineNo: Integer;

        //LineNo: Integer;
        Cust: Record Customer;
        Vend: Record Vendor;
        GLAcc: Record "G/L Account";
        BankAccount: Record "Bank Account";
        CurrExchRate: Record "Currency Exchange Rate";
        Text002: TextConst ENU = 'cannot be specified without %1';
        CalledFromLkup: Boolean;
        VendLedgerEntry: Record "Vendor Ledger Entry";
        Text501: Label 'Invoice %1';
        EmpRec: Record Employee;

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
            if PaymentVoucherLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;

    end;

    procedure PostPayment()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        VendLedgerEntryRec: Record "Vendor Ledger Entry";
        SignRegulator: Decimal;
    begin
        //IF ("Approved Purch. Requisition" = '') AND ("System-Generated" = FALSE) THEN
        //  ERROR('Approved Requisition is required')
        // ELSE BEGIN
        SignRegulator := 1;
        if Posted then
            Error('This Voucher has been posted already');
        GenJournalLine2.SETRANGE("Journal Template Name", 'GENERAL');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF GenJournalLine2.FINDFIRST THEN
            GenJournalLine2.DELETEALL;

        PaymentVoucherLine.SETCURRENTKEY("Document No.", "Line No.");
        PaymentVoucherLine.SETRANGE("Document No.", "No.");
        IF PaymentVoucherLine.FINDFIRST THEN
            REPEAT

                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'DEFAULT';
                GenJournalLine."Line No." := PaymentVoucherLine."Line No.";
                GenJournalLine."Posting Date" := Date;
                GenJournalLine."Document No." := "No.";
                if PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::Staff then begin
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                end;
                if PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::"G/L Account" then begin
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                end;
                if PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::Vendor then begin
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                end;
                if PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::"Bank Account" then begin
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
                end;
                if PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::"Fixed Asset" then begin
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Fixed Asset";
                    GenJournalLine."FA Posting Date" := PaymentVoucherLine."FA Posting Date";
                    GenJournalLine."FA Posting Type" := PaymentVoucherLine."FA Posting Type";
                    GenJournalLine."Depreciation Book Code" := PaymentVoucherLine."Depreciation Book Code";
                    GenJournalLine."Maintenance Code" := PaymentVoucherLine."Maintenance Code";
                end;
                //apply invoice no.
                if PaymentVoucherLine."Applies-to Invoice No." <> '' then begin
                    VendLedgerEntryRec.Reset();
                    vendLedgerEntryRec.SetRange("Vendor No.", PaymentVoucherLine."Account No.");
                    vendLedgerEntryRec.SetRange(Open, true);
                    vendLedgerEntryRec.SetRange("Document Type", vendLedgerEntryRec."Document Type"::Invoice);
                    vendLedgerEntryRec.SetRange("Document No.", PaymentVoucherLine."Applies-to Invoice No.");
                    if vendLedgerEntryRec.FindFirst() then begin
                        GenJournalLine."Posting Date" := Date;
                        GenJournalLine."Due Date" := "Due Date";
                        GenJournalLine.validate("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::Invoice);
                        GenJournalLine.Validate("Applies-to Doc. No.", PaymentVoucherLine."Applies-to Invoice No.");
                        SignRegulator := 1;
                    end;
                end;

                GenJournalLine.VALIDATE("Account No.", PaymentVoucherLine."Account No.");
                GenJournalLine.Description := PaymentVoucherLine."Payment Details";
                GenJournalLine."External Document No." := "Retirement No";
                GenJournalLine."Balance Posted" := "Balance Posted";

                IF "Bal Account Type" = "Bal Account Type"::"Bank Account" THEN begin
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";

                end;
                IF "Bal Account Type" = "Bal Account Type"::Vendor THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::Vendor;
                IF "Bal Account Type" = "Bal Account Type"::Staff THEN
                    GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::Customer);
                IF "Bal Account Type" = "Bal Account Type"::"G/L Account" THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                IF "Bal Account Type" = "Bal Account Type"::"Fixed Asset" THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Fixed Asset";
                GenJournalLine.VALIDATE(Amount, SignRegulator * PaymentVoucherLine.Amount);
                GenJournalLine."Bal. Account No." := "Bal Account No.";
                //GenJournalLine.VALIDATE("Currency Code", PaymentVoucherLine."Currency Code");
                GenJournalLine."Transaction type" := Rec."Transaction type";
                GenJournalLine."Loan ID" := Rec."Loan ID";
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
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentVoucherLine."Shortcut Dimension 1 Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentVoucherLine."Shortcut Dimension 2 Code");
                IF PaymentVoucherLine.Amount <> 0 THEN begin
                    GenJournalLine.INSERT;
                end;

            // PaymentReqRec.SetRange("No.", "Former PR No.");
            // if PaymentReqRec.FindFirst() then begin
            //     PaymentReqRec.Posted := true;
            //     PaymentReqRec.Modify();
            // end;
            UNTIL PaymentVoucherLine.NEXT = 0;
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);


        CheckPostedJnl;
        CheckUpdatePmtReq();
        CheckUpdateCAdv();


    end;

    procedure PreviewPosting()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        SignRegulator: Decimal;
        VendLedgerEntryRec: Record "Vendor Ledger Entry";
    begin
        SignRegulator := 1;
        if Posted then
            Error('This Voucher has been posted already');
        GenJournalLine2.SETRANGE("Journal Template Name", 'GENERAL');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF GenJournalLine2.FINDFIRST THEN
            GenJournalLine2.DELETEALL;

        PaymentVoucherLine.SETCURRENTKEY("Document No.", "Line No.");
        PaymentVoucherLine.SETRANGE("Document No.", "No.");
        IF PaymentVoucherLine.FINDFIRST THEN
            REPEAT
                if PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::"Fixed Asset" then begin
                    PaymentVoucherLine.TestField("Depreciation Book Code");
                    PaymentVoucherLine.TestField("FA Posting Type", PaymentVoucherLine."FA Posting Type"::Maintenance);
                end;
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'DEFAULT';
                GenJournalLine."Line No." := PaymentVoucherLine."Line No.";
                GenJournalLine."Posting Date" := Date;
                GenJournalLine."Document No." := "No.";
                if PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::Staff then begin
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                end;
                if PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::"G/L Account" then begin
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                end;
                if PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::Vendor then begin
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                end;
                if PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::"Bank Account" then begin
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
                end;
                // if PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::"Fixed Asset" then begin
                //     GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Fixed Asset";
                // end;
                if PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::"Fixed Asset" then begin
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Fixed Asset";
                    GenJournalLine."FA Posting Date" := PaymentVoucherLine."FA Posting Date";
                    GenJournalLine."FA Posting Type" := PaymentVoucherLine."FA Posting Type";
                    GenJournalLine."Depreciation Book Code" := PaymentVoucherLine."Depreciation Book Code";
                    GenJournalLine."Maintenance Code" := PaymentVoucherLine."Maintenance Code";
                end;
                //apply invoice no.
                if PaymentVoucherLine."Applies-to Invoice No." <> '' then begin
                    VendLedgerEntryRec.Reset();
                    vendLedgerEntryRec.SetRange("Vendor No.", PaymentVoucherLine."Account No.");
                    vendLedgerEntryRec.SetRange(Open, true);
                    vendLedgerEntryRec.SetRange("Document Type", vendLedgerEntryRec."Document Type"::Invoice);
                    vendLedgerEntryRec.SetRange("Document No.", PaymentVoucherLine."Applies-to Invoice No.");
                    if vendLedgerEntryRec.FindFirst() then begin
                        GenJournalLine."Posting Date" := Date;
                        GenJournalLine."Due Date" := "Due Date";
                        GenJournalLine.validate("Applies-to Doc. Type", GenJournalLine."Applies-to Doc. Type"::Invoice);
                        GenJournalLine.Validate("Applies-to Doc. No.", PaymentVoucherLine."Applies-to Invoice No.");
                        SignRegulator := 1;
                    end;
                end;

                // Message('%1', GenJournalLine."Account Type");
                GenJournalLine.VALIDATE("Account No.", PaymentVoucherLine."Account No.");
                GenJournalLine.Description := PaymentVoucherLine."Payment Details";
                GenJournalLine."External Document No." := "Retirement No";
                GenJournalLine."Balance Posted" := "Balance Posted";
                // GenJournalLine."FA Posting Type" := PaymentVoucherLine."FA Posting Type";
                // GenJournalLine."Depreciation Book Code" := PaymentVoucherLine."Depreciation Book Code";
                // GenJournalLine."Maintenance Code" := PaymentVoucherLine."Maintenance Code";
                // GenJournalLine.VALIDATE(Amount, -PaymentVoucherLine.Amount);
                IF "Bal Account Type" = "Bal Account Type"::"Bank Account" THEN begin
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";

                end;
                IF "Bal Account Type" = "Bal Account Type"::Vendor THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::Vendor;
                IF "Bal Account Type" = "Bal Account Type"::Staff THEN
                    GenJournalLine.Validate("Bal. Account Type", GenJournalLine."Bal. Account Type"::Customer);
                IF "Bal Account Type" = "Bal Account Type"::"G/L Account" THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                IF "Bal Account Type" = "Bal Account Type"::"Fixed Asset" THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Fixed Asset";
                GenJournalLine.VALIDATE(Amount, SignRegulator * PaymentVoucherLine.Amount);
                GenJournalLine."Bal. Account No." := "Bal Account No.";
                GenJournalLine.VALIDATE("Currency Code", PaymentVoucherLine."Currency Code");
                GenJournalLine."Transaction type" := Rec."Transaction type";
                GenJournalLine."Loan ID" := Rec."Loan ID";
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
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentVoucherLine."Shortcut Dimension 1 Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentVoucherLine."Shortcut Dimension 2 Code");
                IF PaymentVoucherLine.Amount <> 0 THEN begin
                    GenJournalLine.INSERT;
                end;

                COMMIT;
            UNTIL PaymentVoucherLine.NEXT = 0;
        GenJnlPost.Preview(GenJournalLine);
    END;
    // end;


    procedure TestReport()
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
    begin
        GenJournalLine2.SETRANGE("Journal Template Name", 'GENERAL');
        GenJournalLine2.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF GenJournalLine2.FINDFIRST THEN
            GenJournalLine2.DELETEALL;

        PaymentVoucherLine.SETCURRENTKEY("Document No.", "Line No.");
        PaymentVoucherLine.SETRANGE("Document No.", "No.");
        IF PaymentVoucherLine.FINDFIRST THEN BEGIN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'DEFAULT';
                GenJournalLine."Line No." := PaymentVoucherLine."Line No.";
                GenJournalLine."Posting Date" := Date;
                GenJournalLine."Document No." := "No.";
                IF PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::"G/L Account" THEN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account"
                ELSE
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine.VALIDATE("Account No.", PaymentVoucherLine."Account No.");
                GenJournalLine.Description := PaymentVoucherLine."Payment Details";
                GenJournalLine.VALIDATE(Amount, PaymentVoucherLine.Amount);

                IF "Bal Account Type" = "Bal Account Type"::"Bank Account" THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account"
                ELSE
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                //GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                GenJournalLine.VALIDATE("Bal. Account No.", "Bal Account No.");
                GenJournalLine.VALIDATE("Currency Code", PaymentVoucherLine."Currency Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentVoucherLine."Shortcut Dimension 1 Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentVoucherLine."Shortcut Dimension 2 Code");
                GenJournalLine.INSERT;
                COMMIT;
            UNTIL PaymentVoucherLine.NEXT = 0;
            TestReportPrint.PrintGenJnlLine(GenJournalLine);
        END;
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

        PaymentVoucherLine.SETCURRENTKEY("Document No.", "Line No.");
        PaymentVoucherLine.SETRANGE("Document No.", "No.");
        IF PaymentVoucherLine.FINDFIRST THEN BEGIN
            REPEAT
                GenJournalLine.INIT;
                GenJournalLine."Journal Template Name" := 'GENERAL';
                GenJournalLine."Journal Batch Name" := 'DEFAULT';
                GenJournalLine."Line No." := PaymentVoucherLine."Line No.";
                GenJournalLine."Posting Date" := Date;
                GenJournalLine."Document No." := "No.";
                IF PaymentVoucherLine."Account Type" = PaymentVoucherLine."Account Type"::"G/L Account" THEN
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account"
                ELSE
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
                GenJournalLine.VALIDATE("Account No.", PaymentVoucherLine."Account No.");
                GenJournalLine.Description := PaymentVoucherLine."Payment Details";

                GenJournalLine."Dimension Set ID" := PaymentVoucherLine."Dimension Set ID";
                GenJournalLine.VALIDATE(Amount, PaymentVoucherLine.Amount);
                IF "Bal Account Type" = "Bal Account Type"::"Bank Account" THEN
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account"
                ELSE
                    GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
                //GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
                GenJournalLine.VALIDATE("Bal. Account No.", "Bal Account No.");
                GenJournalLine.VALIDATE("Currency Code", PaymentVoucherLine."Currency Code");
                GenJournalLine."Transaction type" := Rec."Transaction type";
                GenJournalLine."Loan ID" := Rec."Loan ID";
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
                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentVoucherLine."Shortcut Dimension 1 Code");
                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentVoucherLine."Shortcut Dimension 2 Code");
                GenJournalLine.INSERT;
            UNTIL PaymentVoucherLine.NEXT = 0;
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print", GenJournalLine);
        END;
        CheckPostedJnl;
    end;

    procedure CheckUpdatePmtReq()
    begin
        PaymentReqRec.SetRange("No.", "Former PR No.");
        if PaymentReqRec.FindFirst() then begin
            PaymentReqRec.Posted := true;
            PaymentReqRec."Pmt Req Code" := "No.";
            PaymentReqRec.Modify();
        end;
    end;

    procedure CheckUpdateCAdv()
    begin
        CashAdvance.Reset();
        CashAdvance.SetRange("No.", "Former PR No.");
        if CashAdvance.FindFirst() then begin
            CashAdvance.Posted := true;
            CashAdvance."Pmt Vouch. Code" := "No.";
            CashAdvance.Modify();
        end;
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
        GenJournalLine."Line No." := PaymentVoucherLine."Line No.";
        GenJournalLine."Posting Date" := Date;
        GenJournalLine."Document No." := "No.";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::Vendor;
        GenJournalLine.VALIDATE("Account No.", PaymentVoucherLine."Account No.");
        GenJournalLine.Description := PaymentVoucherLine."Payment Details";
        GenJournalLine."Dimension Set ID" := PaymentVoucherLine."Dimension Set ID";
        //IF (PaymentVoucherLine."Account Type"= PaymentVoucherLine."Account Type"::Vendor) AND (PaymentVoucherLine."Vendor Invoice No." = '') THEN 
        GenJournalLine.VALIDATE(Amount, PaymentVoucherLine.Amount);
        //ELSE
        //GenJournalLine.VALIDATE(Amount,PaymentVoucherLine."Vendor Invoice Amount");
        GenJournalLine.VALIDATE("Currency Code", PaymentVoucherLine."Currency Code");
        //  GenJournalLine."External Document No." := PaymentVoucherLine."Vendor Invoice No.";
        GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
        //  GenJournalLine.VALIDATE("Applies-to Doc. No.", PaymentVoucherLine."Vendor Invoice No.");
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentVoucherLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentVoucherLine."Shortcut Dimension 2 Code");
        IF PaymentVoucherLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
        //Line 2: Credit VAT Payable with VAT Amount
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DEFAULT';
        GenJournalLine."Line No." := PaymentVoucherLine."Line No." + 1;
        GenJournalLine."Posting Date" := Date;
        GenJournalLine."Document No." := "No.";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine.VALIDATE("Account No.", PaymentMgtSetup."VAT Payable Account");
        GenJournalLine.Description := COPYSTR(('VAT Deduction on ' + PaymentVoucherLine."Payment Details"), 1, 150);
        GenJournalLine."Dimension Set ID" := PaymentVoucherLine."Dimension Set ID";
        GenJournalLine.VALIDATE(Amount, -PaymentVoucherLine."VAT Amount");
        GenJournalLine.VALIDATE("Currency Code", PaymentVoucherLine."Currency Code");
        //GenJournalLine."External Document No." := PaymentVoucherLine."Vendor Invoice No.";
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentVoucherLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentVoucherLine."Shortcut Dimension 2 Code");
        IF PaymentVoucherLine."VAT Amount" <> 0 THEN
            GenJournalLine.INSERT;

        //Line 3: Credit WHT Payable with WHT Amount
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DEFAULT';
        GenJournalLine."Line No." := PaymentVoucherLine."Line No." + 2;
        GenJournalLine."Posting Date" := Date;
        GenJournalLine."Document No." := "No.";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine.VALIDATE("Account No.", PaymentMgtSetup."WHT Payable Account");
        GenJournalLine.Description := COPYSTR(('WHT Deduction on ' + PaymentVoucherLine."Payment Details"), 1, 150);
        GenJournalLine."Dimension Set ID" := PaymentVoucherLine."Dimension Set ID";
        //   GenJournalLine.VALIDATE(Amount, -PaymentVoucherLine."WHT Amount");
        GenJournalLine.VALIDATE("Currency Code", PaymentVoucherLine."Currency Code");
        //  GenJournalLine."External Document No." := PaymentVoucherLine."Vendor Invoice No.";
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentVoucherLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentVoucherLine."Shortcut Dimension 2 Code");
        GenJournalLine.INSERT;

        //Line 4: Credit NCDF Payable with NCDF Amount
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DEFAULT';
        GenJournalLine."Line No." := PaymentVoucherLine."Line No." + 3;
        GenJournalLine."Posting Date" := Date;
        GenJournalLine."Document No." := "No.";
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine.VALIDATE("Account No.", PaymentMgtSetup."NCDF Payable Account");
        GenJournalLine.Description := COPYSTR(('NCDF Deduction on ' + PaymentVoucherLine."Payment Details"), 1, 150);

        GenJournalLine."Dimension Set ID" := PaymentVoucherLine."Dimension Set ID";
        // GenJournalLine.VALIDATE(Amount, -PaymentVoucherLine."1% NCDF Amount");
        GenJournalLine.VALIDATE("Currency Code", PaymentVoucherLine."Currency Code");
        //  GenJournalLine."External Document No." := PaymentVoucherLine."Vendor Invoice No.";
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentVoucherLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentVoucherLine."Shortcut Dimension 2 Code");
        GenJournalLine.INSERT;

        //Line 5: Credit Bank with Pay Cheque Amount
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := 'GENERAL';
        GenJournalLine."Journal Batch Name" := 'DEFAULT';
        GenJournalLine."Line No." := PaymentVoucherLine."Line No." + 4;
        GenJournalLine."Posting Date" := Date;
        GenJournalLine."Document No." := "No.";
        IF "Bal Account Type" = "Bal Account Type"::"Bank Account" THEN
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account"
        ELSE
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";

        GenJournalLine.VALIDATE("Account No.", "Bal Account No.");
        GenJournalLine.Description := PaymentVoucherLine."Payment Details";
        GenJournalLine."Dimension Set ID" := PaymentVoucherLine."Dimension Set ID";
        GenJournalLine.VALIDATE(Amount, -PaymentVoucherLine.Amount);
        GenJournalLine.VALIDATE("Currency Code", PaymentVoucherLine."Currency Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", PaymentVoucherLine."Shortcut Dimension 1 Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", PaymentVoucherLine."Shortcut Dimension 2 Code");
        IF PaymentVoucherLine.Amount <> 0 THEN
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
        // PaymentReqHeader."Trade Project Code" := ProjectCode;
        // PaymentReqHeader."Trade Activation Code" := ActivationCode;
        //   PaymentReqHeader."System-Generated" := TRUE;
        PaymentReqHeader.MODIFY(TRUE);

        PaymentReqLine.INIT;
        PaymentReqLine."Document No." := PaymentReqHeader."No.";
        PaymentReqLine."Payment Details" := COPYSTR('Payment for ' + PaymentDetail, 1, 150);
        PaymentReqLine."Account Type" := AccountType;
        PaymentReqLine.VALIDATE("Account No.", AccountNo);
        //    PaymentReqLine."WHT %" := PaymentReqLine."WHT %"::"0%";
        //  PaymentReqLine.VALIDATE("Net Amount to Pay", Amt);
        PaymentReqLine.VALIDATE(Amount, Amt);
        PaymentReqLine."Shortcut Dimension 1 Code" := DeptCode;
        PaymentReqLine."Shortcut Dimension 2 Code" := BranchCode;
        PaymentReqLine."Shortcut Dimension 4 Code" := CargoRef;
        //    PaymentReqLine."System-Generated" := TRUE;
        PaymentReqLine.INSERT(TRUE);

        EXIT(PaymentReqHeader."No.");
    end;

    trigger OnInsert()
    begin
        UserSetup.GET(USERID);
        Requester := UserSetup."User ID";

        Date := TODAY;

        IF "No." = '' THEN BEGIN
            PaymentMgtSetup.GET;
            PaymentMgtSetup.TESTFIELD("Payment Voucher No.");
            NoSeriesMgt.InitSeries(PaymentMgtSetup."Payment Voucher No.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        PaymentVoucherLine2.Reset();
        PaymentVoucherLine2.SetRange("Document No.", "No.");
        if PaymentVoucherLine2.FindFirst() then
            PaymentVoucherLine2.DeleteAll();
    end;

    procedure Navigate()
    var
        NavigatePage: Page Navigate;
    begin
        NavigatePage.SetDoc(Date, "No.");
        NavigatePage.SetRec(Rec);
        NavigatePage.Run();
    end;

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
            if PaymentVoucherLinesExist() then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure PaymentVoucherLinesExist(): Boolean
    var
        IsHandled, Result : Boolean;

    begin
        IsHandled := false;
        Result := false;
        if IsHandled then
            exit(Result);

        PaymentVoucherLine.Reset();
        PaymentVoucherLine.SetRange("Document No.", "No.");
        exit(not PaymentVoucherLine.IsEmpty);
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

        PaymentVoucherLine.Reset();
        PaymentVoucherLine.SetRange("Document No.", "No.");
        PaymentVoucherLine.LockTable();
        if PaymentVoucherLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(PaymentVoucherLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if PaymentVoucherLine."Dimension Set ID" <> NewDimSetID then begin
                    PaymentVoucherLine."Dimension Set ID" := NewDimSetID;


                    DimMgt.UpdateGlobalDimFromDimSetID(
                      PaymentVoucherLine."Dimension Set ID", PaymentVoucherLine."Shortcut Dimension 1 Code", PaymentVoucherLine."Shortcut Dimension 2 Code");
                    PaymentVoucherLine.Modify();
                end;
            until PaymentVoucherLine.Next() = 0;
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

    local procedure UpdateAllLineCurrencyCode()
    var
        CashAdvAmt: Decimal;
    begin

        if "Currency Code" = xRec."Currency Code" then
            exit;

        PaymentVoucherLine.Reset();
        PaymentVoucherLine.SetRange("Document No.", "No.");
        PaymentVoucherLine.LockTable();
        if PaymentVoucherLine.Find('-') then
            repeat
                CashAdvAmt := PaymentVoucherLine.Amount;
                PaymentVoucherLine.Validate("Currency Code", "Currency Code");
                PaymentVoucherLine.Validate(Amount, CashAdvAmt);
                PaymentVoucherLine.Modify();
            until PaymentVoucherLine.Next() = 0;
    end;

    local procedure InsertVoucherLine()
    var
        PaymentVoucherLine: Record "Payment Voucher Line";
    begin
        VendLedgerEntry.FindFirst();
        repeat
            if LineNo = 0 then
                LineNo := 10000
            else
                LineNo += 10000;
            PaymentVoucherLine.Init();
            PaymentVoucherLine."Document No." := "No.";
            PaymentVoucherLine."Line No." := LineNo;
            PaymentVoucherLine."Account Type" := PaymentVoucherLine."Account Type"::"Bank Account";
            PaymentVoucherLine."Payment Details" := StrSubstNo(Text501, VendLedgerEntry."Document No.");
            PaymentVoucherLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            PaymentVoucherLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            PaymentVoucherLine."Dimension Set ID" := "Dimension Set ID";
            PaymentVoucherLine.Insert();
            VendLedgerEntry.CalcFields(Amount);
            PaymentVoucherLine.Validate(Amount, -1 * VendLedgerEntry.Amount);
            PaymentVoucherLine.Modify();
        until VendLedgerEntry.Next() = 0;
    end;

}