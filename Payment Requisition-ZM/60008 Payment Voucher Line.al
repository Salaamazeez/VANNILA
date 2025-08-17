table 60008 "Payment Voucher Line"
{
    //Created by Akande
    DataClassification = CustomerContent;

    fields
    {

        field(1; "Document No."; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(3; "Payment Details"; Text[150])
        {
            DataClassification = CustomerContent;
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
            CaptionML = ENU = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(8; Amount; Decimal)
        {
            BlankZero = true;
            // Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                PaymentVoucher.GET("Document No.");
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    VALIDATE("Amount (LCY)", (
                    ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                     PaymentVoucher.Date, "Currency Code", Amount, "Currency Factor"))));
                END;
            end;
        }
        field(10; "Amount (LCY)"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11; "Currency Code"; Code[10])
        {
            TableRelation = currency.Code;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                PaymentVoucher.GET("Document No.");
                IF "Currency Code" <> '' THEN BEGIN
                    IF ("Currency Code" <> xRec."Currency Code") OR
                       (CurrFieldNo = FIELDNO("Currency Code")) OR
                       ("Currency Factor" = 0)
                    THEN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate(PaymentVoucher.Date, "Currency Code");
                END ELSE
                    "Currency Factor" := 0;
                PaymentVoucher.Validate("Currency Code", "Currency Code");

                VALIDATE(Amount, 0);
            end;
        }
        field(12; "Currency Factor"; Decimal)
        {
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE(Amount);
            end;
        }
        field(13; "Exchange Rate"; Decimal)
        {
            DecimalPlaces = 2 : 9;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                PaymentVoucher.GET("Document No.");
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    IF "Exchange Rate" <> 0 THEN
                        "Currency Factor" := 100 / "Exchange Rate";
                    "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        PaymentVoucher.Date, "Currency Code",
                        Amount, "Currency Factor"));
                END;
            end;
        }
        field(15; "Account No."; Code[10])
        {
            TableRelation = if ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true)) else
            if ("Account Type" = CONST(Staff)) Customer where(Type = const(Staff)) else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset" where(Blocked = const(false)) else
            if ("Account Type" = const(Vendor)) Vendor else
            if ("Account Type" = const("Bank Account")) "Bank Account" where("Currency Code" = field("Currency Code"));

            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CASE "Account Type" OF
                    "Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Account No.");
                            "Account Name" := GLAcc.Name;
                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            Vend.GET("Account No.");
                            "Account Name" := Vend.Name;
                        END;
                    "Account Type"::Staff:
                        BEGIN
                            Cust.GET("Account No.");
                            "Account Name" := Cust.Name;
                        END;
                    "Account Type"::"Bank Account":
                        BEGIN
                            BankAccount.GET("Account No.");
                            "Account Name" := BankAccount.Name;
                            //Validate("Currency Code", BankAccount."Currency Code")
                        END;
                    "Account Type"::"Fixed Asset":
                        begin
                            FA.Get("Account No.");
                            "Account Name" := FA.Description;
                            FA.TestField(Blocked, false);
                            FA.TestField(Inactive, false);
                            FA.TestField("Budgeted Asset", false);
                            UpdateDescription(FA.Description);
                            GetFADeprBook("Account No.");
                            GetFAVATSetup();
                            //GetFAAddCurrExchRate();
                        end;

                END;
                PaymentVoucher.Get("Document No.");
                "Dimension Set ID" := PaymentVoucher."Dimension Set ID";
                "Shortcut Dimension 1 Code" := PaymentVoucher."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := PaymentVoucher."Shortcut Dimension 2 Code";
                "Currency Code" := PaymentVoucher."Currency Code";
                "Currency Factor" := PaymentVoucher."Currency Factor";
            end;
        }
        field(16; "Account Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; "Account Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "G/L Account",Staff,Vendor,"Bank Account","Fixed Asset";
            InitValue = Vendor;
            Editable = false;
        }
        field(18; "VAT %"; Integer)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(19; "VAT Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }


        field(32; "Shortcut Dimension 4 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4), "Dimension Value Type" = CONST(Standard), Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(33; "System-Generated"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        // field(34; "Bal. Account Type"; Option)
        // {
        //     OptionMembers = "G/L Account","Bank";
        //     DataClassification = ToBeClassified;
        // }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                Rec.ShowDimensions();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(50008; "Applies-to Invoice No."; Code[20])
        {

            trigger OnLookup()
            var
                VendLedgerEntryList: Page "Vendor Ledger Entries";
            begin
                CalledFromLkup := true;
                TestField("Account Type", "Account Type"::Vendor);
                VendLedgerEntry.SetCurrentkey("Vendor No.", Open, Positive, "Due Date");
                VendLedgerEntry.Ascending(true);

                VendLedgerEntry.SetRange("Document Type", VendLedgerEntry."document type"::Invoice);
                VendLedgerEntry.SetRange(Open, true);
                VendLedgerEntry.SetRange("Document Type", "Applies-to Doc. Type");
                if Rec."Account No." <> '' then
                    VendLedgerEntry.SetRange("Vendor No.", "Account No.");

                VendLedgerEntry.SetRange(Open, true);
                VendLedgerEntryList.SetTableview(VendLedgerEntry);
                VendLedgerEntryList.LookupMode := true;
                if VendLedgerEntryList.RunModal = Action::LookupOK then begin
                    VendLedgerEntryList.GetRecord(VendLedgerEntry);
                    VendLedgerEntry.SetRange("Document No.", "Applies-to Invoice No.");
                    VendLedgerEntryList.SetSelectionFilter(VendLedgerEntry);
                    Validate("Account No.", VendLedgerEntry."Vendor No.");
                    "Payment Details" := StrSubstNo(Text501, VendLedgerEntry."Document No.");
                    "Applies-to Invoice No." := VendLedgerEntry."Document No.";
                    Validate(Amount, -1 * VendLedgerEntry.Amount);
                    VendLedgerEntry.CalcFields(Amount);
                    Validate(Amount, -1 * VendLedgerEntry.Amount);
                    //Modify();
                    //InsertVoucherLine();
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
                                "Payment Details" := StrSubstNo(Text501, VendLedgerEntry."Document No.");
                            "Applies-to Invoice No." := VendLedgerEntry."Document No.";
                            Validate(Amount, -1 * VendLedgerEntry.Amount);
                            VendLedgerEntry.CalcFields(Amount);
                            Validate(Amount, -1 * VendLedgerEntry.Amount);
                        end;
                        //InsertVoucherLine();
                    end;

                end;
            end;
        }

        field(50050; "Applies-to Doc. Type"; Enum "Pmt Voucher Document Type")
        {

        }
        field(50051; "FA Posting Date"; Date)
        {
            AccessByPermission = TableData "Fixed Asset" = R;
            Caption = 'FA Posting Date';
        }
        field(50052; "FA Posting Type"; Enum "Gen. Journal Line FA Posting Type")
        {
            AccessByPermission = TableData "Fixed Asset" = R;
            Caption = 'FA Posting Type';

            trigger OnValidate()
            begin
                IF "FA Posting Type" <> "FA Posting Type"::Maintenance THEN
                    TESTFIELD("Maintenance Code", '');

                //GetFAPostingGroup;
                GetFAVATSetup();
                //GetFAAddCurrExchRate();
            end;
        }
        field(50053; "Depreciation Book Code"; Code[10])
        {
            Caption = 'Depreciation Book Code';
            TableRelation = "Depreciation Book";

            trigger OnValidate()
            var
                FADeprBook: Record "FA Depreciation Book";
            begin
                if "Depreciation Book Code" = '' then
                    exit;

                if ("Account No." <> '') and
                   ("Account Type" = "Account Type"::"Fixed Asset")
                then begin
                    FADeprBook.Get("Account No.", "Depreciation Book Code");
                    //"Posting Group" := FADeprBook."FA Posting Group";
                end;

                if ("Account No." <> '') and
                   ("Account Type" = "Account Type"::"Fixed Asset")
                then begin
                    FADeprBook.Get("Account No.", "Depreciation Book Code");
                    //"Posting Group" := FADeprBook."FA Posting Group";
                end;
                GetFAVATSetup();
                //GetFAAddCurrExchRate();
            end;
        }
        field(50054; "Maintenance Code"; Code[10])
        {
            Caption = 'Maintenance Code';
            TableRelation = Maintenance;

            trigger OnValidate()
            begin
                if "Maintenance Code" <> '' then
                    TestField("FA Posting Type", "FA Posting Type"::Maintenance);
            end;
        }
        field(50055; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            var
                CheckIfFieldIsEmpty: Boolean;
            begin
                CheckIfFieldIsEmpty := "Account Type" in ["Account Type"::Staff, "Account Type"::Vendor, "Account Type"::"Bank Account"];
                //OnBeforeValidateGenBusPostingGroup(Rec, CheckIfFieldIsEmpty);
                if CheckIfFieldIsEmpty then
                    TestField("Gen. Bus. Posting Group", '');
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then
                        Validate("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(50056; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            var
                CheckIfFieldIsEmpty: Boolean;
            begin
                CheckIfFieldIsEmpty := "Account Type" in ["Account Type"::Staff, "Account Type"::Vendor, "Account Type"::"Bank Account"];
                //OnBeforeValidateGenProdPostingGroup(Rec, CheckIfFieldIsEmpty);
                if CheckIfFieldIsEmpty then
                    TestField("Gen. Prod. Posting Group", '');
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(50057; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                if "Account Type" in ["Account Type"::Staff, "Account Type"::Vendor, "Account Type"::"Bank Account"] then
                    TestField("VAT Bus. Posting Group", '');

                Validate("VAT Prod. Posting Group");

            end;
        }
        field(50058; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                if IsHandled then
                    exit;

                "VAT %" := 0;
                IsHandled := false;
                if not IsHandled then
                    if "Gen. Posting Type" <> "Gen. Posting Type"::" " then begin
                        GetVATPostingSetup("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                    end;
                Validate("VAT %");

            end;
        }
        field(50059; "Gen. Posting Type"; Enum "General Posting Type")
        {
            Caption = 'Gen. Posting Type';

            trigger OnValidate()
            var
                CheckIfFieldIsEmpty: Boolean;
            begin
                CheckIfFieldIsEmpty := "Account Type" in ["Account Type"::Staff, "Account Type"::Vendor, "Account Type"::"Bank Account"];
                //OnBeforeValidateGenPostingType(Rec, CheckIfFieldIsEmpty);
                if CheckIfFieldIsEmpty then
                    TestField("Gen. Posting Type", "Gen. Posting Type"::" ");
                if "Gen. Posting Type" <> "Gen. Posting Type"::" " then
                    Validate("VAT Prod. Posting Group");

            end;
        }
        field(50060; "Preferred Bank Account Code"; Code[20])
        {
            Caption = 'Preferred Bank Account Code';
            TableRelation = "Vendor Bank Account".Code where("Vendor No." = field("Account No."));
        }
        field(50066; "Schedule Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Payment Schedule".Amount);
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    Local Procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        IF "Document No." <> '' THEN
            MODIFY;
    end;

    protected procedure UpdateDescription(Name: Text[100])
    begin
        Rec."Payment Details" := Name;
    end;

    local procedure GetFADeprBook(FANo: Code[20])
    var
        FASetup: Record "FA Setup";
        FADeprBook: Record "FA Depreciation Book";
        DefaultFADeprBook: Record "FA Depreciation Book";
        SetFADeprBook: Record "FA Depreciation Book";
    begin
        if "Depreciation Book Code" = '' then begin
            FASetup.Get();

            DefaultFADeprBook.SetRange("FA No.", FANo);
            DefaultFADeprBook.SetRange("Default FA Depreciation Book", true);

            SetFADeprBook.SetRange("FA No.", FANo);

            case true of
                DefaultFADeprBook.FindFirst():
                    "Depreciation Book Code" := DefaultFADeprBook."Depreciation Book Code";
                FADeprBook.Get(FANo, FASetup."Default Depr. Book"):
                    "Depreciation Book Code" := FASetup."Default Depr. Book";
                SetFADeprBook.Count = 1:
                    begin
                        SetFADeprBook.FindFirst();
                        "Depreciation Book Code" := SetFADeprBook."Depreciation Book Code";
                    end
                else
                    "Depreciation Book Code" := '';
            end;
        end;

        if "Depreciation Book Code" <> '' then begin
            FADeprBook.Get(FANo, "Depreciation Book Code");
            //"Posting Group" := FADeprBook."FA Posting Group";
        end;

        //OnAfterGetFADeprBook(Rec, FANo);
    end;

    procedure GetFAVATSetup()
    var
        LocalGLAcc: Record "G/L Account";
        FAPostingGr: Record "FA Posting Group";
        FABalAcc: Boolean;
    begin
        if CurrFieldNo = 0 then
            exit;
        if ("Account Type" <> "Account Type"::"Fixed Asset")
        then
            exit;
        FABalAcc := ("Account Type" = "Account Type"::"Fixed Asset");
        if not FABalAcc then begin
            //ClearPostingGroups();
            //"Tax Group Code" := '';
            Validate("VAT Prod. Posting Group");
        end;
        if FABalAcc then begin
            // ClearBalancePostingGroups();
            // "Bal. Tax Group Code" := '';
            // Validate("Bal. VAT Prod. Posting Group");
        end;
        // if CopyVATSetupToJnlLines() then
        //     if (("FA Posting Type" = "FA Posting Type"::"Acquisition Cost") or
        //         ("FA Posting Type" = "FA Posting Type"::Disposal) or
        //         ("FA Posting Type" = "FA Posting Type"::Maintenance)) and
        //        ("Posting Group" <> '')
        //     then
        //         if FAPostingGr.GetPostingGroup("Posting Group", "Depreciation Book Code") then begin
        //             case "FA Posting Type" of
        //                 "FA Posting Type"::"Acquisition Cost":
        //                     LocalGLAcc.Get(FAPostingGr.GetAcquisitionCostAccount());
        //                 "FA Posting Type"::Disposal:
        //                     LocalGLAcc.Get(FAPostingGr.GetAcquisitionCostAccountOnDisposal());
        //                 "FA Posting Type"::Maintenance:
        //                     LocalGLAcc.Get(FAPostingGr.GetMaintenanceExpenseAccount());
        //             end;
        //             OnGetFAVATSetupOnBeforeCheckGLAcc(Rec, LocalGLAcc);
        //             LocalGLAcc.CheckGLAcc();
        //             if not FABalAcc then begin
        //                 "Gen. Posting Type" := LocalGLAcc."Gen. Posting Type";
        //                 "Gen. Bus. Posting Group" := LocalGLAcc."Gen. Bus. Posting Group";
        //                 "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
        //                 "VAT Bus. Posting Group" := LocalGLAcc."VAT Bus. Posting Group";
        //                 "VAT Prod. Posting Group" := LocalGLAcc."VAT Prod. Posting Group";
        //                 "Tax Group Code" := LocalGLAcc."Tax Group Code";
        //                 Validate("VAT Prod. Posting Group");
        //             end else begin
        //                 ;
        //                 "Bal. Gen. Posting Type" := LocalGLAcc."Gen. Posting Type";
        //                 "Bal. Gen. Bus. Posting Group" := LocalGLAcc."Gen. Bus. Posting Group";
        //                 "Bal. Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
        //                 "Bal. VAT Bus. Posting Group" := LocalGLAcc."VAT Bus. Posting Group";
        //                 "Bal. VAT Prod. Posting Group" := LocalGLAcc."VAT Prod. Posting Group";
        //                 "Bal. Tax Group Code" := LocalGLAcc."Tax Group Code";
        //                 Validate("Bal. VAT Prod. Posting Group");
        //             end;
        //         end;
    end;

    local procedure GetVATPostingSetup(VATBusPostingGroup: Code[20]; VATProdPostingGroup: Code[20])
    begin
        if not VATPostingSetup.Get(VATBusPostingGroup, VATProdPostingGroup) then
            VATPostingSetup.Init();
    end;

    procedure ShowDimensions() IsChanged: Boolean
    var
        OldDimSetID: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        IsChanged := OldDimSetID <> "Dimension Set ID";

    end;

    procedure JobTaskIsSet() Result: Boolean
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit(Result);

    end;

    var
        GLAcc: Record "G/L Account";
        GLBudgetEntry: Record "G/L Budget Entry";
        //PaymentRequisition: Record "Payment Requisition";
        PaymentVoucher: Record "Payment Voucher Header";
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record Customer;
        Vend: Record "Vendor";
        PurchInvHeader: Record "Purch. Inv. Header";
        DimMgt: CodeUnit "DimensionManagement";
        // TradeActivationLine: Record "prEmployee Banks"; //table missing
        BankAccount: Record "Bank Account";
        Text001: TextConst ENU = 'The budget has been exceed!';
        Text002: TextConst ENU = 'cannot be specified without %1';
        VendLedgerEntry: Record "Vendor Ledger Entry";
        CalledFromLkup: Boolean;
        Text501: Label 'Invoice %1';
        FA: Record "Fixed Asset";
        VATPostingSetup: Record "VAT Posting Setup";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenProdPostingGrp: Record "Gen. Product Posting Group";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        IF "System-Generated" THEN
            ERROR('You can only modify a system-generated payment requisition entry.');

    end;

    trigger OnRename()
    begin

    end;
}