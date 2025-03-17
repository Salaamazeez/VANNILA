pageextension 50135 VATEntriesPreviewExt extends "VAT Entries Preview"
{
    layout
    {
        modify("VAT Prod. Posting Group") { Visible = false; }
        modify("VAT Date") { Visible = false; }
        modify("Document No.") { Visible = false; }
        modify(Amount) { Visible = false; }
        modify(NonDeductibleVATBase) { Visible = false; }
        modify(NonDeductibleVATAmount) { Visible = false; }
        modify("VAT Calculation Type") { Visible = false; }
        modify("Country/Region Code") { Visible = false; }
        modify("EU 3-Party Trade") { Visible = false; }
        modify(Closed) { Visible = false; }
        modify("Closed by Entry No.") { Visible = false; }
        modify("Internal Ref. No.") { Visible = false; }
    }

    actions
    {
        // Add changes to page actions here
    }
}