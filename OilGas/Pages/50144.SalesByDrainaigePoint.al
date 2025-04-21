page 50144 SalesByDrainaigePoint
{
    ApplicationArea = All;
    Caption = 'Sales By Drainaige Point';
    PageType = List;
    SourceTable = SalesByDrainagePoint;
    UsageCategory = Tasks;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code field.', Comment = '%';
                }
                field("Production Code"; Rec."Production Code")
                {
                    ToolTip = 'Specifies the value of the Production Code field.', Comment = '%';
                }
                field("Production Sub Unit Code"; Rec."Production Sub Unit Code")
                {
                    ToolTip = 'Specifies the value of the Production Sub Unit Code field.', Comment = '%';
                }
                field("Area Code"; Rec."Area Code")
                {
                    ToolTip = 'Specifies the value of the Area Code field.', Comment = '%';
                }
                field("Well Code"; Rec."Well Code")
                {
                    ToolTip = 'Specifies the value of the Well Code field.', Comment = '%';
                }
                field("Field Code"; Rec."Field Code")
                {
                    ToolTip = 'Specifies the value of the Field Code field.', Comment = '%';
                }
                field("Facility Code"; Rec."Facility Code")
                {
                    ToolTip = 'Specifies the value of the Facility Code field.', Comment = '%';
                }
                field("Well Type"; Rec."Well Type")
                {
                    ToolTip = 'Specifies the value of the Well Type field.', Comment = '%';
                }

                field("Allocated Production Net Oil"; Rec."Allocated Production Net Oil")
                {
                    ToolTip = 'Specifies the value of the Allocated Production Net Oil field.', Comment = '%';
                }
                field("Allocated Water Volume"; Rec."Allocated Water Volume")
                {
                    ToolTip = 'Specifies the value of the Allocated Water Volume field.', Comment = '%';
                }
                field("Allocated Gas Volume"; Rec."Allocated Gas Volume")
                {
                    ToolTip = 'Specifies the value of the Allocated Gas Volume field.', Comment = '%';
                }
                field("Sales Gas"; Rec."Sales Gas")
                {
                    ToolTip = 'Specifies the value of the Sales Gas field.', Comment = '%';
                }
                field(Fuel; Rec.Fuel)
                {
                    ToolTip = 'Specifies the value of the Fuel field.', Comment = '%';
                }
                field(Flared; Rec.Flared)
                {
                    ToolTip = 'Specifies the value of the Flared field.', Comment = '%';
                }

                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date field.', Comment = '%';
                }
                field(OML; Rec.OML)
                {
                    ToolTip = 'Specifies the value of the OML field.', Comment = '%';
                    Visible = false;
                }
                field("Stream Code"; Rec."Stream Code")
                {
                    ToolTip = 'Specifies the value of the Stream Code field.', Comment = '%';
                    Visible = false;
                }
                field("Stream Name"; Rec."Stream Name")
                {
                    ToolTip = 'Specifies the value of the Stream Name field.', Comment = '%';
                    Visible = false;
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
                Caption = 'Import Monthly Sales By Drainage Point';
                Image = ImportExcel;
                Promoted = true;
                promotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.Run(Report::ImportSalesByDrainagePoint);
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
                    SaleByDrainagePoint.RESET;
                    SaleByDrainagePoint.SetCurrentKey("Well Code", "Well Type", "Period Code");
                    IF SaleByDrainagePoint.FindSet() then
                        SaleByDrainagePoint.DeleteAll();
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
        SaleByDrainagePoint: record SalesByDrainagePoint;
}
