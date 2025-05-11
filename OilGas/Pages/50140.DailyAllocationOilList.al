page 50140 DailyAllocationOilList
{
    ApplicationArea = All;
    Caption = 'Daily Allocation Oil & Condensate (bbl)';
    PageType = List;
    SourceTable = DailyAllocationOil;
    UsageCategory = Tasks;
    Editable = False;
    ApplicationArea = All;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Transaction Date"; Rec."Production Date")
                {
                    ToolTip = 'Specifies the value of the Transaction Date field.', Comment = '%';
                }
                field(Facility; Rec.Facility)
                {
                    ToolTip = 'Specifies the value of the Facility field.', Comment = '%';
                }
                field("Fields"; Rec."Fields")
                {
                    ToolTip = 'Specifies the value of the Fields field.', Comment = '%';
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
                    ApplicationArea = All;
                }

                field("Daily Allocated"; Rec."Daily Allocated")
                {
                    ToolTip = 'Specifies the value of the Daily Allocated field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.', Comment = '%';
                    ApplicationArea = All;
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
                Caption = 'Import Daily Allocation Oil & Cond (bbl)';
                Image = ImportExcel;
                Promoted = true;
                promotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.Run(Report::ImportDailyAllocOil);
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
                    DailyOilAlloc.RESET;
                    DailyOilAlloc.SetCurrentKey(Well, "Well Type", "Production Date");
                    IF DailyOilAlloc.FindSet() then
                        DailyOilAlloc.DeleteAll();
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
        DailyOilAlloc: record DailyAllocationOil;
}