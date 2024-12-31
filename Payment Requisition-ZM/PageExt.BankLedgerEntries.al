pageextension 50022 BankLedgerEntries extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter(Amount)
        {
            field("Amount (LCY) "; Rec."Amount (LCY)") { ApplicationArea = All; }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}