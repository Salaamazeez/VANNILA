table 50031 "Sectoral Purpose Code"
{
    LookupPageId = "Sectoral Purpose Codes";
    DrillDownPageId = "Sectoral Purpose Codes";
    Caption = 'Sectoral Purpose Code';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Purpose Code"; Code[20])
        {
            Caption = 'Purpose Code';
            NotBlank = true;

            trigger OnValidate()
            begin
                if StrLen("Purpose Code") < 5 then
                    Error('Purpose Code must be at least 5 characters (Example: HA101).');
            end;
        }

        field(2; Description; Text[150])
        {
            Caption = 'Description';
        }

        field(3; "Trade Category"; Code[30])
        {
            Caption = 'Trade Category';
            Editable = false;
            InitValue = 'INVISIBLE TRADE';
        }

        field(4; "Import/Export"; Enum "Sectoral Trade Type")
        {
            Caption = 'Import/Export';
        }

        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(6;"FCY Transaction";Boolean)
        {
        }
    }

    keys
    {
        key(PK; "Purpose Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Purpose Code", Description)
        {
        }
    }
}
