report 60000 "Voucher Report"
{
    //Created by Akande
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Voucher Report.rdl';

    dataset
    {
        dataitem("Payment Voucher Header"; "Payment Voucher Header")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            {

            }
            column(Date; Date)
            {

            }
            column(Requester; Requester)
            {

            }
            column(Status; Status)
            {

            }
            column(Type; Type)
            {

            }
            column(Bal_Account_Type; "Bal Account Type")
            {

            }
            column(Bal_Account_No_; "Bal Account No.")
            {

            }
            column(Bal_Account_Name; "Bal Account Name")
            {

            }
            column(Request_Description; "Request Description")
            {

            }
            // column(Purchase_Requisition_No_; "Purchase Requisition No.")
            // {

            // }
            column(Request_Amount; "Request Amount")
            {

            }
            column(Former_PR_No_; "Former PR No.") { }
            column(Beneficiary; Beneficiary) { }
            column(Beneficiary_Name; "Beneficiary Name") { }
            dataitem("Payment Voucher Line"; "Payment Voucher Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Document_No_; "Document No.")
                {

                }
                column(Amount; Amount)
                {

                }
                column(Payment_Details; "Payment Details")
                {

                }
                column(Account_No_; "Account No.")
                {

                }
                column(VAT__; "VAT %")
                {

                }
                column(VAT_Amount; "VAT Amount")
                {

                }
                column(Account_Name; "Account Name")
                {

                }
                column(Account_Type; "Account Type")
                {

                }
                column(Amount_InWords; ConvertAmtToText.ToWords(Amount, "Currency Code", '', 0, '')) { }
                dataitem("Company Information"; "Company Information")
                {
                    column(Picture; Picture)
                    {

                    }
                    column(Name; Name)
                    {

                    }
                    column(Address; Address)
                    {

                    }
                    column(E_Mail; "E-Mail")
                    {

                    }
                    column(Phone_No_; "Phone No.")
                    {

                    }
                    column(Fax_No_; "Fax No.")
                    {

                    }
                }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        ConvertAmtToText: Codeunit Library;
}