report 50156 ImportMonthlyReconData
{
    //Excel to have the following columns
    //Production Date Type	Actual/Plan	Field/FacilityName	Formation Gas	Fuel	Flare	Sales Gas	Oil and Condensate	Heating Value (BTU/scf)	Energy (MMBTU)	Plan Liquid Sales (kb/d)	Plan Gas Sales (mmscf/d)	LE Liquids	LE Gas	Integrated Export Capacity	Spiked Condenate	Returned Condensate	Sold Condensate/NewCross	Production Adjustments	Lifting volumes	Misc1	Misc2

    ApplicationArea = All;
    Caption = 'Import Monthly Reconciliation Data';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Integer; "Integer")
        {

            trigger OnAfterGetRecord()
            begin
                ImportSheet(Number);
                WindowDialog.Update(1, MonthlyReconsData."Field/Facility Name");
                WindowDialog.Update(2, MonthlyReconsData."Production Date");

                MonthlyReconsData.Init();

                Evaluate(MonthlyReconsData."Production Date", ColText[1]);
                MonthlyReconsData.Type := ColText[2];
                MonthlyReconsData."Actual/Plan" := ColText[3];
                MonthlyReconsData."Field/Facility Name" := ColText[4];
                Evaluate(MonthlyReconsData."Formation Gas", ColText[5]);
                Evaluate(MonthlyReconsData.Fuel, ColText[6]);
                Evaluate(MonthlyReconsData.Flare, ColText[7]);
                Evaluate(MonthlyReconsData."Sales Gas", ColText[8]);
                Evaluate(MonthlyReconsData."Oil and Condensate", ColText[9]);
                Evaluate(MonthlyReconsData."Heating Value (BTU/scf)", ColText[10]);
                Evaluate(MonthlyReconsData."Energy (MMBTU)", ColText[11]);

                Evaluate(MonthlyReconsData."Plan Liquid Sales (kb/d)", ColText[12]);
                Evaluate(MonthlyReconsData."Plan Gas Sales (mmscf/d)", ColText[13]);
                Evaluate(MonthlyReconsData."LE Liquids", ColText[14]);
                Evaluate(MonthlyReconsData."LE Gas", ColText[15]);
                Evaluate(MonthlyReconsData."Integrated Export Capacity", ColText[16]);
                Evaluate(MonthlyReconsData."Spiked Condenate", ColText[17]);
                Evaluate(MonthlyReconsData."Returned Condensate", ColText[18]);
                Evaluate(MonthlyReconsData."Sold Condensate/NewCross", ColText[19]);
                Evaluate(MonthlyReconsData."Production Adjustments", ColText[20]);
                Evaluate(MonthlyReconsData."Lifting volumes", ColText[21]);
                Evaluate(MonthlyReconsData.Misc1, ColText[22]);
                Evaluate(MonthlyReconsData.Misc2, ColText[23]);

                if MonthlyReconsData2.get(MonthlyReconsData."Production Date", MonthlyReconsData.Type, MonthlyReconsData."Actual/Plan", MonthlyReconsData."Field/Facility Name") then;

                IF MonthlyReconsData.INSERT(True) then begin
                    RecordCount += 1;
                end ELSE begin
                    //if confirmMgt.GetResponseOrDefault('Record with %1 %2 %3 already exit do you want to modify and continue the import?', true) then begin
                    if (MonthlyReconsData2."Formation Gas" <> MonthlyReconsData."Formation Gas") OR
                        (MonthlyReconsData2.Fuel <> MonthlyReconsData.Fuel) OR
                          (MonthlyReconsData2.Flare <> MonthlyReconsData.Flare) OR
                          (MonthlyReconsData2."Sales Gas" <> MonthlyReconsData."Sales Gas") OR
                          (MonthlyReconsData2."Oil and Condensate" <> MonthlyReconsData."Oil and Condensate") OR
                          (MonthlyReconsData2."Heating Value (BTU/scf)" <> MonthlyReconsData."Heating Value (BTU/scf)") OR
                          (MonthlyReconsData2."Energy (MMBTU)" <> MonthlyReconsData."Energy (MMBTU)") OR
                          (MonthlyReconsData2."Plan Liquid Sales (kb/d)" <> MonthlyReconsData."Plan Liquid Sales (kb/d)") OR
                          (MonthlyReconsData2."Plan Gas Sales (mmscf/d)" <> MonthlyReconsData."Plan Gas Sales (mmscf/d)") OR
                          (MonthlyReconsData2."LE Liquids" <> MonthlyReconsData."LE Liquids") OR
                          (MonthlyReconsData2."LE Gas" <> MonthlyReconsData."LE Gas") OR
                          (MonthlyReconsData2."Integrated Export Capacity" <> MonthlyReconsData."Integrated Export Capacity") OR
                          (MonthlyReconsData2."Spiked Condenate" <> MonthlyReconsData."Spiked Condenate") OR
                          (MonthlyReconsData2."Returned Condensate" <> MonthlyReconsData."Returned Condensate") OR
                          (MonthlyReconsData2."Sold Condensate/NewCross" <> MonthlyReconsData."Sold Condensate/NewCross") OR
                          (MonthlyReconsData2."Production Adjustments" <> MonthlyReconsData."Production Adjustments") OR
                          (MonthlyReconsData2."Lifting volumes" <> MonthlyReconsData."Lifting volumes") OR
                          (MonthlyReconsData2.Misc1 <> MonthlyReconsData.Misc2) OR
                          (MonthlyReconsData2.Misc2 <> MonthlyReconsData.Misc2) then begin
                        if GuiAllowed then
                            If (RecordModified = 0) then
                                if Confirm(ConfirmDuplicate, true, MonthlyReconsData."Field/Facility Name", MonthlyReconsData."Actual/Plan", MonthlyReconsData.Type, MonthlyReconsData."Production Date") then begin
                                    if UserSetup.Get(UserId) then
                                        if (not UserSetup."OilGas Data Admin") then
                                            Error(ErrormodifyData)
                                        else begin
                                            MonthlyReconsData.Modify();
                                            //RecordModified += 1;
                                        end;
                                end;
                    end;
                    RecordModified += 1;
                end;

            end;

            trigger OnPreDataItem()
            begin
                ExcelBuf.RESET;
                ExcelBuf.DELETEALL;
                ExcelBuf.OpenBookStream(instrm, SheetName);
                ExcelBuf.ReadSheet;
                IF ExcelBuf.FINDLAST THEN
                    SETRANGE(Number, 2, ExcelBuf."Row No.");
            end;

            trigger OnPostDataItem()
            begin
                WindowDialog.Close();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Option)
                {
                    group("Import From")
                    {
                        field(FileName; FileName)
                        {
                            Caption = 'Workbook Filename';
                            ApplicationArea = All;

                            trigger OnAssistEdit()
                            begin
                                RequestFile;
                                SheetName := ExcelBuf.SelectSheetsNameStream(instrm);
                            end;
                        }
                        field(SheetName; SheetName)
                        {
                            Caption = 'Sheet Name';
                            ApplicationArea = All;

                            trigger OnAssistEdit()
                            begin
                                IF ServerFileName = '' THEN BEGIN
                                    RequestFile;
                                END;

                                SheetName := ExcelBuf.SelectSheetsNameStream(instrm);
                            end;
                        }
                    }

                }

            }

        }
        actions
        {
            area(processing)
            {
            }
        }
        trigger OnInit()
        begin

        end;

        trigger OnOpenPage()
        begin
        end;
    }
    trigger OnInitReport()
    begin
    end;

    trigger OnPreReport()
    begin
        WindowDialog.Open(TextDisplay, MonthlyReconsData."Field/Facility Name", MonthlyReconsData."Production Date");
    end;

    trigger OnPostReport()
    begin
        //Error('%1     %2', RecordCount, RecordModified);
        //Message(msgfinishUpdate, RecordCount, RecordModified);
        Message('Data successfully imported, %1 record inserted and %2 record modified', RecordCount, RecordModified);
    end;

    var

        ExcelBuf: Record "Excel Buffer" temporary;
        ColText: array[100] of Text[250];
        FileMgt: Codeunit "File Management";
        MonthlyReconsData: Record MonthlyReconData;

        MonthlyReconsData2: Record MonthlyReconData;

        FileName: Text[250];
        ServerFileName: Text[250];
        SheetName: Text[250];
        instrm: instream;

        Text005: Label 'Imported from Excel';
        Text006: Label 'Import Excel File';
        msgfinishUpdate: label 'Data successfully imported, %1 record inserted and %2 record modified';
        WindowDialog: Dialog;

        TextDisplay: Label 'import Record ###########1 with transaction Date ##########2:';
        ConfirmDuplicate: label 'Record with %1 %2 %3 already exist for the period %4, do you want to modify and continue the import?';
        RecordCount: Integer;
        RecordModified: Integer;
        ErrormodifyData: label 'You do not have the OilGas Permission Admin to modify the data';
        UserSetup: record "User Setup";

    Procedure ImportSheet(RowNumber: Integer)
    var
    begin
        CLEAR(ColText);
        ExcelBuf.SETRANGE(ExcelBuf."Row No.", RowNumber);
        IF ExcelBuf.FINDFIRST THEN BEGIN
            REPEAT
                ColText[ExcelBuf."Column No."] := ExcelBuf."Cell Value as Text";
            UNTIL ExcelBuf.NEXT = 0;
        END;
    end;

    procedure RequestFile()
    begin
        UploadIntoStream(Text006, '', 'Excel(.xlsx)|*.xlsx', FileName, instrm);
    end;
}