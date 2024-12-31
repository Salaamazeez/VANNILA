PageExtension 50200 AccountingManagerRoleCenterExt extends "Accounting Manager Role Center"
{

    actions
    {
        addafter("&G/L Trial Balance")
        {



            action(AgedAccountsReceivable)
            {
                ApplicationArea = Basic;
                Caption = '&Aged Accounts Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }

            action("Cash Reciept")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Reciept';
                Image = "Report";
                //RunObject = report ;
            }

            action("Phys. Inventory Journals")
            {
                ApplicationArea = Basic;
                Image = Worksheet;
                Promoted = true;
                RunObject = page "Item Journal Batches";
                RunPageView = WHERE("Template Type" = CONST("Phys. Inventory"), Recurring = CONST(false));
            }
            action("Item Journals")
            {
                ApplicationArea = Basic;
                Image = Journals;
                Promoted = true;
                RunObject = page "Item Journal Batches";
                RunPageView = WHERE("Template Type" = CONST(Item), Recurring = CONST(false));
            }
            action("Bank Account List")
            {
                ApplicationArea = Basic;
                Image = List;
                Promoted = true;
                RunObject = page "Bank Account List";
            }
            action("Released Production Orders")
            {
                ApplicationArea = Basic;
                Image = List;
                Promoted = true;
                RunObject = page "Released Production Orders";
            }
            action("Payment Voucher List")
            {
                ApplicationArea = Basic;
                Image = List;
                Promoted = true;
                RunObject = page "Payment Voucher List";
            }
            action("Pending Payment Voucher")
            {
                ApplicationArea = Basic;
                Caption = 'Pending Payment Voucher';
                RunObject = Page "Pending Payment Voucher List";
            }

            action("Purchase Quotes")
            {
                ApplicationArea = Basic;
                Image = List;
                Promoted = true;
                RunObject = page "Purchase Quotes";
            }

            action("Bank Account Lists")
            {
                ApplicationArea = Basic;
                Image = List;
                Promoted = true;
                RunObject = page "Bank Account List";
            }

            action("Transfer Journal Publish")
            {
                ApplicationArea = Basic;
                Image = Journal;
                Promoted = true;
                RunObject = page "Item Journal Batches";
                //RunPageView = WHERE("Journal Template Name"=CONST("TRANS.ORDE"));
            }

        }



        addbefore("&G/L Trial Balance")
        {

        }
        addafter("Cost Accounting")
        {


            group(Approvals)
            {
                Caption = 'Approvals';
                ToolTip = 'Request approval of your documents, cards, or journal lines or, as the approver, approve requests made by other users.';
                action("Requests Sent for Approval")
                {
                    ApplicationArea = All;
                    Caption = 'Requests Sent for Approval';
                    Image = Approvals;
                    RunObject = Page "Approval Entries";
                    RunPageView = sorting("Record ID to Approve", "Workflow Step Instance ID", "Sequence No.")
                                  order(ascending)
                                  where(Status = filter(Open));
                    ToolTip = 'View the approval requests that you have sent.';
                }
                action(RequestsToApprove)
                {
                    ApplicationArea = All;
                    Caption = 'Requests to Approve';
                    Image = Approvals;
                    RunObject = Page "Requests to Approve";
                    ToolTip = 'Accept or reject other users'' requests to create or change certain documents, cards, or journal lines that you must approve before they can proceed. The list is filtered to requests where you are set up as the approver.';
                }
            }
            group("Employee Self Service")
            {
                Image = HumanResources;
                separator(Action136)
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



                action("Cash Advance List")
                {
                    ApplicationArea = All;
                    Image = CashFlow;
                    RunObject = Page "Cash Advance List";

                }

            }

            group(PostedDocuments)
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action(PostedPaymentVouchers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Payment Vouchers';
                    RunObject = Page "Posted Payment Voucher List";
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


