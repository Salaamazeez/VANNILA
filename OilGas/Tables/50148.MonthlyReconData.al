table 50148 MonthlyReconData
{
    Caption = 'Monthly Reconciliation Data';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Production Date"; Date)
        {
            Caption = 'Production Date';
        }
        field(2; "Type"; Code[50])
        {
            Caption = 'Type';
        }
        field(3; "Actual/Plan"; Code[50])
        {
            Caption = 'Actual/Plan';
        }
        field(4; "Field/Facility Name"; Code[50])
        {
            Caption = 'Field/Facility Name';
        }
        field(5; "Formation Gas"; Decimal)
        {
            Caption = 'Formation Gas';
        }
        field(6; Fuel; Decimal)
        {
            Caption = 'Fuel';
        }
        field(7; Flare; Decimal)
        {
            Caption = 'Flare';
        }
        field(8; "Sales Gas"; Decimal)
        {
            Caption = 'Sales Gas';
        }
        field(9; "Oil and Condensate"; Decimal)
        {
            Caption = 'Oil and Condensate';
        }
        field(10; "Heating Value (BTU/scf)"; Decimal)
        {
            Caption = 'Heating Value (BTU/scf)';
        }
        field(11; "Energy (MMBTU)"; Decimal)
        {
            Caption = 'Energy (MMBTU)';
        }
        field(12; "Plan Liquid Sales (kb/d)"; Decimal)
        {
            Caption = 'Plan Liquid Sales (kb/d)';
        }
        field(13; "Plan Gas Sales (mmscf/d)"; Decimal)
        {
            Caption = 'Plan Gas Sales (mmscf/d)';
        }
        field(14; "LE Liquids"; Decimal)
        {
            Caption = 'LE Liquids';
        }
        field(15; "LE Gas"; Decimal)
        {
            Caption = 'LE Gas';
        }
        field(16; "Integrated Export Capacity"; Decimal)
        {
            Caption = 'Integrated Export Capacity';
        }
        field(17; "Spiked Condenate"; Decimal)
        {
            Caption = 'Spiked Condenate';
        }
        field(18; "Returned Condensate"; Decimal)
        {
            Caption = 'Returned Condensate';
        }
        field(19; "Sold Condensate/NewCross"; Decimal)
        {
            Caption = 'Sold Condensate/NewCross';
        }
        field(20; "Production Adjustments"; Decimal)
        {
            Caption = 'Production Adjustments';
        }
        field(21; "Lifting volumes"; Decimal)
        {
            Caption = 'Lifting volumes';
        }
        field(22; Misc1; Decimal)
        {
            Caption = 'Misc1';
        }
        field(23; Misc2; Decimal)
        {
            Caption = 'Misc2';
        }
        field(24; "Created By"; Code[100])
        {
            Caption = 'Created By';
        }
        field(25; "Created Date"; Date)
        {
            Caption = 'Created Date';
        }
        field(26; "Last Modified By"; Code[100])
        {
            Caption = 'Last Modified By';
        }
        field(27; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
        }
    }
    keys
    {
        key(PK; "Production Date", "Type", "Actual/Plan", "Field/Facility Name")
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
