pageextension 50013 VendorListExt extends "Vendor List"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;
            }
        } 
    } 
    actions
    {
        // Add changes to page actions here
    }
}