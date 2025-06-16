table 60001 "Payment Requisition Line"
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
        field(8; Amount; Decimal)
        {
            BlankZero = true;
            // Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                PaymentRequisition.GET("Document No.");
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    VALIDATE("Amount (LCY)", (
                    ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                     PaymentRequisition.Date, "Currency Code", Amount, "Currency Factor"))));
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
                PaymentRequisition.GET("Document No.");
                //"Currency Code" := PaymentRequisition."Currency Code";
                IF "Currency Code" <> '' THEN BEGIN
                    IF ("Currency Code" <> xRec."Currency Code") OR
                       (CurrFieldNo = FIELDNO("Currency Code")) OR
                       ("Currency Factor" = 0)
                    THEN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate(PaymentRequisition.Date, "Currency Code");
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
                PaymentRequisition.GET("Document No.");
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    IF "Exchange Rate" <> 0 THEN
                        "Currency Factor" := 100 / "Exchange Rate";
                    "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        PaymentRequisition.Date, "Currency Code",
                        Amount, "Currency Factor"));
                END;
            end;
        }
        field(38; "Expense Code"; Code[50])
        {
            Caption = 'Request Code';
            TableRelation = "Expense Code";

            trigger OnValidate()
            var
                ExpenseCode: Record "Expense Code";
            begin
                ExpenseCode.GET("Expense Code");
                if ExpenseCode."Account Type" = ExpenseCode."Account Type"::"Bank Account" then begin
                    "Account Type" := "Account Type"::"Bank Account";
                    Validate("Account No.", ExpenseCode."Account No.");
                end;
                if ExpenseCode."Account Type" = ExpenseCode."Account Type"::"G/L Account" then begin
                    "Account Type" := "Account Type"::"G/L Account";
                    Validate("Account No.", ExpenseCode."Account No.");
                end;
                if ExpenseCode."Account Type" = ExpenseCode."Account Type"::Customer then begin
                    "Account Type" := "Account Type"::Staff;
                    Validate("Account No.", ExpenseCode."Account No.");
                end;
                if ExpenseCode."Account Type" = ExpenseCode."Account Type"::"Fixed Asset" then begin
                    "Account Type" := "Account Type"::"Fixed Asset";
                    Validate("Account No.", ExpenseCode."Account No.");
                end;
            end;
        }
        field(15; "Account No."; Code[10])
        {
            // TableRelation = Customer;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true)) ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor else
            if ("Account Type" = const(Staff)) Customer else
            if ("Account Type" = const("Bank Account")) "Bank Account";
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

                        END;
                END;
                PaymentRequisition.Get("Document No.");
                "Dimension Set ID" := PaymentRequisition."Dimension Set ID";
                "Shortcut Dimension 1 Code" := PaymentRequisition."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := PaymentRequisition."Shortcut Dimension 2 Code";
                "Payment Details" := PaymentRequisition."Request Description";
                Validate("Currency Code", PaymentRequisition."Currency Code");

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
        }
        field(26; "Base Amount"; Decimal)
        {
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(27; "Bal. Account No."; Code[10])
        {
            Editable = false;
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
                        END;
                    "Bal. Account Type"::"Bank Account":
                        BEGIN
                            BankAccount.GET("Bal. Account No.");
                            "Bal. Account Name" := BankAccount.Name;
                        END;
                    "Bal. Account Type"::Customer:
                        BEGIN
                            Cust.GET("Bal. Account No.");
                            "Bal. Account Name" := Cust.Name;
                        END;
                    "Bal. Account Type"::Vendor:
                        BEGIN
                            Vend.GET("Bal. Account No.");
                            "Bal. Account Name" := Vend.Name;
                        END;
                END;
                PaymentRequisition.Get("Document No.");
                "Dimension Set ID" := PaymentRequisition."Dimension Set ID";
                "Shortcut Dimension 1 Code" := PaymentRequisition."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := PaymentRequisition."Shortcut Dimension 2 Code";
                "Payment Details" := PaymentRequisition."Request Description"

            end;
        }
        field(28; "Bal. Account Name"; Text[50])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;

            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(6; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
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

        field(34; "Bal. Account Type"; Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
            DataClassification = ToBeClassified;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            DataClassification = CustomerContent;
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

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        IsHandled: Boolean;
    begin

        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    var
        ExpenseCode: Record "Expense Code";
        GLAcc: Record "G/L Account";
        GLBudgetEntry: Record "G/L Budget Entry";
        PaymentRequisition: Record "Payment Requisition";
        CurrExchRate: Record "Currency Exchange Rate";
        Vend: Record "Vendor";
        Cust: Record Customer;
        PurchInvHeader: Record "Purch. Inv. Header";
        DimMgt: CodeUnit "DimensionManagement";
        // TradeActivationLine: Record "prEmployee Banks"; //table missing
        BankAccount: Record "Bank Account";
        Text001: TextConst ENU = 'The budget has been exceed!';
        Text002: TextConst ENU = 'cannot be specified without %1';

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        //IF "System-Generated" THEN
        ERROR('You can only modify a system-generated payment requisition entry.');

    end;

    trigger OnRename()
    begin

    end;
}