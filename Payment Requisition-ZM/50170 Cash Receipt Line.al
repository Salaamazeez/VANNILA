table 50170 "Cash Receipt Line"
{

    //Created by Salaam Azeez
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[10])
        {
            DataClassification = CustomerContent;

        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;

        }
        field(5; "Transaction Details"; Text[150])
        {
            DataClassification = CustomerContent;

        }
        field(8; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            BlankZero = true;

            trigger OnValidate()
            begin
                Retirement.GET("Document No.");
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    VALIDATE("Amount (LCY)", (
                    ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                     Retirement.Date, "Currency Code", Amount, "Currency Factor"))));
                END;
            end;
        }
        field(10; "Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; "Currency Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Currency."Code";

            trigger OnValidate()
            begin
                Retirement.GET("Document No.");
                IF "Currency Code" <> '' THEN BEGIN
                    IF ("Currency Code" <> xRec."Currency Code") OR
                       (CurrFieldNo = FIELDNO("Currency Code")) OR
                       ("Currency Factor" = 0)
                    THEN
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate(Retirement.Date, "Currency Code");
                END ELSE
                    "Currency Factor" := 0;

                VALIDATE(Amount, 0);
            end;
        }
        field(12; "Currency Factor"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                    FIELDERROR("Currency Factor", STRSUBSTNO(Text002, FIELDCAPTION("Currency Code")));
                VALIDATE(Amount);
            end;
        }
        field(13; "Exchange Rate"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 9;

            trigger OnValidate()
            begin
                Retirement.GET("Document No.");
                IF "Currency Code" = '' THEN
                    "Amount (LCY)" := Amount
                ELSE BEGIN
                    IF "Exchange Rate" <> 0 THEN
                        "Currency Factor" := 100 / "Exchange Rate";
                    "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        Retirement.Date, "Currency Code",
                        Amount, "Currency Factor"));
                END;
            end;
        }
        field(15; "Account No."; Code[10])
        {
            // TableRelation = Customer;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting), Blocked = CONST(false), "Direct Posting" = CONST(true)) ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor else
            if ("Account Type" = const(Staff)) Customer where(Type = const(Staff));
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
                END;
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
            OptionMembers = "G/L Account","Vendor",Staff;
        }
        field(18; "Total Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(19; "Total Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Shortcut Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(21; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
    }

    keys
    {
        key(PKey; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        GLAcc: Record "G/L Account";
        GLBudgetEntry: Record "G/L Budget Entry";
        Retirement: Record Retirement;
        CurrExchRate: Record "Currency Exchange Rate";
        Vend: Record Vendor;
        // DimMgt: Codeunit DimensionManagement;
        Cust: Record Customer;
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

    end;

    trigger OnRename()
    begin

    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        // OldDimSetID := "Dimension Set ID";
        // DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        // IF ("Document No." <> '') AND ("Line No." <> 0) THEN
        //     MODIFY;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        // OldDimSetID := "Dimension Set ID";
        // "Dimension Set ID" :=
        //   DimMgt.EditDimensionSet(
        //     "Dimension Set ID", STRSUBSTNO('%1', "Document No."),
        //     "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        // IF OldDimSetID <> "Dimension Set ID" THEN
        //     MODIFY;
    end;

    procedure CalculateTotals()
    var
        RetirementLine: Record "Retirement Line";
    begin
        RetirementLine.SETRANGE("Document No.", "Document No.");
        RetirementLine.CALCSUMS(Amount, "Amount (LCY)");
        "Total Amount" := RetirementLine.Amount;
        "Total Amount (LCY)" := RetirementLine."Amount (LCY)";
    end;

}