table 70101 "EVK Reconcil. Statement Header"
{
    Caption = 'Reconciliation Statement Header', Comment = 'lt-LT="Skolų suderinimo akto antraštė"';

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.', Comment = 'lt-LT="Nr."';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then
                    NoSeries.TestManual(GetNoSeriesCode());
            end;
        }
        field(20; "Type"; Option)
        {
            Caption = 'Type', Comment = 'lt-LT="Tipas"';
            DataClassification = CustomerContent;
            OptionMembers = " ",Customer,Vendor,"Vendor/Customer";
            OptionCaption = ' ,Customer,Vendor,Vendor/Customer', Comment = 'lt-LT=" ,Pirkėjas,Tiekėjas,Tiekėjas / pirkėjas"';

            trigger OnValidate()
            begin
                DeleteReconciliationStatementLines(true);
            end;
        }
        field(30; "Customer No."; Code[20])
        {
            Caption = 'Customer No.', Comment = 'lt-LT="Pirkėjo Nr."';
            DataClassification = CustomerContent;
            TableRelation = Customer;

            trigger OnValidate()
            var
                CustomerTable: RecordRef;
                NoField: FieldRef;
                RegistrationNoField: FieldRef;
                RegistrationNoFieldNo: Integer;
                ContactNo: Code[20];
            begin
                DeleteReconciliationStatementLines(false);
                Clear(Customer);
                Customer.Reset();
                Customer.SetRange("No.", "Customer No.");
                Customer.FindFirst();
                Name := Customer.Name;
                "Name 2" := Customer."Name 2";
                Address := Customer.Address;
                "Address 2" := Customer."Address 2";
                "Post Code" := Customer."Post Code";
                City := Customer.City;
                "Language Code" := Customer."Language Code";

                DebtReconciliationSetup.Get();
                CustomerTable.GetTable(Customer);
                RegistrationNoFieldNo := DebtReconciliationSetup."Registration No. Field";
                if RegistrationNoFieldNo > 0 then begin
                    NoField := CustomerTable.Field(1);
                    NoField.SetRange("Customer No.");
                    CustomerTable.FindFirst();
                    RegistrationNoField := CustomerTable.Field(RegistrationNoFieldNo);
                    "Registration No." := RegistrationNoField.Value;
                end;
                "VAT Registration No." := Customer."VAT Registration No.";

                if Type = Type::"Vendor/Customer" then begin
                    Clear(ContactBusinessRelation);
                    ContactBusinessRelation.Reset();
                    ContactBusinessRelation.SetCurrentKey("Link to Table", "No.");
                    ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                    ContactBusinessRelation.SetRange("No.", "Customer No.");
                    ContactBusinessRelation.FindFirst();
                    ContactNo := ContactBusinessRelation."Contact No.";

                    Clear(ContactBusinessRelation);
                    ContactBusinessRelation.Reset();
                    ContactBusinessRelation.SetRange("Contact No.", ContactNo);
                    ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Vendor);
                    ContactBusinessRelation.FindFirst();
                    "Vendor No." := ContactBusinessRelation."No.";
                end;
            end;
        }
        field(40; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.', Comment = 'lt-LT="Tiekėjo Nr."';
            DataClassification = CustomerContent;
            TableRelation = Vendor;

            trigger OnValidate()
            var
                VendorTable: RecordRef;
                NoField: FieldRef;
                RegistrationNoField: FieldRef;
                RegistrationNoFieldNo: Integer;
                ContactNo: Code[20];
            begin
                Clear(Vendor);
                Vendor.Reset();
                Vendor.SetRange("No.", "Vendor No.");
                Vendor.FindFirst();
                Name := Vendor.Name;
                "Name 2" := Vendor."Name 2";
                Address := Vendor.Address;
                "Address 2" := Vendor."Address 2";
                "Post Code" := Vendor."Post Code";
                City := Vendor.City;
                "Language Code" := Vendor."Language Code";

                DebtReconciliationSetup.Get();
                VendorTable.GetTable(Vendor);
                RegistrationNoFieldNo := DebtReconciliationSetup."Vendor Registration No. Field";
                if RegistrationNoFieldNo > 0 then begin
                    NoField := VendorTable.Field(1);
                    NoField.SetRange("Vendor No.");
                    VendorTable.FindFirst();
                    RegistrationNoField := VendorTable.Field(RegistrationNoFieldNo);
                    "Registration No." := RegistrationNoField.Value;
                end;
                "VAT Registration No." := Vendor."VAT Registration No.";

                if Type = Type::"Vendor/Customer" then begin
                    Clear(ContactBusinessRelation);
                    ContactBusinessRelation.Reset();
                    ContactBusinessRelation.SetCurrentKey("Link to Table", "No.");
                    ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Vendor);
                    ContactBusinessRelation.SetRange("No.", "Vendor No.");
                    ContactBusinessRelation.FindFirst();
                    ContactNo := ContactBusinessRelation."Contact No.";

                    Clear(ContactBusinessRelation);
                    ContactBusinessRelation.Reset();
                    ContactBusinessRelation.SetRange("Contact No.", ContactNo);
                    ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                    ContactBusinessRelation.FindFirst();
                    "Customer No." := ContactBusinessRelation."No.";
                end;
            end;
        }
        field(50; Name; Text[100])
        {
            Caption = 'Name', Comment = 'lt-LT="Pavadinimas"';
            DataClassification = CustomerContent;
        }
        field(60; "Name 2"; Text[50])
        {
            Caption = 'Name 2', Comment = 'lt-LT="Pavadinimas 2"';
            DataClassification = CustomerContent;
        }
        field(70; Address; Text[100])
        {
            Caption = 'Address', Comment = 'lt-LT="Adresas"';
            DataClassification = CustomerContent;
        }
        field(80; "Address 2"; Text[50])
        {
            Caption = 'Address 2', Comment = 'lt-LT="Adresas 2"';
            DataClassification = CustomerContent;
        }
        field(90; "Post Code"; Code[20])
        {
            Caption = 'Post Code', Comment = 'lt-LT="Pašto kodas"';
            DataClassification = CustomerContent;
        }
        field(100; City; Text[30])
        {
            Caption = 'City', Comment = 'lt-LT="Miestas"';
            DataClassification = CustomerContent;
        }
        field(110; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code', Comment = 'lt-LT="Šalies / regiono kodas"';
            DataClassification = CustomerContent;
        }
        field(120; "Language Code"; Code[10])
        {
            Caption = 'Language Code', Comment = 'lt-LT="Kalbos kodas"';
            DataClassification = CustomerContent;
            TableRelation = Language;
        }
        field(130; "Document Date"; Date)
        {
            Caption = 'Document Date', Comment = 'lt-LT="Dokumento data"';
            DataClassification = CustomerContent;
        }
        field(140; "Reconcile Date"; Date)
        {
            Caption = 'Reconcile Date', Comment = 'lt-LT="Suderinimo data"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                DeleteReconciliationStatementLines(false);
            end;
        }
        field(150; "Reconcile Start Date"; Date)
        {
            Caption = 'Debt Reconciliation Start Date', Comment = 'lt-LT="Skolų suderinimo pradžios data"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                DeleteReconciliationStatementLines(false);
            end;
        }
        field(160; "Reconcile End Date"; Date)
        {
            Caption = 'Debt Reconciliation End Date', Comment = 'lt-LT="Skolų suderinimo pabaigos data"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                DeleteReconciliationStatementLines(false);
            end;
        }
        field(170; "Use Period"; Boolean)
        {
            Caption = 'Reconciliation Statement Period', Comment = 'lt-LT="Suderinimo akto laikotarpis"';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                DeleteReconciliationStatementLines(false);
            end;
        }
        field(158; "Debt Amount"; Decimal)
        {
            Caption = 'Debt Amount', Comment = 'lt-LT="Skolos suma"';
            DataClassification = CustomerContent;
        }
        field(190; Accountant; Text[200])
        {
            Caption = 'Accountant', Comment = 'lt-LT="Buhalteris"';
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(200; "No. Series"; Code[20])
        {
            Caption = 'No. Series', Comment = 'lt-LT="Numerių serija"';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(210; "Remaining Amt. (LCY)"; Decimal)
        {
            Caption = 'Remaining Amt. (LCY)', Comment = 'lt-LT="Likusi suma (viet. val.)"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("EVK Reconcil. Statement Line"."Remaining Amt. (LCY)" where("Reconcilation Statement No." = field("No.")));
        }
        field(220; "Debit (LCY)"; Decimal)
        {
            Caption = 'Debit (LCY)', Comment = 'lt-LT="Debetas (viet. val.)"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("EVK Reconcil. Statement Line"."Debit (LCY)" where("Reconcilation Statement No." = field("No.")));
        }
        field(230; "Credit (LCY)"; Decimal)
        {
            Caption = 'Credit (LCY)', Comment = 'lt-LT="Kreditas (viet. val.)"';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("EVK Reconcil. Statement Line"."Credit (LCY)" where("Reconcilation Statement No." = field("No.")));
        }
        field(240; "Registration No."; Text[20])
        {
            Caption = 'Registration No.', Comment = 'lt-LT="Registracijos Nr."';
            DataClassification = CustomerContent;
        }
        field(250; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.', Comment = 'lt-LT="PVM mokėtojo kodas"';
            DataClassification = CustomerContent;
        }
        field(260; "Apply Entries"; Boolean)
        {
            Caption = 'Apply Entries', Comment = 'lt-LT="Taikyti įrašus"';
            InitValue = true;
        }
        field(290; "Beginning Balance (LCY)"; Decimal)
        {
            Caption = 'Beginning Balance', Comment = 'lt-LT="Pradinis likutis"';
        }
        field(300; "Ending Balance (LCY)"; Decimal)
        {
            Caption = 'Ending Balance', Comment = 'lt-LT="Galutinis likutis"';
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

    trigger OnInsert()
    begin
        DebtReconciliationSetup.Get();
        if "No." = '' then begin
            TestNoSeries();
            "No. Series" := GetNoSeriesCode();
            "No." := NoSeries.GetNextNo("No. Series", "Document Date");
        end;
        "Document Date" := Today;
    end;

    trigger OnDelete()
    begin
        Clear(ReconciliationStatementLine);
        ReconciliationStatementLine.Reset();
        ReconciliationStatementLine.SetRange("Reconcilation Statement No.", "No.");
        if ReconciliationStatementLine.FindSet() then
            repeat
                ReconciliationStatementLine.Delete(true);
            until ReconciliationStatementLine.Next() = 0;
    end;

    procedure AssistEdit(ReconciliationStatementHeader: Record "EVK Reconcil. Statement Header"): Boolean
    begin
        Copy(Rec);
        DebtReconciliationSetup.Get();
        TestNoSeries();
        if NoSeries.LookupRelatedNoSeries(GetNoSeriesCode(), "No. Series", "No. Series") then begin
            Rec."No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        DebtReconciliationSetup.TestField("Reconcilation Statement Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[20]
    begin
        DebtReconciliationSetup.Get();
        exit(DebtReconciliationSetup."Reconcilation Statement Nos.");
    end;

    local procedure DeleteReconciliationStatementLines(ClearRelatedParty: Boolean)
    begin
        Clear(ReconciliationStatementLine);
        ReconciliationStatementLine.Reset();
        ReconciliationStatementLine.SetRange("Reconcilation Statement No.", "No.");

        if ReconciliationStatementLine.Count > 0 then
            if Confirm(RowsWillBeDeletedLbl) then
                ReconciliationStatementLine.DeleteAll()
            else
                Error(ActionCanceledErr);

        if ClearRelatedParty then begin
            Clear("Customer No.");
            Clear("Vendor No.");
            Clear(Name);
            Clear("Name 2");
            Clear(Address);
            Clear("Address 2");
            Clear("Post Code");
            Clear(City);
        end;
    end;

    var
        DebtReconciliationSetup: Record "EVK Debt Reconciliation Setup";
        Customer: Record Customer;
        Vendor: Record Vendor;
        ReconciliationStatementLine: Record "EVK Reconcil. Statement Line";
        ContactBusinessRelation: Record "Contact Business Relation";
        NoSeries: Codeunit "No. Series";
        RowsWillBeDeletedLbl: Label 'The rows will be deleted.', Comment = 'lt-LT="Eilutės bus ištrintos."';
        ActionCanceledErr: Label 'Action canceled.', Comment = 'lt-LT="Veiksmas atšauktas."';
}
