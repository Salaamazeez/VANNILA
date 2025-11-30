

pageextension 90223 VendorBankAccountCardExt extends "Vendor Bank Account Card"
{
    layout
    {
        addafter("Bank Branch No.")
        {
            field("CBN Code"; Rec."CBN Code")
            {
                ApplicationArea = All;
                Caption = 'CBN Bank Code';
            }
           
        }
    }
}
