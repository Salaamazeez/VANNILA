tableextension 50003 VendorExt extends Vendor
{
    fields
    {
        field(50002; "No. 2"; Text[50]) { }
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

    trigger OnBeforeModify()
    var
        UserSetup: Record "User Setup";
        Err0001: Label 'The current user is not g/l account admin';
    begin
        UserSetup.Get(UserId);
        if not UserSetup."Master Record Admin" then
            Error(Err0001);
    end;

}