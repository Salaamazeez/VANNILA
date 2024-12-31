report 50000 "Outstanding Cash Advance"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'OutstandingCashAdvance.rdl';

    dataset
    {
        dataitem("Cash Advance"; "Cash Advance")
        {
            DataItemTableView = where(Retired = const(false), "Transaction type" = const("Staff Adv"));
            column(No_; "No.") { }
            column(Date; Date) { }
            column(Debit_Account_No_; "Debit Account No.") { }
            column(Debit_Account_Name; "Debit Account Name") { }
            column(Description; Description) { }
            column(Currency_Code; "Currency Code") { }
            column(Requester; Requester) { }
            column(Retired; Retired) { }
            column(Total_Amount; "Total Amount") { }
            column(Total_Amount__LCY_; "Total Amount (LCY)") { }
            column(Retired_Amount; "Retired Amount") { }
            column(Outstanding_Amount; "Total Amount" - "Retired Amount") { }
            column(Due_Date; "Due Date") { }
            column(CompanyInfo_Pic; CompanyInfo.Picture) { }
            column(CompanyInfo_Name; CompanyInfo.Name) { }
            // dataitem(CopyLoop; Integer)
            // {
            //     dataitem(PageLoop; Integer)
            //     {

            //     }
            // }
            // dataitem("Cash Advance Line"; "Cash Advance Line")
            // {
            //     DataItemTableView = SORTING("Document No.", "Line No.");
            //     DataItemLink = "Document No." = FIELD("No.");
            //     DataItemLinkReference = "Cash Advance";

            // }

            trigger OnAfterGetRecord()
            begin

            end;

        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.CalcFields(Picture);
    end;

    var
        OutputNo: Integer;
        CopyText: Text;
        NoOfLoops: Integer;
        NoOfCopies: Integer;
        CompanyInfo: Record "Company Information";
}