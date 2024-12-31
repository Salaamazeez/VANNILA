pageextension 50015 PurchInvoiceSubform extends "Purch. Invoice Subform"
{
    layout
    {
        addbefore("Shortcut Dimension 1 Code")
        {
            field("Gen. Bus. Posting Group "; Rec."Gen. Bus. Posting Group") { ApplicationArea = All; }
            field("Gen. Prod. Posting Group  "; Rec."Gen. Prod. Posting Group") { ApplicationArea = All; }
            field("VAT Bus. Posting Group "; Rec."VAT Bus. Posting Group") { ApplicationArea = All; }
            field("VAT Prod. Posting Group "; Rec."VAT Prod. Posting Group") { ApplicationArea = All; }
            field("FA Posting Type "; Rec."FA Posting Type") { ApplicationArea = All; }
            field("Maintenance Code"; Rec."Maintenance Code") { ApplicationArea = All; }
        }
    }
    actions
    {
        // Add changes to page actions here
    }


}