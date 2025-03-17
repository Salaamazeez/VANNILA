tableextension 50101 UserSetupExtension extends "User Setup"
{
    fields
    {
        field(50000; "Finance Admin"; Boolean) { }
        field(50001; "G/L Account Admin"; Boolean) { }
        field(50003; "Master Record Admin"; Boolean) { }
        field(50004; "HR Admin"; Boolean) { }
        field(50005; "Procurement Admin"; Boolean) { }
        field(50100; "Appraiser Line Manager"; Boolean)
        {
            Caption = 'Appraiser Line Manager';
            DataClassification = ToBeClassified;
        }
        field(50101; "HR Administrator"; Boolean)
        {
            Caption = 'HR Administrator';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}