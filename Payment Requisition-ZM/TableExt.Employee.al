tableextension 50004 EmployeeExt extends Employee
{
    fields
    {
        field(50002; "No. 2"; Text[50]) { }
        field(50003; "Leave Setup Code"; code[20])
        {
            Caption = 'Leave Setup Code';
            DataClassification = ToBeClassified;
            TableRelation = LeaveSetup;
        }

    }


    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
    trigger OnBeforeInsert()
    var
        UserSetup: Record "User Setup";
        Err0001: Label 'The current user is not g/l account admin';
    begin
        UserSetup.Get(UserId);
        if not UserSetup."HR Admin" then
            Error(Err0001);
    end;

    trigger OnBeforeModify()
    var
        UserSetup: Record "User Setup";
        Err0001: Label 'The current user is not g/l account admin';
    begin
        UserSetup.Get(UserId);
        if not UserSetup."HR Admin" then
            Error(Err0001);
    end;
}