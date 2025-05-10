page 50142 DailyAllocationWaterList
{
    //ApplicationArea = All;
    Caption = 'Daily Allocation Water (bbl) List';
    PageType = List;
    SourceTable = DailyAllocationWater;
    UsageCategory = Tasks;
    Editable = false;
    //ApplicationArea = All;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Production Date"; Rec."Production Date")
                {
                    ToolTip = 'Specifies the value of the Transaction Date field.', Comment = '%';
                }
                field(Facility; Rec.Facility)
                {
                    ToolTip = 'Specifies the value of the Facility field.', Comment = '%';
                }
                field("Fields"; Rec."Fields")
                {
                    ToolTip = 'Specifies the value of the Field field.', Comment = '%';
                }
                field(OML; Rec.OML)
                {
                    ToolTip = 'Specifies the value of the OML field.', Comment = '%';
                }
                field(Well; Rec.Well)
                {
                    ToolTip = 'Specifies the value of the Well field.', Comment = '%';
                }
                field("Well Type"; Rec."Well Type")
                {
                    ToolTip = 'Specifies the value of the Well Type field.', Comment = '%';
                }

                field("Daily Allocated"; Rec."Daily Allocated")
                {
                    ToolTip = 'Specifies the value of the Daily Allocated field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ImportFromExcel)
            {
                Caption = 'Import Daily Allocation Water (bbl)';
                Image = ImportExcel;
                Promoted = true;
                promotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.Run(Report::ImportDialyAllocWater);
                end;
            }
            action(DeleteRecord)
            {
                Caption = 'Delete Data';
                Image = DeleteRow;
                Promoted = true;
                promotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    DailyWaterAlloc.RESET;
                    DailyWaterAlloc.SetCurrentKey(Well, "Well Type", "Production Date");
                    IF DailyWaterAlloc.FindSet() then
                        DailyWaterAlloc.DeleteAll();
                end;
            }
            action(ViewReport)
            {
                Caption = 'Print Report';
                Image = Report;
                Promoted = true;
                promotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.Run(Report::DailyAllocationOilReport);
                end;
            }
        }
    }
    var
        DailyWaterAlloc: record DailyAllocationWater;
}
