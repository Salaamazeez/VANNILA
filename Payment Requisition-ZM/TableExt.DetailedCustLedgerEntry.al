tableextension 50014 DetCustumerLGExt extends "Detailed Cust. Ledg. Entry"
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