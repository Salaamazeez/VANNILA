report 50029 "Create Bank Reversal"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.") where("KBS Closed" = const(false), Open = const(true));

            trigger OnPreDataItem()
            begin
                if (StartDate = 0D) or (EndDate = 0D) then
                    "Bank Account Ledger Entry".SetFilter("Posting Date", '%1..%2', StartDate, EndDate);
                if ReversingBankNo <> '' then
                    "Bank Account Ledger Entry".SetRange("Bank Account No.", ReversingBankNo)
                else
                    Error('Reversing No. cannot be empty');
                GenJournalLine2.SetRange("Journal Template Name", TemplateNo);
                GenJournalLine2.SetRange("Journal Batch Name", BatchNo);
                GenJournalLine2.DeleteAll();
            end;

            trigger OnAfterGetRecord()
            begin
                CreateBankReversal("Bank Account Ledger Entry")
            end;

        }

    }

    requestpage
    {
        SaveValues = true;
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {

            area(Content)
            {
                group(GroupName)
                {
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;
                    }
                    field(ReversingBankNo; ReversingBankNo)
                    {
                        Caption = 'Reversing Bank No';
                        TableRelation = "Bank Account";
                        ApplicationArea = All;
                    }
                    field(DestinationBankNo; DestinationBankNo)
                    {
                        Caption = 'Destination Bank No';
                        TableRelation = "Bank Account";
                        ApplicationArea = All;
                    }
                    field(TemplateNo; TemplateNo)
                    {
                        Caption = 'Template No';
                        TableRelation = "Gen. Journal Template";
                        ApplicationArea = All;
                    }
                    field(BatchNo; BatchNo)
                    {
                        Caption = 'Batch No';
                        TableRelation = "Gen. Journal Batch".Name;
                        ApplicationArea = All;
                    }
                }
            }
        }

       
    }
    trigger OnInitReport()
    begin
        LineNo := 0;
        GenLedgerSetup.Get();
        TemplateNo := GenLedgerSetup."General Journal Template";
        BatchNo := GenLedgerSetup."General Journal Batch";
    end;

    local procedure CreateBankReversal(BankLedgerEntry: Record "Bank Account Ledger Entry")
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        LineNo += 10000;
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := TemplateNo;
        GenJournalLine."Journal Batch Name" := BatchNo;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := GenJournalLine."Account Type"::"Bank Account";
        GenJournalLine."Posting Date" := "Bank Account Ledger Entry"."Posting Date";
        GenJournalLine."Document No." := "Bank Account Ledger Entry"."Document No.";
        GenJournalLine.Insert();
        GenJournalLine.Validate("Account No.", "Bank Account Ledger Entry"."Bank Account No.");
        GenJournalLine.Description := "Bank Account Ledger Entry".Description;
        GenJournalLine.Description := "Bank Account Ledger Entry".Description;
        GenJournalLine.Validate(Amount, -"Bank Account Ledger Entry".Amount);
        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
        GenJournalLine.Validate("Bal. Account No.", DestinationBankNo);
        GenJournalLine."Shortcut Dimension 1 Code" := "Bank Account Ledger Entry"."Global Dimension 1 Code";
        GenJournalLine."Shortcut Dimension 2 Code" := "Bank Account Ledger Entry"."Global Dimension 2 Code";
        GenJournalLine.Validate( "Dimension Set ID", "Bank Account Ledger Entry"."Dimension Set ID");
        GenJournalLine.Modify();
    end;

    var
        StartDate: Date;
        EndDate: Date;
        ReversingBankNo: Code[20];
        DestinationBankNo: Code[20];
        GenLedgerSetup: Record "General Ledger Setup";
        LineNo: Integer;
        BatchNo: Code[20];
        TemplateNo: Code[20];
        GenJournalLine2: Record "Gen. Journal Line";
}