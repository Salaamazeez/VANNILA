report 60027 "Cash Advance Report"
{
    //Created by Salaam Azeez
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Cash Advance Report.rdl';

    dataset
    {
        dataitem(DataItemName; "Cash Advance")
        {
            // DataItemTableView = where(Status = const("Approved"));
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
            column(Treated; Treated)
            {

            }
            column(Posted; Posted)
            {

            }
            column(Total_Amount; "Total Amount")
            {

            }
            column(Type; "Transaction type")
            {

            }
            column(Pmt_Vouch__Code; "Pmt Vouch. Code")
            {

            }
            column(Voucher_No; "Voucher No")
            {

            }
            column(Retired; Retired)
            {

            }
            column(Retirement_No_; "Retirement No.")
            {

            }
            column(Debit__Account_Type; "Debit  Account Type")
            {
                Caption = 'Account Type';
            }
            column(Payee_No_; "Debit Account No.")
            {
                Caption = 'Payee No';
            }
            column(Debit_Account_Name; "Debit Account Name")
            {
                Caption = 'Payee Name';
            }
            column(Total_Amount_InWords; ConvertAmtToText.ToWords("Total Amount", "Currency Code", '', 0, '')) { }
            dataitem("Cash Advance Line"; "Cash Advance Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Document_No_; "Document No.")
                {

                }
                column(Line_No_; "Line No.")
                {

                }
                column(Payment_Details; "Payment Details")
                {

                }
                column(Amount; Amount)
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
                column(Bal__Account_No_; "Bal. Account No.")
                {

                }
                column(Bal__Account_Name; "Bal. Account Name")
                {

                }
                column(Bal__Account_Type; "Bal. Account Type")
                {

                }
                dataitem("Company Information"; "Company Information")
                {
                    column(Name; Name)
                    {

                    }
                    column(Address; Address + ' ' + "Address 2" + ' ' + City)
                    {

                    }
                    column(Picture; Picture)
                    {

                    }
                }
            }
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(check; check)
                    {
                        ApplicationArea = All;

                    }
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
        check: Boolean;
        ConvertAmtToText: Codeunit Library;
}