Table 52130 "VAT/WHT Posting Group"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "WithHolding Tax %"; Decimal)
        {
        }
        field(4; "Tax Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; "WHT Authority"; Option)
        {
            OptionCaption = ' ,State,Federal';
            OptionMembers = " ",State,Federal;

        }

        field(10; "WHT Calculation Type"; Option)
        {

            Caption = 'WHT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal WHT,Full WHT';
            OptionMembers = "Normal WHT","Full WHT";
        }
        field(11; "Adjustment %"; Decimal) { }
        field(12; Credit; Boolean)
        { }
        field(13; Type; Option)
        {
            OptionMembers = " ",VAT,WHT;
        }
        field(14; "Transaction Type"; Option)
        {
            OptionMembers = " ",Purchase,Sales;
        }
    }

    keys
    {
        key(Key1; "Code","Transaction Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GLSetup: Record "General Ledger Setup";

    local procedure CheckGLAcc(AccNo: Code[20])
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo <> '' then begin
            GLAcc.Get(AccNo);
            GLAcc.CheckGLAcc;
        end;
    end;


    procedure "GetWHTTax%"(): Decimal
    begin
        exit("WithHolding Tax %");
    end;

}

