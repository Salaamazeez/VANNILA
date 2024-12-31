codeunit 50050 CustomReleaseDocument
{
    procedure SetCalledFromApproval(CalledFromApproval2: Boolean)
    begin
        CalledFromApproval := CalledFromApproval2;
    end;

    var
        CalledFromApproval: Boolean;
}