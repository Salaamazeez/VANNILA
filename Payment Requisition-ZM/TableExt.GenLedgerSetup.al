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
        field(50003; "General Journal Template"; Code[10])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Gen. Journal Template";
        }
        field(50004; "General Journal Batch"; Text[10])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("General Journal Template"));
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