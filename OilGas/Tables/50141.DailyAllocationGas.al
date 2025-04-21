table 50141 DailyAllocationGas
{
    Caption = 'Daily Allocation Gas (Mscf)';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Well; Code[50])
        {
            Caption = 'Well Code';
        }
        field(2; "Well Type"; Code[50])
        {
            Caption = 'Well Type';
        }
        field(3; "Production Date"; Date)
        {
            Caption = 'Production Date';
        }
        field(4; Facility; Code[50])
        {
            Caption = 'Facility Code';
        }
        field(5; "Fields"; Code[50])
        {
            Caption = 'Field Code';
        }
        field(6; OML; Code[50])
        {
            Caption = 'Oil Mining Lease';
        }
        field(7; "Daily Allocated"; Decimal)
        {
            Caption = 'Allocated Gas Volume';
        }
        field(8; "Created By"; code[100])
        {

        }
        field(9; "Created Date"; Date)
        {

        }
        field(10; "Last Modified By"; code[100])
        {

        }
        field(11; "Last Modified Date"; Date)
        {

        }
        field(12; "Production Code"; code[50])
        {

        }
        field(13; "Production Sub Unit Code"; code[50])
        {

        }
        field(14; "Area Code"; code[50])
        {

        }
        field(15; "Stream Code Code"; code[50])
        {

        }
        field(16; "Stream Name"; text[200])
        {

        }
    }
    keys
    {
        key(PK; Well, "Well Type", "Production Date")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var

    begin
        "Created By" := UserId;
        "Created Date" := Today;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := Today;
    end;
}
