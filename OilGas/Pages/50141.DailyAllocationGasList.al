page 50141 DailyAllocationGasList
{
    //ApplicationArea = All;
    Caption = 'Daily Allocation Gas (Mscf) List';
    PageType = List;
    SourceTable = DailyAllocationGas;
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
                    ApplicationArea = All;
                }
                field(Facility; Rec.Facility)
                {
                    ToolTip = 'Specifies the value of the Facility field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Fields"; Rec."Fields")
                {
                    ToolTip = 'Specifies the value of the Field field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(OML; Rec.OML)
                {
                    ToolTip = 'Specifies the value of the OML field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Well; Rec.Well)
                {
                    ToolTip = 'Specifies the value of the Well field.', Comment = '%';
                    ApplicationArea = All;
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
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ToolTip = 'Specifies the value of the Last Modified By field.', Comment = '%';
                    Visible = False;
                    ApplicationArea = All;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ToolTip = 'Specifies the value of the Last Modified Date field.', Comment = '%';
                    Visible = False;
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
                Caption = 'Import Daily Allocation Gas (Mscf)';
                Image = ImportExcel;
                Promoted = true;
                promotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.Run(Report::ImportDailyAllocGas);
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
                    DailyGasAlloc.RESET;
                    DailyGasAlloc.SetCurrentKey(Well, "Well Type", "Production Date");
                    IF DailyGasAlloc.FindSet() then
                        DailyGasAlloc.DeleteAll();
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
        DailyGasAlloc: record DailyAllocationGas;
}
