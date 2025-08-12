pageextension 50015 PurchInvoiceSubform extends "Purch. Invoice Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
            Caption = 'Narration';
        }
        addbefore("Shortcut Dimension 1 Code")
        {
            field("Gen. Bus. Posting Group "; Rec."Gen. Bus. Posting Group") { ApplicationArea = All; }
            field("Gen. Prod. Posting Group  "; Rec."Gen. Prod. Posting Group") { ApplicationArea = All; }
            field("VAT Bus. Posting Group "; Rec."VAT Bus. Posting Group") { ApplicationArea = All; Visible = false; }
            field("VAT Prod. Posting Group "; Rec."VAT Prod. Posting Group") { ApplicationArea = All; Visible = false;}
            field("FA Posting Type "; Rec."FA Posting Type") { ApplicationArea = All; Visible = false;}
            field("Maintenance Code"; Rec."Maintenance Code") { ApplicationArea = All; Visible = false; }
        }
        addafter("Line Amount")
        {
            field("Tax Type"; Rec."Tax Type")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Unit Cost b/f Adjusted"; Rec."Unit Cost b/f Adjusted")
            {
                Visible = false;
                ApplicationArea = All;
            }

        }
        modify("Direct Unit Cost")
        {
            Editable = false;
        }
        addbefore("Direct Unit Cost")
        {
            field("Base Unit Cost"; Rec."Base Unit Cost")
            {
                ApplicationArea = All;
            }
        }

        modify("Location Code")
        {
            Visible = false;
        }

        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        
    }
    actions
    {

        addafter("&Line")
        {
            group(WHTVAT)
            {
                Caption = 'WHT/VAT';
                action(WHTVATEntries)
                {
                    Caption = 'WHT/VAT Entries';
                    ApplicationArea = All;
                    Image = VATEntries;

                    trigger OnAction()
                    begin
                        GeneralCodeunit.PurchaseVATEntry(Rec)
                    end;
                }
            }
        }
    }
    var
        GeneralCodeunit: Codeunit GeneralCodeunit;

}