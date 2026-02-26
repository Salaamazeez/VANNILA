page 50118 "Bank Statement Setup"
{
    PageType = Card;
    SourceTable = "Statement Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Bank Statement Setup';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Base URL"; Rec."Base URL")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}