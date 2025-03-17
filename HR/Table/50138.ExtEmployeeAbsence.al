tableextension 50138 ExtEmployeeAbsence extends "Employee Absence"
{
    fields
    {
        field(50100; "Leave Year"; Integer)
        {
            Caption = 'Leave Year';
            DataClassification = ToBeClassified;
        }
        field(50101; "Leave Code"; Code[20])
        {
            Caption = 'Leave Code';
            DataClassification = ToBeClassified;
        }
        field(50102; "Recalled/Adjustment Reason"; Text[150])
        {
            Caption = 'Recalled/Adjustment Reason';
            DataClassification = ToBeClassified;
        }
        field(50103; "Leave Recalled"; Boolean)
        {
            Caption = 'Leave Recalled';
            DataClassification = ToBeClassified;
        }
        field(50104; "Recalled Date"; Date)
        {
            Caption = 'Recalled Date';
            DataClassification = ToBeClassified;
        }
        field(50105; "Adjustment Type"; Option)
        {
            Caption = 'Adjustment Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Positive Adjustment","Negative Adjustment";
        }
        field(50106; "Leave Adjustment"; Boolean)
        {
            Caption = 'Leave Adjustment';
            DataClassification = ToBeClassified;
        }
        field(50107; "Leave Application"; Boolean)
        {
            Caption = 'Leave Application';
            DataClassification = ToBeClassified;
        }
        field(50108; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50109; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(50110; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(50111; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        modify("Employee No.")
        {
            trigger OnAfterValidate()
            begin
                Employee.GET("Employee No.");
                IF Employee."Privacy Blocked" THEN
                    ERROR(BlockedErr);

                "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                //"Shortcut Dimension 3 Code" := Employee."Shortcut Dimension 3 Code";
                //"Shortcut Dimension 4 Code" := Employee."Shortcut Dimension 4 Code";
            end;
        }
    }
    var
        Employee: Record Employee;
        BlockedErr: Label 'You cannot register absence because the employee is blocked due to privacy.';
}
