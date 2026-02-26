pageextension 50012 VendorExt extends "Vendor Card"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;

            }
            field("Sectorial Purpose Code"; Rec."Sectorial Purpose Code")
            {
                ApplicationArea = All;
            }
            field("Payment Category Code"; Rec."Payment Category Code")
            {
                Visible = false;
                ApplicationArea = All;
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