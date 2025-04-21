pageextension 50022 BankLedgerEntries extends "Bank Account Ledger Entries"
{
    layout
    {
        modify(Open){
            Visible = false;
        }
        addafter(Amount)
        {
            field("Amount (LCY) "; Rec."Amount (LCY)") { ApplicationArea = All; }
        }
        addafter("Entry No.")
        {
            field("KBS Closed"; Rec."KBS Closed") { ApplicationArea = All; }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}