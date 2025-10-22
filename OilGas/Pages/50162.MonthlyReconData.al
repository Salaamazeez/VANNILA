page 50162 MonthlyReconData
{
    ApplicationArea = All;
    Caption = 'Monthly Reconciliation Data';
    PageType = List;
    SourceTable = MonthlyReconData;
    UsageCategory = Tasks;
    Editable = true;
    ModifyAllowed = true;
    InsertAllowed = false;
    DeleteAllowed = true;

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
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = '%';
                }
                field("Actual/Plan"; Rec."Actual/Plan")
                {
                    ToolTip = 'Specifies the value of the Actual/Plan field.', Comment = '%';
                }
                field("Field/Facility Name"; Rec."Field/Facility Name")
                {
                    ToolTip = 'Specifies the value of the Field/Facility Name field.', Comment = '%';
                }
                field("Formation Gas"; Rec."Formation Gas")
                {
                    ToolTip = 'Specifies the value of the Formation Gas field.', Comment = '%';
                }
                field(Fuel; Rec.Fuel)
                {
                    ToolTip = 'Specifies the value of the Fuel field.', Comment = '%';
                }
                field(Flare; Rec.Flare)
                {
                    ToolTip = 'Specifies the value of the Flare field.', Comment = '%';
                }
                field("Sales Gas"; Rec."Sales Gas")
                {
                    ToolTip = 'Specifies the value of the Sales Gas field.', Comment = '%';
                }
                field("Oil and Condensate"; Rec."Oil and Condensate")
                {
                    ToolTip = 'Specifies the value of the Oil and Condensate field.', Comment = '%';
                }
                field("Heating Value (BTU/scf)"; Rec."Heating Value (BTU/scf)")
                {
                    ToolTip = 'Specifies the value of the Heating Value (BTU/scf) field.', Comment = '%';
                }
                field("Energy (MMBTU)"; Rec."Energy (MMBTU)")
                {
                    ToolTip = 'Specifies the value of the Energy (MMBTU) field.', Comment = '%';
                }
                field("Plan Liquid Sales (kb/d)"; Rec."Plan Liquid Sales (kb/d)")
                {
                    ToolTip = 'Specifies the value of the Plan Liquid Sales (kb/d) field.', Comment = '%';
                }
                field("Plan Gas Sales (mmscf/d)"; Rec."Plan Gas Sales (mmscf/d)")
                {
                    ToolTip = 'Specifies the value of the Plan Gas Sales (mmscf/d) field.', Comment = '%';
                }
                field("LE Liquids"; Rec."LE Liquids")
                {
                    ToolTip = 'Specifies the value of the LE Liquids field.', Comment = '%';
                }
                field("LE Gas"; Rec."LE Gas")
                {
                    ToolTip = 'Specifies the value of the LE Gas field.', Comment = '%';
                }
                field("Integrated Export Capacity"; Rec."Integrated Export Capacity")
                {
                    ToolTip = 'Specifies the value of the Integrated Export Capacity field.', Comment = '%';
                }
                field("Spiked Condenate"; Rec."Spiked Condenate")
                {
                    ToolTip = 'Specifies the value of the Spiked Condenate field.', Comment = '%';
                }
                field("Returned Condensate"; Rec."Returned Condensate")
                {
                    ToolTip = 'Specifies the value of the Returned Condensate field.', Comment = '%';
                }
                field("Sold Condensate/NewCross"; Rec."Sold Condensate/NewCross")
                {
                    ToolTip = 'Specifies the value of the Sold Condensate/NewCross field.', Comment = '%';
                }
                field("Production Adjustments"; Rec."Production Adjustments")
                {
                    ToolTip = 'Specifies the value of the Production Adjustments field.', Comment = '%';
                }
                field("Lifting volumes"; Rec."Lifting volumes")
                {
                    ToolTip = 'Specifies the value of the Lifting volumes field.', Comment = '%';
                }
                field(Misc1; Rec.Misc1)
                {
                    ToolTip = 'Specifies the value of the Misc1 field.', Comment = '%';
                }
                field(Misc2; Rec.Misc2)
                {
                    ToolTip = 'Specifies the value of the Misc2 field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.', Comment = '%';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ToolTip = 'Specifies the value of the Last Modified By field.', Comment = '%';
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ToolTip = 'Specifies the value of the Last Modified Date field.', Comment = '%';
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
                Caption = 'Import Monthly Reconciliation Data';
                Image = ImportExcel;
                Promoted = true;
                promotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.Run(Report::ImportMonthlyReconData);
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
                            MonthlyReconsData.RESET;
                            MonthlyReconsData.SetCurrentKey(MonthlyReconsData."Production Date", MonthlyReconsData."Type", MonthlyReconsData."Actual/Plan", MonthlyReconsData."Field/Facility Name");
                            IF MonthlyReconsData.FindSet() then
                                MonthlyReconsData.DeleteAll();
                        end else
                            error(errorDeleteData);
                    end
                end;
            }
            */

        }
    }
    var
        MonthlyReconsData: record MonthlyReconData;
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
        Error('Page under development');
        if UserSetup.Get(UserId) then
            if (not UserSetup."OilGas Data Upload") then
                Error(ErrorOpenOilGas);
    end;
}
