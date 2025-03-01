pageextension 50052 SalesInvoiceSubform extends "Sales Invoice Subform"
{
    layout
    {
        modify(Description)
        {
            editable = false;
        }
        addafter("Line Amount")
        {
            field("Tax Type"; Rec."Tax Type")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Unit Price b/f Adjusted"; Rec."Unit Price b/f Adjusted")
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
        modify("Unit Price")
        {
            Enabled = false;
        }
        addafter("Unit Price")
        {
            field("Base Unit Price"; Rec."Base Unit Price")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("&Line")
        {
            group(WHTVATEntry)
            {
                Caption = 'WHT/VAT';
                action(WHTVATEntries)
                {
                    Caption = 'WHT/VAT Entries';
                    ApplicationArea = All;
                    Image = VATEntries;
                    trigger OnAction()
                    var
                        VATAndWHTEntry: Record VATAndWHTEntry;
                        VATAndWHTEntries: Page VATAndWHTEntries;
                        VATWHTPostingGrp: Record "VAT/WHT Posting Group";
                        SalesLine: Record "Sales Line";
                    begin
                        GeneralCodeunit.SalesVATEntry(Rec)
                    end;
                }
            }
        }
    }

    var
        GeneralCodeunit: Codeunit GeneralCodeunit;

}