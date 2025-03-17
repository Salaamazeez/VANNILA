page 50132 PerformanceAppraiserSubform
{
    ApplicationArea = All;
    Caption = 'PerformanceAppraiserSubform';
    PageType = ListPart;
    SourceTable = PerformanceAppraiserLine;
    LinksAllowed = false;
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    Visible = false;
                }
                field("Appraisaer Year"; Rec."Appraisaer Year")
                {
                    ToolTip = 'Specifies the value of the Appraisaer Year field.', Comment = '%';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                    Visible = false;
                }
                field("Objective Settings"; Rec."Objective Settings")
                {
                    ToolTip = 'Specifies the value of the Objective Settings field.', Comment = '%';
                }
                field("Objective Summary"; Rec."Objective Summary")
                {
                    ToolTip = 'Specifies the value of the Ebjective Summary field.', Comment = '%';
                }
                field(Measure; Rec.Measure)
                {
                    ToolTip = 'Specifies the value of the Measure field.', Comment = '%';
                }
                field(Weight; Rec.Weight)
                {
                    ToolTip = 'Specifies the value of the Weight field.', Comment = '%';
                }
                field("By When"; Rec."By When")
                {
                    ToolTip = 'Specifies the value of the By When field.', Comment = '%';
                }
                field("Employee Score"; Rec."Employee Score")
                {
                    ToolTip = 'Specifies the value of the Employee Score field.', Comment = '%';
                }
                field("Manager Score"; Rec."Manager Score")
                {
                    ToolTip = 'Specifies the value of the Manager Score field.', Comment = '%';
                }
            }
        }
    }
}
