table 50102 "Payment Category Code"
{
    LookupPageId ="Payment Category Codes";
    DrillDownPageId ="Payment Category Codes";
    DataClassification = ToBeClassified;
    Caption = 'Payment Category Code';

    fields
    {
        field(1; "Category Code"; Code[20])
        {
            Caption = 'Category Code';
            NotBlank = true;
        }

        field(2; "Category Description"; Text[50])
        {
            Caption = 'Category Description';
        }

        field(3; "4 Character Code"; Code[4])
        {
            Caption = '4 Character Code';
        }

        field(4; "3 Character Code"; Code[3])
        {
            Caption = '3 Character Code';
        }
    }

    keys
    {
        key(PK; "Category Code")
        {
            Clustered = true;
        }
    }
}
