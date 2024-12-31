page 60023 "Approved Cash Advance Card"
{
    //Created by Salaam Azeez
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cash Advance";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTableView = where(Status = const(Approved));
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
                    Editable = true;
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                    Editable = true;
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
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;

                }

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
                        if Rec.Treated then
                            Error('Voucher already has been created for this document');
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformManualReopen(RecRef);
                        CurrPage.Update;
                    end;
                }
            }
            action("Create Voucher")
            {
                Visible = financeAdmin;
                trigger OnAction()
                begin
                    Rec.TestField(Status, Rec.Status::Approved);
                    Rec.CreateVoucher()
                end;
            }

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

    trigger OnClosePage()
    var
    //  myInt: Integer;
    begin
        //   "Actual User 3" := '';
        Rec.Modify();
    end;


    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        financeAdmin := UserSetup."Finance Admin";
    end;

    var
        CAImprestMgt: Record "Cash Advance";
        RecRef: RecordRef;
        RecID: RecordID;
        financeAdmin: Boolean;
}