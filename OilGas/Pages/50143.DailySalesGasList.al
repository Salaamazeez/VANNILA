page 50143 DailySalesGasList
{
    //ApplicationArea = All;
    Caption = 'Daily Sales Gas List';
    PageType = List;
    SourceTable = DailySalesGas;
    UsageCategory = Tasks;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
                field("Transaction Date"; Rec."Transaction Date")
                {
                    ToolTip = 'Specifies the value of the Transaction Date field.', Comment = '%';
                }
                field("Sale Gas"; Rec."Sale Gas")
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
                Caption = 'Import Daily Sales Gas';
                Image = ImportExcel;
                Promoted = true;
                promotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.Run(Report::ImportDailySalesGas);
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
                    DailySaleGas.RESET;
                    DailySaleGas.SetCurrentKey(Well, "Well Type", "Transaction Date");
                    IF DailySaleGas.FindSet() then
                        DailySaleGas.DeleteAll();
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
        DailySaleGas: record DailySalesGas;
}
