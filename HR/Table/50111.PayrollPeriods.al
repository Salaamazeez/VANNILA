table 50111 PayrollPeriods
{
    Caption = 'Payroll Periods';
    DataClassification = ToBeClassified;
    LookupPageId = 50112;

    fields
    {
        field(1; "Period Code"; Code[10])
        {
            Caption = 'Period Code';
        }
        field(2; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(3; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(4; "Period Name"; Text[30])
        {
            Caption = 'Period Name';
        }
        field(5; Closed; Boolean)
        {
            Caption = 'Closed';
        }
        field(6; "Search Name"; Code[20])
        {
            Caption = 'Search name';
        }
        field(7; "New Year"; Boolean)
        {
            Caption = 'New Year';
        }
        field(8; "Current Period"; Boolean)
        {
            Caption = 'Current Period';
        }
        field(9; "Date Locked"; Boolean)
        {
            Caption = 'Date Locked';
        }
        field(10; "Period Year"; Integer)
        {
            Caption = 'Period Year';
        }
    }
    keys
    {
        key(PK; "Period Code")
        {
            Clustered = true;
        }
        key(SK1; "Start Date")
        {

        }
        key(SK2; "Current Period")
        {

        }
        key(SK3; Closed)
        {

        }
    }
}
