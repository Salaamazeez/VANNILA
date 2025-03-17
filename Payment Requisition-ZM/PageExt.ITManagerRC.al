pageextension 50004 ITManagerRCExt extends "Administrator Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addbefore(Intrastat)
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
                Caption = 'Employee Self Service';
                Image = HumanResources;
                separator(Action1000000052)
                {
                    Caption = 'Employee';
                }
                action(CashReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cash Receipts';
                    RunObject = Page "Cash Receipt List";
                    RunPageView = where(Posted = filter(false));
                }
                action(CashAdvance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cash Advance';
                    RunObject = Page "Cash Advance List";
                    RunPageView = where(Posted = filter(false));
                }

                action("Approved Cash Advance List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Cash Advance';
                    RunObject = Page "Approved Cash Advance List";
                }
                action("Payment Requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Requests';
                    RunObject = Page "Payment Req. List";
                    Enabled = false;
                }
                action("Pending Payment Req. List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending Payment Req. List';
                    RunObject = Page "Pending Payment Req. List";
                }
                action("Pending Payment Voucher")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending Payment Voucher';
                    RunObject = Page "Pending Payment Voucher List";
                }
                action("Approved Payment Req. List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Payment Req. List';
                    RunObject = Page "Approved Payment Req. List";
                    Visible = true;
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
                action("Approved Cash Adv. Retirements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Cash Adv. Retirements';
                    RunObject = Page "Approved Retirement List";
                }

                // action("Payment Vouchers")
                // {
                //     ApplicationArea = Basic;
                //     Image = List;
                //     Promoted = true;
                //     RunObject = page "Payment Voucher List";
                // }

                // action("Approved Payment Vouchers")
                // {
                //     ApplicationArea = Basic;
                //     Image = List;
                //     Promoted = true;
                //     RunObject = page "Approved Payment Voucher List";
                // }

            }


        }
    }

    var
        myInt: Integer;
}