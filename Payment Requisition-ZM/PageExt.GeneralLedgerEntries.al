pageextension 50023 GeneralLedgerEntries extends "General Ledger Entries"
{
    layout
    {
        addbefore(Amount)
        {
            field(CurrencyCode; Rec."Source Currency Code")
            {
                ApplicationArea = All;
                Caption = 'Currency Code';
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