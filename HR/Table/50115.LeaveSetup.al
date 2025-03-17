table 50115 LeaveSetup
{
    Caption = 'Leave Setup';
    DataClassification = ToBeClassified;
    LookupPageId = 50122;

    fields
    {
        field(1; "Leave Setup Code"; Code[20])
        {
            Caption = 'Leave Setup Code';
            //TableRelation = EmployeeBandHeader."Employee Zone";

        }
        field(2; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = " ",Permanent,Contract;
        }
        field(3; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(4; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(5; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(6; "Created Time"; Time)
        {
            Caption = 'Created Time';
            Editable = false;
        }
        field(7; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
            Editable = false;
        }
        field(8; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
            Editable = false;
        }
        field(9; "Last Modified Time"; Time)
        {
            Caption = 'Last Modified Time';
            Editable = false;
        }
        field(10; Description; Text[150])
        {
            Caption = 'Description';
        }
        field(11; "Employee Level"; Code[50])
        {
            Caption = 'Employee Level';
            Editable = false;
        }
        field(12; "Employee Cadre"; Code[50])
        {
            Caption = 'Employee Cadre';
            Editable = false;

        }
        field(13; "Employee Category"; option)
        {
            OptionMembers = ,Junior,Senior,Managers,Management;
        }
    }

    keys
    {
        key(PK; "Leave Setup Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created Date" := Today;
        "Created Time" := Time;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := Today;
        "Last Modified Time" := Time;
    end;

    var
}
