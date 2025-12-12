

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
            field("Creditor Identifier Type"; Rec."Creditor Identifier Type")
            {
                ApplicationArea = All;
            }
        }
    }
}
