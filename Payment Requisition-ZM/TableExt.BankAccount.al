tableextension 50021 BankAccountExt extends "Bank Account"
{
    fields
    {
        field(50060; "Suspense/Clearing"; Option)
        {
            OptionMembers = " ","Bank Payment","Bank Receipts","Main Bank";
        }
        field(60002; "Bank Code"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = Bank.Code;
        }
        field(60003; "Bank Name"; Text[100])
        {
            Editable = false;
            DataClassification = EndUserIdentifiableInformation;
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