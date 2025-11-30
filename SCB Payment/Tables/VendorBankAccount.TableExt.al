

tableextension 90206 VendorBankAccountExt extends "Vendor Bank Account"
{
    fields
    {
        field(50000; "CBN Code"; Code[20])
        {
            Caption = 'CBN Bank Code';
            DataClassification = CustomerContent;
            TableRelation = "Bank";
        }
        // field(50002; "Creditor BIC"; Text[30])
        // {
        //     TableRelation = "SWIFT Code".Code;
        // }
    }
}
