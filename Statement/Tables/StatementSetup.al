table 50113 "Statement Setup"
{
    Caption = 'Statement Setup';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "PK"; Code[20])
        {
            Caption = 'PK';
        }
        field(2; "Base URL"; Text[300])
        {
            Caption = 'Base URL';
        }
    }
    keys
    {
        key(PK; "PK")
        {
            Clustered = true;
        }
    }
}
