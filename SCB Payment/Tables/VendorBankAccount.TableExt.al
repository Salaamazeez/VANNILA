

tableextension 90206 VendorBankAccountExt extends "Vendor Bank Account"
{
    fields
    {
        field(52092179; "CBN Code"; Code[20])
        {
            Caption = 'CBN Bank Code';
            DataClassification = CustomerContent;
            TableRelation = "Bank";
        }
    }
}
