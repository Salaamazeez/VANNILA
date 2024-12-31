tableextension 50015 CustumerLGExt extends "Cust. Ledger Entry"
{
    fields
    {
        field(50004; "Transaction type"; Option)
        {
            OptionMembers = " ",Loan,"Staff Adv";
        }
        field(50005; "Loan ID"; Code[20]) { }
    }
}