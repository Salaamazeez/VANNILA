report 50154 ImportDailyAllocOilWaterGas
{
    //Excel to have the following columns
    //Facility(Code)  Filed(Code)   OML(Code) Well(Code)    Well Type(Code)   Transaction Date(Date)    Dailly Allocation(Decimal)
    ApplicationArea = All;
    Caption = 'Import Daily Allocation Oil, Water & Gas';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Integer; "Integer")
        {

            trigger OnAfterGetRecord()
            begin
                ImportSheet(Number);
                WindowDialog.Update(1, DailyOliAllocation.Well);
                WindowDialog.Update(2, DailyOliAllocation."Production Date");

                DailyOliAllocation.Init();

                Evaluate(DailyOliAllocation."Production Date", ColText[1]);
                DailyOliAllocation.Facility := ColText[2];
                DailyOliAllocation.Fields := ColText[3];
                DailyOliAllocation.OML := ColText[4];
                DailyOliAllocation.Well := ColText[5];
                DailyOliAllocation."Well Type" := ColText[6];
                Evaluate(DailyOliAllocation."Daily Allocated Oil", ColText[7]);
                Evaluate(DailyOliAllocation."Daily Allocated Water", ColText[8]);
                Evaluate(DailyOliAllocation."Daily Allocated Gas", ColText[9]);
                Evaluate(DailyOliAllocation."Potential Oil Cond", ColText[10]);
                Evaluate(DailyOliAllocation."Potential Gas Rate", ColText[11]);

                if DailyOliAllocation2.get(DailyOliAllocation.Well, DailyOliAllocation."Well Type", DailyOliAllocation."Production Date") then;
                //DailyOliAllocation."Production Code" := ColText[8];
                //DailyOliAllocation."Production Sub Unit Code" := ColText[9];
                //DailyOliAllocation."Stream Code Code" := ColText[10];
                //DailyOliAllocation."Stream Name" := ColText[11];
                IF DailyOliAllocation.INSERT(True) then begin
                    RecordCount += 1;
                end ELSE begin
                    //if confirmMgt.GetResponseOrDefault('Record with %1 %2 %3 already exit do you want to modify and continue the import?', true) then begin
                    if (DailyOliAllocation2."Daily Allocated Oil" <> DailyOliAllocation."Daily Allocated Oil") OR
                        (DailyOliAllocation2."Daily Allocated Water" <> DailyOliAllocation."Daily Allocated Water") OR
                          (DailyOliAllocation2."Daily Allocated Gas" <> DailyOliAllocation."Daily Allocated Gas") OR
                          (DailyOliAllocation2."Potential Oil Cond" <> DailyOliAllocation."Potential Oil Cond") OR
                          (DailyOliAllocation2."Potential Oil Cond" <> DailyOliAllocation."Potential Gas Rate") then begin
                        if GuiAllowed then
                            if Confirm(ConfirmDuplicate, true, DailyOliAllocation.Well, DailyOliAllocation."Well Type", DailyOliAllocation."Production Code") then begin
                                if UserSetup.Get(UserId) then
                                    if (not UserSetup."OilGas Data Admin") then
                                        Error(ErrormodifyData);
                                DailyOliAllocation.Modify();
                                RecordModified += 1;
                            end;
                    end;
                end;

            end;

            trigger OnPreDataItem()
            begin
                ExcelBuf.RESET;
                ExcelBuf.DELETEALL;
                //ExcelBuf.OpenBook(ServerFileName, SheetName);
                //UploadIntoStream(Text006, '', 'Excel(.xlsx)|*xlsx', FileName, instrm);
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
        WindowDialog.Open(TextDisplay, DailyOliAllocation.Well, DailyOliAllocation."Production Date");
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
        DailyOliAllocation: Record DailyAllocationOilWaterGas;
        DailyOliAllocation2: Record DailyAllocationOilWaterGas;

        FileName: Text[250];
        ServerFileName: Text[250];
        SheetName: Text[250];
        instrm: instream;

        Text005: Label 'Imported from Excel';
        Text006: Label 'Import Excel File';
        msgfinishUpdate: label 'Data successfully imported, %1 record inserted and %2 record modified';
        WindowDialog: Dialog;

        TextDisplay: Label 'import Record ###########1 with transaction Date ##########2:';
        ConfirmDuplicate: label 'Record with %1 %2 %3 already exit do you want to modify and continue the import?';
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
        /*
        IF FileName <> '' THEN
            ServerFileName := FileMgt.UploadFile(Text006, FileName)

        ELSE
            ServerFileName := FileMgt.UploadFile(Text006, '.xlsx');


        FileName := FileMgt.GetFileName(ServerFileName);
        */
        UploadIntoStream(Text006, '', 'Excel(.xlsx)|*.xlsx', FileName, instrm);
    end;
}