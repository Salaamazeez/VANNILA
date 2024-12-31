Codeunit 50002 "Approval Mgt"
{
    Permissions = TableData "Approval Entry" = imd,
                  TableData "Approval Comment Line" = imd,
                  TableData "Posted Approval Entry" = imd,
                  TableData "Posted Approval Comment Line" = imd,
                  TableData "Overdue Approval Entry" = imd;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        NoWorkflowEnabledErr: label 'This record is not supported by related approval workflow.';

    procedure CheckGenericApprovalsWorkflowEnabled(var RecRef: RecordRef): Boolean
    var
        DocName: Text;
    begin
        if not IsGenericApprovalsWorkflowEnabled(RecRef) then
            Error(NoWorkflowEnabledErr);

        exit(true);
    end;

    procedure IsGenericApprovalsWorkflowEnabled(var RecRef: RecordRef): Boolean
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
                    DocName := 'PAYMENTREQUEST';
                    exit(WorkflowManagement.CanExecuteWorkflow(PaymentRequest, WorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Cash Advance":
                begin
                    RecRef.SetTable(CashAdvance);
                    DocName := 'CASHADVANCE';
                    exit(WorkflowManagement.CanExecuteWorkflow(CashAdvance, WorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::Retirement:
                begin
                    RecRef.SetTable(Retirement);
                    DocName := 'CASHRETIREMENT';
                    exit(WorkflowManagement.CanExecuteWorkflow(Retirement, WorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Cash Receipt":
                begin
                    RecRef.SetTable(CashReceipt);
                    DocName := 'CASHRECEIPT';
                    exit(WorkflowManagement.CanExecuteWorkflow(CashReceipt, WorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Payment Voucher Header":
                begin
                    RecRef.SetTable(PaymentVoucherHeader);
                    DocName := 'PAYMENTVOUCHER';
                    exit(WorkflowManagement.CanExecuteWorkflow(PaymentVoucherHeader, WorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
        end;
    end;

    procedure CheckAndApproveDoc(var RecRef: RecordRef): Boolean
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
                    CashAdvance.Validate(Status, CashAdvance.Status::Approved);
                    CashAdvance.Modify(true);
                end;
            Database::Retirement:
                begin
                    RecRef.SetTable(Retirement);
                    if not ApproveDoc(Retirement."No.") then
                        exit;
                    Retirement.Validate(Status, Retirement.Status::Approved);
                    Retirement.Modify(true);
                end;
            Database::"Cash Receipt":
                begin
                    RecRef.SetTable(CashReceipt);
                    if not ApproveDoc(CashReceipt."No.") then
                        exit;
                    CashReceipt.Validate(Status, CashReceipt.Status::Approved);
                    CashReceipt.Modify(true);
                end;
            Database::"Payment Voucher Header":
                begin
                    RecRef.SetTable(PaymentVoucherHeader);
                    if not ApproveDoc(PaymentVoucherHeader."No.") then
                        exit;
                    PaymentVoucherHeader.Validate(Status, PaymentVoucherHeader.Status::Approved);
                    PaymentVoucherHeader.Modify(true);
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        ReleaseDocuments: Codeunit "Release Documents";
    begin
        case RecRef.Number of
            GetTableIDForApproval(RecRef.Number):
                begin
                    ReleaseDocuments.SetCalledFromApproval(true);
                    ReleaseDocuments.PerformManualReopen(RecRef);
                    Handled := true;
                end;
        end;
    end;



    [IntegrationEvent(false, false)]

    procedure OnCancelGenericDocForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendGenericDocForApproval(RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnPopulateApprovalEntryArgumentCode(RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        PaymentReq: Record "Payment Requisition";
        CashAdvance: Record "Cash Advance";
        Retirement: Record Retirement;
        CashReceipt: Record "Cash Receipt";
        PaymentVoucherHeader: Record "Payment Voucher Header";
    Begin
        if WorkflowStepArgument.Get(WorkflowStepInstance.Argument) then
            ApprovalEntryArgument."Workflow User Group" := WorkflowStepArgument."Workflow User Group Code";
        case RecRef.Number of

            Database::"Payment Requisition":
                begin
                    RecRef.SetTable(PaymentReq);
                    //SetBeneficiary(PaymentReq.Beneficiary);
                    PaymentReq.CalcFields("Request Amount (LCY)", "Request Amount (LCY)");
                    ApprovalEntryArgument."Document No." := PaymentReq."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := PaymentReq."Request Amount";
                    ApprovalEntryArgument."Amount (LCY)" := PaymentReq."Request Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := PaymentReq."Currency Code";
                    ApprovalEntryArgument.Description := PaymentReq."Request Description";
                end;
            Database::"Cash Advance":
                begin
                    RecRef.SetTable(CashAdvance);
                    CashAdvance.CalcFields("Total Amount (LCY)", "Total Amount (LCY)");
                    ApprovalEntryArgument."Document No." := CashAdvance."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := CashAdvance."Total Amount";
                    ApprovalEntryArgument."Amount (LCY)" := CashAdvance."Total Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := CashAdvance."Currency Code";
                    ApprovalEntryArgument.Description := CashAdvance.Description;
                end;
            Database::Retirement:
                begin
                    RecRef.SetTable(Retirement);
                    Retirement.CalcFields(Amount, "Amount (LCY)");
                    ApprovalEntryArgument."Document No." := Retirement."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := Retirement.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := Retirement."Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := Retirement."Currency Code";
                    ApprovalEntryArgument.Description := Retirement.Purpose;
                end;
            Database::"Cash Receipt":
                begin
                    RecRef.SetTable(CashReceipt);
                    CashReceipt.CalcFields(Amount, "Amount (LCY)");
                    ApprovalEntryArgument."Document No." := CashReceipt."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := CashReceipt.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := CashReceipt."Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := CashReceipt."Currency Code";
                    ApprovalEntryArgument.Description := CashReceipt.Purpose;
                end;
            Database::"Payment Voucher Header":
                begin
                    RecRef.SetTable(PaymentVoucherHeader);
                    PaymentVoucherHeader.CalcFields("Request Amount", "Request Amount (LCY)");
                    ApprovalEntryArgument."Document No." := PaymentVoucherHeader."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := PaymentVoucherHeader."Request Amount";
                    ApprovalEntryArgument."Amount (LCY)" := PaymentVoucherHeader."Request Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := PaymentVoucherHeader."Currency Code";
                    ApprovalEntryArgument.Description := PaymentVoucherHeader."Request Description";
                end;

        end;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]

    procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        PaymentReq: Record "Payment Requisition";
        CashAdvance: Record "Cash Advance";
        Retirement: Record Retirement;
        CashReceipt: Record "Cash Receipt";
        PaymentVoucherHeader: Record "Payment Voucher Header";
    begin
        case RecRef.Number of
            Database::"Payment Requisition":
                begin
                    RecRef.SetTable(PaymentReq);
                    PaymentReq.Validate(Status, PaymentReq.Status::"Pending Approval");
                    PaymentReq.Modify(true);
                    Variant := PaymentReq;
                    IsHandled := true;
                end;
            Database::"Cash Advance":
                begin
                    RecRef.SetTable(CashAdvance);
                    CashAdvance.Validate(Status, CashAdvance.Status::"Pending Approval");
                    CashAdvance.Modify(true);
                    Variant := CashAdvance;
                    IsHandled := true;
                end;
            Database::Retirement:
                begin
                    RecRef.SetTable(Retirement);
                    Retirement.Validate(Status, Retirement.Status::"Pending Approval");
                    Retirement.Modify(true);
                    Variant := Retirement;
                    IsHandled := true;
                end;
            Database::"Cash Receipt":
                begin
                    RecRef.SetTable(CashReceipt);
                    CashReceipt.Validate(Status, CashReceipt.Status::"Pending Approval");
                    CashReceipt.Modify(true);
                    Variant := CashReceipt;
                    IsHandled := true;
                end;
            Database::"Payment Voucher Header":
                begin
                    RecRef.SetTable(PaymentVoucherHeader);
                    PaymentVoucherHeader.Validate(Status, PaymentVoucherHeader.Status::"Pending Approval");
                    PaymentVoucherHeader.Modify(true);
                    Variant := PaymentVoucherHeader;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeApprovalEntryInsert', '', false, false)]

    procedure OnBeforeApprovalEntryInsert(var ApprovalEntry: Record "Approval Entry"; ApprovalEntryArgument: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
    begin
        ApprovalEntry."Workflow User Group" := ApprovalEntryArgument."Workflow User Group";
        ApprovalEntry.Description := ApprovalEntryArgument.Description;
        UserSetup.Get(ApprovalEntry."Approver ID");
        // UserSetup.TestField("Employee No.");
        // ApprovalEntry."Employee No." := UserSetup."Employee No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]

    procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        lApprovalEntry: Record "Approval Entry";
        ApprovalConfirmMsg: Label 'Do you want to approve the request';
    begin

        //Message('Hello');
        if ApprovalEntry."Workflow User Group" = '' then
            exit;
        lApprovalEntry.SetCurrentkey("Table ID", "Document No.", "Workflow User Group", Status);
        lApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        lApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        lApprovalEntry.SetRange("Workflow User Group", ApprovalEntry."Workflow User Group");
        lApprovalEntry.SetRange("Sequence No.", ApprovalEntry."Sequence No." + 1);
        lApprovalEntry.SetRange(Status, lApprovalEntry.Status::Created);
        lApprovalEntry.ModifyAll(Status, lApprovalEntry.Status::Open);

        //end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnApproveApprovalRequest, '', false, false)]
    local procedure "Approvals Mgmt._OnApproveApprovalRequest"(var ApprovalEntry: Record "Approval Entry")
    var
        lApprovalEntry: Record "Approval Entry";
        ApprovalConfirmMsg: Label 'Do you want to approve the request';
    begin

        //Message('Hello');
        if ApprovalEntry."Workflow User Group" = '' then
            exit;
        lApprovalEntry.SetCurrentkey("Table ID", "Document No.", "Workflow User Group", Status);
        lApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
        lApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
        lApprovalEntry.SetRange("Workflow User Group", ApprovalEntry."Workflow User Group");
        lApprovalEntry.SetRange("Sequence No.", ApprovalEntry."Sequence No." + 1);
        lApprovalEntry.SetRange(Status, lApprovalEntry.Status::Created);
        lApprovalEntry.ModifyAll(Status, lApprovalEntry.Status::Open);

        //end;
    end;


    procedure RequiredApprovalReached(ApprovalEntry: Record "Approval Entry"): Boolean
    var
        ApprovalEntry2: Record "Approval Entry";
        WorkflowUserGrp: Record "Workflow User Group";
    begin
        if ApprovalEntry."Workflow User Group" = '' then
            exit;
        WorkflowUserGrp.Get(ApprovalEntry."Workflow User Group");
        if WorkflowUserGrp."No. of Required Approvals" = 0 then
            exit;
        ApprovalEntry.CalcFields("Number of Approved Requests");
        exit(ApprovalEntry."Number of Approved Requests" >= WorkflowUserGrp."No. of Required Approvals");
    end;

    procedure ApproveDoc(DocNo: Code[20]): Boolean
    var
        ApprovalEntry2: Record "Approval Entry";
        ApprovalEntry3: Record "Approval Entry";
    begin
        ApprovalEntry2.SetRange("Document No.", DocNo);
        ApprovalEntry2.SetFilter(Status, '%1|%2', ApprovalEntry2.Status::Created, ApprovalEntry2.Status::Open);

        ApprovalEntry3.SetCurrentKey("Table ID", "Record ID to Approve", Status, "Workflow Step Instance ID", "Sequence No.");
        ApprovalEntry3.SetRange("Document No.", DocNo);
        ApprovalEntry3.SetFilter(Status, '%1', ApprovalEntry3.Status::Created);
        exit(ApprovalEntry2.IsEmpty);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        ReleaseDocuments: Codeunit "Release Documents";
    begin
        case RecRef.Number of
            GetTableIDForApproval(RecRef.Number):
                begin
                    ReleaseDocuments.SetCalledFromApproval(true);
                    ReleaseDocuments.PerformanualManualDocRelease(RecRef);
                    Handled := true;
                end;
        end;
    end;

    procedure GetTableIDForApproval(TableID: Integer): Integer
    begin
        case TableID of
            //Treasury
            Database::"Payment Requisition":
                exit(Database::"Payment Requisition");
            Database::"Cash Advance":
                exit(Database::"Cash Advance");
            Database::"Payment Voucher Header":
                exit(Database::"Payment Voucher Header");
            Database::"Cash Receipt":
                exit(Database::"Cash Receipt");
            Database::Retirement:
                exit(Database::Retirement);
        end;
    end;

    procedure CheckAndRejectDoc(var RecRef: RecordRef): Boolean
    var
        CashAdvance: Record "Cash Advance";
        PaymentRequest: Record "Payment Requisition";
        Retirement: Record Retirement;
        CashReceipt: Record "Cash Receipt";
        PaymentVoucherHeader: Record "Payment Voucher Header";
        WorkflowEvent: Codeunit "Workflow Event";
        ApprovalCommentList: Page "Sales Comment Sheet";
        ApprovalComment: Record "Sales Comment Line";
        DocNo: Code[20];
    begin
        case RecRef.Number of
            Database::"Payment Requisition":
                begin
                    RecRef.SetTable(PaymentRequest);
                    if not ApproveDoc(PaymentRequest."No.") then
                        exit;
                    PaymentRequest.Status := PaymentRequest.Status::Open;
                    PaymentRequest.Modify();
                    DocNo := PaymentRequest."No.";
                end;
            Database::"Cash Advance":
                begin
                    RecRef.SetTable(CashAdvance);
                    if not ApproveDoc(CashAdvance."No.") then
                        exit;
                    CashAdvance.Status := CashAdvance.Status::Open;
                    CashAdvance.Modify();
                    DocNo := CashAdvance."No.";
                end;
            Database::Retirement:
                begin
                    RecRef.SetTable(Retirement);
                    if not ApproveDoc(Retirement."No.") then
                        exit;
                    Retirement.Status := Retirement.Status::Open;
                    Retirement.Modify();
                    DocNo := Retirement."No.";
                end;
            Database::"Cash Receipt":
                begin
                    RecRef.SetTable(CashReceipt);
                    if not ApproveDoc(CashReceipt."No.") then
                        exit;
                    CashReceipt.Status := CashReceipt.Status::Open;
                    CashReceipt.Modify();
                    DocNo := CashReceipt."No.";
                end;


            Database::"Payment Voucher Header":
                begin
                    RecRef.SetTable(PaymentVoucherHeader);
                    if not ApproveDoc(PaymentVoucherHeader."No.") then
                        exit;
                    PaymentVoucherHeader.Status := PaymentVoucherHeader.Status::Open;
                    PaymentVoucherHeader.Modify();
                    DocNo := CashReceipt."No.";
                end;
        end;
        if DocNo = '' then
            exit;
        //ApprovalComment.SetRange("Document Type", ApprovalComment."Document Type"::" ");
        ApprovalComment.SetRange("No.", DocNo);
        ApprovalCommentList.SetTableview(ApprovalComment);
        ApprovalCommentList.LookupMode := true;
        ApprovalCommentList.Run();

    end;



    [IntegrationEvent(true, false)]
    PROCEDURE OnApproveApprovalRequestHook(VAR ApprovalEntry: Record "Approval Entry");
    BEGIN
    END;


    var
        DocName: Text;
}