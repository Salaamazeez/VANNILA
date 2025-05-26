report 50152 ImportMonthlyAllocWaterOilGas
{
    //Excel to have the following columns
    //Facility(Code)  Filed(Code)   OML(Code) Well(Code)    Well Type(Code)   Transaction Date(Date)    Dailly Allocation(Decimal)
    ApplicationArea = All;
    Caption = 'Import Monthly Allocation Water, Oil & Gas';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Integer; "Integer")
        {

            trigger OnAfterGetRecord()
            begin
                ImportSheet(Number);
                WindowDialog.Update(1, monthlyAlloc.Well);
                WindowDialog.Update(2, monthlyAlloc."Production Date");

                monthlyAlloc.Init();
                Evaluate(monthlyAlloc."Production Date", ColText[1]);
                monthlyAlloc.Facility := ColText[2];
                monthlyAlloc.Fields := ColText[3];
                monthlyAlloc.OML := ColText[4];
                monthlyAlloc.Well := ColText[5];
                monthlyAlloc."Well Type" := ColText[6];
                Evaluate(monthlyAlloc."Daily Allocated Oil", ColText[7]);
                Evaluate(monthlyAlloc."Daily Allocated Water", ColText[8]);
                Evaluate(monthlyAlloc."Daily Allocated Gas", ColText[9]);
                Evaluate(monthlyAlloc."Potential Oil Cond", ColText[10]);
                Evaluate(monthlyAlloc."Potential Gas Rate", ColText[11]);


                if monthlyAlloc2.Get(monthlyAlloc.Well, monthlyAlloc."Well Type", monthlyAlloc."Production Date") then;

                IF monthlyAlloc.INSERT(True) then begin
                    RecordCount += 1;
                end ELSE begin
                    //if confirmMgt.GetResponseOrDefault('Record with %1 %2 %3 already exit do you want to modify and continue the import?', true) then begin
                    if GuiAllowed then
                        if (RecordModified = 0) then
                            if Confirm(ConfirmDuplicate, true, monthlyAlloc.Well, monthlyAlloc."Well Type", monthlyAlloc."Production Date") then begin
                                if (monthlyAlloc."Daily Allocated Gas" <> monthlyAlloc2."Daily Allocated Gas") OR
                                (monthlyAlloc."Daily Allocated Oil" <> monthlyAlloc2."Daily Allocated Oil") OR
                                (monthlyAlloc."Daily Allocated Water" <> monthlyAlloc2."Daily Allocated Water") OR
                                (monthlyAlloc."Potential Oil Cond" <> monthlyAlloc2."Potential Oil Cond") OR
                                (monthlyAlloc."Potential Gas Rate" <> monthlyAlloc2."Potential Gas Rate") then begin
                                    if UserSetup.Get(UserId) then
                                        if (not UserSetup."OilGas Data Admin") then
                                            Error(ErrormodifyData)
                                        else begin
                                            //monthlyAlloc.Modify();
                                            RecordModified += 1;
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
        WindowDialog.Open(TextDisplay, monthlyAlloc.Well, monthlyAlloc."Production Date");
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
        monthlyAlloc: Record MonthlyAllocationOilWaterGas;
        monthlyAlloc2: Record MonthlyAllocationOilWaterGas;

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
        confirmMgt: Codeunit "Confirm Management";
        UserSetup: Record "User Setup";
        ErrormodifyData: label 'You do not have the OilGas Permission Admin to modify the data';

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