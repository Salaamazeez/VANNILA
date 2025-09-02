pageextension 50102 PurchaseInvoiceExt extends "Purchase Invoice"
{
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
            {
                ApplicationArea = All;
            }
            field("Applies-to ID"; Rec."Applies-to ID")
            {
                ApplicationArea = All;

            }
            field("Applies-to Doc. No."; Rec."Applies-to Doc. No.")
            {
                ApplicationArea = All;

            }
        }

        modify("Location Code")
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = false;
        }
    }

    actions
    {  
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField()
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField()
            end;
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField()
            end;
        }
        modify("Re&lease")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField()
            end;
        }
    }
}