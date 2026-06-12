table 70103 "EVK Issued Rec. Stat. Header"
{
    Caption = 'Issued Debt Reconsilation Statement Header', Comment = 'lt-LT="Išrašyto skolų suderinimo akto antraštė"';
    LookupPageID = "EVK IssuedReconStatementList";
    DrillDownPageID = "EVK IssuedReconStatementList";
    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'lt-LT="Numeris"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Type"; Option)
        {
            Caption = 'Type', Comment = 'lt-LT="Tipas"';
            DataClassification = CustomerContent;
            OptionMembers = " ","Customer","Vendor","Vendor/Customer";
            OptionCaption = ' ,Customer,Vendor,Vendor/Customer', Comment = 'lt-LT=" ,Klientas,Tiekėjas,Tiekėjas/Klientas"';
            Editable = false;
        }
        field(30; "Customer No."; Code[20])
        {
            Caption = 'Customer No.', Comment = 'lt-LT="Kliento numeris"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(40; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.', Comment = 'lt-LT="Tiekėjo numeris"';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
            Editable = false;
        }
        field(50; Name; text[100])
        {
            Caption = 'Name', Comment = 'lt-LT="Pavadinimas"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(60; "Name 2"; text[50])
        {
            Caption = 'Name 2', Comment = 'lt-LT="Pavadinimas 2"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(70; Address; text[100])
        {
            Caption = 'Address', Comment = 'lt-LT="Adresas"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80; "Address 2"; text[50])
        {
            Caption = 'Address 2', Comment = 'lt-LT="Adresas 2"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(90; "Post Code"; Code[20])
        {
            Caption = 'Post Code', Comment = 'lt-LT="Pašto kodas"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(100; "City"; text[30])
        {
            Caption = 'City', Comment = 'lt-LT="Miestas"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(110; "Country/Region Code"; CODE[10])
        {
            Caption = 'Country/Region Code', Comment = 'lt-LT="Šalies/Regiono kodas"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(120; "Language Code"; CODE[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Language Code', Comment = 'lt-LT="Kalbos kodas"';
            TableRelation = Language;
            Editable = false;
        }
        field(130; "Document Date"; date)
        {
            Caption = 'Document Date', Comment = 'lt-LT="Dokumento data"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(140; "Reconcile Date"; date)
        {
            Caption = 'Reconcile Date', Comment = 'lt-LT="Suderinimo data"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(150; "Reconcile Start Date"; date)
        {
            Caption = 'Debt Reconciliation Start Date', Comment = 'lt-LT="Skolų suderinimo pradžios data"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(160; "Reconcile End Date"; date)
        {
            Caption = 'Debt Reconciliation End Date', Comment = 'lt-LT="Skolų suderinimo pabaigos data"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(170; "Use Period"; boolean)
        {
            Caption = 'Reconcilation Statement Period', Comment = 'lt-LT="Suderinimo akto laikotarpis"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(158; "Debt Amount"; decimal)
        {
            Caption = 'Debt Amount', Comment = 'lt-LT="Skolos suma"';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(190; "Accountant"; text[200])
        {
            Caption = 'Accountant', Comment = 'lt-LT="Buhalteris"';
            DataClassification = CustomerContent;
            TableRelation = Employee;
            Editable = false;
        }
        field(200; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series', Comment = 'lt-LT="Numerių serija"';
            TableRelation = "No. Series";
            Editable = false;
        }
        field(210; "Remaining Amt. (LCY)"; decimal)
        {
            Caption = 'Remaining Amt. (LCY)', Comment = 'lt-LT="Liko (LCY)"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("EVK Issued Debt Rec. StatLine"."Remaining Amt. (LCY)" where("Reconcilation Statement No." = FIELD("No.")));
        }
        field(220; "Debit (LCY)"; decimal)
        {
            Caption = 'Debit (LCY)', Comment = 'lt-LT="Debitas (LCY)"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("EVK Issued Debt Rec. StatLine"."Debit (LCY)" where("Reconcilation Statement No." = FIELD("No.")));
        }
        field(230; "Credit (LCY)"; decimal)
        {
            Caption = 'Credit (LCY)', Comment = 'lt-LT="Kreditas (LCY)"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("EVK Issued Debt Rec. StatLine"."Credit (LCY)" where("Reconcilation Statement No." = FIELD("No.")));
        }

        field(240; "Registration No."; text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Registration No.', Comment = 'lt-LT="Registracijos numeris"';
            Editable = false;
        }
        field(250; "VAT Registration No."; text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Registration No.', Comment = 'lt-LT="PVM registracijos numeris"';
            Editable = false;
        }
        field(260; "Apply Entries"; boolean)
        {
            Caption = 'Apply Entries', Comment = 'lt-LT="Taikyti įrašus"';
            InitValue = true;
            Editable = false;
        }
        field(270; Canceled; boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Canceled', Comment = 'lt-LT="Atšaukta"';
            Editable = false;
        }
        field(280; Sent; Option)
        {
            Caption = 'Sent', Comment = 'lt-LT="Išsiųsta"';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Email', Comment = 'lt-LT=" ,El. paštu"';
            OptionMembers = " ",Email;

            Editable = false;
        }
        field(290; "Beginning Balance (LCY)"; decimal)
        {
            Caption = 'Beginning Balance', Comment = 'lt-LT="Pradinis likutis"';
            Editable = false;
        }
        field(300; "Ending Balance (LCY)"; decimal)
        {
            Caption = 'Ending Balance', Comment = 'lt-LT="Pabaigos likutis"';
            Editable = false;
        }
        field(310; "Print Details"; boolean)
        {
            Caption = 'Print Details', Comment = 'lt-LT="Spausdinti detalius duomenis"';

        }

    }
    keys
    {
        key(PrimaryKey; "No.")
        {
            Clustered = true;
        }
        key(SecondKey; "Type", "Customer No.")
        {

        }
        key(ThirdKey; "Type", "Vendor No.")
        {

        }
    }

    procedure PrintRecords(ShowRequestForm: Boolean; SendAsEmail: Boolean; HideDialog: Boolean)
    var

        DocumentSendingProfile: record "Document Sending Profile";
        fieldNo: Integer;
    begin
        DebtReconcilationStatSetup.get();
        DebtReconcilationStatSetup.TestField("Report Selection Usage");

        fieldNo := FIELDNO("Customer No.");
        if Type = Type::Vendor then fieldNo := FIELDNO("Vendor No.");
        IF SendAsEmail THEN
            DocumentSendingProfile.TrySendToEMail(
              DebtReconcilationStatSetup."Report Selection Usage", Rec, FIELDNO("No."), DebtReconcStatemenTxt, fieldNo, NOT HideDialog)
        ELSE
            DocumentSendingProfile.TrySendToPrinter(
              DebtReconcilationStatSetup."Report Selection Usage", Rec, fieldNo, ShowRequestForm)

    end;

    var
        DebtReconcilationStatSetup: record "EVK Debt Reconciliation Setup";
        DebtReconcStatemenTxt: Label 'Debt Reconsilation Statement', Comment = 'lt-LT="Skolų suderinimo akto pavadinimas"';

}
