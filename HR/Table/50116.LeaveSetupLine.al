table 50116 LeaveSetupLine
{
    Caption = 'Leave Setup Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee Zone"; Code[20])
        {
            Caption = 'Employee Zone';
            //TableRelation = EmployeeBandHeader."Employee Zone";
        }
        field(2; "Leave Code"; Code[10])
        {
            Caption = 'Leave Code';
            TableRelation = "Cause of Absence";

            trigger OnValidate()
            begin
                IF CauseAbsence.GET("Leave Code") THEN
                    "Leave Description" := CauseAbsence.Description;

                IF "Leave Code" = '' THEN
                    CLEAR("Leave Description");

            end;
        }
        field(3; "Duration"; Integer)
        {
            Caption = 'Duration';
        }
        field(4; Sex; Enum GenderEnum)
        {
            Caption = 'Sex';

        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; "Leave Allowance Allowed"; Boolean)
        {
            Caption = 'Leave Allowance Allowed';
        }
        field(7; "Encashment Allowed"; Boolean)
        {
            Caption = 'Encashment Allowed';
        }
        field(8; "Probabtion Period(Days)"; Integer)
        {
            Caption = 'Probabtion Period(Days)';
        }
        field(9; "Carry Forward Leave Allowed"; Boolean)
        {
            Caption = 'Carry Forward Leave Allowed';
        }
        field(10; "Deduct from Annaul Leave"; Boolean)
        {
            Caption = 'Deduct from Annaul Leave';
        }
        field(11; "Unit of Measure"; Code[10])
        {
            Caption = 'Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(12; "Leave Description"; Text[150])
        {
            Caption = 'Leave Description';
            Editable = false;
        }
        field(13; "Unit of Measure 2"; Code[10])
        {
            Caption = 'Unit of Measure 2';
            TableRelation = "Unit of Measure";
        }
    }
    keys
    {
        key(PK; "Employee Zone", "Leave Code")
        {
            Clustered = true;
        }
    }
    var
        CauseAbsence: Record "Cause of Absence";
}
