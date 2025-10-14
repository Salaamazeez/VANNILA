reportextension 50004 PurchaseInvoiceExt extends "Purchase - Invoice"
{
    dataset
    {
        modify("Purch. Inv. Header")
        {
            trigger OnAfterPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture)
            end;
        }
        add("Purch. Inv. Header")
        {
            column(CompanyInfo_Picture; CompanyInfo.Picture) { }
        }

    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    rendering
    {
        layout("PurchaseInvoice-Modified")
        {
            Type = RDLC;
            LayoutFile = 'Layouts/PurchaseInvoice-Modified.rdl';
        }
    }
    var
        //CompanyInfo: Record "Company Information";
}