report 50147 ImportDailyAllocOil
{
    //Excel to have the following columns
    //Facility(Code)  Filed(Code)   OML(Code) Well(Code)    Well Type(Code)   Transaction Date(Date)    Dailly Allocation(Decimal)
    //ApplicationArea = All;
    Caption = 'Import Daily Oil Allocation & Condensate (bbl)';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    //ApplicationArea = All;
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
                Evaluate(DailyOliAllocation."Daily Allocated", ColText[7]);

                DailyOliAllocation."Production Code" := ColText[8];
                DailyOliAllocation."Production Sub Unit Code" := ColText[9];
                DailyOliAllocation."Stream Code Code" := ColText[10];
                DailyOliAllocation."Stream Name" := ColText[11];
                IF DailyOliAllocation.INSERT(True) then begin
                    RecordCount += 1;
                end ELSE begin
                    DailyOliAllocation.Modify();
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
        DailyOliAllocation: Record DailyAllocationOil;

        FileName: Text[250];
        ServerFileName: Text[250];
        SheetName: Text[250];
        instrm: instream;

        Text005: Label 'Imported from Excel';
        Text006: Label 'Import Excel File';
        msgfinishUpdate: label 'Data successfully imported, %1 record inserted and %2 record modified';
        WindowDialog: Dialog;

        TextDisplay: Label 'import Record ###########1 with transaction Date ##########2:';
        RecordCount: Integer;
        RecordModified: Integer;

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