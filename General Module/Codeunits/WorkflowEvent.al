Codeunit 50003 "Workflow Event"
{

    trigger OnRun()
    begin
    end;

    var
        WorkflowEventMgt: Codeunit "Workflow Event Handling";
        WorkflowManagement: Codeunit "Workflow Management";
        GlobalUserSetup: Record "User Setup";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddWorkflowEventsToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        //Payment Management
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendPaymentRequestForApprovalCode',
          Database::"Payment Requisition", 'Approval of a payment request is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelPaymentRequestForApprovalCode',
          Database::"Payment Requisition", 'An approval request for a payment request is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendCashAdvanceForApprovalCode',
          Database::"Cash Advance", 'Approval of a cash advance is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelCashAdvanceForApprovalCode',
          Database::"Cash Advance", 'An approval request for a cash advance is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendCashRetirementForApprovalCode',
          Database::Retirement, 'Approval of a cash retirement is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelCashRetirementForApprovalCode',
          Database::Retirement, 'An approval request for a cash retirement is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendCashReceiptForApprovalCode',
          Database::"Cash Receipt", 'Approval of a cash receipt is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelCashReceiptForApprovalCode',
          Database::"Cash Receipt", 'An approval request for a cash receipt is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendPaymentVoucherForApprovalCode',
          Database::"Payment Voucher Header", 'Approval of a payment voucher is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelPaymentVoucherForApprovalCode',
          Database::"Payment Voucher Header", 'An approval request for a payment voucher is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendLeaveApplicationForApprovalCode',
                 Database::"Payment Voucher Header", 'Approval of a leave application is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelLeaveApplicationForApprovalCode',
          Database::"Payment Voucher Header", 'An approval request for a leave application is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendPerformanceAppraisalForApprovalCode',
                        Database::"Payment Voucher Header", 'Approval of a performance appraisal is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelPerformanceAppraisalForApprovalCode',
          Database::"Payment Voucher Header", 'An approval request for a performance appraisal is cancelled', 0, false);

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgt", 'OnSendGenericDocForApproval', '', false, false)]
    local procedure RunWorkflowOnSendGenericDocForApproval(RecRef: RecordRef)
    var
        PaymentReq: Record "Payment Requisition";
        CashAdvance: Record "Cash Advance";
        Retirement: Record Retirement;
        CashReceipt: Record "Cash Receipt";
        PaymentVoucherHeader: Record "Payment Voucher Header";
        LeaveApplication: Record LeaveApplication;
        PerformanceAppraisal: Record PerformanceAppraisalHeader;
    begin
        //WorkflowManagement.SetMobileUserID(GlobalUserSetup."User ID");
        case RecRef.Number of
            Database::"Payment Requisition":
                begin
                    RecRef.SetTable(PaymentReq);
                    DocName := 'PAYMENTREQUEST';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), PaymentReq);
                end;
            Database::"Cash Advance":
                begin
                    RecRef.SetTable(CashAdvance);
                    DocName := 'CASHADVANCE';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), CashAdvance);
                end;
            Database::Retirement:
                begin
                    RecRef.SetTable(Retirement);
                    DocName := 'CASHRETIREMENT';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), Retirement);
                end;
            Database::"Cash Receipt":
                begin
                    RecRef.SetTable(CashReceipt);
                    DocName := 'CASHRECEIPT';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), CashReceipt);
                end;
            Database::"Payment Voucher Header":
                begin
                    RecRef.SetTable(PaymentVoucherHeader);
                    DocName := 'PAYMENTVOUCHER';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), PaymentVoucherHeader);
                end;
            Database::LeaveApplication:
                begin
                    RecRef.SetTable(LeaveApplication);
                    DocName := 'LEAVEAPPLICATION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), LeaveApplication);
                end;
            Database::PerformanceAppraisalHeader:
                begin
                    RecRef.SetTable(PerformanceAppraisal);
                    DocName := 'PERFORMANCEAPPRAISAL';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), PerformanceAppraisal);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Mgt", 'OnCancelGenericDocForApproval', '', false, false)]
    local procedure RunWorkflowOnCancelGenericDocForApproval(var RecRef: RecordRef)
    var
        PaymentReq: Record "Payment Requisition";
        CashAdvance: Record "Cash Advance";
        Retirement: Record Retirement;
        CashReceipt: Record "Cash Receipt";
        PaymentVoucherHeader: Record "Payment Voucher Header";
        LeaveApplication: Record LeaveApplication;
        PerformanceAppraisal: Record PerformanceAppraisalHeader;
    begin

        //WorkflowManagement.SetMobileUserID(GlobalUserSetup."User ID");
        case RecRef.Number of
            Database::"Payment Requisition":
                begin
                    RecRef.SetTable(PaymentReq);
                    DocName := 'PAYMENTREQUEST';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), PaymentReq);
                end;
            Database::"Cash Advance":
                begin
                    RecRef.SetTable(CashAdvance);
                    DocName := 'CASHADVANCE';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), CashAdvance);
                end;
            Database::Retirement:
                begin
                    RecRef.SetTable(Retirement);
                    DocName := 'RETIREMENT';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), Retirement);
                end;
            Database::"Cash Receipt":
                begin
                    RecRef.SetTable(CashReceipt);
                    DocName := 'CASHRECEIPT';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), CashReceipt);
                end;
            Database::"Payment Voucher Header":
                begin
                    RecRef.SetTable(PaymentVoucherHeader);
                    DocName := 'PAYMENTVOUCHER';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), PaymentVoucherHeader);
                end;
            Database::LeaveApplication:
                begin
                    RecRef.SetTable(LeaveApplication);
                    DocName := 'LEAVEAPPLICATION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), LeaveApplication);
                end;
            Database::PerformanceAppraisalHeader:
                begin
                    RecRef.SetTable(PerformanceAppraisal);
                    DocName := 'PERFORMANCEAPPRAISAL';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), PerformanceAppraisal);
                end;
        end;

    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnSetStatusToPendingApproval, '', false, false)]
    // local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean);
    // var
    //     PaymentReq: Record "Payment Requisition";
    //     CashAdvance: Record "Cash Advance";
    // begin
    //     case RecRef.Number of
    //         Database::"Payment Requisition":
    //             begin
    //                 RecRef.SetTable(PaymentReq);
    //                 PaymentReq.Validate(Status, PaymentReq.Status::"Pending Approval");
    //                 PaymentReq.Modify(true);
    //                 Variant := PaymentReq;
    //                 IsHandled := true;
    //             end;
    //         Database::"Cash Advance":
    //             begin
    //                 RecRef.SetTable(CashAdvance);
    //                 CashAdvance.Validate(Status, CashAdvance.Status::"Pending Approval");
    //                 CashAdvance.Modify(true);
    //                 Variant := CashAdvance;
    //                 IsHandled := true;
    //             end;
    //     end;
    // end;


    procedure RunWorkflowOnSendGenericDocForApprovalCode(var DocName: Text[40]): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSend' + DocName + 'ForApprovalCode'));
    end;


    procedure RunWorkflowOnCancelGenericDocForApprovalCode(var DocName: Text[40]): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancel' + DocName + 'ForApprovalCode'));
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendGenericDocForApproval(RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelGenericDocForApproval(var RecRef: RecordRef)
    begin
    end;

    var
        DocName: Text;
}