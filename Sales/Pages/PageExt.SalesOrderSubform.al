pageextension 50051 SalesOrderSubform extends "Sales Order Subform"
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
            Editable = false;
        }
        addbefore("Unit Price")
        {
            field("Base Unit Price"; Rec."Base Unit Price")
            {
                ApplicationArea = All;
            }
        }
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Planned Shipment Date")
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
        modify("Planned Delivery Date")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Item Charge Qty. to Handle")
        {
            Visible = false;
        }

    }
    actions
    {
        addafter("O&rder")
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