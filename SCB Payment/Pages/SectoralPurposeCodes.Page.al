page 50031 "Sectoral Purpose Codes"
{
    PageType = List;
    SourceTable = "Sectoral Purpose Code";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Sectoral Purpose Codes';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Purpose Code"; Rec."Purpose Code")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }

                field("Trade Category"; Rec."Trade Category")
                {
                    ApplicationArea = All;
                }

                field("Import/Export"; Rec."Import/Export")
                {
                    ApplicationArea = All;
                }

                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("FCY Transaction"; Rec."FCY Transaction")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
