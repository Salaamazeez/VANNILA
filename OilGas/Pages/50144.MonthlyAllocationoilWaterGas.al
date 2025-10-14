page 50144 SalesByDrainaigePoint
{
    ApplicationArea = All;
    Caption = 'Monthly Allocation Oil, Water & Gas';
    PageType = List;
    SourceTable = MonthlyAllocationOilWaterGas;
    UsageCategory = Tasks;
    Editable = true;
    ModifyAllowed = true;
    DeleteAllowed = true;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Production Date"; Rec."Production Date")
                {
                    ToolTip = 'Specifies the value of the Production Date field.', Comment = '%';
                }
                field(Facility; Rec.Facility)
                {
                    ToolTip = 'Specifies the value of the Facility Code field.', Comment = '%';
                }
                field("Fields"; Rec."Fields")
                {
                    ToolTip = 'Specifies the value of the Field Code field.', Comment = '%';
                }
                field(OML; Rec.OML)
                {
                    ToolTip = 'Specifies the value of the Oil Mining Lease field.', Comment = '%';
                }
                field(Well; Rec.Well)
                {
                    ToolTip = 'Specifies the value of the Well Code field.', Comment = '%';
                }
                field("Well Type"; Rec."Well Type")
                {
                    ToolTip = 'Specifies the value of the Well Type field.', Comment = '%';
                }
                field("Daily Allocated Oil"; Rec."Daily Allocated Oil")
                {
                    ToolTip = 'Specifies the value of the Tot Net Oil & Condensate field.', Comment = '%';
                }
                field("Allocated Water volume (bbl)"; Rec."Daily Allocated Water")
                {
                    ToolTip = 'Specifies the value of the Allocated Water volume (bbl) field.', Comment = '%';
                }
                field("Allocated Gas volume (Mscf)"; Rec."Daily Allocated Gas")
                {
                    ToolTip = 'Specifies the value of the Allocated Gas volume (Mscf) field.', Comment = '%';
                }
                field("Potential Oil Cond"; Rec."Potential Oil Cond")
                {
                    ToolTip = 'Specifies the value for Potential Oil + Condensate';
                }
                field("Potential Gas Rate"; Rec."Potential Gas Rate")
                {
                    ToolTip = 'Specifies the value for Potential Gas Rate [Mscf]';
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
                Caption = 'Import Monthly Allocation Oil, Water & Gas';
                Image = ImportExcel;
                Promoted = true;
                promotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.Run(Report::ImportMonthlyAllocWaterOilGas);
                end;
            }
            /*
            action(DeleteRecord)
            {
                Caption = 'Delete Data';
                Image = DeleteRow;
                Promoted = true;
                promotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF UserSetup.Get(UserId) then begin
                        IF UserSetup."OilGas Data Admin" then begin
                            MonthlyAlloc.RESET;
                            MonthlyAlloc.SetCurrentKey(Well, "Well Type", "Production Date");
                            IF MonthlyAlloc.FindSet() then
                                MonthlyAlloc.DeleteAll();
                        end;
                    end else
                        error(errorDeleteData);
                end;
            }
            */
            action(ViewReport)
            {
                Caption = 'Print Report';
                Image = Report;
                Promoted = true;
                promotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //Report.Run(Report::DailyAllocationOilReport);
                end;
            }
        }
    }
    var
        MonthlyAlloc: record MonthlyAllocationOilWaterGas;
        UserSetup: Record "User Setup";
        ErrorDeleteData: Label 'You do not have the OilGas permission Admin to delete the data';
        ErrormodifyData: label 'You do not have the OilGas permission Admin to modify the data';
        ErrorOpenOilGas: label 'You do not have permmision to open this page';

    trigger OnDeleteRecord(): Boolean
    begin
        if UserSetup.Get(UserId) then
            if (not UserSetup."OilGas Data Admin") then
                error(errorDeleteData);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if UserSetup.Get(UserId) then
            if (not UserSetup."OilGas Data Admin") then
                Error(ErrormodifyData);
    end;

    trigger OnOpenPage()
    begin
        if UserSetup.Get(UserId) then
            if (not UserSetup."OilGas Data Upload") then
                Error(ErrorOpenOilGas);
    end;
}

