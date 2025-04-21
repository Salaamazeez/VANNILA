codeunit 50030 MyCodeunit
{
    Permissions = tabledata "Bank Account Ledger Entry" = rm;
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldCustLedgEntry', '', false, false)]
    local procedure OnBeforeInsertDtldCustLedgEntry(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.Get(DtldCustLedgEntry."Cust. Ledger Entry No.");
        DtldCustLedgEntry."Transaction type" := CustLedgerEntry."Transaction type";
        DtldCustLedgEntry."Loan ID" := CustLedgerEntry."Loan ID";
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', true, true)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line");
    begin
        GLEntry."Transaction type" := GenJournalLine."Transaction type";
        GLEntry."Loan ID" := GenJournalLine."Loan ID";

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitCustLedgEntry, '', false, false)]
    local procedure OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; var GLRegister: Record "G/L Register");
    begin
        CustLedgerEntry."Transaction type" := GenJournalLine."Transaction type";
        CustLedgerEntry."Loan ID" := GenJournalLine."Loan ID";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnSetUpNewLineOnBeforeIncrDocNo, '', false, false)]
    local procedure "Gen. Journal Line_OnSetUpNewLineOnBeforeIncrDocNo"(var GenJournalLine: Record "Gen. Journal Line"; LastGenJournalLine: Record "Gen. Journal Line"; var Balance: Decimal; var BottomLine: Boolean; var IsHandled: Boolean; var Rec: Record "Gen. Journal Line"; GenJnlBatch: Record "Gen. Journal Batch")
    begin
        IsHandled := true
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitBankAccLedgEntry, '', false, false)]
    // local procedure "Gen. Jnl.-Post Line_OnAfterInitBankAccLedgEntry"(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    // begin
    //     BankAccountLedgerEntry."KBS Open" := GenJournalLine."KBS Open"
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnPostBankAccOnBeforeBankAccLedgEntryInsert, '', false, false)]
    local procedure "Gen. Jnl.-Post Line_OnPostBankAccOnBeforeBankAccLedgEntryInsert"(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextTransactionNo: Integer; GLRegister: Record "G/L Register")
    var
        LastBankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        BankAccountLedgerEntry."KBS Closed" := GenJournalLine."KBS Closed";
        if not GenJournalLine."KBS Closed" then
            exit;
        if BankAccountLedgerEntry.IsTemporary then
            exit;
        LastBankAccountLedgerEntry.Reset();
        LastBankAccountLedgerEntry.SetRange("Bank Account No.", GenJournalLine."Account No.");
        LastBankAccountLedgerEntry.SetRange(Amount, -GenJournalLine.Amount);
        LastBankAccountLedgerEntry.SetRange("Currency Code", GenJournalLine."Currency Code");
        LastBankAccountLedgerEntry.SetRange("KBS Closed", false);
        LastBankAccountLedgerEntry.SetRange(Open, true);
        if LastBankAccountLedgerEntry.FindFirst() then begin
            LastBankAccountLedgerEntry."KBS Closed" := true;
            LastBankAccountLedgerEntry.Modify();
        end;

    end;


}