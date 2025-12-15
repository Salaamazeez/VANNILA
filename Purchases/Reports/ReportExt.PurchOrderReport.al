reportextension 50005 PurchaseOrderExt extends 1322
{
    dataset
    {
        modify("Purchase Header")
        {
            trigger OnAfterPreDataItem()
            begin
                CompanyInfo.Get();
                CompanyInfo.CalcFields(Picture)
            end;
        }
        add("Purchase Header")
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
        layout("PurchaseOrder-Modified")
        {
            Type = Word;
            LayoutFile = 'Layouts/StandardPurchaseOrder.docx';
        }
    }
    var
    //CompanyInfo: Record "Company Information";
}