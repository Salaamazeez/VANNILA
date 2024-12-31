page 50024 "Cash Advance Card Dummy"
{
    //Created by Salaam Azeez
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cash Advance";
    //SourceTableView = where(Status = const("Pending Approval"));
    layout
    {
        area(Content)
        {
            group(General)
            {
                // field("User Code 2"; "User Code 2")
                // {
                //     ApplicationArea = All;
                // }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field(Date; rec.Date)
                {
                    ApplicationArea = All;

                }
                field(Requester; rec.Requester)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;

                }
                // field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                // {
                //     ApplicationArea = All;

                // }
                // field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                // {
                //     ApplicationArea = All;

                // }
                field("Transaction type"; Rec."Transaction type")
                {
                    ApplicationArea = All;

                }
                field(Treated; rec.Treated)
                {
                    ApplicationArea = All;
                    //  MultiLine = true;
                }
                field("Total Amount"; rec."Total Amount")
                {
                    ApplicationArea = All;

                }
                field("Total Amount (LCY)"; rec."Total Amount (LCY)")
                {
                    ApplicationArea = All;

                }
                field("Retirement No."; rec."Retirement No.")
                {
                    Enabled = true;
                }
                // field("Debit Account No."; "Debit Account No.")
                // {
                //     ApplicationArea = All;

                // }
                // field("Debit Account Name"; "Debit Account Name")
                // {
                //     ApplicationArea = All;

                // }
                // field("Currency Code"; "Currency Code")
                // {
                //     ApplicationArea = All;

                // }
                // field(Amount; Amount)
                // {
                //     ApplicationArea = All;

                // }
                // field("Bank No."; "Bank No.")
                // {
                //     ApplicationArea = All;
                // }
                // field("Bank Name"; "Bank Name")
                // {
                //     ApplicationArea = All;
                // }
                // field("Bank Balances"; "Bank Balances")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                // }
                field(Status; rec.Status)
                {
                    ApplicationArea = All;

                }
                // field("Actual User 2"; "Actual User 2")
                // {
                //     ApplicationArea = All;
                // }

            }
            group(ListPart)
            {
                part("Cash Advance Subform"; "Cash Advance Subform")
                {
                    ApplicationArea = All;

                    SubPageLink = "Document No." = FIELD("No.");

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
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
                        if ApprovalMgt.ApproveDoc(Rec."No.") then begin
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
                action(Comment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Approval Comments";
                    RunPageLink = //"Table ID" = const(60200),
                                  "Document No." = field("No.");
                    Visible = false;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = const(0),
                                  "No." = field("No."),
                                  "Document Line No." = const(0);
                    ToolTip = 'View or add comments for the record.';
                }
            }

            group(Action13)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                group(Release)
                {
                    action("Re&lease")
                    {
                        ApplicationArea = Basic;
                        Image = ReleaseDoc;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'Ctrl+F9';

                        trigger OnAction()
                        var
                            RecRef: RecordRef;
                            ReleaseDocument: Codeunit "Release Documents";

                        begin
                            Rec.TestMandatoryFields;
                            RecRef.GetTable(Rec);
                            ReleaseDocument.PerformanualManualDocRelease(RecRef);
                            CurrPage.Update;
                        end;
                    }
                    action("Re&open")
                    {
                        ApplicationArea = Basic;
                        Image = ReOpen;
                        Promoted = true;
                        PromotedCategory = Process;

                        trigger OnAction()
                        var
                            RecRef: RecordRef;
                            ReleaseDocument: Codeunit "Release Documents";
                        begin
                            RecRef.GetTable(Rec);
                            ReleaseDocument.PerformManualReopen(RecRef);
                            CurrPage.Update;
                        end;
                    }
                }
            }
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
                        Rec.TestMandatoryFields();
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
        }
        area(Navigation)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Enabled = Rec."No." <> '';
                Image = Dimensions;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                    CurrPage.SaveRecord();
                end;
            }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Image = Approvals;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    ApprovalEntries.SetRecordFilters(Database::"Cash Advance", 6, Rec."No.");
                    ApprovalEntries.Run;
                end;
            }

        }
    }
    trigger OnOpenPage()
    begin
        EnableControl := true;
        if Rec.Status <> Rec.Status::Open then begin
            EnableControl := false;
        end;
        IF Rec.Status = Rec.Status::Approved THEN BEGIN
            Mypage := FALSE;
        END
        ELSE BEGIN
            Mypage := TRUE;
        END;
    end;

    trigger OnAfterGetRecord()
    begin
        EnableFields;
        SetControlAppearance
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    procedure EnableFields()
    begin
        CurrPage.Editable(Rec.Status <> Rec.Status::"Pending Approval");
    end;

    var
        CashAdvLine: Record "Cash Advance Line";
        // DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        TotalAmount: Decimal;
        //LimDocumentApprovalWorkflow: Codeunit "Limited Doc. Approval Workflow";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        EnableControl: Boolean;



    trigger OnModifyRecord(): Boolean
    begin
        IF Rec.Status = Rec.Status::Approved THEN
            ERROR('Modification is not allowed after Approval!');
    end;

    var
        CashAdvHr: Record "Cash Advance";
        // DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        CAImprestMgt: Record "Cash Advance";
        RecRef: RecordRef;
        RecID: RecordID;
        DocumentApprovalEntryS: Record "Document Approval Entry1";
        Limit: Decimal;
        Mypage: Boolean;
        Text0001: TextConst ENU = 'The Document %1 has previously been sent for Approval';
}