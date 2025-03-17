pageextension 50000 AccPayablesCoordinatorRCExt extends "Acc. Payables Coordinator RC"
{


    actions
    {
        addafter("Posted Documents")
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
                    Caption = 'Cash Advances';
                    RunObject = Page "Cash Advance List";
                    RunPageView = where(Posted = filter(false));
                }
                action("Pending Cash Advance List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending Cash Advances';
                    RunObject = Page "Pending Cash Advance List";
                }
                action("Approved Cash Advance List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Cash Advances';
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
                    Caption = 'Pending Payment Requests';
                    RunObject = Page "Pending Payment Req. List";
                }
                action("Approved Payment Req. List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Payment Requests';
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
                action("Pending Payment Voucher")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pending Payment Voucher';
                    RunObject = Page "Pending Payment Voucher List";
                }
                action("Approved Cash Adv. Retirements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Cash Adv. Retirements';
                    RunObject = Page "Approved Retirement List";
                }



            }


        }
        addafter("Purchase &Credit Memo Nos.")
        {

            action(AgedAccountsReceivable)
            {
                ApplicationArea = Basic;
                Caption = '&Aged Accounts Receivables';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
            }

            action("Cash Reciept")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Reciepts';
                Image = "Report";
                //RunObject = report ;
            }
            action("Payment Vouchers")
            {
                ApplicationArea = Basic;
                Image = List;
                Promoted = true;
                RunObject = page "Payment Voucher List";
            }

            action("Approved Payment Vouchers")
            {
                ApplicationArea = Basic;
                Image = List;
                Promoted = true;
                RunObject = page "Approved Payment Voucher List";
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



        addafter("G/L Registers")
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
            action("Posted Cash Adv. Retirements")
            {
                ApplicationArea = Basic;
                Caption = 'Posted Cash Adv. Retirements';
                RunObject = Page "Posted Retirement List";
            }
            action("Posted Payment Vouchers")
            {
                ApplicationArea = Basic;
                Image = List;
                Promoted = true;
                RunObject = page "Posted Payment Voucher List";
            }
            action(PostedCashReceipts)
            {
                ApplicationArea = Basic;
                Caption = 'Posted Cash Receipts';
                RunObject = Page "Posted Cash Receipt List";
                // RunPageView = where(Posted = filter(true));
            }

            action(GLRegisters)
            {
                ApplicationArea = Basic;
                Caption = 'G/L Registers';
                Image = GLRegisters;
                RunObject = Page "G/L Registers";
            }

        }
    }


}