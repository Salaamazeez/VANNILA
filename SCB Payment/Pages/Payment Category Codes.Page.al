page 50030 "Payment Category Codes"
{
    PageType = List;
    SourceTable = "Payment Category Code";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Payment Category Codes';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Category Code"; Rec."Category Code")
                {
                }

                field("Category Description"; Rec."Category Description")
                {
                }

                field("4 Character Code"; Rec."4 Character Code")
                {
                }

                field("3 Character Code"; Rec."3 Character Code")
                {
                }
            }
        }
    }
}
