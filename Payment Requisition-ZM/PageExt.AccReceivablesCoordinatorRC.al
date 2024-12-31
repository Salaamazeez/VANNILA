pageextension 50003 AccReceivableCoordRCExt extends "Acc. Receivables Adm. RC"
{
    actions
    {

        addafter("Finance Charge Memos")
        {
            separator(Action1000000052)
            {
                Caption = 'Employee';
            }
            action("Payment Requests")
            {
                ApplicationArea = Basic;
                Caption = 'Payment Requests';
                RunObject = Page "Payment Req. List";
            }
            action("Pending Payment Req. List")
            {
                ApplicationArea = Basic;
                Caption = 'Pending Payment Req. List';
                RunObject = Page "Pending Payment Req. List";
            }
            action("Approved Payment Req. List")
            {
                Visible = false;
                ApplicationArea = Basic;
                Caption = 'Approved Payment Req. List';
                RunObject = Page "Approved Payment Req. List";
            }

            action("Cash Adv. Retirements")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Adv. Retirements';
                RunObject = Page "Retirement List";
            }
            action("Pending Cash Adv. Retirements")
            {
                ApplicationArea = Basic;
                Caption = 'Pending Cash Adv. Retirements';
                RunObject = Page "Pending Retirement List";
            }
            action("Posted Cash Adv. Retirements")
            {
                ApplicationArea = Basic;
                Caption = 'Posted Cash Adv. Retirements';
                RunObject = Page "Posted Retirement List";
            }
        }


        addafter("G/L Registers")
        {

            group("Posted Documentsl")
            {
                action(PostedPaymentVouchers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Payment Vouchers';
                    RunObject = Page "Posted Payment Voucher List";
                }
                action(PostedCheques)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Cheques';
                    RunObject = Page "Check Ledger Entries";
                }
                action(PostedCashAdvances)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Cash Advances';
                    RunObject = Page "Cash Advance List";
                    RunPageView = where(Posted = filter(true));
                }
                action(NotRetired)
                {
                    ApplicationArea = Basic;
                    Caption = 'Not Retired';
                    RunObject = Page "Cash Advance List";
                    RunPageView = where(Retired = filter(false));
                }
                action(Retired)
                {
                    ApplicationArea = Basic;
                    Caption = 'Retired';
                    RunObject = Page "Cash Advance List";
                    RunPageView = where(Retired = filter(true));
                }

                action(PostedCashAdvRetirements)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Cash Adv.Retirements';
                    RunObject = Page "Retirement List";
                    RunPageView = where(Posted = filter(true));
                }



            }


        }
    }
}