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
            field("General Journal Template";Rec."General Journal Template")
            {
                ApplicationArea = All;
            }
            field("General Journal Batch";Rec."General Journal Batch"){ ApplicationArea = All;}
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}