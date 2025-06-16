report 60022 "Payment Requisition Report"
{
    //Created by Akande
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Payment Requisition Report.rdl';

    dataset
    {
        dataitem("Payment Requisition"; "Payment Requisition")
        {
            RequestFilterFields = "No.";
            column(No_; "No.")
            {

            }
            column(Date; Format(Date))
            {

            }
            column(Requester; Requester)
            {

            }
            column(Status; Status)
            {

            }


            column(Request_Description; "Request Description")
            {

            }
            column(Purchase_Requisition_No_; "Purchase Requisition No.")
            {
            }
            column(Request_Amount; "Request Amount")
            {

            }
            column(Current_Pending_Approver; "Current Pending Approver")
            {

            }
            column(Detailed_Pay_Description; "Request Description")
            {

            }
            column(Request_AmountInwords; ConvertAmtToText.ToWords("Request Amount", "Currency Code", '', 0, '')) { }
            column(Beneficiary; Beneficiary) { }
            column(Beneficiary_Name; "Beneficiary Name") { }
            dataitem("Payment Requisition Line"; "Payment Requisition Line")
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
                column(Account_Name; "Account Name")
                {

                }
                column(Account_Type; "Account Type")
                {

                }
                column(Program_Mode; "Expense Code")
                {

                }
                column(Bal__Account_Name; "Bal. Account Name")
                {

                }
                column(Bal__Account_No_; "Bal. Account No.")
                {

                }
                column(Bal__Account_Type; "Bal. Account Type")
                {

                }
                column(Exchange_Rate; "Exchange Rate")
                {

                }


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