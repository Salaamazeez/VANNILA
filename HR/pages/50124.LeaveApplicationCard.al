page 50124 LeaveApplicationCard
{
    ApplicationArea = All;
    Caption = 'Leave Application Card';
    PageType = Card;
    SourceTable = LeaveApplication;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code.';
                }
                field("Applying Type"; Rec."Applying Type")
                {
                    ToolTip = 'Specifies the value of the Applying Type';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code.';
                }

                field("Approval Status"; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Approval Status.';
                }

                field("No. of Days Recalled"; Rec."No. of Days Recalled")
                {
                    ToolTip = 'Specifies the value of the No. of Days Recalled ';
                }
                field("No. of Leave Days Entitled"; Rec."No. of Leave Days Entitled")
                {
                    ToolTip = 'Specifies the value of the No. of Leave Days Entitled.';
                }
                field("No. of Days Taken"; Rec."No. of Days Taken")
                {
                    ToolTip = 'Specifies the value of the No. of Days Taken';
                }
                field("Current Leave Balance"; Rec."Current Leave Balance")
                {
                    ToolTip = 'Specifies the value of the Current Leave Balance.';
                }
                field("Requested Days"; Rec."Requested Days")
                {
                    ToolTip = 'Specifies the value of the Requested Days.';
                }
                field("Balance After Current Leave"; Rec."Balance After Current Leave")
                {
                    ToolTip = 'Specifies the value of the Balance After Current Leave.';
                }
                field("First Day of Vacation"; Rec."First Day of Vacation")
                {
                    ToolTip = 'Specifies the value of the First Day of Vacation.';
                }
                field("Leave End Date"; Rec."Leave End Date")
                {
                    ToolTip = 'Specifies the value of the Leave End Date field.';
                }
                field("Resumption Date"; Rec."Resumption Date")
                {
                    ToolTip = 'Specifies the value of the Resumption Date field.';
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the value of the Leave Type.';
                }
                field("Leave Year"; Rec."Leave Year")
                {
                    ToolTip = 'Specifies the value of the Leave Year';
                }
                field("Current Residential Address"; Rec."Current Residential Address")
                {
                    ToolTip = 'Specifies the value of the Current Residential Address.';
                    MultiLine = true;
                }
                field("On Leave Contact Address"; Rec."On Leave Contact Address")
                {
                    ToolTip = 'Specifies the value of the On Leave Contact Address.';
                    MultiLine = true;
                }
            }
            group(Administration)
            {
                Caption = 'Administration';

                field("Supervisor Approval Date"; Rec."Supervisor Approval Date")
                {
                    ToolTip = 'Specifies the value of the Supervisor Approval Date.';
                }
                field("Supervisor Name"; Rec."Supervisor Name")
                {
                    ToolTip = 'Specifies the value of the Supervisor Name.';
                }
                field("Supervisor Comment"; Rec."Supervisor Comment")
                {
                    ToolTip = 'Specifies the value of the Supervisor Comment.';
                }
                field("HR Comment"; Rec."HR Comment")
                {
                    ToolTip = 'Specifies the value of the HR Comment.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the Created By.';
                    Caption = 'Created By';
                    Editable = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the Created Date.';
                    Caption = 'Created Date';
                    Editable = false;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the Modified By.';
                    Caption = 'Modified By';
                    Editable = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the Modified Date.';
                    Caption = 'Modified Date';
                    Editable = false;
                }
            }
        }

        area(FactBoxes)
        {
            systempart(mynotes; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Notes; notes)
            {
                ApplicationArea = All;
            }
            /*
            systempart(Links; links)
            {
                ApplicationArea = All;
            }
            */
            systempart(Outlook; Outlook)
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        area(Processing)
        {
            group("Request Approval")
            {
                action("Send &Approval Request")
                {
                    ApplicationArea = Basic;
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalsMgmt: Codeunit "Approval Mgt";
                    begin
                        RecRef.GetTable(Rec);
                        if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                            ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = Basic;
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalsMgmt: Codeunit "Approval Mgt";
                    begin
                        RecRef.GetTable(Rec);
                        ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    end;
                }

            }

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        ApprovalMgt: Codeunit "Approval Mgt";

                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                        if ApprovalMgt.ApproveDoc(Rec."Leave Code") then begin
                            Rec.Status := Rec.Status::Approved;
                            Rec.Modify()
                        end;
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        MyApprovalMgt: Codeunit "Approval Mgt";
                        RecRef: RecordRef;
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                        RecRef.GetTable(Rec);
                        MyApprovalMgt.CheckAndRejectDoc(RecRef)
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                
            }
               action(manualRelease)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Visible = IsReleaseVisible;
                trigger OnAction()
                begin
                    rec.PerformManualRelease();
                end;
            }
            action(ManualReopen)
            {
                Caption = 'Reopen';
                Image = ReOpen;
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Visible = IsReopenVisible;
                trigger OnAction()
                begin
                    rec.PerformManualReopen();
                end;
            }
            action(LeaveRecal)
            {
                Caption = 'Leave Recall';
                Image = Return;
                ApplicationArea = all;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Visible = IsLeaveRecallVisible;
                RunObject = page LeaveRecall;
                RunPageLink = "Employee Code" = field("Employee No."), "Leave Code" = field("Leave Code");
            }
            action(leave)
            {
                Caption = 'Post Leave Application';
                Image = Travel;
                ApplicationArea = all;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = process;
                Visible = IsLeavePostedVisible;
                trigger OnAction()
                begin
                    rec.PostLeaveApplication();
                end;

            }
            action(LeavAppForm)
            {
                Caption = 'Leave Application Form';
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = InsertTravelFee;
                trigger OnAction()
                begin
                    LeaveAppForm.SetRange("Leave Code", Rec."Leave Code");
                    if LeaveAppForm.FindFirst() then
                        report.Run(Report::LeaveApplication, True, false, LeaveAppForm);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        iF (Rec.Status <> Rec.Status::Open) then BEGIN
            CurrPage.Editable := false;
            IsReopenVisible := true;
        END else begin
            CurrPage.Editable := true;
            IsLeaveRecallVisible := false;
            IsLeavePostedVisible := false;
            IsSendvisible := true;
            IsCancelVisible := true;
            IsReleaseVisible := true;
            IsReopenVisible := true;

        end;

        if (Rec.Status = Rec.Status::"Pending Approval") then begin
            IsLeavePostedVisible := false;
            IsLeaveReportVisible := false;
            IsLeaveRecallVisible := false;
            IsCancelVisible := true;
            IsSendvisible := false;
            IsReopenVisible := true;
            IsReleaseVisible := false;
        end;

        if (Rec.Status = Rec.Status::Approved) then begin
            IsLeavePostedVisible := true;
            IsLeaveReportVisible := true;
            IsLeaveRecallVisible := false;
            IsCancelVisible := false;
            IsSendvisible := false;
            IsReopenVisible := true;
            IsReleaseVisible := false;
        end;

        if (Rec.Status = Rec.Status::Posted) then begin
            //IsLeavePostedVisible := true;
            IsLeaveRecallVisible := true;
            IsLeavePostedVisible := false;
            IsCancelVisible := false;
            IsSendvisible := false;
            IsReopenVisible := false;
            IsReleaseVisible := false;
        end
    end;

    trigger OnAfterGetRecord()
    begin
       SetControlAppearance();
        iF (Rec.Status <> Rec.Status::Open) then
            CurrPage.Editable := false
        else
            CurrPage.Editable := true;

    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;


    var
        IsLeaveRecallVisible: Boolean;
        //IsLeaveApprovedVisible: Boolean;
        LeaveAppForm: Record LeaveApplication;
        IsLeavePostedVisible: Boolean;
        IsLeaveReportVisible: Boolean;
        IsSendvisible: Boolean;
        IsCancelVisible: Boolean;
        IsReleaseVisible: Boolean;
        IsReopenVisible: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        EnableControl: Boolean;
}
