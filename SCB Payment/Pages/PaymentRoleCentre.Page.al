page 90239 "Payment Role Centre"
{
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control2)
            {
                systempart(Control3; Outlook)
                {
                    ApplicationArea = All;

                }
                systempart(Control4; MyNotes)
                {
                    ApplicationArea = All;
                }
                chartpart(BANK_SWEEPING; BANK_SWEEPING)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action(PaymentTransactions)
            {
                ApplicationArea = All;
                Caption = 'Payment Scheduleactions';
                RunObject = Page "Payment Window List";
            }
            action(Open)
            {
                ApplicationArea = All;
                Caption = 'Open';
                RunObject = Page "Payment Window List";
                RunPageView = where(Status = const(Open));
            }
            action(PendingApproval)
            {
                ApplicationArea = All;
                Caption = 'Pending Approval';
                RunObject = Page "Payment Window List";
                RunPageView = where(Status = const("Pending Approval"));
            }
            action(Approved)
            {
                ApplicationArea = All;
                Caption = 'Approved';
                RunObject = Page "Payment Window List";
                RunPageView = where(Status = const(Approved));
            }
            action("Payment Vouchers")
            {
                ApplicationArea = All;
                Caption = 'Payment Vouchers';
                RunObject = Page "Payment Voucher List";
            }
        }
        area(sections)
        {
            group(History)
            {
                Caption = 'History';
                action(ArchivedTransactions)
                {
                    ApplicationArea = All;
                    Caption = 'Archived Transactions';
                    RunObject = Page "Archived Payment Schedule List";
                }
            }
            group(Administration)
            {

                Caption = 'Administration';
                Image = Administration;
                action("Debit Accounts")
                {
                    Image = BankAccount;
                    RunObject = Page "Payment-DebitAccounts";
                    ApplicationArea = All;
                }
                action(CBNBankCodes)
                {
                    ApplicationArea = All;
                    Caption = 'CBN Bank Codes';
                    RunObject = Page "Banks";
                }
                action(PaymentBanks)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Banks';
                    RunObject = Page "Payment Window Banks";
                }
            }
        }
        area(processing)
        {
            group(Setup)
            {
                Caption = 'Setup';
                action(PmtTranSetup)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Setup';
                    Image = Setup;
                    RunObject = Page "Payment Schedule Setup";
                }
            }

        }
    }
}

