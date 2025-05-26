page 60024 "Pending Cash Advance Card"
{
    //Created by Akande
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cash Advance";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTableView = where(Status = const("Pending Approval"));
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                // field("User Code 3"; "User Code 3")
                // {
                //     ApplicationArea = All;
                // }
                field("No."; REC."No.")
                {
                    ApplicationArea = All;

                }
                field("Date"; REC."Date")
                {
                    ApplicationArea = All;

                }
                field(Requester; Rec.Requester)
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;

                }
                // field("Amount (LCY)"; "Amount (LCY)")
                // {
                //     ApplicationArea = All;

                // }

                field(Treated; Rec.Treated)
                {
                    ApplicationArea = All;

                }
                field(Posted; REC.Posted) { }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
                field(Retired; Rec.Retired) { }
                field("Voucher No"; Rec."Voucher No") { }
                field("Pmt Vouch. Code"; Rec."Pmt Vouch. Code") { }
                field("Retirement No."; Rec."Retirement No.") { }


            }
            group(ListPart)
            {
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
            group(Grp001)
            {
                Caption = 'Reopen';
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
                action(Comment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = const(60202),
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
            group(Prints)
            {
                action(Print)
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        CashAdvanceTbl: Record "Cash Advance";
                    begin
                        CashAdvanceTbl.SetRange("No.", Rec."No.");
                        if CashAdvanceTbl.FindFirst() then
                            Report.RunModal(60027, true, true, CashAdvanceTbl);
                    end;
                }
            }
        }


    }
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
        //CurrPage.Editable(Rec.Status <> Rec.Status::"Pending Approval");
    end;

    trigger OnClosePage()
    var
    //  myInt: Integer;
    begin
        //   "Actual User 3" := '';
        Rec.Modify();
    end;

    trigger OnOpenPage()
    begin
        Rec.MarkAllWhereUserisUserIDOrDepartment()
    end;

    var
        // DocumentApprovalWorkflow: Codeunit Codeunit50000;
        CAImprestMgt: Record "Cash Advance";
        RecRef: RecordRef;
        RecID: RecordID;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
}