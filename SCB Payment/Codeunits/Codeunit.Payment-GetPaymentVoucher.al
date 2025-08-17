// Codeunit 52092236 "Payment - Get Payment Voucher"
// {
//     TableNo = "Payment Window Header";

//     trigger OnRun()
//     var
//         PaymentHeader: Record "Payment Header";
//     begin
//         PaymentTransHeader.Get("Batch Number");
//         PaymentTransHeader.TestField("Bank Account Code");
//         PaymentHeader.SetRange(Status, PaymentHeader.Status::Approved);
//         PaymentHeader.SetRange("Payment Method", PaymentHeader."payment method"::"E-Payment");
//         PaymentHeader.SetRange(PaymentHeader."Payment Source", PaymentTransHeader."Bank Account Code");
//         PaymentHeader.SetFilter(PaymentHeader."Payment ID", '%1', '');

//         if PaymentHeader.Find('-') then begin
//             PaymentSchedule.SetRange(PaymentSchedule."Source Document No.", PaymentHeader."No.");
//             repeat
//                 if (PaymentHeader."Payment Type" = PaymentHeader."payment type"::"Supp. Invoice") then begin
//                     PaymentHeader.TestField("Payee Bank Code");
//                     PaymentHeader.TestField("Payee Bank Account No.");
//                     PaymentHeader.TestField(Payee);
//                 end;
//             until PaymentHeader.Next = 0;
//         end;

//         GetPaymentList.LookupMode := true;
//         GetPaymentList.SetTableview(PaymentHeader);

//         GetPaymentList.SetPaymentHeader(PaymentTransHeader);
//         GetPaymentList.RunModal;
//     end;

//     var
//         PaymentTransHeader: Record "Payment Window Header";
//         PaymentTransLine: Record "Payment Window Line";
//         GetPaymentList: Page "Get Payment Voucher";
//         LineNo: Integer;
//         PaymentSchedule: Record "Payment Schedule";
//         Batch: label ' Payment Batch';
//         NewBatchNumber: Code[20];


//     procedure CreatePaymentLines(var PaymentHeader: Record "Payment Header")
//     var
//         RecdRef: RecordRef;
//         PaymentLine: Record "Payment Line";
//         GLSetup: Record "General Ledger Setup";
//         PaymentScheduleLine: Record "Payment Schedule";
//         CountOnLine: Integer;
//         PaymentBatch: Integer;
//         PaymentBatchTex: Text[100];
//         FirstPaymentHeader: Code[10];
//         PageNo: Integer;
//         SerialNo: Integer;
//         PmtTranSetup: Record "Payment Trans Setup";
//     begin
//         PaymentTransLine.SetRange("Batch Number", PaymentTransHeader."Batch Number");
//         PmtTranSetup.Get;
//         if PaymentTransLine.Find('+') then
//             LineNo := PaymentTransLine."Line No." + 10000
//         else
//             LineNo := 10000;
//         PageNo := 1;
//         SerialNo := 1;
//         with PaymentHeader do begin
//             if PaymentHeader.Find('-') then begin
//                 repeat
//                     PaymentHeader.CalcFields(Amount, "WHT Amount", "Schedule Amount");
//                     RecdRef.GetTable(PaymentHeader);
//                     if PaymentHeader."Schedule Amount" = 0 then begin
//                         PaymentHeader.TestField("Payee Bank Code");
//                         PaymentHeader.TestField(PaymentHeader."Payee Bank Account No.");
//                         PaymentHeader.TestField(Payee);
//                         PaymentHeader.TestField("Payee CBN Bank Code");
//                         LineNo := LineNo + 10000;
//                         PaymentTransLine.Init;
//                         PaymentTransLine."Batch Number" := PaymentTransHeader."Batch Number";
//                         PaymentTransLine."Line No." := LineNo;
//                         PaymentTransLine.Validate("Bank CBN Code", "Payee CBN Bank Code");
//                         PaymentTransLine."To Account Number" := PaymentHeader."Payee Bank Account No.";
//                         PaymentTransLine.Amount := (PaymentHeader.Amount - PaymentHeader."WHT Amount");
//                         PaymentTransLine.Description := PaymentHeader."Posting Description";
//                         PaymentTransLine.Payee := PaymentHeader.Payee;
//                         PaymentTransLine."Reference Type" := PaymentTransLine."reference type"::Voucher;
//                         PaymentTransLine."Record ID" := RecdRef.RecordId;
//                         if Format(SerialNo) = PmtTranSetup."Nibss Schedule Size" then begin
//                             PageNo := PageNo + 1;
//                             SerialNo := 1;
//                         end;
//                         PaymentTransLine."Source No." := PaymentHeader."No.";
//                         PaymentTransLine."Schedule Page No." := PageNo;
//                         PaymentTransLine."Schedule Serial No." := SerialNo;
//                         SerialNo := SerialNo + 1;
//                         PaymentTransLine.Insert(true);
//                         SerialNo := SerialNo + 1;
//                     end else begin
//                         PaymentLine.SetRange("Document Type", PaymentHeader."Document Type");
//                         PaymentLine.SetRange("Document No.", PaymentHeader."No.");
//                         PaymentLine.Find('-');
//                         repeat
//                             PaymentLine.CalcFields("Schedule Amount");
//                             if PaymentLine."Schedule Amount" <> 0 then begin
//                                 PaymentScheduleLine.SetRange("Source Document No.", PaymentLine."Document No.");
//                                 PaymentScheduleLine.SetRange("Source Line No.", PaymentLine."Line No.");
//                                 PaymentScheduleLine.FindSet;
//                                 if PaymentScheduleLine.Count > 8000 then begin
//                                     PaymentBatch := PaymentBatch + 1;
//                                     PaymentBatchTex := '001';
//                                     FirstPaymentHeader := PaymentTransHeader."Batch Number";
//                                     PaymentTransHeader.Description := PaymentHeader."Posting Description" + '' + Batch + '-' + PaymentBatchTex;
//                                     PaymentTransHeader.Modify;
//                                     PaymentBatchTex := PaymentTransHeader.Description;
//                                 end;
//                                 NewBatchNumber := PaymentTransHeader."Batch Number";
//                                 repeat
//                                     PaymentScheduleLine.TestField("Payee Account No.");
//                                     PaymentScheduleLine.TestField("Payee Name");
//                                     //PaymentScheduleLine.TESTFIELD("CBN Bank Code");
//                                     PaymentTransLine.Init;
//                                     PaymentTransLine."Reference Number" := '';
//                                     if CountOnLine = 8000 then begin
//                                         PaymentBatchTex := IncStr(PaymentBatchTex);
//                                         PaymentBatch := PaymentBatch + 1;
//                                         //PaymentBatchTex:= FORMAT(PaymentBatch);
//                                         NewBatchNumber := CreateHeaderBatch(FirstPaymentHeader, PaymentBatchTex);
//                                         LineNo := 0;
//                                         CountOnLine := 0;
//                                     end;
//                                     LineNo := LineNo + 1000;
//                                     PaymentTransLine."Batch Number" := NewBatchNumber;
//                                     PaymentTransLine."Payment Batch" := Batch + ' ' + PaymentBatchTex;
//                                     PaymentTransLine."Line No." := LineNo;
//                                     PaymentTransLine.Validate("Bank CBN Code", PaymentScheduleLine."Credit Bank Code");
//                                     //PaymentTransLine.TransactionType := 50;
//                                     PaymentTransLine."To Account Number" := PaymentScheduleLine."Payee Account No.";
//                                     //PaymentTransLine."To Account Type" := 10;
//                                     PaymentTransLine.Amount := (PaymentScheduleLine.Amount);
//                                     PaymentTransLine.Description := PaymentScheduleLine."Posting Description";
//                                     //PaymentTransLine."Bank Name" := PaymentHeader."Bank Account Name";
//                                     PaymentTransLine.Payee := PaymentScheduleLine."Payee Name";
//                                     PaymentTransLine."Reference Type" := PaymentTransLine."reference type"::Voucher;
//                                     PaymentTransLine."Record ID" := RecdRef.RecordId;
//                                     PaymentTransLine."Source No." := PaymentHeader."No.";
//                                     if PaymentHeader."Payment Type" = PaymentHeader."payment type"::"Supp. Invoice" then
//                                         PaymentTransLine."Source Type" := PaymentTransLine."source type"::Vendor;



//                                     if PaymentHeader."Payment Type" = PaymentHeader."payment type"::Others then
//                                         PaymentTransLine."Source Type" := PaymentTransLine."source type"::"Bank Account";

//                                     PaymentTransLine."Payee No." := PaymentScheduleLine."Payee No.";
//                                     PaymentTransLine."Payee BVN" := PaymentScheduleLine."Payee BVN";
//                                     if Format(SerialNo) = PmtTranSetup."Nibss Schedule Size" then begin
//                                         PageNo := PageNo + 1;
//                                         SerialNo := 1;
//                                     end;
//                                     PaymentTransLine."Schedule Page No." := PageNo;
//                                     PaymentTransLine."Schedule Serial No." := SerialNo;
//                                     PaymentTransLine.Insert(true);
//                                     SerialNo := SerialNo + 1;
//                                     CountOnLine := CountOnLine + 1;
//                                 until PaymentScheduleLine.Next = 0;
//                             end;
//                         until PaymentLine.Next = 0;
//                     end;
//                     PaymentHeader."Payment ID" := PaymentTransHeader."Batch Number";
//                     PaymentHeader.Modify;
//                 until PaymentHeader.Next = 0;
//             end;
//         end
//     end;


//     procedure SetPaymentTranHeader(var PaymentTransHeader2: Record "Payment Window Header")
//     begin
//         PaymentTransHeader.Get(PaymentTransHeader2."Batch Number");
//         PaymentTransHeader.TestField(Submitted, false);
//     end;


//     procedure CreateHeaderBatch(PaymentHeader: Code[20]; BatchName: Text) "Batch Number": Code[20]
//     var
//         PaymentTransHeaderRec: Record "Payment Window Header";
//         NewPaymentTransHeaderRec: Record "Payment Window Header";
//         Position: Integer;
//     begin
//         PaymentTransHeaderRec.Get(PaymentHeader);
//         NewPaymentTransHeaderRec.Init;
//         NewPaymentTransHeaderRec.TransferFields(PaymentTransHeaderRec);
//         NewPaymentTransHeaderRec."Batch Number" := '';
//         NewPaymentTransHeaderRec.Insert(true);
//         "Batch Number" := NewPaymentTransHeaderRec."Batch Number";
//         if PaymentTransHeaderRec."Related Batches" = '' then begin
//             PaymentTransHeaderRec."Related Batches" := NewPaymentTransHeaderRec."Batch Number";
//             Position := StrPos(NewPaymentTransHeaderRec.Description, '-');
//             //NewPaymentTransHeaderRec.Description:= COPYSTR(NewPaymentTransHeaderRec.Description,Position) + BatchName;
//             NewPaymentTransHeaderRec.Description := BatchName;
//             NewPaymentTransHeaderRec.Modify;
//             PaymentTransHeaderRec.Modify;
//         end else begin
//             PaymentTransHeaderRec."Related Batches" := PaymentTransHeaderRec."Related Batches" + '|' + NewPaymentTransHeaderRec."Batch Number";
//             Position := StrPos(NewPaymentTransHeaderRec.Description, '-');
//             //NewPaymentTransHeaderRec.Description:= COPYSTR(NewPaymentTransHeaderRec.Description,Position) + BatchName;
//             NewPaymentTransHeaderRec.Description := BatchName;
//             NewPaymentTransHeaderRec.Modify;
//             PaymentTransHeaderRec.Modify;
//         end;
//         exit;
//     end;


//     procedure CreateHeaderFromApprovedPV(PaymentVoucherNo: Code[20]) "Batch Number": Code[20]
//     var
//         PaymentTransHeaderRec: Record "Payment Window Header";
//         NewPaymentTransHeaderRec: Record "Payment Window Header";
//         Position: Integer;
//         PaymentHeader: Record "Payment Header";
//         GeneralLedgerSetup: Record "General Ledger Setup";
//         PmtTranSetup: Record "Payment Trans Setup";
//     begin
//         PaymentHeader.Get(PaymentHeader."document type"::"Payment Voucher", PaymentVoucherNo);
//         PmtTranSetup.Get;
//         PaymentHeader.TestField(Status, PaymentHeader.Status::Approved);

//         PaymentTransHeader.Init;
//         PaymentTransHeader."Batch Number" := PaymentHeader."No.";
//         PaymentTransHeader."API Platform" := PmtTranSetup."Payment Platform";
//         PaymentTransHeader.Description := PaymentHeader."Posting Description";
//         GeneralLedgerSetup.Get;
//         PaymentTransHeader."Payment Type" := PaymentHeader."Payment Type";
//         PaymentTransHeader.Validate("Bank Account Number", PaymentHeader."Payment Source");
//         if PaymentTransHeader.Insert(true) then
//             exit(PaymentTransHeader."Batch Number");
//     end;


//     procedure CreatePaymentLinesFromPV(var PaymentHeader: Record "Payment Header")
//     var
//         RecdRef: RecordRef;
//         PaymentLine: Record "Payment Line";
//         GLSetup: Record "General Ledger Setup";
//         PaymentScheduleLine: Record "Payment Schedule";
//         CountOnLine: Integer;
//         PaymentBatch: Integer;
//         PaymentBatchTex: Text[100];
//         FirstPaymentHeader: Code[10];
//         //PaymentGateways: Codeunit "Payment Gateways";
//         PaymentTransHeader: Record "Payment Window Header";
//     begin
//         PaymentTransLine.SetRange("Batch Number", PaymentHeader."No.");
//         if PaymentTransLine.Find('+') then
//             LineNo := PaymentTransLine."Line No." + 10000
//         else
//             LineNo := 10000;
//         PaymentHeader.CalcFields(Amount, "WHT Amount", "Schedule Amount");
//         RecdRef.GetTable(PaymentHeader);
//         if PaymentHeader."Schedule Amount" = 0 then begin
//             PaymentHeader.TestField("Payee Bank Code");
//             PaymentHeader.TestField(PaymentHeader."Payee Bank Account No.");
//             PaymentHeader.TestField(Payee);
//             PaymentHeader.TestField("Payee CBN Bank Code");
//             LineNo := LineNo + 10000;
//             PaymentTransLine.Init;
//             PaymentTransLine."Batch Number" := PaymentHeader."No.";
//             PaymentTransLine."Line No." := LineNo;
//             PaymentTransLine.Validate("Bank CBN Code", PaymentHeader."Payee CBN Bank Code");
//             //PaymentTransLine.TransactionType := 50;
//             PaymentTransLine."To Account Number" := PaymentHeader."Payee Bank Account No.";
//             //PaymentTransLine."To Account Type" := 10;
//             PaymentTransLine.Amount := (PaymentHeader.Amount - PaymentHeader."WHT Amount");
//             PaymentTransLine.Description := PaymentHeader."Posting Description";
//             //PaymentTransLine."Bank Name" := PaymentHeader."Bank Account Name";
//             PaymentTransLine.Payee := PaymentHeader.Payee;
//             PaymentTransLine."Reference Type" := PaymentTransLine."reference type"::Voucher;
//             PaymentTransLine."Record ID" := RecdRef.RecordId;
//             PaymentTransLine."Source No." := PaymentHeader."No.";
//             PaymentTransLine.Insert(true);
//         end else begin
//             PaymentLine.SetRange("Document Type", PaymentHeader."Document Type");
//             PaymentLine.SetRange("Document No.", PaymentHeader."No.");
//             PaymentLine.Find('-');
//             repeat
//                 PaymentLine.CalcFields("Schedule Amount");
//                 if PaymentLine."Schedule Amount" <> 0 then begin
//                     PaymentScheduleLine.SetRange("Source Document No.", PaymentLine."Document No.");
//                     PaymentScheduleLine.SetRange("Source Line No.", PaymentLine."Line No.");
//                     PaymentScheduleLine.FindSet;
//                     repeat
//                         PaymentScheduleLine.TestField("Payee Account No.");
//                         PaymentScheduleLine.TestField("Payee Name");

//                         PaymentTransLine.Init;
//                         PaymentTransLine."Reference Number" := '';
//                         LineNo := LineNo + 1000;
//                         PaymentTransLine."Batch Number" := PaymentHeader."No.";
//                         PaymentTransLine."Payment Batch" := Batch + ' ' + PaymentBatchTex;
//                         PaymentTransLine."Line No." := LineNo;
//                         PaymentTransLine.Validate("Bank CBN Code", PaymentScheduleLine."Credit Bank Code");
//                         //PaymentTransLine.TransactionType := 50;
//                         PaymentTransLine."To Account Number" := PaymentScheduleLine."Payee Account No.";
//                         //PaymentTransLine."From Account Number":= PaymentScheduleLine."Debit Bank Account No.";
//                         //PaymentTransLine."To Account Type" := 10;
//                         PaymentTransLine.Amount := (PaymentScheduleLine.Amount);
//                         PaymentTransLine.Description := PaymentScheduleLine."Posting Description";
//                         //PaymentTransLine."Bank Name" := PaymentHeader."Bank Account Name";
//                         PaymentTransLine.Payee := PaymentScheduleLine."Payee Name";
//                         PaymentTransLine."Reference Type" := PaymentTransLine."reference type"::Voucher;
//                         PaymentTransLine."Record ID" := RecdRef.RecordId;
//                         PaymentTransLine."Source No." := PaymentHeader."No.";
//                         if PaymentHeader."Payment Type" = PaymentHeader."payment type"::"Supp. Invoice" then
//                             PaymentTransLine."Source Type" := PaymentTransLine."source type"::Vendor;


//                         PaymentTransLine."Payee No." := PaymentScheduleLine."Payee No.";
//                         PaymentTransLine."Payee BVN" := PaymentScheduleLine."Payee BVN";
//                         PaymentTransLine.Insert(true);
//                         CountOnLine := CountOnLine + 1;
//                     until PaymentScheduleLine.Next = 0;
//                 end;
//             until PaymentLine.Next = 0;
//         end;
//         PaymentHeader."Payment ID" := PaymentHeader."No.";
//         PaymentHeader.Modify;
//         //PaymentTransHeader.GET(PaymentHeader."No.");
//         //PaymentGateways.SendSchedule(PaymentTransHeader);
//     end;
// }

