tableextension 50016 GLEntryExt extends "G/L Entry"
{
    fields
    {
        field(50004; "Transaction type"; Option)
        {
            OptionMembers = " ",Loan,"Staff Adv";
        }
        field(50005; "Loan ID"; Code[20]) { }
        field(50006; "Description 2"; Text[100]) { }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}