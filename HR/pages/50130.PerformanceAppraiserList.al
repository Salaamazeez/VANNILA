page 50130 PerformanceAppraiserList
{
    ApplicationArea = All;
    Caption = 'Performance Appraiser List';
    PageType = List;
    SourceTable = PerformanceAppraisalHeader;
    UsageCategory = Lists;
    Editable = false;
    SourceTableView = where(Closed = const(False));
    CardPageId = 50131;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Appraisal Year"; Rec."Appraisal Year")
                {
                    ToolTip = 'Specifies the value of the Appraisal Year field.', Comment = '%';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.', Comment = '%';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                }
            }
        }
    }
}
