table 50143 DailySalesGas
{
    Caption = 'Daily Sales Gas';
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
        field(3; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
        }
        field(4; "Stream Code"; Code[50])
        {
            Caption = 'Stream Code';
        }
        field(5; "Stream Name"; Text[250])
        {
            Caption = 'Stream Name';
        }
        field(6; Facility; Code[50])
        {
            Caption = 'Facility Code';
        }
        field(7; "Fields"; Code[50])
        {
            Caption = 'Field Code';
        }
        field(8; OML; Code[50])
        {
            Caption = 'OML';
        }
        field(9; "Sale Gas"; Decimal)
        {
            Caption = 'Sales Gas (Mscf)';
        }
        field(10; "Created By"; code[100])
        {

        }
        field(11; "Created Date"; Date)
        {

        }
        field(12; "Last Modified By"; code[100])
        {

        }
        field(13; "Last Modified Date"; Date)
        {
        }
        field(14; "Production Code"; code[50])
        {

        }
        field(15; "Production Sub Unit Code"; code[50])
        {

        }
        field(16; "Area Code"; code[50])
        {

        }
    }
    keys
    {
        key(PK; Well, "Well Type", "Transaction Date")
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

