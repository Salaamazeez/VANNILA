// pageextension 50001 BusinessManagerRCExt extends "Business Manager Role Center"
// {
//     layout
//     {
//         // Add changes to page layout here
//     }

//     actions
//     {
//         addafter("Cash Management")
//         {
//             group(Approvals)
//             {
//                 Caption = 'Approvals';
//                 ToolTip = 'Request approval of your documents, cards, or journal lines or, as the approver, approve requests made by other users.';
//                 action("Requests Sent for Approval")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Requests Sent for Approval';
//                     Image = Approvals;
//                     RunObject = Page "Approval Entries";
//                     RunPageView = sorting("Record ID to Approve", "Workflow Step Instance ID", "Sequence No.")
//                                   order(ascending)
//                                   where(Status = filter(Open));
//                     ToolTip = 'View the approval requests that you have sent.';
//                 }
//                 action(RequestsToApprove)
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Requests to Approve';
//                     Image = Approvals;
//                     RunObject = Page "Requests to Approve";
//                     ToolTip = 'Accept or reject other users'' requests to create or change certain documents, cards, or journal lines that you must approve before they can proceed. The list is filtered to requests where you are set up as the approver.';
//                 }
//             }
//             group("Employee Self Service")
//             {
//                 Image = HumanResources;
//                 separator(Action136)
//                 {
//                     Caption = 'Employee';
//                 }
//                 action("Payment Requests")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Payment Requests';
//                     RunObject = Page "Payment Req. List";
//                 }
//                 action("Pending Payment Req. List")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Pending Payment Req. List';
//                     RunObject = Page "Pending Payment Req. List";
//                 }
//                 action("Approved Payment Req. List")
//                 {
//                     Visible = false;
//                     ApplicationArea = Basic;
//                     Caption = 'Approved Payment Req. List';
//                     RunObject = Page "Approved Payment Req. List";
//                 }
//                 action("Cash Adv. Retirements")
//                 {
//                     ApplicationArea = Basic;
//                     Caption = 'Cash Adv. Retirements';
//                     RunObject = Page "Retirement List";
//                 }
//                 action("Cash Advance List")
//                 {
//                     ApplicationArea = All;
//                     Image = CashFlow;
//                     RunObject = Page "Cash Advance List";
//                 }
//             }

//         }
//         addafter("Payment Reconciliation Journals")
//         {
//             action("Payment Vouchers")
//             {
//                 ApplicationArea = Basic;
//                 //Image = List;
//                 //Promoted = true;
//                 RunObject = page "Payment Voucher List";
//             }
//             action("Pending Payment Voucher")
//             {
//                 ApplicationArea = Basic;
//                 Caption = 'Pending Payment Voucher';
//                 RunObject = Page "Pending Payment Voucher List";
//             }
//             action("Approved Payment Vouchers")
//             {
//                 ApplicationArea = Basic;
//                 //Image = List;
//                 //Promoted = true;
//                 RunObject = page "Approved Payment Voucher List";
//             }
//         }
//     }

//     var
//         myInt: Integer;
// }