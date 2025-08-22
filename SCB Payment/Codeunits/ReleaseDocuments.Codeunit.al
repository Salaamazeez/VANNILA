// Codeunit 52092142 "Release Documents"
// {

//     trigger OnRun()
//     begin
//     end;

//     var
//         TransferHeader: Record "Transfer Header";
//         RecRef: RecordRef;
//         FldRef: FieldRef;
//         StatusOption: Option Open,Approved,"Pending Approval";
//         Text001: label 'The approval process must be cancelled or completed to reopen this document.';
//         Text002: label 'This document can only be released when the approval process is complete.';
//         StatusInteger: Integer;
//         CalledFromApproval: Boolean;


//     procedure PerformManualReopen(RecdRef: RecordRef)
//     begin
//         RecRef := RecdRef;
//         if FindFieldNo = 0 then
//             exit;
//         if not CalledFromApproval then begin
//             StatusInteger := FldRef.Value;
//             StatusOption := StatusInteger;
//             if StatusOption = Statusoption::"Pending Approval" then
//                 Error(Text001);
//         end;
//         ReopenDocument;
//     end;


//     procedure PerformanualManualDocRelease(RecdRef: RecordRef): Boolean
//     begin
//         RecRef := RecdRef;
//         ReleaseDocument;
//     end;


//     procedure ReopenDocument()
//     begin

//         FldRef.Validate(0);
//         RecRef.Modify();

//     end;


//     procedure ReleaseDocument()
//     var
//     begin
//         FindFieldNo;
//         FldRef.Validate(1);
//         RecRef.Modify();
//     end;

//     procedure FindFieldNo(): Integer
//     var
//         i: Integer;
//     begin
//         for i := 1 to RecRef.FieldCount do begin
//             FldRef := RecRef.FieldIndex(i);
//             if UpperCase(Format(FldRef.CLASS)) = 'NORMAL' then begin
//                 if (RecRef.Number = Database::Job) OR (RecRef.Number = Database::"Transfer Header") then begin
//                     if FldRef.Name = 'Approval Status' then
//                         exit(i);
//                 end else begin
//                     if FldRef.Name = 'Status' then
//                         exit(i);
//                 end;
//             end;
//         end;

//         exit(0);
//     end;


//     procedure SetCalledFromApproval(CalledFromApproval2: Boolean)
//     begin
//         CalledFromApproval := CalledFromApproval2;
//     end;

//     local procedure ReleaseTranDoc()
//     var
//         TransferHeader: Record "Transfer Header";
//         ReleaseTransferDoc: Codeunit "Release Transfer Document";
//     begin
//         RecRef.SetTable(TransferHeader);
//         ReleaseTransferDoc.Run(TransferHeader);

//     end;


// }

