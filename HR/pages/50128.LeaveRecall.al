page 50128 LeaveRecall
{
    ApplicationArea = All;
    Caption = 'Leave Recall';
    PageType = List;
    SourceTable = LeaveRecall;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code.';
                    Editable = false;
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the value of the Leave Type';
                    Editable = false;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.';
                    Editable = false;
                }
                field("Recalled Reason"; Rec."Recalled Reason")
                {
                    ToolTip = 'Specifies the value of the Recalled Reason field.';
                }
                field("Date Recalled"; Rec."Date Recalled")
                {
                    ToolTip = 'Specifies the value of the Date Recalled field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.';
                    Editable = false;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.';
                    Editable = false;
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                    Editable = false;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                    Editable = false;
                }
            }
        }
    }
}
