tableextension 50110 CustomerExt extends Customer
{
    fields
    {
        field(50000; Type; Option)
        {
            OptionMembers = Customer,Staff;
        }
        field(50001; "No. 2"; Text[50])
        {

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
        if not UserSetup."Master Record Admin" then
            Error(Err0001);
    end;
}