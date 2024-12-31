// codeunit 50011 WorkFlowEventKBS
// {

//     trigger OnRun()
//     begin
//         AddWorkflowEventToLibrary;
//     end;

//     var
//         WorkflowManagement: Codeunit "Workflow Management";
//         // LeaveAppRec: Record "50009";
//         // LeaveAdjRec: Record "50012";
//         // LeaveAllowRec: Record "50022";
//         // PayrollRec: Record "50017";
//         // PayHeaderRec: Record "50025";
//         // EmpLoanRec: Record "50001";
//         // PayrollBookRec: Record "50005";
//         ApprovalEntryTable: Record "Approval Entry";
//         //SMAIL: Codeunit "400";
//         MailBody: Text;
//         WorkflowEventHandling: Codeunit 1520;
//         WKFlowEvent: Codeunit 50011;
//         CustRec: Record 18;
//         Itemrec: Record 27;
//         FixedAstRec: Record 5600;
//         BankRec: Record 270;
//         VendRec: Record 23;
//         EmployeeRec: Record 5200;
//         GLAcctRec: Record 15;
//         JobRec: Record 167;
//         SendMail: Codeunit 50001;

//     [EventSubscriber(ObjectType::Codeunit, 1520, 'OnAddWorkflowTableRelationsToLibrary', '', false, false)]
//     local procedure AddWorkflowTableReationsToLibrary()
//     var
//         WorkflowSetup: Codeunit "1502";
//     begin
//         WorkflowSetup.InsertTableRelation(DATABASE::Job, 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::"Leave Application", 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::"Leave Adjustment Header", 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::"Leave Allowance", 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::"Payroll Header", 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::"Payroll Book", 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::"Payment Header", 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::"Employee Loans", 0, DATABASE::"Approval Entry", 22);

//         WorkflowSetup.InsertTableRelation(DATABASE::Employee, 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::Customer, 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::Item, 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::"Fixed Asset", 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::"Bank Account", 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::Vendor, 0, DATABASE::"Approval Entry", 22);
//         WorkflowSetup.InsertTableRelation(DATABASE::"G/L Account", 0, DATABASE::"Approval Entry", 22);

//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1520, 'OnAddWorkflowEventsToLibrary', '', false, false)]
//     local procedure AddWorkflowEventToLibrary()
//     var
//         WorkflowEventHandling: Codeunit 1520;
//     begin

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendLeaveAppforApprovalCode, DATABASE::"Leave Application", 'Send Leave Application for aproval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelLeaveAppforApprovalCode, DATABASE::"Leave Application", 'Cancel aproval for Leave Application', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendLeaveAdjforApprovalCode, DATABASE::"Leave Adjustment Header", 'Send Leave Adjustment for approval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelLeaveAdjforApprovalCode, DATABASE::"Leave Adjustment Header", 'Cancel Approval for Leave Adjustment', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendLeaveAllowforApprovalCode, DATABASE::"Leave Allowance", 'Send Leave Allowancent for approval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelLeaveAllowforApprovalCode, DATABASE::"Leave Allowance", 'Cancel Approval for Leave Allowance', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPayrollforApprovalCode, DATABASE::"Payroll Header", 'Send Payroll for approval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPayrollforApprovalCode, DATABASE::"Payroll Header", 'Cancel Approval for Payroll', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPayHeaderforApprovalCode, DATABASE::"Payment Header", 'Send Payment Voucher for approval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPayHeaderforApprovalCode, DATABASE::"Payment Header", 'Cancel Approval for Payment Voucher', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendEmpLoanforApprovalCode, DATABASE::"Employee Loans", 'Send Employee Loan for approval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelEmpLoanforApprovalCode, DATABASE::"Employee Loans", 'Cancel Approval for Employee Loan', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPayrollBkforApprovalCode, DATABASE::"Payroll Book", 'Send Payroll Book document for approval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPayrollBkforApprovalCode, DATABASE::"Payroll Book", 'Cancel Approval for Payroll Book document', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendCustforApprovalCode, DATABASE::Customer, 'Send Customer card for approval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelCustforApprovalCode, DATABASE::Customer, 'Cancel Approval for Customer Card', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendItemforApprovalCode, DATABASE::Item, 'Send Item card for approval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelItemforApprovalCode, DATABASE::Item, 'Cancel Approval for Item Card', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendFixedAstforApprovalCode, DATABASE::"Fixed Asset", 'Send Fixed Asset for approval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelFixedAstforApprovalCode, DATABASE::"Fixed Asset", 'Cancel Approval for Fixed Asset', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendBankforApprovalCode, DATABASE::"Bank Account", 'Send Bank Account for approval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelBankforApprovalCode, DATABASE::"Bank Account", 'Cancel Approval for Bank Account', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendVendforApprovalCode, DATABASE::Vendor, 'Send Vendor Card for approval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelVendforApprovalCode, DATABASE::Vendor, 'Cancel Approval for Vendor Card', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendEmployeeforApprovalCode, DATABASE::Employee, 'Send Employee for aproval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelEmployeeforApprovalCode, DATABASE::Employee, 'Cancel aproval for Employee', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendGLAcctforApprovalCode, DATABASE::"G/L Account", 'Send G/L Account Card for approval', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelGLAcctforApprovalCode, DATABASE::"G/L Account", 'Cancel Approval for G/L Account Card', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendJobTMforApprovalCode, DATABASE::Job, 'Send Job for aproval - Please', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelJobTMforApprovalCode, DATABASE::Job, 'Cancel aproval for Job - Please', 0, FALSE);


//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforJobTMCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Job', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforJobTMCode, DATABASE::"Approval Entry",
//         'Reject Approval For Job', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforJobTMCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Job', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforLeaveAppCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Leave Application', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforLeaveAppCode, DATABASE::"Approval Entry",
//         'Reject Approval For Leave Application', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforLeaveAppCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Leave Application', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforLeaveAdjCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Leave Adjustment', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforLeaveAdjCode, DATABASE::"Approval Entry",
//         'Reject Approval For Leave Adjustment', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforLeaveAdjCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Leave Adjustment', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforPayrollCode, DATABASE::"Approval Entry",
//         'Approve Approval Request for Payroll', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforPayrollCode, DATABASE::"Approval Entry",
//         'Reject approval for Payroll', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforPayrollCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Payroll', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforPayHeaderCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Payment Voucher', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforPayHeaderCode, DATABASE::"Approval Entry",
//         'Reject Approval For Payment Voucher', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforPayheaderCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Payment Voucher', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforPayrollBkCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Payroll Book', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforPayrollBkCode, DATABASE::"Approval Entry",
//         'Reject Approval For Payroll Book', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforPayrollBkCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Payroll Book', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforEmpLoanCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Employee Loan', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforEmpLoanCode, DATABASE::"Approval Entry",
//         'Reject Approval For Employee Loan', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforEmpLoanCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Employee Loan', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforLeaveAllowCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Leave Allowance', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforLeaveAllowCode, DATABASE::"Approval Entry",
//         'Reject Approval For Leave Allowance', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforLeaveAllowCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Leave Allowance', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforCustCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Customer Card', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforCustCode, DATABASE::"Approval Entry",
//         'Reject Approval For Customer Card', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforCustCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Customer Card', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforItemCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Item Card', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforItemCode, DATABASE::"Approval Entry",
//         'Reject Approval For Item Card', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforItemCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Item Card', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforFixedAstCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Fixed Asset', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforFixedAstCode, DATABASE::"Approval Entry",
//         'Reject Approval For Fixed Asset', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforFixedAstCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Fixed Asset', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforBankCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Bank Account', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforBankCode, DATABASE::"Approval Entry",
//         'Reject Approval For Bank Account', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforBankCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Bank Account', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforVendCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Vendor Card', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforVendCode, DATABASE::"Approval Entry",
//         'Reject Approval For Vendor Card', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforVendCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Vendor Card', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforGLAcctCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For GL Account', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforGLAcctCode, DATABASE::"Approval Entry",
//         'Reject Approval For GL Account', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforGLAcctCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for GL Account', 0, FALSE);

//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestforEmployeeCode, DATABASE::"Approval Entry",
//         'Approve Approval Request For Employee', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowRejectApprovalRequestforEmployeeCode, DATABASE::"Approval Entry",
//         'Reject Approval For Employee', 0, FALSE);
//         WorkflowEventHandling.AddEventToLibrary(RunWorkflowDelegateApprovalRequestforEmployeeCode, DATABASE::"Approval Entry",
//         'Delegate Approval Request for Employee', 0, FALSE);
//     end;

//     local procedure "--LEAVE APPLICATION CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelLeaveAppforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelLeaveAppforApproval'));
//     end;

//     /* [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelLeaveAppforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelLeaveAppforApproval(var LeaveApp: Record 50009)
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelLeaveAppforApprovalCode, LeaveApp);

//         LeaveApp."Approval Status" := LeaveApp."Approval Status"::Open;
//         LeaveApp.MODIFY(TRUE);
//     end;
//  */
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendLeaveAppforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendLeaveAppforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendLeaveAppforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendLeaveAppforApproval(var LeaveApp: Record "50009")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendLeaveAppforApprovalCode, LeaveApp);

//         LeaveApp."Approval Status" := LeaveApp."Approval Status"::"Pending Approval";
//         LeaveApp.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforLeaveApp(var ApprovalEntry: Record "454")
//     begin
//         LeaveAppRec.RESET;
//         LeaveAppRec.SETRANGE("Leave Code", ApprovalEntry."Document No.");
//         IF LeaveAppRec.FINDFIRST THEN BEGIN
//             LeaveAppRec."Approval Status" := LeaveAppRec."Approval Status"::Approved;
//             LeaveAppRec.MODIFY(TRUE);
//             SendMail.SendHRNotificationEmail(LeaveAppRec);
//         END;

//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforLeaveAppCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforLeaveAppCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforLeaveApp'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforLeaveApp(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforLeaveAppCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         LeaveAppRec.RESET;
//         LeaveAppRec.SETRANGE("Leave Code", ApprovalEntry."Document No.");
//         IF LeaveAppRec.FINDFIRST THEN BEGIN
//             LeaveAppRec."Approval Status" := LeaveAppRec."Approval Status"::Open;
//             LeaveAppRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforLeaveAppCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforLeaveApp'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforLeaveApp(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforLeaveAppCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");


//         LeaveAppRec.RESET;
//         LeaveAppRec.SETRANGE("Leave Code", ApprovalEntry."Document No.");
//         IF LeaveAppRec.FINDFIRST THEN BEGIN
//             LeaveAppRec."Approval Status" := LeaveAppRec."Approval Status"::"Pending Approval";
//             LeaveAppRec.MODIFY(TRUE);
//         END;

//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforLeaveAppCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforLeaveApp'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendLeaveAppforApproval(var LeaveApp: Record "50009")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelLeaveAppforApproval(var LeaveApp: Record "50009")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsLeaveAppApprovalsWorkflowEnabled(leaveApp: Record "50009"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(leaveApp, WKFlowEvent.RunWorkflowOnSendLeaveAppforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckLeaveAppApprovalsWorkflowEnabled(var Rec: Record "50009"): Boolean
//     begin
//         IF NOT IsLeaveAppApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 50020, 'OnAfterActionEvent', 'Action27', false, false)]
//     local procedure SendLeaveforApprovalFunction(var Rec: Record "50009")
//     begin
//         IF WKFlowEvent.CheckLeaveAppApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendLeaveAppforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 50020, 'OnAfterActionEvent', '<Action58>', false, false)]
//     local procedure CancelLeaveforApprovalFunction(var Rec: Record "50009")
//     begin
//         WKFlowEvent.OnCancelLeaveAppforApproval(Rec);
//     end;

//     local procedure "---LEAVE APPLICATION CARD---"()
//     begin
//     end;

//     local procedure "--LEAVE ADJUSTMENT CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelLeaveAdjforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelLeaveAdjforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelLeaveAdjforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelLeaveAdjforApproval(var LeaveAdj: Record "50012")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelLeaveAdjforApprovalCode, LeaveAdj);

//         LeaveAdj.Status := LeaveAdj.Status::Open;
//         LeaveAdj.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendLeaveAdjforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendLeaveAdjforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendLeaveAdjforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendLeaveAdjforApproval(var LeaveAdj: Record "50012")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendLeaveAdjforApprovalCode, LeaveAdj);

//         LeaveAdj.Status := LeaveAdj.Status::"Pending Approval";
//         LeaveAdj.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforLeaveAdj(var ApprovalEntry: Record "454")
//     begin
//         LeaveAdjRec.RESET;
//         LeaveAdjRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF LeaveAdjRec.FINDFIRST THEN BEGIN
//             LeaveAdjRec.Status := LeaveAdjRec.Status::Released;
//             LeaveAdjRec.MODIFY(TRUE);
//         END;


//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforLeaveAdjCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforLeaveAdjCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforLeaveAdj'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforLeaveAdj(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforLeaveAdjCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         LeaveAdjRec.RESET;
//         LeaveAdjRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF LeaveAdjRec.FINDFIRST THEN BEGIN
//             LeaveAdjRec.Status := LeaveAdjRec.Status::Open;
//             LeaveAdjRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforLeaveAdjCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforLeaveAdj'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforLeaveAdj(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforLeaveAdjCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");


//         LeaveAdjRec.RESET;
//         LeaveAdjRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF LeaveAdjRec.FINDFIRST THEN BEGIN
//             LeaveAdjRec.Status := LeaveAdjRec.Status::"Pending Approval";
//             LeaveAdjRec.MODIFY(TRUE);
//         END;

//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforLeaveAdjCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforLeaveAdj'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendLeaveAdjforApproval(var LeaveAdj: Record "50012")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelLeaveAdjforApproval(var LeaveAdj: Record "50012")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsLeaveAdjApprovalsWorkflowEnabled(LeaveAdj: Record "50012"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(LeaveAdj, WKFlowEvent.RunWorkflowOnSendLeaveAdjforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckLeaveAdjApprovalsWorkflowEnabled(var Rec: Record "50012"): Boolean
//     begin
//         IF NOT IsLeaveAdjApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 50022, 'OnAfterActionEvent', 'Action22', false, false)]
//     local procedure SendLeaveAdjforApprovalFunction(var Rec: Record "50012")
//     begin
//         IF WKFlowEvent.CheckLeaveAdjApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendLeaveAdjforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 50022, 'OnAfterActionEvent', 'Action21', false, false)]
//     local procedure CancelLeaveAdjforApprovalFunction(var Rec: Record "50012")
//     begin
//         //IF WKFlowEvent.CheckLeaveAdjApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelLeaveAdjforApproval(Rec);
//         //END;
//     end;

//     local procedure "---LEAVE ADJUSTMENT CARD---"()
//     begin
//     end;

//     local procedure "--LEAVE ALLOWANCE CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelLeaveAllowforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelLeaveAllowforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelLeaveAllowApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelLeaveAllowforApproval(var LeaveAllow: Record "50022")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelLeaveAllowforApprovalCode, LeaveAllow);

//         LeaveAllow."Approval Status" := LeaveAllow."Approval Status"::Open;
//         LeaveAllow.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendLeaveAllowforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendLeaveAllowforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendLeaveAllowforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendLeaveAllowforApproval(var LeaveAllow: Record "50022")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendLeaveAllowforApprovalCode, LeaveAllow);

//         LeaveAllow."Approval Status" := LeaveAllow."Approval Status"::"Pending Approval";
//         LeaveAllow.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforLeaveAllow(var ApprovalEntry: Record "454")
//     begin
//         LeaveAllowRec.RESET;
//         LeaveAllowRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF LeaveAllowRec.FINDFIRST THEN BEGIN
//             LeaveAllowRec."Approval Status" := LeaveAllowRec."Approval Status"::Approved;
//             LeaveAllowRec.MODIFY(TRUE);
//         END;

//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforLeaveAllowCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforLeaveAllowCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforLeaveAllow'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforLeaveAllow(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforLeaveAllowCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         LeaveAllowRec.RESET;
//         LeaveAllowRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF LeaveAllowRec.FINDFIRST THEN BEGIN
//             LeaveAllowRec."Approval Status" := LeaveAllowRec."Approval Status"::Open;
//             LeaveAllowRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforLeaveAllowCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforLeaveAllow'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforLeaveAllow(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforLeaveAllowCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");


//         LeaveAllowRec.RESET;
//         LeaveAllowRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF LeaveAllowRec.FINDFIRST THEN BEGIN
//             LeaveAllowRec."Approval Status" := LeaveAllowRec."Approval Status"::"Pending Approval";
//             LeaveAllowRec.MODIFY(TRUE);
//         END;

//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforLeaveAllowCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforLeaveAllow'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendLeaveAllowforApproval(var LeaveAllow: Record "50022")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelLeaveAllowforApproval(var LeaveAllow: Record "50022")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsLeaveAllowApprovalsWorkflowEnabled(LeaveAllow: Record "50022"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(LeaveAllow, WKFlowEvent.RunWorkflowOnSendLeaveAllowforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckLeaveAllowApprovalsWorkflowEnabled(var Rec: Record "50022"): Boolean
//     begin
//         IF NOT IsLeaveAllowApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 50030, 'OnAfterActionEvent', 'Action32', false, false)]
//     local procedure SendLeaveAllowforApprovalFunction(var Rec: Record "50022")
//     begin
//         IF WKFlowEvent.CheckLeaveAllowApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendLeaveAllowforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 50030, 'OnAfterActionEvent', 'Action31', false, false)]
//     local procedure CancelLeaveAllowforApprovalFunction(var Rec: Record "50022")
//     begin
//         //IF WKFlowEvent.CheckLeaveAdjApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelLeaveAllowforApproval(Rec);
//         //END;
//     end;

//     local procedure "---LEAVE ALLOWANCE CARD---"()
//     begin
//     end;

//     local procedure "--EMPLOYEE LOAN CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelEmpLoanforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelEmpLoanforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelEmpLoanforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelEmpLoanforApproval(var EmpLoan: Record "50001")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelEmpLoanforApprovalCode, EmpLoan);

//         EmpLoan."Approval Status" := EmpLoan."Approval Status"::Open;
//         EmpLoan.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendEmpLoanforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendEmpLoanforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendEmpLoanforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendEmpLoanforApproval(var EmpLoan: Record "50001")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendEmpLoanforApprovalCode, EmpLoan);

//         EmpLoan."Approval Status" := EmpLoan."Approval Status"::"Pending Approval";
//         EmpLoan.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforEmpLoan(var ApprovalEntry: Record "454")
//     begin
//         EmpLoanRec.RESET;
//         EmpLoanRec.SETRANGE("Loan ID", ApprovalEntry."Document No.");
//         IF EmpLoanRec.FINDFIRST THEN BEGIN
//             EmpLoanRec."Approval Status" := EmpLoanRec."Approval Status"::Approved;
//             EmpLoanRec.MODIFY(TRUE);
//         END;

//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforEmpLoanCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforEmpLoanCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforEmpLoan'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforEmpLoan(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforEmpLoanCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         EmpLoanRec.RESET;
//         EmpLoanRec.SETRANGE("Loan ID", ApprovalEntry."Document No.");
//         IF EmpLoanRec.FINDFIRST THEN BEGIN
//             EmpLoanRec."Approval Status" := EmpLoanRec."Approval Status"::Open;
//             EmpLoanRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforEmpLoanCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforEmpLoan'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforEmpLoan(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforEmpLoanCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");


//         EmpLoanRec.RESET;
//         EmpLoanRec.SETRANGE("Loan ID", ApprovalEntry."Document No.");
//         IF EmpLoanRec.FINDFIRST THEN BEGIN
//             EmpLoanRec."Approval Status" := EmpLoanRec."Approval Status"::"Pending Approval";
//             EmpLoanRec.MODIFY(TRUE);
//         END;

//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforEmpLoanCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforEmpLoan'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendEmpLoanforApproval(var EmpLoan: Record "50001")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelEmpLoanforApproval(var EmpLoan: Record "50001")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsEmpLoanApprovalsWorkflowEnabled(EmpLoan: Record "50001"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(EmpLoan, WKFlowEvent.RunWorkflowOnSendEmpLoanforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckEmpLoanApprovalsWorkflowEnabled(var Rec: Record "50001"): Boolean
//     begin
//         IF NOT IsEmpLoanApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 50000, 'OnAfterActionEvent', 'SendApprovalRequest', false, false)]
//     local procedure SendEmpLoanforApprovalFunction(var Rec: Record "50001")
//     begin
//         IF WKFlowEvent.CheckEmpLoanApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendEmpLoanforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 50000, 'OnAfterActionEvent', 'CancelApprovalRequest', false, false)]
//     local procedure CancelEmpLoanforApprovalFunction(var Rec: Record "50001")
//     begin
//         //IF WKFlowEvent.CheckLeaveAdjApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelEmpLoanforApproval(Rec);
//         //END;
//     end;

//     local procedure "---EMPLOYEE LOAN CARD---"()
//     begin
//     end;

//     local procedure "--PAYMENT HEADER CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelPayHeaderforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelPayHeaderforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelPayforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelPayHeaderforApproval(var PayHeader: Record "50025")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelPayHeaderforApprovalCode, PayHeader);

//         PayHeader.Status := PayHeader.Status::Open;
//         PayHeader.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendPayHeaderforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendPayHeaderforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendPayforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendPayHeaderforApproval(var PayHeader: Record "50025")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendPayHeaderforApprovalCode, PayHeader);

//         PayHeader.Status := PayHeader.Status::"Pending Approval";
//         PayHeader.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforPayHeader(var ApprovalEntry: Record "454")
//     begin
//         PayHeaderRec.RESET;
//         PayHeaderRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF PayHeaderRec.FINDFIRST THEN BEGIN
//             PayHeaderRec.Status := PayHeaderRec.Status::Released;
//             PayHeaderRec.MODIFY(TRUE);
//         END;

//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforPayHeaderCode,
//         ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforPayHeaderCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforPayHeader'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforPayHeader(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforPayHeaderCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         PayHeaderRec.RESET;
//         PayHeaderRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF PayHeaderRec.FINDFIRST THEN BEGIN
//             PayHeaderRec.Status := PayHeaderRec.Status::Open;
//             PayHeaderRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforPayHeaderCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforPayHeader'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforPayHeader(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforPayheaderCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         PayHeaderRec.RESET;
//         PayHeaderRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF PayHeaderRec.FINDFIRST THEN BEGIN
//             PayHeaderRec.Status := PayHeaderRec.Status::"Pending Approval";
//             PayHeaderRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforPayheaderCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforPayHeader'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendPayforApproval(var PayHeader: Record "50025")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelPayforApproval(var PayHeader: Record "50025")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsPayApprovalsWorkflowEnabled(PayHeader: Record "50025"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(PayHeader, WKFlowEvent.RunWorkflowOnSendPayHeaderforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckPayApprovalsWorkflowEnabled(var Rec: Record "50025"): Boolean
//     begin
//         IF NOT IsPayApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 50049, 'OnAfterActionEvent', 'SendApprovalRequest', false, false)]
//     local procedure SendPayforApprovalFunction(var Rec: Record "50025")
//     begin
//         IF WKFlowEvent.CheckPayApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendPayforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 50049, 'OnAfterActionEvent', 'CancelApprovalRequest', false, false)]
//     local procedure CancelpayforApprovalFunction(var Rec: Record "50025")
//     begin
//         //IF WKFlowEvent.CheckPayApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelPayforApproval(Rec);
//         //END;
//     end;

//     local procedure "---PAYMENT HEADER CARD---"()
//     begin
//     end;

//     local procedure "--PAYROLL BOOK-------"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelPayrollBkforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelPayrollBkforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelPayrollBkforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelPayrollBkforApproval(var PayrollBook: Record "50005")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelPayrollBkforApprovalCode, PayrollBook);

//         PayrollBookRec."Approval Status" := PayrollBookRec."Approval Status"::Open;
//         PayrollBookRec.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendPayrollBkforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendpayrollBkforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendPayrollBkforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendPayrollBkforApproval(var PayrollBook: Record "50005")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendPayrollBkforApprovalCode, PayrollBook);

//         PayrollBookRec."Approval Status" := PayrollBookRec."Approval Status"::"Pending Approval";
//         PayrollBookRec.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforPayrollBk(var ApprovalEntry: Record "454")
//     begin
//         PayrollBookRec.RESET;
//         PayrollBookRec.SETRANGE("Employee No.", ApprovalEntry."Document No.");
//         IF PayrollBookRec.FINDFIRST THEN BEGIN
//             PayrollBookRec."Approval Status" := PayrollBookRec."Approval Status"::Approved;
//             PayrollBookRec.MODIFY(TRUE);
//         END;


//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforPayrollBkCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforPayrollBkCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforPayrollBk'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforPayrollBk(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforPayrollBkCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         PayrollBookRec.RESET;
//         PayrollBookRec.SETRANGE("Employee No.", ApprovalEntry."Document No.");
//         IF PayrollBookRec.FINDFIRST THEN BEGIN
//             PayrollBookRec."Approval Status" := PayrollRec."Approval Status"::Open;
//             PayrollBookRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforPayrollBkCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforPayrollBk'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforPayrollBk(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforPayrollBkCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         PayrollBookRec.RESET;
//         PayrollBookRec.SETRANGE("Employee No.", ApprovalEntry."Document No.");
//         IF PayrollBookRec.FINDFIRST THEN BEGIN
//             PayrollBookRec."Approval Status" := PayrollBookRec."Approval Status"::"Pending Approval";
//             PayrollBookRec.MODIFY(TRUE);
//         END;

//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforPayrollBkCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforPayrollBk'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendPayrollBkforApproval(var PayrollBook: Record "50005")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelPayrollBkforApproval(var PayrollBook: Record "50005")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsPayrollBkApprovalsWorkflowEnabled(PayrollBook: Record "50005"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(PayrollBook, WKFlowEvent.RunWorkflowOnSendPayrollBkforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckPayrollBkApprovalsWorkflowEnabled(var Rec: Record "50005"): Boolean
//     begin
//         IF NOT IsPayrollBkApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 50005, 'OnAfterActionEvent', 'Action19', false, false)]
//     local procedure SendPayrollBkforApprovalFunction(var Rec: Record "50005")
//     begin
//         IF WKFlowEvent.CheckPayrollBkApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendPayrollBkforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 50005, 'OnAfterActionEvent', 'Action18', false, false)]
//     local procedure CancelPayrollBkforApprovalFunction(var Rec: Record "50005")
//     begin
//         //IF WKFlowEvent.CheckJobTMApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelPayrollBkforApproval(Rec);
//         //END;
//     end;

//     local procedure "--PAYROLL BOOK----------"()
//     begin
//     end;

//     local procedure "--PAYROLL-------"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelPayrollforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelPayrollforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelPayrollforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelPayrollforApproval(var Payroll: Record "50017")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelPayrollforApprovalCode, Payroll);

//         PayrollRec."Approval Status" := PayrollRec."Approval Status"::Open;
//         PayrollRec.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendPayrollforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendPayrollforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendPayrollforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendPayrollforApproval(var Payroll: Record "50017")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendPayrollforApprovalCode, Payroll);

//         PayrollRec."Approval Status" := PayrollRec."Approval Status"::"Pending Approval";
//         PayrollRec.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforPayroll(var ApprovalEntry: Record "454")
//     begin
//         PayrollRec.RESET;
//         PayrollRec.SETRANGE("Payroll Period", ApprovalEntry."Document No.");
//         IF PayrollRec.FINDFIRST THEN BEGIN
//             PayrollRec."Approval Status" := PayrollRec."Approval Status"::Approved;
//             PayrollRec.MODIFY(TRUE);
//         END;


//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforPayrollCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforPayrollCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforPayroll'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforPayroll(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforPayrollCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         PayrollRec.RESET;
//         PayrollRec.SETRANGE("Payroll Period", ApprovalEntry."Document No.");
//         IF PayrollRec.FINDFIRST THEN BEGIN
//             PayrollRec."Approval Status" := PayrollRec."Approval Status"::Open;
//             PayrollRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforPayrollCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforPayroll'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforPayroll(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforPayrollCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         PayrollRec.RESET;
//         PayrollRec.SETRANGE("Payroll Period", ApprovalEntry."Document No.");
//         IF PayrollRec.FINDFIRST THEN BEGIN
//             PayrollRec."Approval Status" := PayrollRec."Approval Status"::"Pending Approval";
//             PayrollRec.MODIFY(TRUE);
//         END;

//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforPayrollCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforPayroll'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendPayrollforApproval(var Payroll: Record "50017")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelPayrollforApproval(var Payroll: Record "50017")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsPayrollApprovalsWorkflowEnabled(Payroll: Record "50017"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(Payroll, WKFlowEvent.RunWorkflowOnSendPayrollforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckPayrollApprovalsWorkflowEnabled(var Rec: Record "50017"): Boolean
//     begin
//         IF NOT IsPayrollApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 50027, 'OnAfterActionEvent', 'Action23', false, false)]
//     local procedure SendPayrollforApprovalFunction(var Rec: Record "50017")
//     begin
//         IF WKFlowEvent.CheckPayrollApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendPayrollforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 50027, 'OnAfterActionEvent', '<Action58>', false, false)]
//     local procedure CancelPayrollforApprovalFunction(var Rec: Record "50017")
//     begin
//         //IF WKFlowEvent.CheckJobTMApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelPayrollforApproval(Rec);
//         //END;
//     end;

//     local procedure "--PAYROLL -------------"()
//     begin
//     end;

//     local procedure "--G/L ACCOUNT CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelGLAcctforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelGLAcctforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelGLAcctforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelGLAcctforApproval(var GLAcct: Record "15")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelGLAcctforApprovalCode, GLAcct);

//         GLAcct."Approval Status" := GLAcct."Approval Status"::Open;
//         GLAcct.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendGLAcctforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendGLAcctforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendGLAcctforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendGLAcctforApproval(var GLAcct: Record "15")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendGLAcctforApprovalCode, GLAcct);

//         GLAcct."Approval Status" := GLAcct."Approval Status"::"Pending Approval";
//         GLAcct.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforGLAcct(var ApprovalEntry: Record "454")
//     begin
//         GLAcctRec.RESET;
//         GLAcctRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF GLAcctRec.FINDFIRST THEN BEGIN
//             GLAcctRec."Approval Status" := GLAcctRec."Approval Status"::Approved;
//             GLAcctRec.MODIFY(TRUE);
//         END;


//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforGLAcctCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforGLAcctCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforGLAcct'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforGLAcct(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforGLAcctCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         GLAcctRec.RESET;
//         GLAcctRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF GLAcctRec.FINDFIRST THEN BEGIN
//             GLAcctRec."Approval Status" := GLAcctRec."Approval Status"::Open;
//             GLAcctRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforGLAcctCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforGLAcct'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforGLAcct(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforGLAcctCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         GLAcctRec.RESET;
//         GLAcctRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF GLAcctRec.FINDFIRST THEN BEGIN
//             GLAcctRec."Approval Status" := GLAcctRec."Approval Status"::"Pending Approval";
//             GLAcctRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforGLAcctCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforGLAcct'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendGLAcctforApproval(var GLAcct: Record "15")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelGLAcctforApproval(var GLAcct: Record "15")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsGLAcctApprovalsWorkflowEnabled(GLAcct: Record "15"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(GLAcct, WKFlowEvent.RunWorkflowOnSendGLAcctforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckGLAcctApprovalsWorkflowEnabled(var Rec: Record "15"): Boolean
//     begin
//         IF NOT IsGLAcctApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 17, 'OnAfterActionEvent', 'Action19', false, false)]
//     local procedure SendGLAcctforApprovalFunction(var Rec: Record "15")
//     begin
//         IF WKFlowEvent.CheckGLAcctApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendGLAcctforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 17, 'OnAfterActionEvent', 'Action17', false, false)]
//     local procedure CancelGLAcctforApprovalFunction(var Rec: Record "15")
//     begin
//         //IF WKFlowEvent.CheckGLAcctApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelGLAcctforApproval(Rec);
//         //END;
//     end;

//     local procedure "---G/L ACCOUNT CARD---"()
//     begin
//     end;

//     local procedure "--CUSTOMER CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelCustforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelCustforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelCustforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelCustforApproval(var Cust: Record "18")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelCustforApprovalCode, Cust);

//         Cust."Approval Status" := Cust."Approval Status"::Open;
//         Cust.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendCustforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendCustforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendCustforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendCustforApproval(var Cust: Record "18")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendCustforApprovalCode, Cust);

//         Cust."Approval Status" := Cust."Approval Status"::"Pending Approval";
//         Cust.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforCust(var ApprovalEntry: Record "454")
//     begin
//         CustRec.RESET;
//         CustRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF CustRec.FINDFIRST THEN BEGIN
//             CustRec."Approval Status" := CustRec."Approval Status"::Approved;
//             CustRec.MODIFY(TRUE);
//         END;

//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforCustCode,
//         ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforCustCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforCust'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforCust(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforCustCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         CustRec.RESET;
//         CustRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF CustRec.FINDFIRST THEN BEGIN
//             CustRec."Approval Status" := CustRec."Approval Status"::Open;
//             CustRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforCustCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforCust'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforCust(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforCustCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         CustRec.RESET;
//         CustRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF CustRec.FINDFIRST THEN BEGIN
//             CustRec."Approval Status" := CustRec."Approval Status"::"Pending Approval";
//             CustRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforCustCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforCust'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendCustforApproval(var Cust: Record "18")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelCustforApproval(var Cust: Record "18")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsCustApprovalsWorkflowEnabled(Cust: Record "18"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(Cust, WKFlowEvent.RunWorkflowOnSendCustforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckCustApprovalsWorkflowEnabled(var Rec: Record "18"): Boolean
//     begin
//         IF NOT IsCustApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 21, 'OnAfterActionEvent', 'SendApprovalRequest', false, false)]
//     local procedure SendCustforApprovalFunction(var Rec: Record "18")
//     begin
//         IF WKFlowEvent.CheckCustApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendCustforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 21, 'OnAfterActionEvent', 'CancelApprovalRequest', false, false)]
//     local procedure CancelCustforApprovalFunction(var Rec: Record "18")
//     begin
//         //IF WKFlowEvent.CheckPayApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelCustforApproval(Rec);
//         //END;
//     end;

//     local procedure "---CUSTOMER CARD---"()
//     begin
//     end;

//     local procedure "--ITEM CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelItemforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelItemforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelItemforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelItemforApproval(var Item: Record "27")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelItemforApprovalCode, Item);

//         Item."Approval Status" := Item."Approval Status"::Open;
//         Item.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendItemforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendItemforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendItemforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendItemforApproval(var Item: Record "27")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendItemforApprovalCode, Item);

//         Item."Approval Status" := Item."Approval Status"::"Pending Approval";
//         Item.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforItem(var ApprovalEntry: Record "454")
//     begin
//         Itemrec.RESET;
//         Itemrec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF Itemrec.FINDFIRST THEN BEGIN
//             Itemrec."Approval Status" := Itemrec."Approval Status"::Approved;
//             Itemrec.MODIFY(TRUE);
//         END;

//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforItemCode,
//         ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforItemCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforItem'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforItem(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforItemCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         Itemrec.RESET;
//         Itemrec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF Itemrec.FINDFIRST THEN BEGIN
//             Itemrec."Approval Status" := Itemrec."Approval Status"::Open;
//             Itemrec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforItemCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforItem'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforItem(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforItemCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         Itemrec.RESET;
//         Itemrec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF Itemrec.FINDFIRST THEN BEGIN
//             Itemrec."Approval Status" := Itemrec."Approval Status"::"Pending Approval";
//             Itemrec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforItemCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforItem'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendItemforApproval(var Item: Record "27")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelItemforApproval(var Item: Record "27")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsItemApprovalsWorkflowEnabled(Item: Record "27"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(Item, WKFlowEvent.RunWorkflowOnSendItemforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckItemApprovalsWorkflowEnabled(var Rec: Record "27"): Boolean
//     begin
//         IF NOT IsItemApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 30, 'OnAfterActionEvent', 'SendApprovalRequest', false, false)]
//     local procedure SendItemforApprovalFunction(var Rec: Record "27")
//     begin
//         IF WKFlowEvent.CheckItemApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendItemforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 30, 'OnAfterActionEvent', 'CancelApprovalRequest', false, false)]
//     local procedure CancelItemforApprovalFunction(var Rec: Record "27")
//     begin
//         //IF WKFlowEvent.CheckPayApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelItemforApproval(Rec);
//         //END;
//     end;

//     local procedure "---ITEM CARD---"()
//     begin
//     end;

//     local procedure "--FIXED ASSET CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelFixedAstforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelFixedAstforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelFixedAstforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelFixedAstforApproval(var FixedAst: Record "5600")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelFixedAstforApprovalCode, FixedAst);

//         FixedAst."Approval Status" := FixedAst."Approval Status"::Open;
//         FixedAst.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendFixedAstforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendFixedAstforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendFixedAstforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendFixedAstforApproval(var FixedAst: Record "5600")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendFixedAstforApprovalCode, FixedAst);

//         FixedAst."Approval Status" := FixedAst."Approval Status"::"Pending Approval";
//         FixedAst.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforFixedAst(var ApprovalEntry: Record "454")
//     begin
//         FixedAstRec.RESET;
//         FixedAstRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF FixedAstRec.FINDFIRST THEN BEGIN
//             FixedAstRec."Approval Status" := FixedAstRec."Approval Status"::Approved;
//             FixedAstRec.MODIFY(TRUE);
//         END;

//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforFixedAstCode,
//         ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforFixedAstCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforFixedAst'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforFixedAst(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforFixedAstCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         FixedAstRec.RESET;
//         FixedAstRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF FixedAstRec.FINDFIRST THEN BEGIN
//             FixedAstRec."Approval Status" := FixedAstRec."Approval Status"::Open;
//             FixedAstRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforFixedAstCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforFixedAst'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforFixedAst(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforFixedAstCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         FixedAstRec.RESET;
//         FixedAstRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF FixedAstRec.FINDFIRST THEN BEGIN
//             FixedAstRec."Approval Status" := FixedAstRec."Approval Status"::"Pending Approval";
//             FixedAstRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforFixedAstCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforFixedAst'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendFixedAstforApproval(var FixedAst: Record "5600")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelFixedAstforApproval(var FixedAst: Record "5600")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsFixedAstApprovalsWorkflowEnabled(FixedAst: Record "5600"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(FixedAst, WKFlowEvent.RunWorkflowOnSendFixedAstforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckFixedAstApprovalsWorkflowEnabled(var Rec: Record "5600"): Boolean
//     begin
//         IF NOT IsFixedAstApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 5600, 'OnAfterActionEvent', 'SendApprovalRequest', false, false)]
//     local procedure SendFixedAstforApprovalFunction(var Rec: Record "5600")
//     begin
//         IF WKFlowEvent.CheckFixedAstApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendFixedAstforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 5600, 'OnAfterActionEvent', 'CancelApprovalRequest', false, false)]
//     local procedure CancelFixedAstforApprovalFunction(var Rec: Record "5600")
//     begin
//         //IF WKFlowEvent.CheckPayApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelFixedAstforApproval(Rec);
//         //END;
//     end;

//     local procedure "---FIXED ASSET CARD---"()
//     begin
//     end;

//     local procedure "--BANK CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelBankforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelBankforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelBankforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelBankforApproval(var Bank: Record "270")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelBankforApprovalCode, Bank);

//         Bank."Approval Status" := Bank."Approval Status"::Open;
//         Bank.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendBankforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendBankforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendBankforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendBankforApproval(var Bank: Record "270")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendBankforApprovalCode, Bank);

//         Bank."Approval Status" := Bank."Approval Status"::"Pending Approval";
//         Bank.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforBank(var ApprovalEntry: Record "454")
//     begin
//         BankRec.RESET;
//         BankRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF BankRec.FINDFIRST THEN BEGIN
//             BankRec."Approval Status" := BankRec."Approval Status"::Approved;
//             BankRec.MODIFY(TRUE);
//         END;

//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforBankCode,
//         ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforBankCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforBank'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforBank(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforBankCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         BankRec.RESET;
//         BankRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF BankRec.FINDFIRST THEN BEGIN
//             BankRec."Approval Status" := BankRec."Approval Status"::Open;
//             BankRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforBankCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforBank'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforBank(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforBankCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         BankRec.RESET;
//         BankRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF BankRec.FINDFIRST THEN BEGIN
//             BankRec."Approval Status" := BankRec."Approval Status"::"Pending Approval";
//             BankRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforBankCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforBank'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendBankforApproval(var Bank: Record "270")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelBankforApproval(var Bank: Record "270")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsBankApprovalsWorkflowEnabled(Bank: Record "270"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(Bank, WKFlowEvent.RunWorkflowOnSendBankforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckBankApprovalsWorkflowEnabled(var Rec: Record "270"): Boolean
//     begin
//         IF NOT IsBankApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 370, 'OnAfterActionEvent', 'SendApprovalRequest', false, false)]
//     local procedure SendBankforApprovalFunction(var Rec: Record "270")
//     begin
//         IF WKFlowEvent.CheckBankApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendBankforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 370, 'OnAfterActionEvent', 'CancelApprovalRequest', false, false)]
//     local procedure CancelBankforApprovalFunction(var Rec: Record "270")
//     begin
//         //IF WKFlowEvent.CheckPayApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelBankforApproval(Rec);
//         //END;
//     end;

//     local procedure "---BANK CARD---"()
//     begin
//     end;

//     local procedure "--VENDOR CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelVendforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelvendforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelVendforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelVendforApproval(var Vend: Record "23")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelVendforApprovalCode, Vend);

//         Vend."Approval Status" := Vend."Approval Status"::Open;
//         Vend.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendVendforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendVendforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendVendforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendVendforApproval(var Vend: Record "23")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendVendforApprovalCode, Vend);

//         Vend."Approval Status" := Vend."Approval Status"::"Pending Approval";
//         Vend.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforVend(var ApprovalEntry: Record "454")
//     begin
//         VendRec.RESET;
//         VendRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF VendRec.FINDFIRST THEN BEGIN
//             VendRec."Approval Status" := VendRec."Approval Status"::Approved;
//             VendRec.MODIFY(TRUE);
//         END;


//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforVendCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforVendCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforVend'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforVend(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforVendCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         VendRec.RESET;
//         VendRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF VendRec.FINDFIRST THEN BEGIN
//             VendRec."Approval Status" := VendRec."Approval Status"::Open;
//             VendRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforVendCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforVend'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforVend(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforVendCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         VendRec.RESET;
//         VendRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF VendRec.FINDFIRST THEN BEGIN
//             VendRec."Approval Status" := VendRec."Approval Status"::"Pending Approval";
//             VendRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforVendCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforVend'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendVendforApproval(var Vend: Record "23")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelVendforApproval(var Vend: Record "23")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsVendApprovalsWorkflowEnabled(Vend: Record "23"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(Vend, WKFlowEvent.RunWorkflowOnSendVendforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckVendApprovalsWorkflowEnabled(var Rec: Record "23"): Boolean
//     begin
//         IF NOT IsVendApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 26, 'OnAfterActionEvent', 'SendApprovalRequest', false, false)]
//     local procedure SendVendforApprovalFunction(var Rec: Record "23")
//     begin
//         IF WKFlowEvent.CheckVendApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendVendforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 26, 'OnAfterActionEvent', 'CancelApprovalRequest', false, false)]
//     local procedure CancelVendforApprovalFunction(var Rec: Record "23")
//     begin
//         //IF WKFlowEvent.CheckVendApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelVendforApproval(Rec);
//         //END;
//     end;

//     local procedure "---VENDOR CARD---"()
//     begin
//     end;

//     local procedure "--EMPLOYEE CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelEmployeeforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelEmployeeforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelEmployeeforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelEmployeeforApproval(var Employee: Record "5200")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelEmployeeforApprovalCode, Employee);

//         Employee."Approval Status" := Employee."Approval Status"::Open;
//         Employee.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendEmployeeforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendEmployeeforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendEmployeeforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendEmployeeforApproval(var Employee: Record "5200")
//     begin
//         //Employee.CheckMandFields;

//         WorkflowManagement.HandleEvent(RunWorkflowOnSendEmployeeforApprovalCode, Employee);

//         Employee."Approval Status" := Employee."Approval Status"::"Pending Approval";
//         Employee.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforEmployee(var ApprovalEntry: Record "454")
//     begin
//         EmployeeRec.RESET;
//         EmployeeRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF EmployeeRec.FINDFIRST THEN BEGIN
//             EmployeeRec."Approval Status" := EmployeeRec."Approval Status"::Approved;
//             EmployeeRec.MODIFY(TRUE);
//         END;

//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforEmployeeCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforEmployeeCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforEmployee'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforEmployee(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforEmployeeCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         EmployeeRec.RESET;
//         EmployeeRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF EmployeeRec.FINDFIRST THEN BEGIN
//             EmployeeRec."Approval Status" := EmployeeRec."Approval Status"::Open;
//             EmployeeRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforEmployeeCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforEmployee'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforEmployee(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforEmployeeCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         EmployeeRec.RESET;
//         EmployeeRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF EmployeeRec.FINDFIRST THEN BEGIN
//             EmployeeRec."Approval Status" := EmployeeRec."Approval Status"::"Pending Approval";
//             EmployeeRec.MODIFY(TRUE);
//         END;

//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforEmployeeCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegatesApprovalRequestforEmployee'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendEmployeeforApproval(var Employee: Record "5200")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelEmployeeforApproval(var Employee: Record "5200")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsEmployeeApprovalsWorkflowEnabled(employee: Record "5200"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(employee, WKFlowEvent.RunWorkflowOnSendEmployeeforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckEmployeeApprovalsWorkflowEnabled(var Rec: Record "5200"): Boolean
//     begin
//         IF NOT IsEmployeeApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 5200, 'OnAfterActionEvent', 'Action47', false, false)]
//     local procedure SendEmpforApprovalFunction(var Rec: Record "5200")
//     begin
//         IF WKFlowEvent.CheckEmployeeApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendEmployeeforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 5200, 'OnAfterActionEvent', '<Action58>', false, false)]
//     local procedure CancelEmpforApprovalFunction(var Rec: Record "5200")
//     begin
//         WKFlowEvent.OnCancelEmployeeforApproval(Rec);
//     end;

//     local procedure "---EMPLOYEE CARD---"()
//     begin
//     end;

//     local procedure "--JOB CARD--"()
//     begin
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelJobTMforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnCancelJobTMforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnCancelJobTMforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnCancelJobTMforApproval(var Job: Record "167")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnCancelJobTMforApprovalCode, Job);

//         Job."Approval Status" := Job."Approval Status"::Open;
//         Job.MODIFY(TRUE);
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnSendJobTMforApprovalCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnSendJobTMforApproval'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 50011, 'OnSendJobTMforApproval', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnSendJobTMforApproval(var Job: Record "167")
//     begin
//         WorkflowManagement.HandleEvent(RunWorkflowOnSendJobTMforApprovalCode, Job);

//         Job."Approval Status" := Job."Approval Status"::"Pending Approval";
//         Job.MODIFY(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforJobTM(var ApprovalEntry: Record "454")
//     begin
//         JobRec.RESET;
//         JobRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF JobRec.FINDFIRST THEN BEGIN
//             JobRec."Approval Status" := JobRec."Approval Status"::Approved;
//             JobRec.MODIFY(TRUE);
//         END;

//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestforJobTMCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowOnApproveApprovalRequestforJobTMCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowOnApproveApprovalRequestforJobTM'))
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforJobTM(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowRejectApprovalRequestforJobTMCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         JobRec.RESET;
//         JobRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF JobRec.FINDFIRST THEN BEGIN
//             JobRec."Approval Status" := JobRec."Approval Status"::Open;
//             JobRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowRejectApprovalRequestforJobTMCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowRejectApprovalRequestforJobTM'));
//     end;

//     [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforJobTM(var ApprovalEntry: Record "454")
//     begin
//         WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowDelegateApprovalRequestforJobTMCode,
//           ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");

//         JobRec.RESET;
//         JobRec.SETRANGE("No.", ApprovalEntry."Document No.");
//         IF JobRec.FINDFIRST THEN BEGIN
//             JobRec."Approval Status" := JobRec."Approval Status"::"Pending Approval";
//             JobRec.MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Internal')]
//     procedure RunWorkflowDelegateApprovalRequestforJobTMCode(): Code[128]
//     begin
//         EXIT(UPPERCASE('RunWorkflowDelegateApprovalRequestforJobTM'))
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnSendJobTMforApproval(var Job: Record "167")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     [Scope('Internal')]
//     procedure OnCancelJobTMforApproval(var Job: Record "167")
//     begin
//     end;

//     [Scope('Internal')]
//     procedure IsJobTMApprovalsWorkflowEnabled(job: Record "167"): Boolean
//     begin
//         EXIT(WorkflowManagement.CanExecuteWorkflow(job, WKFlowEvent.RunWorkflowOnSendJobTMforApprovalCode));
//     end;

//     [Scope('Internal')]
//     procedure CheckJobTMApprovalsWorkflowEnabled(var Rec: Record "167"): Boolean
//     begin
//         IF NOT IsJobTMApprovalsWorkflowEnabled(Rec) THEN
//             ERROR('check your workflow');
//         EXIT(TRUE);
//     end;

//     [EventSubscriber(ObjectType::Page, 88, 'OnAfterActionEvent', 'Action57', false, false)]
//     local procedure SendJobforApprovalFunction(var Rec: Record "167")
//     begin
//         IF WKFlowEvent.CheckJobTMApprovalsWorkflowEnabled(Rec) THEN BEGIN
//             WKFlowEvent.OnSendJobTMforApproval(Rec);
//         END;
//     end;

//     [EventSubscriber(ObjectType::Page, 88, 'OnAfterActionEvent', '<Action58>', false, false)]
//     local procedure CancelJobforApprovalFunction(var Rec: Record "167")
//     begin
//         //IF WKFlowEvent.CheckJobTMApprovalsWorkflowEnabled(Rec) THEN BEGIN
//         WKFlowEvent.OnCancelJobTMforApproval(Rec);
//         //END;
//     end;

//     local procedure "---JOB CARD---"()
//     begin
//     end;
// }

