pageextension 50431 SalesOrderExt extends "Sales Order"
{
    layout
    {
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Shipment Date")
        {
            Visible = false;
        }
    }

    actions
    {
        addafter("Archive Document")
        {
            action("Archive & Discontinue")
            {
                ApplicationArea = All;
                Caption = 'Archive & Discontinue';
                Image = Archive;
                //ToolTip = 'Send the document to the archive, for example because it is too soon to delete it. Later, you delete or reprocess the archived document.';

                trigger OnAction()
                var
                    
                begin
                    Rec.Delete(true)
                end;
            }
        }
    }

}