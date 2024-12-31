pageextension 50019 GenLedgerSetupExt extends "General Ledger Setup"
{
    layout
    {
        addafter(EnableDataCheck)
        {
            field("Enable ESS"; Rec."Enable ESS")
            {
                ApplicationArea = All;
            }
            field("Loan Nos"; Rec."Loan Nos")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}