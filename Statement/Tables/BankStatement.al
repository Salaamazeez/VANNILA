table 50105 "Bank Statement"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Statement Id"; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Electronic Seq. No."; Integer) { }
        field(3; "Created DateTime"; DateTime) { }
        field(4; "From Date"; Date) { }
        field(5; "To Date"; Date) { }
        field(6; "Account No."; Code[30]) { }
        field(7; "Account Name"; Text[100]) { }
        field(8; "Currency Code"; Code[10]) { }
        field(9; "Total Entries"; Integer) { }
        field(10; "Total Amount"; Decimal) { }
        field(11; "Net Amount"; Decimal) { }
        field(12; "Credit/Debit"; Code[5]) { }
    }

    keys
    {
        key(PK; "Statement Id")
        {
            Clustered = true;
        }
    }
}