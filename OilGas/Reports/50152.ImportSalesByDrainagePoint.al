report 50152 ImportSalesByDrainagePoint
{
    //Excel to have the following columns
    //Facility(Code)  Filed(Code)   OML(Code) Well(Code)    Well Type(Code)   Transaction Date(Date)    Dailly Allocation(Decimal)
    //ApplicationArea = All;
    Caption = 'Import Sales By Drainage point';
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
                WindowDialog.Update(1, SalesByDrainagePoint."Well Code");
                WindowDialog.Update(2, SalesByDrainagePoint."Period Code");
                //SalesByDrainagePoint2.Get(ColText[5], ColText[])

                SalesByDrainagePoint.Init();
                SalesByDrainagePoint."Period Code" := ColText[1];
                SalesByDrainagePoint."Production Code" := ColText[2];
                SalesByDrainagePoint."Production Sub Unit Code" := ColText[3];
                SalesByDrainagePoint."Area Code" := ColText[4];
                SalesByDrainagePoint."Well Code" := ColText[5];
                SalesByDrainagePoint."Field Code" := ColText[6];
                SalesByDrainagePoint."Facility Code" := ColText[7];
                SalesByDrainagePoint."Well Type" := ColText[8];

                Evaluate(SalesByDrainagePoint."Allocated Production Net Oil", ColText[9]);
                Evaluate(SalesByDrainagePoint."Allocated Water Volume", ColText[10]);
                Evaluate(SalesByDrainagePoint."Allocated Gas Volume", ColText[11]);
                Evaluate(SalesByDrainagePoint."Sales Gas", ColText[12]);
                Evaluate(SalesByDrainagePoint.Fuel, ColText[13]);
                Evaluate(SalesByDrainagePoint.Flared, ColText[14]);
                SalesByDrainagePoint.OML := ColText[15];
                SalesByDrainagePoint."Stream Code" := ColText[16];
                SalesByDrainagePoint."Stream Name" := ColText[17];

                IF SalesByDrainagePoint.INSERT(True) then begin
                    RecordCount += 1;
                end ELSE begin
                    //if confirmMgt.GetResponseOrDefault('Record with %1 %2 %3 already exit do you want to modify and continue the import?', true) then begin
                    if Confirm(ConfirmDuplicate, true, SalesByDrainagePoint."Well Code", SalesByDrainagePoint."Well Type", SalesByDrainagePoint."Period Code") then begin
                        // if (DailyOliAllocation2."Daily Allocated Oil" <> DailyOliAllocation."Daily Allocated Oil") OR
                        //(DailyOliAllocation2."Daily Allocated Water" <> DailyOliAllocation."Daily Allocated Water") OR
                        // (DailyOliAllocation2."Daily Allocated Gas" <> DailyOliAllocation."Daily Allocated Gas") then
                        SalesByDrainagePoint.Modify();
                        RecordModified += 1;
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
        WindowDialog.Open(TextDisplay, SalesByDrainagePoint."Well Code", SalesByDrainagePoint."Period Code");
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
        SalesByDrainagePoint: Record SalesByDrainagePoint;
        SalesByDrainagePoint2: Record SalesByDrainagePoint;

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