#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 80000 "Bank Recon Import"
{
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("Bank Acc. Reconc Line";"Bank Acc. Reconciliation Line")
            {
                XmlName = 'StockItems';
                fieldelement(AcctNo;"Bank Acc. Reconc Line"."Bank Account No.")
                {
                }
                fieldelement(StatementNo;"Bank Acc. Reconc Line"."Statement No.")
                {
                }
                fieldelement(LineNo;"Bank Acc. Reconc Line"."Statement Line No.")
                {
                }
                fieldelement(Date;"Bank Acc. Reconc Line"."Transaction Date")
                {
                }
                fieldelement(Description;"Bank Acc. Reconc Line".Description)
                {
                }
                fieldelement(Amount;"Bank Acc. Reconc Line"."Statement Amount")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}
