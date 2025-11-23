page 60008 "Payment Req. Card"
{
    //Created by Akande
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Requisition";
    SourceTableView = WHERE(Posted = CONST(false), Status = FILTER(<> Approved));

    layout
    {
        area(Content)
        {
            group(General)
            {
                //     field("User Code";Rec. "User Code")
                //     {
                //         ApplicationArea = All;

                //     }

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
                field(Beneficiary; Rec.Beneficiary)
                {
                    ApplicationArea = All;
                }
                field("Beneficiary Name"; Rec."Beneficiary Name")
                {
                    ApplicationArea = All;
                }
                field("Bal Account Type"; Rec."Bal Account Type")
                {
                    ApplicationArea = All;
                }
                field("Bal Account No."; Rec."Bal Account No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Bal Account Name"; Rec."Bal Account Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code") { ApplicationArea = All; }
                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = All;
                }

                field("Purchase Requisition No."; Rec."Purchase Requisition No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                // field("Actual User";Rec. "Actual User")
                // {
                //     ApplicationArea = All;
                // }
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
                field("Transaction type"; Rec."Transaction type")
                {
                    ApplicationArea = All;
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                    Visible = false;
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
            // action("Create Voucher")
            // {
            //     trigger OnAction()// var
            //     begin
            //         if Rec."Transaction type" = Rec."Transaction type"::Loan then
            //             Rec.TestField("Loan ID");
            //         Rec.TestMandatoryFields;
            //         Rec.CreateVoucher();
            //     end;
            // }
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
            action(Print)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PaymentRequisition.SETRANGE("No.", Rec."No.");
                    IF PaymentRequisition.FINDFIRST THEN REPORT.RUNMODAL(60022, TRUE, TRUE, PaymentRequisition);
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
            action(Approvals)
            {
                ApplicationArea = Basic;
                Image = Approvals;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    ApprovalEntries.SetRecordFilters(Database::"Payment Requisition", 6, Rec."No.");
                    ApprovalEntries.Run;
                end;
            }

        }

    }
    trigger OnAfterGetRecord()
    begin
        SetControlAppearance
    end;

    trigger OnOpenPage()
    begin
        if Rec.Status <> Rec.Status::Open then
            CurrPage.Editable(false)
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    var
      
        PaymentRequisition: Record "Payment Requisition";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
}
