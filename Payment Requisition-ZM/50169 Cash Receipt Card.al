page 50169 "Cash Receipt Card"
{
    //Created by Akande
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cash Receipt";

    layout
    {
        area(Content)
        {
            group(General)
            {
                // field("User Code"; Rec."User Code")
                // {
                //     ApplicationArea = All;
                // }
                field("No."; Rec."No.")
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
                    Editable = true;
                }
                field("Date"; Rec."Date")
                {

                }
                field("Retiring Officer"; Rec."Retiring Officer")
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
                field("Credit Account Type"; Rec."Credit Account Type") { }
                field("Credit Account No."; Rec."Credit Account No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
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
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }

            }
            // group(ListPart)
            // {
            // part("Cash Receipt Line Subform"; "Cash Receipt Line Subform")

            // {
            //     CaptionML = ENU = 'Lines';
            //     SubPageLink = "Document No." = FIELD("No.");
            //     ApplicationArea = Basic, Suite;
            //     UpdatePropagation = Both;

            // }
            // }
            // group(ListParts)
            // {
            //     // part("Document Approval Entries"; "Document Approval Entries")
            //     // {
            //     //     CaptionML = ENU = 'Approvals';
            //     //     SubPageLink = "Document No." = FIELD("No.");
            //     // }
            // }


        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50169),
                              "No." = FIELD("No.");
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
                    Enabled = false;//not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalsMgmt: Codeunit "Approval Mgt";
                    begin
                        if Rec."Transaction type" = Rec."Transaction type"::Loan then
                            Rec.TestField("Loan ID");
                        RecRef.GetTable(Rec);
                        if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                            ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    end;
                }

                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = Basic;
                    Enabled = false;//OpenApprovalEntriesExist;
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
                    Visible = false;//OpenApprovalEntriesExistForCurrUser;

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
                    Visible = false;//OpenApprovalEntriesExistForCurrUser;

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
                    Visible = false;//OpenApprovalEntriesExistForCurrUser;

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
                    Enabled = false;
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
                            Rec.TestField(Status, Rec.Status::Open);
                            if Rec."Transaction type" = Rec."Transaction type"::Loan then
                                Rec.TestField("Loan ID");
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

            action(Preview)
            {
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Preview Posting';
                ToolTipML = ENU = 'Review the different types of entries that will be created when you post the document or journal.';
                Image = ViewPostedOrder;
                Enabled = false;
                trigger OnAction()
                var
                    GenJnlPost: Codeunit 231;
                begin
                    // PreviewPosting;
                end;
            }

            action("Post Balance")
            {
                CaptionML = ENU = 'Post Balance';
                ToolTipML = ENU = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedIsBig = true;
                Image = PostOrder;
                PromotedCategory = Process;
                Visible = financeAdmin;
                trigger OnAction()
                begin

                    Rec.PostBalance;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Promoted = true;
                PromotedIsBig = true;
                Image = PostOrder;
                PromotedCategory = Process;
                Visible = false;
                trigger OnAction()
                var
                    CashRcpt: Record "Cash Receipt";
                    CashRcptReport: Report "Cash Receipt Report 2";
                begin
                    CashRcpt.SetRange("No.", Rec."No.");
                    if CashRcpt.FindFirst() then
                        Report.Run(50100, true, true, CashRcpt);
                end;
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

        }
    }
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        financeAdmin := UserSetup."Finance Admin";
        IF Rec."No." <> '' THEN BEGIN
            Rec.CALCFIELDS("Total Line Amount");
            IF Rec."Total Line Amount" <> 0 THEN
                Rec.Balance := Rec.Amount - Rec."Total Line Amount";
            Rec.MODIFY;
        END;
    end;

    trigger OnClosePage()
    begin
        IF Rec."No." <> '' THEN BEGIN
            Rec.CALCFIELDS("Total Line Amount");
            IF Rec."Total Line Amount" <> 0 THEN
                Rec.Balance := Rec.Amount - Rec."Total Line Amount";
            Rec.MODIFY;
        END;
    end;

    trigger OnAfterGetRecord()
    begin
        EnableFields;
        SetControlAppearance;
        IF Rec."No." <> '' THEN BEGIN
            Rec.CALCFIELDS("Total Line Amount");
            IF Rec."Total Line Amount" <> 0 THEN
                Rec.Balance := Rec.Amount - Rec."Total Line Amount";
            Rec.MODIFY;
        END;
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
        myInt: Integer;
        Text0001: TextConst ENU = 'The Document %1 has already been sent for approval!';
        //DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        Retirement: Record Retirement;
        RecRef: RecordRef;
        RecID: RecordID;
        DocumentApprovalEntryS: Record "Document Approval Entry";
        financeAdmin: boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        EnableControl: Boolean;
}