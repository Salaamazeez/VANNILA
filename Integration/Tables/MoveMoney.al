table 50401 "Instruction"
{
    DataClassification = ToBeClassified;

    fields
    {
        // Original fields from Instruction table
        field(1; "Message Sender"; Code[20]) {}
        field(2; "Message Id"; Code[20]) {}
        field(3; "Country Code"; Code[10]) {}
        field(10; "Required Execution Date"; Date) {}
        field(11; "Date Priority"; Code[10]) {}
        field(12; "Amount Currency Code"; Code[10]) {}
        field(13; "Amount Value"; Decimal) {}
        field(14; "Amount Priority"; Code[10]) {}
        field(15; "Reference Id"; Code[50]) {}
        field(16; "Payment Type"; Code[10]) {}
        field(17; "Charger Bearer"; Code[10]) {}

        // Debtor
        field(20; "Debtor Name"; Text[100]) {}
        field(21; "Debtor Account Id"; Code[50]) {}
        field(22; "Debtor Account City"; Text[50]) {}
        field(23; "Debtor Account Currency"; Code[10]) {}
        field(24; "Debtor Agent BIC"; Code[20]) {}
        field(25; "Debtor Agent Name"; Text[100]) {}
        field(26; "Debtor Agent City"; Text[50]) {}
        field(27; "Debtor Agent Address Line"; Text[100]) {}
        field(28; "Debtor Agent Country"; Code[10]) {}
        field(29; "Debtor Agent Postcode"; Code[20]) {}

        // On Behalf Of
        field(30; "OBO Name"; Text[100]) {}
        field(31; "OBO Line 1"; Text[100]) {}
        field(32; "OBO City"; Text[50]) {}
        field(33; "OBO State"; Text[50]) {}
        field(34; "OBO Country"; Code[10]) {}
        field(35; "OBO Account Id"; Code[50]) {}
        field(36; "OBO Type"; Code[10]) {}

        // Debtor Address
        field(40; "Debtor Country ISO"; Code[10]) {}
        field(41; "Debtor Postcode"; Code[20]) {}
        field(42; "Debtor Street Name"; Text[100]) {}
        field(43; "Debtor Address Type"; Code[10]) {}
        field(44; "Debtor Address Line1"; Text[100]) {}

        // Creditor
        field(50; "Creditor Name"; Text[100]) {}
        field(51; "Creditor City"; Text[50]) {}
        field(52; "Creditor Line1"; Text[100]) {}
        field(53; "Creditor Country"; Code[10]) {}
        field(54; "Creditor Postcode"; Code[20]) {}

        // Creditor Agent
        field(60; "Creditor Agent BIC"; Code[20]) {}
        field(61; "Creditor Agent Name"; Text[100]) {}
        field(62; "Creditor Agent City"; Text[50]) {}
        field(63; "Creditor Agent Line1"; Text[100]) {}
        field(64; "Creditor Agent Country"; Code[10]) {}
        field(65; "Creditor Agent Postcode"; Code[20]) {}
        field(70; "Creditor Account Id"; Code[50]) {}

        // Remittance Info
        field(80; "Remittance Info Line 1"; Text[100]) {}
        field(81; "Remittance Info Line 2"; Text[100]) {}

        // Regulatory
        field(90; "Regulatory Instruction Code"; Code[20]) {}
        field(91; "Regulatory Instruction Details"; Text[250]) {}

        // Instruction Code Details
        field(100; "Instruction Code 1"; Code[10]) {}
        field(101; "Instruction Details 1"; Text[100]) {}
        field(102; "Instruction Code 2"; Code[10]) {}
        field(103; "Instruction Details 2"; Text[100]) {}

        // New JSON Fields
        field(200; "Group Id"; Code[20]) {}
        field(201; "Account Id"; Code[30]) {}
        field(202; "Account Currency Code"; Code[10]) {}
        field(203; "Account Bank Code"; Code[20]) {}
        field(204; "Event Date"; Date) {}
        field(205; "Transaction Identifier"; Code[30]) {}
        field(206; "Transaction Type"; Code[20]) {}
        field(207; "Advice Type"; Code[10]) {}
        field(208; "Value Date"; Date) {}
        field(209; "Virtual Account Id"; Code[30]) {}
        field(210; "Account Name"; Text[100]) {}
        field(211; "Transaction Code"; Code[10]) {}
        field(212; "BAI Code"; Code[10]) {}
        field(213; "Transaction Description"; Text[100]) {}

        field(214; "Post Balance Currency"; Code[10]) {}
        field(215; "Post Balance Amount"; Decimal) {}
        field(216; "Pre Balance Currency"; Code[10]) {}
        field(217; "Pre Balance Amount"; Decimal) {}

        field(218; "Transaction Amount Currency"; Code[10]) {}
        field(219; "Transaction Amount Value"; Decimal) {}

        field(220; "Client Identifier Type"; Code[20]) {}
        field(221; "Client Identifier Value"; Code[50]) {}

        field(222; "External Identifier Type"; Code[20]) {}
        field(223; "External Identifier Value"; Code[100]) {}

        field(224; "Transaction Timestamp"; DateTime) {}
        field(225; "Time"; DateTime) {}
        field(226; "Posting Mode"; Code[10]) {}

        // Contacts
        field(230; "Contact Type Codes"; Text[250]) {} // store comma-separated
        field(231; "Contacts"; Text[500]) {} // store comma-separated

        // Payer
        field(240; "Payer Name"; Text[100]) {}
        field(241; "Payer Account Id"; Code[50]) {}
        field(242; "Payer Identity Type"; Code[20]) {}
        field(243; "Payer Bank Name"; Text[100]) {}
        field(244; "Payer Bank Code"; Code[20]) {}
        field(245; "Payer Clearing System Id"; Code[20]) {}

        // Payee
        field(250; "Payee Name"; Text[100]) {}
        field(251; "Payee Account Id"; Code[50]) {}
        field(252; "Payee Bank Name"; Text[100]) {}
        field(253; "Payee Bank Code"; Code[20]) {}

        // Sender Correspondent Bank
        field(260; "Sender Bank Code"; Code[20]) {}

        // Reference IDs
        field(270; "End To End Id"; Code[50]) {}
        field(271; "TX Id"; Code[50]) {}
        field(272; "Clearing System Reference"; Code[50]) {}

        // Additional Descriptions
        field(280; "Additional Transaction Des."; Text[100]) {}
        field(281; "Supplementary Transaction Des."; Text[100]) {}

        // Free Text (3 arrays of 6 lines each)
        field(290; "Free Text 1"; Text[100]) {}
        field(291; "Free Text 2"; Text[100]) {}
        field(292; "Free Text 3"; Text[100]) {}
        field(293; "Free Text 4"; Text[100]) {}
        field(294; "Free Text 5"; Text[100]) {}
        field(295; "Free Text 6"; Text[100]) {}

        field(296; "Extended Free Text 1"; Text[100]) {}
        field(297; "Extended Free Text 2"; Text[100]) {}
        field(298; "Extended Free Text 3"; Text[100]) {}
        field(299; "Extended Free Text 4"; Text[100]) {}

        field(300; "Multilingual Free Text 1"; Text[100]) {}
        field(301; "Multilingual Free Text 2"; Text[100]) {}

    }

    keys
    {
        key(PK; "Message Id") { Clustered = true; }
    }
}
