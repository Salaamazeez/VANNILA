pageextension 50009 EmployeeExt extends "Employee Card"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;

            }

        }
        addafter(Gender)
        {
            field("Leave Setup Code"; Rec."Leave Setup Code")
            {
                ApplicationArea = All;
                TableRelation = LeaveSetup;
            }
            field("Manager No."; Rec."Manager No.")
            {
                ApplicationArea = All;
                TableRelation = Employee;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}