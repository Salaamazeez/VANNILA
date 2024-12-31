tableextension 50005 GenLedgerSetupExt extends "General Ledger Setup"
{
    fields
    {
        field(50001; "Loan Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50002; "Enable ESS"; Boolean)
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

    var
        myInt: Integer;
}