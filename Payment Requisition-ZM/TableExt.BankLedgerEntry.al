tableextension 50030 BandLedgerEntryExt extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50014; "KBS Closed"; Boolean)
        {
            Caption = 'Bank Closed';
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

    var
        myInt: Integer;
}