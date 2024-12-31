table 60020 "Cash Advance Line"
{
    //Created by Salaam Azeez
    LookupPageId = "Cash Advance List";
    DrillDownPageId = "Cash Advance List";
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
        field(38; "Expense Code"; Code[50])
        {
            TableRelation = "Expense Code";

            trigger OnValidate()
            var
                ExpenseCode: Record "Expense Code";
            begin
                if ExpenseCode.GET("Expense Code") then;
                if ExpenseCode."Account Type" = ExpenseCode."Account Type"::"Bank Account" then begin
                    "Account Type" := "Account Type"::"Bank Account";
                    //Validate("Account No.", ExpenseCode."Account No.");
                end;
                if ExpenseCode."Account Type" = ExpenseCode."Account Type"::"G/L Account" then begin
                    "Account Type" := "Account Type"::"G/L Account";
                    //Validate("Account No.", ExpenseCode."Account No.");
                end;
                if ExpenseCode."Account Type" = ExpenseCode."Account Type"::Customer then begin
                    "Account Type" := "Account Type"::Customer;
                    //Validate("Account No.", ExpenseCode."Account No.");
                end;
                GetHeaderData()
            end;
        }
        field(3; "Payment Details"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(8; Amount; Decimal)
        {
            //BlankZero = true;
            //Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CashAdvance.GET("Document No.");

                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    VALIDATE("Amount (LCY)", (
                    ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                     CashAdvance.Date, "Currency Code", Amount, "Currency Factor"))));
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
                CashAdvance.GET("Document No.");
                IF "Currency Code" <> '' THEN BEGIN
                    IF ("Currency Code" <> xRec."Currency Code") OR
                       (CurrFieldNo = FIELDNO("Currency Code")) OR
                       ("Currency Factor" = 0)
                    THEN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate(CashAdvance.Date, "Currency Code");
                END ELSE
                    "Currency Factor" := 0;

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
                CashAdvance.GET("Document No.");
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    IF "Exchange Rate" <> 0 THEN
                        "Currency Factor" := 100 / "Exchange Rate";
                    "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        CashAdvance.Date, "Currency Code",
                        Amount, "Currency Factor"));
                END;
            end;
        }
        field(15; "Account No."; Code[10])
        {
            // TableRelation = Customer;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true)) ELSE
            IF ("Account Type" = CONST(Staff)) Vendor else
            if ("Account Type" = const(Customer)) Customer where(Type = const(Staff)) else
            if ("Account Type" = const("Bank Account")) "Bank Account" where("Currency Code" = field("Currency Code"));
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CashAdvance.GET("Document No.");
                "Currency Code" := CashAdvance."Currency Code";
                CASE "Account Type" OF
                    "Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Account No.");
                            "Account Name" := GLAcc.Name;
                        END;
                    "Account Type"::Staff:
                        BEGIN
                            Vend.GET("Account No.");
                            "Account Name" := Vend.Name;
                        END;
                    "Account Type"::Customer:
                        BEGIN
                            Cust.GET("Account No.");
                            "Account Name" := Cust.Name;
                        END;
                    "Account Type"::"Bank Account":
                        BEGIN
                            BankAccount.GET("Account No.");
                            "Account Name" := BankAccount.Name;
                        END;


                END;
                GetHeaderData();
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
            OptionMembers = "G/L Account",Staff,Customer,"Bank Account";
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

        field(25; "Net Amount to Pay"; Decimal)
        {
            BlankZero = true;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(26; "Base Amount"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;

        }
        field(28; "Bal. Account Name"; Text[50])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(33; "System-Generated"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(34; "Bal. Account Type"; Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account",Employee;

            DataClassification = ToBeClassified;
        }
        field(27; "Bal. Account No."; Code[10])
        {
            TableRelation = IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"."No." ELSE
            IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"."No." WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true));
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CASE "Bal. Account Type" OF
                    "Bal. Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Bal. Account No.");
                            "Bal. Account Name" := GLAcc.Name;
                            Validate("Shortcut Dimension 1 Code", GLAcc."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", GLAcc."Global Dimension 2 Code");
                        END;
                    "Bal. Account Type"::"Bank Account":
                        BEGIN
                            BankAccount.GET("Bal. Account No.");
                            "Bal. Account Name" := BankAccount.Name;
                            Validate("Shortcut Dimension 1 Code", BankAccount."Global Dimension 1 Code");
                            Validate("Shortcut Dimension 2 Code", BankAccount."Global Dimension 2 Code");

                        END;
                END;
            end;
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
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
        field(41; "Shortcut Dimension 2 Code"; Code[20])
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
                Rec.ShowDimensions();
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }


    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    // Procedure ShowDocDim()
    // var
    //     OldDimSetID: Integer;
    // begin
    //     OldDimSetID := "Dimension Set ID";
    //     "Dimension Set ID" :=
    //     DimMgt.EditDimensionSet2(
    //         "Dimension Set ID", STRSUBSTNO('%1', "Document No."),
    //         "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    //     IF OldDimSetID <> "Dimension Set ID" THEN
    //         MODIFY;
    // end;
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        IsHandled: Boolean;
    begin

        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    // procedure ShowDimensions() IsChanged: Boolean
    // var
    //     OldDimSetID: Integer;
    //     IsHandled: Boolean;
    // begin
    //     OldDimSetID := "Dimension Set ID";
    //     "Dimension Set ID" :=
    //       DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', "Document No.", "Line No."));
    //     DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    //     IsChanged := OldDimSetID <> "Dimension Set ID";

    // end;
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

    procedure GetHeaderData()
    begin
        CashAdvance.Get("Document No.");
        "Dimension Set ID" := CashAdvance."Dimension Set ID";
        "Shortcut Dimension 1 Code" := CashAdvance."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := CashAdvance."Shortcut Dimension 2 Code";
        "Currency Code" := CashAdvance."Currency Code";
        "Currency Factor" := CashAdvance."Currency Factor";
    end;

    var
        GLAcc: Record "G/L Account";
        GLBudgetEntry: Record "G/L Budget Entry";
        CashAdvance: Record "Cash Advance";
        CurrExchRate: Record "Currency Exchange Rate";
        Vend: Record Vendor;
        Cust: Record Customer;
        PurchInvHeader: Record "Purch. Inv. Header";
        DimMgt: CodeUnit "DimensionManagement";
        // TradeActivationLine: Record "prEmployee Banks"; //table missing
        BankAccount: Record "Bank Account";
        Text002: TextConst ENU = 'cannot be specified without %1';

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