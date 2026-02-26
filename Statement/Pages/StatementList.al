page 50105 "Bank Statements"
{
    PageType = List;
    SourceTable = "Bank Statement";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Bank Statements';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Statement Id"; Rec."Statement Id") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
                field("Currency Code"; Rec."Currency Code") { }
                field("From Date"; Rec."From Date") { }
                field("To Date"; Rec."To Date") { }
                field("Total Entries"; Rec."Total Entries") { }
                field("Total Amount"; Rec."Total Amount") { }
                field("Net Amount"; Rec."Net Amount") { }
                field("Credit/Debit"; Rec."Credit/Debit") { }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Fetch Bank Statement")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    Stmtrpt: Report "Bank Statement";
                begin
                    Stmtrpt.Run
                end;
            }
        }
    }
}