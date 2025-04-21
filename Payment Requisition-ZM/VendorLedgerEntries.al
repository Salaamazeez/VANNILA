pageextension 50090 "VendorLedgerEntriesExt" extends "Vendor Ledger Entries"
{
    layout
    {
        modify(Description){Visible = false;}
        modify(Open){Visible = false;}
        modify("Exported to Payment File"){Visible = false;}
        modify("Due Date"){Visible = false;}
        modify("Original Amount"){Visible = false;}
    }
    
    actions
    {
        // Add changes to page actions here
    }
    
    var
        myInt: Integer;
}