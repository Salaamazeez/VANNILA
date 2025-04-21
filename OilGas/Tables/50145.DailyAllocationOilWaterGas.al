table 50145 DailyAllocationOilWaterGas
{
    Caption = 'Daily Allocation Oil, Water & Gas';
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
        field(7; "Daily Allocated Oil"; Decimal)
        {
            Caption = 'Tot Net Oil & Condensate';
        }
        field(8; "Daily Allocated Water"; Decimal)
        {
            Caption = 'Allocated Water volume (bbl)';
        }
        field(9; "Daily Allocated Gas"; Decimal)
        {
            Caption = 'Allocated Gas volume (Mscf)';
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
        field(17; "Stream Code Code"; code[50])
        {

        }
        field(18; "Stream Name"; text[200])
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
