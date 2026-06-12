table 70100 "EVK Debt Reconciliation Setup"
{
    Caption = 'Debt Reconciliation Statement Setup', Comment = 'lt-LT="Skolų suderinimo aktų nustatymai"';
    LookupPageId = "EVK Debt Reconciliation Setup";
    DrillDownPageId = "EVK Debt Reconciliation Setup";

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key', Comment = 'lt-LT="Pirminis raktas"';
            DataClassification = CustomerContent;
        }
        field(20; "Reconcilation Statement Nos."; Code[10])
        {
            Caption = 'Reconciliation Statement Nos.', Comment = 'lt-LT="Suderinimo aktų numerių serija"';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(30; "Registration No. Field"; Integer)
        {
            Caption = 'Customer Registration No. Field', Comment = 'lt-LT="Pirkėjo registracijos Nr. laukas"';
            DataClassification = CustomerContent;
        }
        field(40; "Vendor Registration No. Field"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Registration No. Field', Comment = 'lt-LT="Tiekėjo registracijos Nr. laukas"';
        }
        field(50; "Report Selection Usage"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Report Selection Usage', Comment = 'lt-LT="Ataskaitų pasirinkimo naudojimas"';
        }
        field(60; "Statement E-mail"; text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Debt Reconcilation Statement E-mail', Comment = 'lt-LT="Skolų suderinimo aktų el. pašto adresas"';
        }
        field(70; "Additional Text"; text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Text', Comment = 'lt-LT="Papildomas tekstas"';
        }
        field(80; "Additional Text ENU"; text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Text ENU', Comment = 'lt-LT="Papildomas tekstas ENU"';
        }
    }
    keys
    {
        key(PrimaryKey; "Primary Key")
        {
            Clustered = true;
        }
    }
}
