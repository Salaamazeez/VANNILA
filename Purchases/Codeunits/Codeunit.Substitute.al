codeunit 50240 ReportSubstute
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reporting Triggers", SubstituteReport, '', false, false)]
    local procedure "Reporting Triggers_SubstituteReport"(ReportId: Integer; RunMode: Option; RequestPageXml: Text; RecordRef: RecordRef; var NewReportId: Integer)
    begin
        if ReportId = Report::"Purchase - Receipt" then
            NewReportId := Report::"Posted WCC"
    end;
}