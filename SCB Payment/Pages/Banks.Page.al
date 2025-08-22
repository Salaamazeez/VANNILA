Page 90232 Banks
{
    PageType = List;
    SourceTable = "Bank";
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(SearchName; Rec."Search Name")
                {
                    ApplicationArea = All;
                }
                field(SortCode; Rec."Sort Code")
                {
                    ApplicationArea = All;
                }
                field("Lead Bank Code"; Rec."Lead Bank Code")
                {
                    ApplicationArea = All;
                }
                field("Lead Bank Description"; Rec."Lead Bank Description")
                {
                    ApplicationArea = All;
                }
                field("Lead Bank ID"; Rec."Lead Bank ID")
                {
                    ApplicationArea = All;
                }
                field("Lead Bank Account Code"; Rec."Lead Bank Account Code")
                {
                    ApplicationArea = All;

                }
            }
        }
        area(factboxes)
        {
            systempart(Control8; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart(Control7; Notes)
            {
                Visible = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

