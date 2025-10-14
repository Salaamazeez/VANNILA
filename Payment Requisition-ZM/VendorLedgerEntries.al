pageextension 50090 "VendorLedgerEntriesExt" extends "Vendor Ledger Entries"
{
    layout
    {
        modify(Description){Visible = false;}
        modify(Open){Visible = false;}
        modify("Exported to Payment File"){Visible = false;}
        modify("Due Date"){Visible = false;}
        modify("Original Amount"){Visible = false;}
        modify("Remit-to Code"){Visible = false;}
        modify("Entry No."){Visible = false;}
        modify("On Hold"){Visible = false;}
        modify("Max. Payment Tolerance"){Visible = false;}
        modify("Remaining Pmt. Disc. Possible"){Visible = false;}
        modify("Original Pmt. Disc. Possible"){Visible = false;}
        modify("Pmt. Disc. Tolerance Date"){Visible = false;}
        modify("Pmt. Discount Date"){Visible = false;}
    }
    
    actions
    {
        // Add changes to page actions here
    }
    
    var
        myInt: Integer;
}