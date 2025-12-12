reportextension 50005 PurchaseOrderExt extends 1322
{
    dataset
    {
        

    }

    requestpage
    {
        // Add changes to the requestpage here
    }

    rendering
    {
        layout("PurchaseOrder-Modified")
        {
            Type = Word;
            LayoutFile = 'Layouts/StandardPurchaseOrder.docx';
        }
    }
    var
        //CompanyInfo: Record "Company Information";
}