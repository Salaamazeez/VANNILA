table 50900 "SWIFT/BIC Directory"
{
    Caption = 'SWIFT/BIC Directory';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'SWIFT/BIC Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }

        field(2; "Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
        }

        field(3; "Country Code"; Code[2])
        {
            Caption = 'Country Code (ISO)';
        }

        field(4; "City"; Text[50])
        {
            Caption = 'City';
        }

        field(5; "Branch Code"; Code[3])
        {
            Caption = 'Branch Code (Last 3 of BIC)';
        }

        field(6; "Full SWIFT/BIC"; Code[11])
        {
            Caption = 'Full SWIFT/BIC Code';
        }

        field(7; "Bank Address"; Text[250])
        {
            Caption = 'Bank Address';
        }

        field(8; "Is Active"; Boolean)
        {
            Caption = 'Active';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
