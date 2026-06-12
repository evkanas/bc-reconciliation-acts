report 70121 "EVK DebtReconcStatementSuggest"
{
    Caption = 'Suggest Debt Reconcile Statement', Comment = 'lt-LT="Sukurti skolų suderinimo ataskaitos pasiūlymą"';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    ProcessingOnly = true;

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group(General)
                {
                    Caption = 'General', Comment = 'lt-LT="Bendrieji nustatymai"';
                    field(EVKRSType; ReconsileType)
                    {
                        OptionCaption = ' ,Customer,Vendor,Vendor/Customer', Comment = 'lt-LT=" ,Klientas,Tiekėjas,Tiekėjas/Klientas"';
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reconcile Statement Type', Comment = 'lt-LT="Suderinimo ataskaitos tipas"';
                        ToolTip = 'Specifies reconcile statement type.', Comment = 'lt-LT="Nurodo suderinimo  ataskaitos tipą"';
                        Editable = false;
                    }
                    field(EVKDoctDate; DocumentDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Date', Comment = 'lt-LT="Dokumento data"';
                        ToolTip = 'Specifies document date.', Comment = 'lt-LT="Nurodo dokumento datą"';
                        Editable = false;
                    }
                    field(EVKReconciDate; ReconcileDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reconcile Date', Comment = 'lt-LT="Suderinimo data"';
                        ToolTip = 'Specifies reconcile date.', Comment = 'lt-LT="Nurodo suderinimo datą"';
                        Editable = false;
                    }
                    field(EVKStartDate; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reconcilation Start Date', Comment = 'lt-LT="Suderinimo pradžios data"';
                        ToolTip = 'Specifies reconcilation start date.', Comment = 'lt-LT="Nurodo suderinimo pradžios datą"';
                        Editable = false;
                    }
                    field(EVKEndDate; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reconcilation End Date', Comment = 'lt-LT="Suderinimo pabaigos data"';
                        ToolTip = 'Specifies reconcilation end date.', Comment = 'lt-LT="Nurodo suderinimo pabaigos datą"';
                        Editable = false;
                    }

                    field(EVKusePeriod; UseReconciliationPeriod)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reconcilation Statement Period', Comment = 'lt-LT="Suderinimo ataskaitos laikotarpis"';
                        ToolTip = 'Specifies reconcilation statement period.', Comment = 'lt-LT="Nurodo suderinimo ataskaitos laikotarpį"';
                        Editable = false;
                    }
                    field(EVKCustomerFilter; ReconcileCustomer)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer', Comment = 'lt-LT="Klientas"';
                        ToolTip = 'Specifies customer.', Comment = 'lt-LT="Nurodo klientą"';
                        Editable = false;

                    }
                    field(EVKVendorFilter; ReconcileVendor)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor', Comment = 'lt-LT="Tiekėjas"';
                        ToolTip = 'Specifies vendor.', Comment = 'lt-LT="Nurodo tiekėją"';
                        Editable = false;
                    }
                    field(EVKCurrencyCodeFilter; CurrencyCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Currency Code', Comment = 'lt-LT="Valiutos kodas"';
                        ToolTip = 'Specifies currency Code.', Comment = 'lt-LT="Nurodo valiutos kodą"';
                        TableRelation = Currency;
                    }

                }
            }
        }
    }

    trigger OnPostReport()
    begin
        Clear(ReconsilStatementCU);
        if DocumentDate = 0D then error(DocumentDateErr);

        if not UseReconciliationPeriod then
            if ReconcileDate = 0D then error(ReconcileDateErr);

        if UseReconciliationPeriod then begin
            if StartDate = 0D then error(StartDateErr);
            if EndDate = 0D then error(EndDateErr);
        end;

        case ReconsileType of
            ReconsileType::"Customer":
                begin
                    Clear(Customer);
                    Customer.Reset();
                    ReconsilStatementCU.SuggestReconcilationStatementLinesCustomer(CurrencyCode, Customer, DocumentDate, UseReconciliationPeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName, ReconcileCustomer, ReconcileNo);
                end;
            ReconsileType::"Vendor":
                begin
                    Clear(Vendor);
                    Vendor.Reset();
                    ReconsilStatementCU.SuggestReconcilationStatementLinesVendor(CurrencyCode, Vendor, DocumentDate, UseReconciliationPeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName, ReconcileVendor, ReconcileNo);
                end;
            ReconsileType::"Vendor/Customer":
                begin
                    Clear(Vendor);
                    Vendor.Reset();
                    ReconsilStatementCU.SuggestReconcilationStatementLinesVendor(CurrencyCode, Vendor, DocumentDate, UseReconciliationPeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName, ReconcileVendor, ReconcileNo);
                    Clear(Customer);
                    Customer.Reset();
                    ReconsilStatementCU.SuggestReconcilationStatementLinesCustomer(CurrencyCode, Customer, DocumentDate, UseReconciliationPeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName, ReconcileCustomer, ReconcileNo);
                end;
        end;

    end;

    procedure SetParameter(paramCustomerfilter: Text; paramVendorfilter: Text; paramRSTypeFilter: Option ,Customer,Vendor,Both; paramDocumentDateParam: date; paramusePeriodParam: boolean; paramReconcileDateParam: date; paramStartDateParam: date; paramEndDateParam: date; paramChiefAccountantNameParam: Text; paramRCNoParam: Code[20])
    begin
        ReconcileCustomer := paramCustomerfilter;
        ReconcileVendor := paramVendorfilter;
        ReconsileType := paramRSTypeFilter;
        DocumentDate := paramDocumentDateParam;
        ReconcileDate := paramReconcileDateParam;
        ChiefAccountantName := paramChiefAccountantNameParam;
        ReconcileNo := paramRCNoParam;
        UseReconciliationPeriod := paramusePeriodParam;
        StartDate := paramStartDateParam;
        EndDate := paramEndDateParam;
    end;

    var

        Customer: record Customer;
        Vendor: Record Vendor;
        ReconsilStatementCU: Codeunit "EVK ReconsilStatement";
        ChiefAccountantName: Text;
        ReconcileNo: Code[20];
        ReconcileVendor: Text;
        ReconcileCustomer: Text;
        CurrencyCode: Code[3];
        DocumentDate: Date;
        ReconcileDate: Date;
        StartDate: date;
        EndDate: date;
        ReconsileType: Option ,Customer,Vendor,"Vendor/Customer";
        DocumentDateErr: Label 'Document date is required.', Comment = 'lt-LT="Dokumento data yra būtina."';
        ReconcileDateErr: Label 'Reconcile date is required.', Comment = 'lt-LT="Suderinimo data yra būtina."';
        StartDateErr: Label 'Start date is required.', Comment = 'lt-LT="Pradžios data yra būtina."';
        EndDateErr: Label 'End date is required.', Comment = 'lt-LT="Pabaigos data yra būtina."';
        UseReconciliationPeriod: boolean;
}
