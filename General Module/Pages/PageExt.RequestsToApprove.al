pageextension 50020 RequestToApproveExt extends "Requests to Approve"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify(Approve)
        {
            trigger OnAfterAction()
            var
                Variant: Variant;
                ApprovalEntry: Record "Approval Entry";
                RecRef: RecordRef;
                ApprovalMgt: Codeunit "Approval Mgt";

            begin
                CurrPage.SetSelectionFilter(Rec);
                RecRef.GetTable(Rec);
                if not RecRef.Get(Rec."Record ID to Approve") then
                    exit;
                RecRef.SetRecFilter();
                ApprovalMgt.CheckAndApproveDoc(RecRef);
            end;
        }
        modify(Reject)
        {
            trigger OnAfterAction()
            var
                Variant: Variant;
                ApprovalEntry: Record "Approval Entry";
                RecRef: RecordRef;
                ApprovalMgt: Codeunit "Approval Mgt";
            begin
                CurrPage.SetSelectionFilter(Rec);
                RecRef.GetTable(Rec);
                if not RecRef.Get(Rec."Record ID to Approve") then
                    exit;
                RecRef.SetRecFilter();
                ApprovalMgt.CheckAndRejectDoc(RecRef);
            end;
        }

    }

    local procedure CheckAndApproveDoc(var RecRef: RecordRef): Boolean
    var
        CashAdvance: Record "Cash Advance";
        PaymentRequest: Record "Payment Requisition";
        Retirement: Record Retirement;
        CashReceipt: Record "Cash Receipt";
        PaymentVoucherHeader: Record "Payment Voucher Header";
        WorkflowEvent: Codeunit "Workflow Event";
    begin
        case RecRef.Number of
            Database::"Payment Requisition":
                begin
                    RecRef.SetTable(PaymentRequest);
                    if not ApproveDoc(PaymentRequest."No.") then
                        exit;
                    PaymentRequest.Status := PaymentRequest.Status::Approved;
                    PaymentRequest.Modify();
                end;
            Database::"Cash Advance":
                begin
                    RecRef.SetTable(CashAdvance);
                    if not ApproveDoc(CashAdvance."No.") then
                        exit;
                    CashAdvance.Status := CashAdvance.Status::Approved;
                    CashAdvance.Modify();
                end;
            Database::Retirement:
                begin
                    RecRef.SetTable(Retirement);
                    if not ApproveDoc(Retirement."No.") then
                        exit;
                    Retirement.Status := Retirement.Status::Approved;
                    Retirement.Modify();
                end;
            Database::"Cash Receipt":
                begin
                    RecRef.SetTable(CashReceipt);
                    if not ApproveDoc(CashReceipt."No.") then
                        exit;
                    CashReceipt.Status := CashReceipt.Status::Approved;
                    CashReceipt.Modify();
                end;
            Database::"Payment Voucher Header":
                begin
                    RecRef.SetTable(PaymentVoucherHeader);
                    if not ApproveDoc(PaymentVoucherHeader."No.") then
                        exit;
                    PaymentVoucherHeader.Status := PaymentVoucherHeader.Status::Approved;
                    PaymentVoucherHeader.Modify();
                end;
        end;
    end;

    local procedure CheckAndRejectDoc(var RecRef: RecordRef): Boolean
    var
        CashAdvance: Record "Cash Advance";
        PaymentRequest: Record "Payment Requisition";
        Retirement: Record Retirement;
        CashReceipt: Record "Cash Receipt";
        PaymentVoucherHeader: Record "Payment Voucher Header";
        WorkflowEvent: Codeunit "Workflow Event";
    begin
        case RecRef.Number of
            Database::"Payment Requisition":
                begin
                    RecRef.SetTable(PaymentRequest);
                    if not ApproveDoc(PaymentRequest."No.") then
                        exit;
                    PaymentRequest.Status := PaymentRequest.Status::Open;
                    PaymentRequest.Modify();
                end;
            Database::"Cash Advance":
                begin
                    RecRef.SetTable(CashAdvance);
                    if not ApproveDoc(CashAdvance."No.") then
                        exit;
                    CashAdvance.Status := CashAdvance.Status::Open;
                    CashAdvance.Modify();
                end;
            Database::Retirement:
                begin
                    RecRef.SetTable(Retirement);
                    if not ApproveDoc(Retirement."No.") then
                        exit;
                    Retirement.Status := Retirement.Status::Open;
                    Retirement.Modify();
                end;
            Database::"Cash Receipt":
                begin
                    RecRef.SetTable(CashReceipt);
                    if not ApproveDoc(CashReceipt."No.") then
                        exit;
                    CashReceipt.Status := CashReceipt.Status::Open;
                    CashReceipt.Modify();
                end;
            Database::"Payment Voucher Header":
                begin
                    RecRef.SetTable(PaymentVoucherHeader);
                    if not ApproveDoc(PaymentVoucherHeader."No.") then
                        exit;
                    PaymentVoucherHeader.Status := PaymentVoucherHeader.Status::Open;
                    PaymentVoucherHeader.Modify();
                end;
        end;
    end;


    local procedure ApproveDoc(DocNo: Code[20]): Boolean//Also useful for reject
    var
        ApprovalEntry2: Record "Approval Entry";
    begin
        ApprovalEntry2.SetRange("Document No.", DocNo);
        ApprovalEntry2.SetFilter(Status, '%1|%2', ApprovalEntry2.Status::Created, ApprovalEntry2.Status::Open);
        exit(ApprovalEntry2.IsEmpty);
    end;
}
