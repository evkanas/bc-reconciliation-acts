report 70120 "EVK DebtReconcilStatCreate"
{
    Caption = 'Create Debt Reconcile Statement', Comment = 'lt-LT="Sukurti skolų suderinimo ataskaitą"';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Responsibility Center";
        }
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Responsibility Center";
        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            {
                group(General)
                {
                    Caption = 'General', Comment = 'lt-LT="Bendrieji"';
                    field(EVKRSType; ReconsileType)
                    {
                        OptionCaption = ' ,Customer,Vendor,Vendor/Customer', Comment = 'lt-LT=" ,Klientas,Tiekėjas,Tiekėjas/Klientas"';
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reconcile Statement Type', Comment = 'lt-LT="Suderinimo ataskaitos tipas"';
                        ToolTip = 'Specifies reconcile statement type.', Comment = 'lt-LT="Nurodo suderinimo  ataskaitos tipą"';
                    }
                    field(EVKDocumentDate; DocumentDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Date', Comment = 'lt-LT="Dokumento data"';
                        ToolTip = 'Specifies document date.', Comment = 'lt-LT="Nurodo dokumento datą"';
                    }
                    field(EVKReconcileDate; ReconcileDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reconcile Date', Comment = 'lt-LT="Suderinimo data"';
                        ToolTip = 'Specifies reconcilation date.', Comment = 'lt-LT="Nurodo suderinimo datą"';
                        Enabled = not UseReconciliationPeriod;
                    }
                    field(EVKStartDate; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reconcilation Start Date', Comment = 'lt-LT="Suderinimo pradžios data"';
                        ToolTip = 'Specifies reconcilation start date.', Comment = 'lt-LT="Nurodo suderinimo pradžios datą"';
                        Enabled = UseReconciliationPeriod;
                    }
                    field(EVKEndDate; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reconcilation End Date', Comment = 'lt-LT="Suderinimo pabaigos data"';
                        ToolTip = 'Specifies reconcilation end date.', Comment = 'lt-LT="Nurodo suderinimo pabaigos datą"';
                        Enabled = UseReconciliationPeriod;
                    }
                    field(EVKusePeriod; UseReconciliationPeriod)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Use Reconciliation Period', Comment = 'lt-LT="Naudoti suderinimo laikotarpį"';
                        ToolTip = 'Specifies reconcilation statement period.', Comment = 'lt-LT="Nurodo suderinimo ataskaitos laikotarpį"';
                    }

                    field(CurrencyCodeFilter; CurrencyCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Currency Code', Comment = 'lt-LT="Valiutos kodas"';
                        ToolTip = 'Specifies currency Code.', Comment = 'lt-LT="Nurodo valiutos kodą"';
                        TableRelation = Currency;
                    }
                    field(PrintDtls; PrintDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Details', Comment = 'lt-LT="Spausdinti detales"';
                        ToolTip = 'Specifies how to print rows.', Comment = 'lt-LT="Nurodo kaip spausdinti eilutes"';
                        Visible = false;
                    }
                    field(PrintyNotZero; PrintOnlyNotZero)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Only Not Zero', Comment = 'lt-LT="Spausdinti tik ne nulinį"';
                        ToolTip = 'Print Only Not Zero.', Comment = 'lt-LT="Spausdinti tik ne nulinį"';
                        Visible = false;
                    }

                    field(AccountantName; ChiefAccountantName)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Accountant', Comment = 'lt-LT="Raštininkas"';
                        ToolTip = 'Shows accountant.', Comment = 'lt-LT="Rodo raštininką"';
                        TableRelation = Employee;

                    }
                    field(StatementDebtAmount; BalancedNetChange)
                    {
                        ApplicationArea = Basic, Suite;

                        Caption = 'Balanced Net Change (LCY) at specified date', Comment = 'lt-LT="Subalansuotas grynas pokyčias (LCY) nurodytą data"';
                        toolTip = 'Specifies Net Change (LCY) at specified date.', Comment = 'lt-LT="Nurodo gryną pokyčias (LCY) nurodytą data"';
                    }
                    field(optBalanceAtDate; BalanceAtDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Balance at Date', Comment = 'lt-LT="Balansas nurodytą datą"';
                        ToolTip = 'Specifies balance date.', Comment = 'lt-LT="Nurodo balanso datą"';
                    }
                }
            }
        }

    }

    trigger OnPostReport()
    begin

        Customer.SETrange("EVK DEBDATEFILTER");
        Customer.SETrange("EVK DEBTBALANCE");

        Vendor.SETrange("EVK DEBDATEFILTER");
        Vendor.SETrange("EVK DEBTBALANCE");

        If (BalanceAtDate <> 0D) and (BalancedNetChange <> '') then begin
            Customer.SETFILTER("EVK DEBDATEFILTER", '..%1', BalanceAtDate);
            Vendor.SETFILTER("EVK DEBDATEFILTER", '..%1', BalanceAtDate);

            Customer.SETFILTER("EVK DEBTBALANCE", BalancedNetChange);
            Vendor.SETFILTER("EVK DEBTBALANCE", BalancedNetChange)

        end;

        Clear(ReconsilStatementCU);
        if DocumentDate = 0D then error(DocumentDateErr);
        if not UseReconciliationPeriod then
            if ReconcileDate = 0D then
                error(ReconcileDateErr);
        if UseReconciliationPeriod then begin
            if StartDate = 0D then error(StartDateErr);
            if EndDate = 0D then error(EndDateErr);
        end;

        case ReconsileType of
            ReconsileType::"Customer":
                ReconsilStatementCU.CreateCustomerReconcileStatement(CurrencyCode, Customer, DocumentDate, UseReconciliationPeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName);
            ReconsileType::"Vendor":
                ReconsilStatementCU.CreateVendorReconcileStatement(CurrencyCode, Vendor, DocumentDate, UseReconciliationPeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName);
            ReconsileType::"Vendor/Customer":
                ReconsilStatementCU.CreateVendorCustomerReconcileStatement(CurrencyCode, Vendor, Customer, DocumentDate, UseReconciliationPeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName
                );
        end;

    end;


    var
        ReconsilStatementCU: Codeunit "EVK ReconsilStatement";
        BalancedNetChange: Text;
        DocumentDate: Date;
        ReconcileDate: Date;
        StartDate: date;
        EndDate: date;
        BalanceAtDate: Date;
        PrintDetails: Boolean;
        PrintOnlyNotZero: Boolean;
        ChiefAccountantName: Text;
        CurrencyCode: Code[3];
        ReconsileType: Option ,Customer,Vendor,"Vendor/Customer";
        DocumentDateErr: Label 'Document date is required.', Comment = 'lt-LT="Dokumento data yra būtina."';
        ReconcileDateErr: Label 'Reconcilation date is required.', Comment = 'lt-LT="Konsolidavimo data yra būtina."';
        StartDateErr: Label 'Start date is required.', Comment = 'lt-LT="Pradžios data yra būtina."';
        EndDateErr: Label 'End date is required.', Comment = 'lt-LT="Pabaigos data yra būtina."';
        UseReconciliationPeriod: boolean;
}
