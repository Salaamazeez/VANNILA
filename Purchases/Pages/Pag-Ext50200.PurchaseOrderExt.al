pageextension 50207 PurchaseOrderExt extends "Purchase Order"
{
    layout
    {
        modify("Location Code")
        {
            Visible = false;
        }
    }

    actions
    {
        modify("Create &Whse. Receipt")
        {
            Visible = false;
        }
        modify("Create Inventor&y Put-away/Pick")
        {
            Visible = false;
        }
        modify("Send Intercompany Purchase Order")
        {
            Visible = false;
        }
    }
}
