table 50100 "Tariff Codes"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {

        }
        field(2; Description; Text[50])
        {

        }
        field(3; Percentage; Decimal)
        {

        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No." ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor."No.";
        }
        field(5; Type; Option)
        {
            OptionMembers = ,"W/Tax",VAT,Excise,Others,Retention;
        }
        field(6; "Account Type"; Option)
        {

            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

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

}