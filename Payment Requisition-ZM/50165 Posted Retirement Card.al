page 50165 "Posted Retirement Card"
{
    //Created by Salaam Azeez
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Retirement;
    SourceTableView = WHERE(Posted = CONST(true), Status = FILTER(Approved));
    Editable = false;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;

                }
                field("Retiring Officer"; Rec."Retiring Officer")
                {
                    ApplicationArea = All;

                }
                field("Retirement Ref."; Rec."Retirement Ref.")
                {
                    ApplicationArea = All;

                }
                field("Debit Account Name"; Rec."Debit Account Name")
                {
                    ApplicationArea = All;

                }
                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ApplicationArea = All;

                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;

                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Posted Balance"; Rec."Posted Balance")
                {
                    ApplicationArea = All;

                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }

                field(Status; Rec.Status)
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

            }
            group(ListPart)
            {
                part("Retirement Line Subform"; "Retirement Line Subform")
                {
                    CaptionML = ENU = 'Lines';
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
                SubPageLink = "Table ID" = CONST(50155),
                              "No." = FIELD("No.");
            }
        }
    }

    actions
    {

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
            action(Navigate)
            {
                Image = Navigate;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.Navigate();
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
                    ApprovalEntries.SetRecordFilters(Database::Retirement, 6, Rec."No.");
                    ApprovalEntries.Run;
                end;
            }
        }

    }

    var
        myInt: Integer;
}