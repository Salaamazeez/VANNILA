page 50005 "Pending Payment Req. Card"
{
    //Created by Salaam Azeez
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Requisition";
    SourceTableView = WHERE(Posted = CONST(false), Status = CONST("Pending Approval"));
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
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
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                }
                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = All;
                }
                field(Beneficiary; Rec.Beneficiary)
                {
                    ApplicationArea = All;
                }
                field("Beneficiary Name"; Rec."Beneficiary Name")
                {
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Purchase Requisition No."; Rec."Purchase Requisition No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Request Amount"; Rec."Request Amount")
                {
                    ApplicationArea = All;
                }
                field("Request Amount (LCY)"; Rec."Request Amount (LCY)")
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
                field("Voucher Created?"; Rec."Voucher Created?")
                {
                    ApplicationArea = All;
                }

            }
            group(ListPart)
            {
                part("Payment Req. Subform"; "Payment Req. Subform")
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
                SubPageLink = "Table ID" = CONST(60000),
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
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();
                    end;
                }
            }
            group(Related)
            {
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

            action(Print)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // PaymentRequisition.SETRANGE("No.", "No.");
                    // IF PaymentRequisition.FINDFIRST THEN REPORT.RUNMODAL(50009, TRUE, TRUE, PaymentRequisition);
                end;
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
        CurrPage.Editable(Rec.Status <> Rec.Status::"Pending Approval");
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustSetup: Record "Payment Mgt Setup";
        PVHeaderNo: Code[20];
        PRHeader: Record "Payment Requisition";
        PRLine: Record "Payment Requisition Line";
        PVHeader: Record "Payment Voucher Header";
        PVLine: Record "Payment Voucher Line";
        //DocumentApprovalWorkflow: Codeunit "Document Approval Workflow"; //50001 Document Approval Workflow
        PaymentRequisition: Record "Payment Requisition";
        RecRef: RecordRef;
        RecID: RecordID;
        PaymentRequisitionLine: Record "Payment Requisition Line";
        //DocumentApprovalEntry: Record "Document Approval Entry";
        TotalAmount: Decimal;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ApprovalMgt: Codeunit "Approval Mgt";
    //LimDocumentApprovalWorkflow: Codeunit "Limited Doc. Approval Workflow";
    // TradeActivationLine: Record "prEmployee Banks";
}
