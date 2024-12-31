tableextension 50002 FixedAssetExt extends "Fixed Asset"
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
    begin
        UserSetup.Get(UserId);
        if not UserSetup."Master Record Admin" then
            Error(Err0001);
    end;

    trigger OnBeforeDelete()
    begin
        UserSetup.Get(UserId);
        if not UserSetup."Master Record Admin" then
            Error(Err0001);
    end;

    trigger OnBeforeModify()
    begin
        UserSetup.Get(UserId);
        if not UserSetup."Master Record Admin" then
            Error(Err0001);
    end;

    var
        UserSetup: Record "User Setup";
        Err0001: Label 'The current user is not Master Admin';
}