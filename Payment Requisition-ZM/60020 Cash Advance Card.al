page 60020 "Cash Advance Card"
{
    //Created by Salaam Azeez
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cash Advance";
    //SourceTableView = where(StatusP = const(" "));
    layout
    {
        area(Content)
        {
            group(General)
            {
                Enabled = EnableControl;
                // field("User Code"; "User Code")
                // {
                //     ApplicationArea = All;

                // }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;

                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;

                }

                field("Transaction type"; Rec."Transaction type")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Treated; Rec.Treated)
                {
                    ApplicationArea = All;
                    //  MultiLine = true;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;

                }
                field("Total Amount (LCY)"; Rec."Total Amount (LCY)")
                {
                    ApplicationArea = All;

                }
                field("Retirement No."; Rec."Retirement No.")
                {
                    Enabled = true;
                }
                field("Debit  Account Type"; Rec."Debit  Account Type")
                {
                    ApplicationArea = All;
                }
                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ApplicationArea = All;

                }
                field("Debit Account Name"; Rec."Debit Account Name")
                {
                    ApplicationArea = All;

                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;

                }

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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }


            }

            group(ListPart)
            {
                Enabled = EnableControl;
                part("Cash Advance Subform"; "Cash Advance Subform")
                {
                    SubPageLink = "Document No." = FIELD("No.");
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(60021),
                              "No." = FIELD("No.");
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
                    Visible = false;
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = const(60021),
                                  "Document No." = field("No.");

                    //Visible = OpenApprovalEntriesExistForCurrUser;
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
                            Rec.TestMandatoryFields();
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
                        Err001: Label 'Kindly select a %1 value';
                        Err002: Label 'Kindly input a %1 value';
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
        CashAdvHr: Record "Cash Advance";
        CashAdvLine: Record "Cash Advance Line";
        // DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        CAImprestMgt: Record "Cash Advance";
        RecRef: RecordRef;
        RecID: RecordID;
        DocumentApprovalEntryS: Record "Document Approval Entry1";
        Limit: Decimal;
        TotalAmount: Decimal;
        //LimDocumentApprovalWorkflow: Codeunit "Limited Doc. Approval Workflow";
        Mypage: Boolean;
        Text0001: TextConst ENU = 'The Document %1 has previously been sent for Approval';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        EnableControl: Boolean;


}