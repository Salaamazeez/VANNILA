table 50149 SalesByDrainagePoint
{
    Caption = 'SalesByDrainagePoint';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Well Code"; Code[50])
        {
            Caption = 'Well Code';
        }
        field(2; "Well Type"; Code[50])
        {
            Caption = 'Well Type';
        }
        field(3; "Period Code"; Code[10])
        {
            Caption = 'Period Code';
        }
        field(4; "Production Code"; Code[50])
        {
            Caption = 'Production Code';
        }
        field(5; "Production Sub Unit Code"; Code[50])
        {
            Caption = 'Production Sub Unit Code';
        }
        field(6; "Area Code"; Code[50])
        {
            Caption = 'Area Code';
        }
        field(7; "Field Code"; Code[50])
        {
            Caption = 'Field Code';
        }
        field(8; "Facility Code"; Code[50])
        {
            Caption = 'Facility Code';
        }
        field(9; "Allocated Production Net Oil"; Decimal)
        {
            Caption = 'Allocated Production Net Oil';
        }
        field(10; "Allocated Water Volume"; Decimal)
        {
            Caption = 'Allocated Water Volume';
        }
        field(11; "Allocated Gas Volume"; Decimal)
        {
            Caption = 'Allocated Gas Volume';
        }
        field(12; "Sales Gas"; Decimal)
        {
            Caption = 'Sales Gas';
        }
        field(13; Fuel; Decimal)
        {
            Caption = 'Fuel';
        }
        field(14; Flared; Decimal)
        {
            Caption = 'Flared';
        }
        field(15; "Created By"; Code[150])
        {
            Caption = 'Created By';
        }
        field(16; "Created Date"; Date)
        {
            Caption = 'Created Date';
        }
        field(17; "Stream Code"; Code[50])
        {
            Caption = 'Stream Code';
        }
        field(18; "Stream Name"; Text[100])
        {
            Caption = 'Stream Name';
        }
        field(19; OML; Code[50])
        {
            Caption = 'OML';
        }
        field(20; "Last Modified By"; Code[150])
        {
            Caption = 'Last Modified By';
        }
        field(21; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
        }
    }
    keys
    {
        key(PK; "Well Code", "Well Type", "Period Code")
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
