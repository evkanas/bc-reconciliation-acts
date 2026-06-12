table 70102 "EVK Reconcil. Statement Line"
{
    Caption = 'Reconsilation Statement Lines', Comment = 'lt-LT="Skolų suderinimo akto eilutės"';
    fields
    {
        field(10; "Reconcilation Statement No."; Code[20])
        {
            Caption = 'Reconsilation Statement No.', Comment = 'lt-LT="Suderinimo akto numeris"';
            DataClassification = CustomerContent;
            TableRelation = "EVK Reconcil. Statement Header";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'lt-LT="Eilutės numeris"';
            DataClassification = CustomerContent;
        }
        field(30; "Document Type"; Option)
        {
            Caption = 'Type', Comment = 'lt-LT="Dokumento tipas"';
            DataClassification = CustomerContent;
            OptionMembers = ,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund', Comment = 'lt-LT=" ,Mokėjimas,Sąskaita,Kreditinė pastaba,Finansinių palūkanų pastaba,Priminimas,Grąžinimas"';
        }
        field(40; "Document No."; Code[35])
        {
            Caption = 'Document No.', Comment = 'lt-LT="Dokumento numeris"';
            DataClassification = CustomerContent;
        }
        field(50; "Document Date"; date)
        {
            Caption = 'Document Date', Comment = 'lt-LT="Dokumento data"';
            DataClassification = CustomerContent;
        }
        field(60; "Currency Code"; CODE[10])
        {
            Caption = 'Currency Code', Comment = 'lt-LT="Valiutos kodas"';
            DataClassification = CustomerContent;
        }
        field(70; "Amount"; decimal)
        {
            Caption = 'Amount', Comment = 'lt-LT="Suma"';
            DataClassification = CustomerContent;
        }
        field(80; "Amount (LCY)"; decimal)
        {
            Caption = 'Amount (LCY)', Comment = 'lt-LT="Suma (vietinė valiuta)"';
            DataClassification = CustomerContent;
        }
        field(90; "Remaining Amt. (LCY)"; decimal)
        {
            Caption = 'Remaining Amt. (LCY)', Comment = 'lt-LT="Likusi suma (vietinė valiuta)"';
            DataClassification = CustomerContent;
        }
        field(100; "Debit (LCY)"; decimal)
        {
            Caption = 'Debit (LCY)', Comment = 'lt-LT="Debetas (vietinė valiuta)"';
            DataClassification = CustomerContent;
        }
        field(110; "Credit (LCY)"; decimal)
        {
            Caption = 'Credit (LCY)', Comment = 'lt-LT="Kreditas (vietinė valiuta)"';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PrimaryKey; "Reconcilation Statement No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Remaining Amt. (LCY)", "Debit (LCY)", "Credit (LCY)";
        }
    }
}
