// Codeunit 52092242 "Payment - Get Payroll Entries"
// {
//     TableNo = "Payment Schedule Header";

//     trigger OnRun()
//     var
//         ClosePayrollHeader: Record "Payroll-PayslipHder";
//         ClosedPayslipList: Page "Closed Payslip List";
//     begin
//         PaymentTransHeader.Get(Rec."Batch Number");
//         PaymentTransHeader.TestField("Bank Account Code");
//         if PaymentTransHeader."Multiple Remittance Period" = false then
//             PaymentTransHeader.TestField("Payroll Period")
//         else begin
//             PaymentTransHeader.TestField("Start Period");
//             PaymentTransHeader.TestField("End Period");
//         end;
//         PaymentTransHeader.TestField("Payroll-E/DCode");
//         ClosePayrollHeader.SetRange("Payroll Period", PaymentTransHeader."Payroll Period");
//         ClosePayrollHeader.SetFilter("Voucher No.", '%1', '');

//         Clear(ClosedPayslipList);
//         ClosedPayslipList.SetTableview(ClosePayrollHeader);
//         ClosedPayslipList.LookupMode := true;
//         ClosedPayslipList.SetPaymentParameters(Rec, true);
//         ClosedPayslipList.RunModal;
//     end;

//     var
//         PaymentTransHeader: Record "Payment Schedule Header";
//         GLSetup: Record "General Ledger Setup";
//         PmtTranSetup: Record "Payment Trans Setup";
//         NextEntryNo: Integer;
//         FileManagement: Codeunit "File Management";
//         TempFileName: Text;
//         MyExcelBuffer: Record "Excel Buffer";
//         EmployeeContributionED: Text;
//         EmployeerContributionED: Text;
//         EmployerVoluntaryContributionED: Text;
//         EmployeeVoluntaryContributionED: Text;
//         TotalPensionContributionED: Code[20];
//         SheetName: Text;
//         Body: Text;


//     procedure SetPaymentTranHeader(var PaymentTransHeader2: Record "Payment Schedule Header")
//     begin
//         PaymentTransHeader.Get(PaymentTransHeader2."Batch Number");
//         PaymentTransHeader.TestField(Submitted, false);
//     end;

//     procedure CreatePayrollEntries(var ClosePayrollHeader: Record "Closed Payroll-PayslipHder")
//     var
//         PaymentTransLine: Record "Payment Schedule Line";
//         RecdRef: RecordRef;
//         PageNo: Integer;
//         SerialNo: Integer;
//     begin
//         PmtTranSetup.Get;
//         PageNo := 1;
//         SerialNo := 1;
//         with ClosePayrollHeader do begin
//             ClosePayrollHeader.SetRange("ED Filter", PaymentTransHeader."Payroll-E/DCode");
//             if FindSet then
//                 repeat
//                     ClosePayrollHeader.CalcFields("ED Amount");
//                     RecdRef.GetTable(ClosePayrollHeader);
//                     if ClosePayrollHeader."ED Amount" <> 0 then begin
//                         PaymentTransLine.Init;
//                         PaymentTransLine."Batch Number" := PaymentTransHeader."Batch Number";
//                         PaymentTransLine."Line No." := GetNextEntryNo;
//                         PaymentTransLine.Validate("Bank CBN Code", "CBN Bank Code");
//                         PaymentTransLine."To Account Number" := "Bank Account";
//                         PaymentTransLine.Amount := "ED Amount";
//                         PaymentTransLine.Description := 'Salary Payment';
//                         PaymentTransLine."Payee No." := ClosePayrollHeader."Employee No.";
//                         PaymentTransLine.Payee := ClosePayrollHeader."Employee Name";
//                         PaymentTransLine."Reference Type" := PaymentTransLine."reference type"::Payroll;
//                         PaymentTransLine."Record ID" := RecdRef.RecordId;
//                         if Format(SerialNo) = PmtTranSetup."Nibss Schedule Size" then begin
//                             PageNo := PageNo + 1;
//                             SerialNo := 1;
//                         end;
//                         PaymentTransLine."Source No." := ClosePayrollHeader."Payroll Period";
//                         PaymentTransLine."Schedule Page No." := PageNo;
//                         PaymentTransLine."Schedule Serial No." := SerialNo;
//                         PaymentTransLine.Insert(true);
//                         SerialNo += 1;
//                     end;
//                 until ClosePayrollHeader.Next = 0;
//             // PaymentTransHeader."Attached to Entity" := PaymentTransHeader."Attached to Entity"::Payroll;
//             // PaymentTransHeader.Modify();
//         end;
//     end;

//     local procedure GetNextEntryNo(): Integer
//     var
//         PaymentTransLine: Record "Payment Schedule Line";
//     begin
//         if NextEntryNo = 0 then begin
//             PaymentTransLine.SetRange("Batch Number", PaymentTransHeader."Batch Number");
//             if PaymentTransLine.FindLast then
//                 NextEntryNo := PaymentTransLine."Line No." + 1000
//             else
//                 NextEntryNo := 1000;
//         end else
//             NextEntryNo += 1000;

//         exit(NextEntryNo);
//     end;


//     procedure CreatePayrollPensionRemittanceEntries(var ClosePayrollHeader: Record "Closed Payroll-PayslipHder")
//     var
//         PaymentTransLine: Record "Payment Schedule Line";
//         RecdRef: RecordRef;
//         PageNo: Integer;
//         SerialNo: Integer;
//         PayrollSetup: Record "Payroll-Setup";
//         PensionAdministrator: Record "Pension Administrator";
//         ClosedPayrollPayslipLine: Record "Closed Payroll-PayslipLine";
//         TotalRemittace: Decimal;
//     begin
//         if PaymentTransHeader."Payroll Payment" <> PaymentTransHeader."payroll payment"::"Pension Remitance" then
//             exit;
//         PmtTranSetup.Get;
//         PayrollSetup.Get;
//         PayrollSetup.TestField("Total Pension Contri. E/D");
//         PageNo := 1;
//         SerialNo := 1;
//         if PaymentTransHeader."Multiple Remittance Period" = false then
//             PensionAdministrator.SetRange("Payroll Period Filter", PaymentTransHeader."Payroll Period")
//         else
//             PensionAdministrator.SetRange("Payroll Period Filter", PaymentTransHeader."Start Period", PaymentTransHeader."End Period");
//         PensionAdministrator.CalcFields("Exist In Closed Payroll");
//         PensionAdministrator.SetRange("Exist In Closed Payroll", true);
//         if PensionAdministrator.FindSet then
//             repeat
//                 TotalRemittace := 0;
//                 ClosePayrollHeader.Reset;
//                 if PaymentTransHeader."Multiple Remittance Period" = false then
//                     ClosePayrollHeader.SetRange("Payroll Period", PaymentTransHeader."Payroll Period")
//                 else
//                     ClosePayrollHeader.SetRange("Payroll Period", PaymentTransHeader."Start Period", PaymentTransHeader."End Period");
//                 ClosePayrollHeader.SetRange("Pension Adminstrator Code", PensionAdministrator."Code");
//                 with ClosePayrollHeader do begin
//                     if FindSet then
//                         repeat
//                             if ClosedPayrollPayslipLine.Get(ClosePayrollHeader."Payroll Period", ClosePayrollHeader."Employee No.", PaymentTransHeader."Payroll-E/DCode") then
//                                 TotalRemittace := TotalRemittace + ClosedPayrollPayslipLine."Amount";
//                         until ClosePayrollHeader.Next = 0;
//                 end;
//                 PaymentTransLine.Init;
//                 PaymentTransLine."Batch Number" := PaymentTransHeader."Batch Number";
//                 PaymentTransLine."Line No." := GetNextEntryNo;
//                 PaymentTransLine.Validate("Bank CBN Code", PensionAdministrator."CBN Bank Code");
//                 PaymentTransLine."To Account Number" := PensionAdministrator."Receiving Account";
//                 PaymentTransLine.Amount := TotalRemittace;
//                 PaymentTransLine.Description := Format(PaymentTransHeader."Payroll Payment") + ' ' + PaymentTransHeader."Payroll Period";
//                 PaymentTransLine."Source Type" := PaymentTransLine."source type"::"Pension Fund Administrator";
//                 PaymentTransLine."Payee No." := PensionAdministrator."Code";
//                 PaymentTransLine.Payee := PensionAdministrator."Receiving Account Name";
//                 PaymentTransLine."Reference Type" := PaymentTransLine."reference type"::Payroll;

//                 //PaymentTransLine."Record ID" := RecdRef.RECORDID;
//                 if Format(SerialNo) = PmtTranSetup."Nibss Schedule Size" then begin
//                     PageNo := PageNo + 1;
//                     SerialNo := 1;
//                 end;
//                 PaymentTransLine."Source No." := ClosePayrollHeader."Payroll Period";
//                 PaymentTransLine."Schedule Page No." := PageNo;
//                 PaymentTransLine."Schedule Serial No." := SerialNo;
//                 PaymentTransLine.Insert(true);
//                 SerialNo += 1;
//             until PensionAdministrator.Next = 0;
//     end;


//     procedure GeneratePensionRemittanceExcelSchedule(PayrollPeriod: Code[10]; PensionAdministratorCode: Code[10]; PaymentBatch: Code[20])
//     var
//         ClosedPayrollPayslipHeader: Record "Closed Payroll-PayslipHder";
//         ClosedPayrollPayslipLine: Record "Closed Payroll-PayslipLine";
//         TotalEmployeeContributionAmt: Decimal;
//         TotalEmployerContributionAmt: Decimal;
//         TotalEmployeeVoluntaryContributionAmt: Decimal;
//         TotalEmployerVoluntaryContributionAmt: Decimal;
//         GrandTotalContributionAmt: Decimal;
//         PensionAdministrator: Record "Pension Administrator";
//         TransHeader: Record "Payment Schedule Header";
//         MailSubject: Text;
//     begin
//         TransHeader.Get(PaymentBatch);
//         if TransHeader."Multiple Remittance Period" = true then
//             MailSubject := StrSubstNo('Pension Remittance from %1 to %2', TransHeader."Start Period", TransHeader."End Period")
//         else
//             MailSubject := StrSubstNo('Pension Remittance for %1', TransHeader."Payroll Period");
//         MailSubject := UpperCase(MailSubject);

//         if PensionAdministrator.Get(PensionAdministratorCode) then begin
//             //TempFileName := FileManagement.ServerTempFileName(PensionAdministratorCode + '_Pension Remittance.xlsx');
//             CreatePensionRemittanceExcelScheduleHeader(PayrollPeriod, PensionAdministrator);
//             CreatePensionRemittanceExcelScheduleBody(PayrollPeriod, PensionAdministrator."Code",
//               PaymentBatch, TotalEmployeeContributionAmt, TotalEmployerContributionAmt, TotalEmployeeVoluntaryContributionAmt, TotalEmployerVoluntaryContributionAmt,
//                 GrandTotalContributionAmt);
//             CreatePensionRemittanceExcelScheduleFooter(PayrollPeriod, PensionAdministrator, PaymentBatch, TotalEmployeeContributionAmt,
//               TotalEmployerContributionAmt, TotalEmployeeVoluntaryContributionAmt, TotalEmployerVoluntaryContributionAmt, GrandTotalContributionAmt);
//             SendMail(true, TempFileName, PensionAdministrator."E-Mail Address Of PFA", 'Pension Remittance.xlsx',
//               GetMailBodyFromFilePath(PensionAdministrator."Mail Body File"), MailSubject, PensionAdministrator."Cc Mail Addresses");
//         end;
//     end;


//     procedure SendPensionRemittanceExcelScheduleToPFAs(PaymentBatch: Code[20]; myEmployeeContributionED: Text; myEmployeerContributionED: Text; myEmployerVoluntaryContributionED: Text; myEmployeeVoluntaryContributionED: Text; myTotalPensionContributionED: Code[20])
//     var
//         PensionAdministrator: Record "Pension Administrator";
//         PaymentTransHeader: Record "Payment Schedule Header";
//         PaymentTransLines: Record "Payment Schedule Line";
//         CompanyInformation: Record "Company Information";
//     begin
//         PaymentTransHeader.Get(PaymentBatch);
//         CompanyInformation.Get;
//         CompanyInformation.TestField("PENCOM Employer Code");
//         EmployeeContributionED := myEmployeeContributionED;
//         EmployeerContributionED := myEmployeerContributionED;
//         EmployeeVoluntaryContributionED := myEmployeeVoluntaryContributionED;
//         EmployerVoluntaryContributionED := myEmployerVoluntaryContributionED;

//         PaymentTransLines.Reset;
//         TotalPensionContributionED := myTotalPensionContributionED;
//         PaymentTransLines.SetRange("Batch Number", PaymentBatch);
//         PaymentTransLines.SetRange("Source Type", PaymentTransLines."source type"::"Pension Fund Administrator");
//         if PaymentTransLines.FindSet then
//             repeat
//                 if PensionAdministrator.Get(PaymentTransLines."Payee No.") then begin
//                     PensionAdministrator.TestField("Mail Body File");
//                     PensionAdministrator.TestField("E-Mail Address Of PFA");
//                     GeneratePensionRemittanceExcelSchedule(PaymentTransHeader."Payroll Period", PensionAdministrator."Code", PaymentBatch);
//                 end;
//             until PaymentTransLines.Next = 0;
//     end;

//     local procedure CreatePensionRemittanceExcelScheduleHeader(PayrollPeriod: Code[10]; PensionAdministrator: Record "Pension Administrator")
//     var
//         PayrollPeriodRec: Record "Payroll-Period";
//     begin
//         PayrollPeriodRec.Get(PayrollPeriod);
//         MyExcelBuffer.DeleteAll;
//         MyExcelBuffer.ClearNewRow;

//         MyExcelBuffer.NewRow();
//         MyExcelBuffer.AddColumn('REPORT TITLE: ' + COMPANYNAME + ' :' + 'PENSION CONTRIBUTION SCHEDULE', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.NewRow();
//         MyExcelBuffer.AddColumn('REPORT DATE: ' + Format(Today), false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.NewRow();
//         MyExcelBuffer.AddColumn('START DATE: ' + Format(PayrollPeriodRec."Start Date"), false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.NewRow();
//         MyExcelBuffer.AddColumn('END DATE: ' + Format(PayrollPeriodRec."End Date"), false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.NewRow();
//         MyExcelBuffer.AddColumn('S/NO.', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('RSA PIN', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('RSA HOLDER-FirstNameMiddleNameLastName', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('EMPLOYER CODE', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('EMPLOYER NAME', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('TRANSACTION DATE', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('SCHEDULE PERIOD', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('PERIOD START DATE', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('PERIOD END DATE', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('EMPLOYEE CONTRIBUTION', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('EMPLOYEE VOLUNTARY CONTRIBUTION', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('EMPLOYER CONTRIBUTION', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('EMPLOYER VOLUNTARY CONTRIBUTION', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('TOTAL CONTRIBUTION', false, '', true, false, true, '', MyExcelBuffer."cell type"::Text);
//     end;

//     local procedure CreatePensionRemittanceExcelScheduleBody(PayrollPeriod: Code[10]; PensionAdministratorCode: Code[10]; PaymentBatch: Code[20]; var TotalEmployeeContributionAmt: Decimal; var TotalEmployerContributionAmt: Decimal; var TotalEmployeeVoluntaryContributionAmt: Decimal; var TotalEmployerVoluntaryContributionAmt: Decimal; var GrandTotalContributionAmt: Decimal)
//     var
//         ClosedPayrollPayslipLine: Record "Closed Payroll-PayslipLine";
//         TransHeader: Record "Payment Schedule Header";
//         PayrollSetup: Record "Payroll-Setup";
//         EmployeeContributionAmt: Decimal;
//         EmployerContributionAmt: Decimal;
//         EmployeeVoluntaryContributionAmt: Decimal;
//         TotalContributionAmt: Decimal;
//         EmployerVoluntaryContributionAmt: Decimal;
//         SN: Integer;
//         PayrollEmployee: Record "Payroll-Employee";
//         PayrollPeriodRec: Record "Payroll-Period";
//         PensionAdministrator: Record "Pension Administrator";
//         StartPeriod: Code[10];
//         EndPeriod: Code[10];
//         CompanyInformation: Record "Company Information";
//     begin
//         TransHeader.Get(PaymentBatch);
//         CompanyInformation.Get;
//         PayrollEmployee.Reset;
//         GrandTotalContributionAmt := 0;
//         TotalEmployeeContributionAmt := 0;
//         TotalEmployeeVoluntaryContributionAmt := 0;
//         TotalEmployerContributionAmt := 0;
//         TotalEmployerVoluntaryContributionAmt := 0;
//         if TransHeader."Multiple Remittance Period" = true then begin
//             StartPeriod := TransHeader."Start Period";
//             EndPeriod := TransHeader."End Period";
//         end
//         else begin
//             StartPeriod := TransHeader."Payroll Period";
//             EndPeriod := TransHeader."Payroll Period";
//         end;

//         if PensionAdministrator.Get(PensionAdministratorCode) then begin
//             PayrollEmployee.SetRange("Pension Administrator Code", PensionAdministrator."Code");
//             PayrollEmployee.SetRange("Period Filter", StartPeriod, EndPeriod);

//             if PayrollEmployee.FindSet then
//                 repeat
//                     PayrollEmployee.CalcFields("Closed No. of Entries");
//                     if PayrollEmployee."Closed No. of Entries" <> 0 then begin
//                         SN := SN + 1;
//                         InitializePensionAmt(EmployeeContributionAmt, EmployerContributionAmt, EmployeeVoluntaryContributionAmt, EmployerVoluntaryContributionAmt, TotalContributionAmt);
//                         //Getvalues from payroll
//                         EmployeeContributionAmt := GetPayslipAmount(StartPeriod, EndPeriod, PayrollEmployee."No.", EmployeeContributionED);
//                         EmployerContributionAmt := GetPayslipAmount(StartPeriod, EndPeriod, PayrollEmployee."No.", EmployeerContributionED);
//                         EmployeeVoluntaryContributionAmt := GetPayslipAmount(StartPeriod, EndPeriod, PayrollEmployee."No.", EmployeeVoluntaryContributionED);
//                         EmployerVoluntaryContributionAmt := GetPayslipAmount(StartPeriod, EndPeriod, PayrollEmployee."No.", EmployerVoluntaryContributionED);
//                         TotalContributionAmt := GetPayslipAmount(StartPeriod, EndPeriod, PayrollEmployee."No.", TotalPensionContributionED);
//                         //Build Sum for footer
//                         TotalEmployeeContributionAmt := TotalEmployeeContributionAmt + EmployeeContributionAmt;
//                         TotalEmployeeVoluntaryContributionAmt := TotalEmployeeVoluntaryContributionAmt + EmployeeVoluntaryContributionAmt;
//                         TotalEmployerContributionAmt := TotalEmployerContributionAmt + EmployerContributionAmt;
//                         TotalEmployerVoluntaryContributionAmt := TotalEmployerVoluntaryContributionAmt + EmployerVoluntaryContributionAmt;
//                         GrandTotalContributionAmt := GrandTotalContributionAmt + TotalContributionAmt;
//                         //IF TotalContributionAmt<>0 THEN
//                         // BEGIN
//                         MyExcelBuffer.NewRow;
//                         MyExcelBuffer.AddColumn(SN, false, '', false, false, false, '', MyExcelBuffer."cell type"::Number);
//                         MyExcelBuffer.AddColumn(PayrollEmployee."Pension No.", false, '', false, false, false, '', MyExcelBuffer."cell type"::Text);
//                         MyExcelBuffer.AddColumn(PayrollEmployee."First Name" + ' ' + PayrollEmployee."Middle Name" + ' ' + PayrollEmployee."Last Name",
//                           false, '', false, false, false, '', MyExcelBuffer."cell type"::Text);
//                         MyExcelBuffer.AddColumn(CompanyInformation."PENCOM Employer Code", false, '', false, false, false, '', MyExcelBuffer."cell type"::Text);
//                         MyExcelBuffer.AddColumn(COMPANYNAME, false, '', false, false, false, '', MyExcelBuffer."cell type"::Text);
//                         MyExcelBuffer.AddColumn(TransHeader."Date Submitted", false, '', false, false, false, '', MyExcelBuffer."cell type"::Date);
//                         if TransHeader."Multiple Remittance Period" then begin
//                             PayrollPeriodRec.Get(TransHeader."Start Period");
//                             MyExcelBuffer.AddColumn(TransHeader."Start Period" + '-' + TransHeader."End Period", false, '', false, false, false, '', MyExcelBuffer."cell type"::Text);
//                             MyExcelBuffer.AddColumn(PayrollPeriodRec."Start Date", false, '', false, false, false, '', MyExcelBuffer."cell type"::Date);
//                             PayrollPeriodRec.Get(TransHeader."End Period");
//                             MyExcelBuffer.AddColumn(PayrollPeriodRec."End Date", false, '', false, false, false, '', MyExcelBuffer."cell type"::Date);
//                         end
//                         else begin
//                             PayrollPeriodRec.Get(TransHeader."Payroll Period");
//                             MyExcelBuffer.AddColumn(TransHeader."Payroll Period", false, '', false, false, false, '', MyExcelBuffer."cell type"::Text);
//                             MyExcelBuffer.AddColumn(PayrollPeriodRec."Start Date", false, '', false, false, false, '', MyExcelBuffer."cell type"::Date);
//                             MyExcelBuffer.AddColumn(PayrollPeriodRec."End Date", false, '', false, false, false, '', MyExcelBuffer."cell type"::Date);
//                         end;
//                         MyExcelBuffer.AddColumn(EmployeeContributionAmt, false, '', false, false, false, '', MyExcelBuffer."cell type"::Number);
//                         MyExcelBuffer.AddColumn(EmployeeVoluntaryContributionAmt, false, '', false, false, false, '', MyExcelBuffer."cell type"::Number);
//                         MyExcelBuffer.AddColumn(EmployerContributionAmt, false, '', false, false, false, '', MyExcelBuffer."cell type"::Number);
//                         MyExcelBuffer.AddColumn(EmployerVoluntaryContributionAmt, false, '', false, false, false, '', MyExcelBuffer."cell type"::Number);
//                         MyExcelBuffer.AddColumn(TotalContributionAmt, false, '', false, false, false, '', MyExcelBuffer."cell type"::Number);
//                         //END;
//                     end;
//                 until PayrollEmployee.Next = 0;
//         end;
//     end;

//     local procedure CreatePensionRemittanceExcelScheduleFooter(PayrollPeriod: Code[10]; PensionAdministrator: Record "Pension Administrator"; PaymentBatch: Code[20]; TotalEmployeeContributionAmt: Decimal; TotalEmployerContributionAmt: Decimal; TotalEmployeeVoluntaryContributionAmt: Decimal; TotalEmployerVoluntaryContributionAmt: Decimal; GrandTotalContributionAmt: Decimal)
//     begin

//         MyExcelBuffer.NewRow;
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Number);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Date);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Date);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Date);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Number);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Number);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Number);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Number);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Number);

//         MyExcelBuffer.NewRow;
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Number);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Date);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Text);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Date);
//         MyExcelBuffer.AddColumn('', false, '', false, false, true, '', MyExcelBuffer."cell type"::Date);
//         MyExcelBuffer.AddColumn(TotalEmployeeContributionAmt, false, '', true, false, true, '', MyExcelBuffer."cell type"::Number);
//         MyExcelBuffer.AddColumn(TotalEmployeeVoluntaryContributionAmt, true, '', false, false, true, '', MyExcelBuffer."cell type"::Number);
//         MyExcelBuffer.AddColumn(TotalEmployerContributionAmt, false, '', true, false, true, '', MyExcelBuffer."cell type"::Number);
//         MyExcelBuffer.AddColumn(TotalEmployerVoluntaryContributionAmt, false, '', true, false, true, '', MyExcelBuffer."cell type"::Number);
//         MyExcelBuffer.AddColumn(GrandTotalContributionAmt, false, '', true, false, true, '', MyExcelBuffer."cell type"::Number);


//         SheetName := PensionAdministrator."Code";
//         // MyExcelBuffer.CreateBook(TempFileName, SheetName);
//         MyExcelBuffer.WriteSheet(SheetName, COMPANYNAME, UserId);
//         MyExcelBuffer.CloseBook;
//         //Comment this line after testing
//         //MyExcelBuffer.OpenExcel;
//     end;

//     local procedure SendMail(HasAttachment: Boolean; AttachmentFilePath: Text; Receiver: Text; FileNameWithExtension: Text; MailBody1: Text; Subject: Text; CcMailAddress: Text)
//     var
//         EmailMessage: Codeunit "Email Message";
//         Email: Codeunit Email;
//         EmailAccount: Record "Email Account";
//         UserSetup: Record "User Setup";
//         Recipients: List of [Text];
//     begin
//         UserSetup.Get(UserId);
//         Recipients.Add(Receiver);
//         Body := 'Dear Sir/Ma,<br><br><p>' + MailBody1 + '</p><HR><BR>Thank you.';
//         EmailMessage.Create(Recipients, Subject, Body, true);

//         if HasAttachment then
//             EmailMessage.AddAttachment('Attachment', FileNameWithExtension, AttachmentFilePath);
//         if Email.Send(EmailMessage, Enum::"Email Scenario"::Default) then;
//     end;

//     local procedure GetPayslipAmount(StartPayrollPeriod: Code[10]; EndPayrollPeriod: Code[10]; EmpNo: Code[20]; EDFilter: Text): Decimal
//     var
//         ClosedPayrollPayslipLine: Record "Closed Payroll-PayslipLine";
//     begin
//         ClosedPayrollPayslipLine.Reset;
//         ClosedPayrollPayslipLine.SetRange("Payroll Period", StartPayrollPeriod, EndPayrollPeriod);
//         ClosedPayrollPayslipLine.SetRange("Employee No.", EmpNo);
//         ClosedPayrollPayslipLine.SetFilter("E/D Code", EDFilter);
//         ClosedPayrollPayslipLine.CalcSums("Amount");
//         exit(ClosedPayrollPayslipLine."Amount");
//     end;

//     local procedure InitializePensionAmt(var EmployeeContributionAmt: Decimal; var EmployerContributionAmt: Decimal; var EmployeeVoluntaryContributionAmt: Decimal; var TotalContributionAmt: Decimal; var EmployerVoluntaryContributionAmt: Decimal)
//     begin
//         EmployeeContributionAmt := 0;
//         EmployerContributionAmt := 0;
//         TotalContributionAmt := 0;
//         EmployeeVoluntaryContributionAmt := 0;
//         EmployerVoluntaryContributionAmt := 0;
//     end;

//     local procedure GetMailBodyFromFilePath(MailBodyFilePath: Text): Text
//     var
//         mFile: File;
//         mInstream: InStream;
//     begin
//         // mFile.Open(MailBodyFilePath);
//         // mFile.CreateInstream(mInstream);
//         // exit(StreamToString(mInstream));
//     end;


//     procedure StreamToString(StreamToConvert: InStream) StreamContent: Text
//     var
//         // StringBuilder: dotnet StringBuilder;
//         // uriObj: dotnet Uri;
//         // HttpRequest: dotnet HttpWebRequest;
//         //stream: dotnet StreamWriter;
//         // HttpResponse: dotnet HttpWebResponse;
//         //str: dotnet Stream;
//         // reader: dotnet XmlTextReader;
//         // XMLDoc: dotnet XmlDocument;
//         // ascii: dotnet Encoding;
//         // credentials: dotnet CredentialCache;
//         // ServicePointManager: dotnet ServicePointManager;
//         vBigText: BigText;
//         ErrorMsg: Text;
//         // XMLDocNodeList: dotnet XmlNodeList;
//         // XMLDocNode: dotnet XmlNode;
//         StatusOK: Boolean;
//     begin
//         // vBigText.Read(StreamToConvert);
//         // StringBuilder := StringBuilder.StringBuilder();
//         // StringBuilder.Append(vBigText);
//         // StreamContent := StringBuilder.ToString;
//     end;
// }

