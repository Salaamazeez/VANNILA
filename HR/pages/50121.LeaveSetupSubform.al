page 50121 LeaveSetupSubform
{
    ApplicationArea = All;
    Caption = 'Leave Setup Subform';
    PageType = ListPart;
    SourceTable = LeaveSetupLine;
    DelayedInsert = true;
    MultipleNewLines = true;
    AutoSplitKey = False;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code';
                }
                field("Leave Description"; Rec."Leave Description")
                {
                    ToolTip = 'Specifies the value of the Leave Description';
                }
                field("Duration"; Rec."Duration")
                {
                    ToolTip = 'Specifies the value of the Maximum Duration of the Leave';
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Unit of Measure';
                }
                field(Sex; Rec.Sex)
                {
                    ToolTip = 'Specifies the value of the Sex entitled for the Leave';
                }

            }
        }
    }
}
