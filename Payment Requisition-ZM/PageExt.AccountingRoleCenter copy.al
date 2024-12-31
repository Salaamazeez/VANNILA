PageExtension 50202 TeamMemberRoleCenterExt extends "Team Member Role Center"
{

    actions
    {
        addafter(Purchasing)
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


