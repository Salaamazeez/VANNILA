tableextension 50017 "G/L AccountExt" extends "G/L Account"
{
    fields
    {
        // Add changes to table fields here
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
        if not UserSetup."G/L Account Admin" then
            Error(Err0001);
    end;

    trigger OnBeforeModify()
    var
        UserSetup: Record "User Setup";
        Err0001: Label 'The current user is not g/l account admin';
    begin
        UserSetup.Get(UserId);
        if not UserSetup."G/L Account Admin" then
            Error(Err0001);
    end;

}