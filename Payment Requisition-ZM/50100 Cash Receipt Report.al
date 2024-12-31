report 50100 "Cash Receipt Report"
{
    //Created by Salaam Azeez
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Cash Receipt Layout.rdl';

    dataset
    {
        dataitem("Cash Receipt"; "Cash Receipt")
        {
            column("Date"; "Date")
            {

            }
            column(Cash_Receipt_No; "No.")
            {

            }
            column(Purpose; Purpose)
            {

            }
            column("Type"; "Type")
            {

            }
            column(Debit_Account_Name; "Debit Account Name")
            {

            }
            column(Status; Status)
            {

            }
            column("Retiring_Officer"; "Retiring Officer")
            {

            }
            column(Credit_Account_No_; "Credit Account No.")
            {

            }
            column(Credit_Account_Name; "Credit Account Name")
            {

            }
            column(Balance; Balance)
            {

            }
            column(Debit__Account_Type; "Debit  Account Type")
            {

            }
            column(Debit_Account_No_; "Debit Account No.")
            {

            }
            column(Amount; Amount)
            {

            }
            column(Retirement_No_; "Retirement No.")
            {

            }
            column(Balance_Posted; "Balance Posted")
            {

            }
            column(Retired_Amount; "Retired Amount")
            {

            }
            column(Amount_InWords; ConvertAmtToText.ToWords(Amount, "Currency Code", '', 0, '')) { }
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