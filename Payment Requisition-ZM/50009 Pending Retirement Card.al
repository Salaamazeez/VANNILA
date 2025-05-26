page 50009 "Pending Retirement Card"
{
    //Created by Akande
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Retirement;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableView = WHERE(Posted = CONST(false), Status = FILTER("Pending Approval"));

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;


                }
                field("Type"; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Date"; Rec.Date)
                {

                }
                field("Retiring Officer"; Rec."Retiring Officer")
                {
                    ApplicationArea = All;
                }
                field("Retirement Ref."; Rec."Retirement Ref.")
                {
                    ApplicationArea = All;
                }
                field("Debit  Account Type"; Rec."Debit  Account Type") { }
                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ApplicationArea = All;
                }
                field("Debit Account Name"; Rec."Debit Account Name")
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                // field("Credit Account No."; Rec."Credit Account No.")
                // {
                //     ApplicationArea = All;
                // }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Total Line Amount"; Rec."Total Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Posted Balance"; Rec."Posted Balance")
                {

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }

            }

            part("Retirement Line Subform"; "Retirement Line Subform")

            {
                CaptionML = ENU = 'Lines';
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;

            }

        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(60000),
                              "No." = FIELD("No.");
            }
        }


    }

    actions
    {
        area(Processing)
        {
            group(Approv)
            {
                Caption = 'Approve';
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
                        ApprovalEntries.SetRecordFilters(Database::Retirement, 6, Rec."No.");
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
            action("Test Report")
            {
                ApplicationArea = Basic, Suite;
                Ellipsis = true;
                Image = TestReport;
                CaptionML = ENU = 'Test Report';
                ToolTipML = ENU = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';


                trigger OnAction()
                begin
                    Rec.TestReport;
                end;
            }
            action(Preview)
            {
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Preview Posting';
                ToolTipML = ENU = 'Review the different types of entries that will be created when you post the document or journal.';
                Image = ViewPostedOrder;

                trigger OnAction()
                var
                    GenJnlPost: Codeunit 231;
                begin
                    Rec.PreviewPosting;
                end;
            }


            // action("Post Balance")
            // {
            //     CaptionML = ENU = 'Post Balance';
            //     ToolTipML = ENU = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
            //     ApplicationArea = Basic, Suite;
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     Image = PostOrder;
            //     PromotedCategory = Process;

            //     trigger OnAction()
            //     begin
            //         PostBalance;
            //     end;
            // }
        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);

        if not UserSetup."Finance Admin" then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Retiring Officer", UserSetup."User ID");
            Rec.FilterGroup(0);
        end else
            Rec.SetRange("Retiring Officer");
        Rec.Balance := 0;
        // Modify();
        IF Rec."No." <> '' THEN BEGIN
            Rec.CALCFIELDS("Total Line Amount");
            IF (Rec."Total Line Amount" <> 0) THEN
                // Message('%1', Amount  - "Total Line Amount");
              Rec.Balance := Rec.Amount - Rec."Posted Balance" - Rec."Total Line Amount";
            Rec.MODIFY;
        END;
    end;



    trigger OnClosePage()
    begin
        Rec.Balance := 0;
        IF Rec."No." <> '' THEN BEGIN
            Rec.CALCFIELDS("Total Line Amount");
            IF Rec."Total Line Amount" <> 0 THEN
                Rec.Balance := Rec.Amount - Rec."Posted Balance" - Rec."Total Line Amount";
            Rec.MODIFY;
        END;
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec."No." <> '' THEN BEGIN
            Rec.CALCFIELDS("Total Line Amount");
            IF Rec."Total Line Amount" <> 0 THEN
                Rec.Balance := Rec.Amount - Rec."Posted Balance" - Rec."Total Line Amount";
            Rec.MODIFY;
        END;
        SetControlAppearance()
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    var
        myInt: Integer;
        Text0001: TextConst ENU = 'The Document %1 has already been sent for approval!';
        //DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        Retirement: Record Retirement;
        RecRef: RecordRef;
        RecID: RecordID;
        DocumentApprovalEntryS: Record "Document Approval Entry";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
}