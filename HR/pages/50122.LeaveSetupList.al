page 50122 LeaveSetupList
{
    ApplicationArea = All;
    Caption = 'Leave Setup List';
    PageType = List;
    SourceTable = LeaveSetup;
    UsageCategory = Lists;
    CardPageId = 50120;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Leave Setup Code"; Rec."Leave Setup Code")
                {
                    ToolTip = 'Specifies the value of the Employee Zone';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description of the Leave';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the reated By';
                }
            }

        }
    }
}
