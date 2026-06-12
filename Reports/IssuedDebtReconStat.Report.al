report 70122 "EVK Issued Debt Recon. Stat."
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports/RDLC/IssuedReconsilStatement.rdl';
    Caption = 'Issued Debt Reconcilation Statement Report', Comment = 'lt-LT="Išrašyto skolų suderinimo akto ataskaita"';
    UsageCategory = ReportsAndAnalysis;
    WordLayout = 'Reports/RDLC/IssuedReconsilStatement.docx';
    PdfFontEmbedding = yes;
    ApplicationArea = all;

    dataset
    {
        dataitem("EVK Issued Rec. Stat. Header"; "EVK Issued Rec. Stat. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Customer No.", "Vendor No.", "Language Code";

            column("StatementHeaderNo"; "No.") { }
            column(CompanyNameTxt; CompanyNameTxt) { }
            column(CompanyAddress; CompanyInformation.Address + ', ' + CompanyInformation."Post Code" + ' ' + CompanyInformation.City) { }
            column(Type; Type) { }
            column(Customer_No_; "Customer No.") { }
            column(Vendor_No_; "Vendor No.") { }
            column(Name; Name) { }
            column(Name_2; "Name 2") { }
            column(FullNameTxt; FullNameTxt) { }
            column(Address; Address) { }
            column(Address_2; "Address 2") { }
            column(Post_Code; "Post Code") { }
            column(City; City) { }
            column(CustomerAddress; CustomerAddress) { }
            column(Header_Document_Date; format("Document Date", 0, 4)) { }
            column(documentDate; documentDate) { }
            column(Reconcile_Date; "Reconcile Date") { }
            column(startingDate; startingDate) { }
            column(endingDate; endingDate) { }
            column(Use_Period; "Use Period") { }
            column(Accountant; Accountant) { }
            column(jobTitle; jobTitle) { }
            column(fullEmplName; fullEmplName) { }
            column(EVKEmployeesignature; Employee."EVK Employee Signature") { }
            column(PleaseConfirmTxt; PleaseConfirmTxt) { }
            column(CompanyNameRegistrationNoLbl; CompanyNameRegistrationNoLbl) { }
            column(AddressLbl; AddressLbl) { }
            column(DateLbl; DateLbl) { }
            column(NoLbl; NoLbl) { }
            column(FulNoTxt; FulNoTxt) { }
            column(DebtReconciliationStatementLbl; DebtReconciliationStatementLbl) { }
            column(InformationAboutDebtDocumentLbl; InformationAboutDebtDocumentLbl) { }
            column(Counter; Counter) { }
            column(DocumentTypeLbl; DocumentTypeLbl) { }
            column(DocumentNoLbl; DocumentNoLbl) { }
            column(DocumentDateLbl; DocumentDateLbl) { }
            column(CurrCodeLbl; CurrCodeLbl) { }
            column(AmountLbl; AmountLbl) { }
            column(AmountLCYLbl; AmountLCYLbl) { }
            column(RemainingAmountLbl; RemainingAmountLbl) { }
            column(AccountantLbl; AccountantLbl) { }
            column(debtTxt; debtTxt) { }
            column(NameLastNameSignatureLbl; NameLastNameSignatureLbl) { }
            column(SpecifiedDebtAmountTxt; SpecifiedDebtAmountTxt) { }
            column(IsCorrectOnlyLbl; IsCorrectOnlyLbl) { }
            column(InformationTextTxt; InformationTextTxt) { }
            column(SinceWeHaveNotReceivedDebtConfirmationLbl; SinceWeHaveNotReceivedDebtConfirmationLbl) { }
            column(DebtAmountInWords; DebtAmountInWords) { }
            column(TotalLbl; TotalLbl) { }
            column(ConfirmationLbl; ConfirmationLbl) { }
            column(CurrencyIntegerLbl; CurrencyIntegerLbl) { }
            column(CurrencyDecimalLbl; CurrencyDecimalLbl) { }
            column(RemainingAmtLCY; RemainingAmtLCY) { }
            column(DebitAmtLCY; DebitAmtLCY) { }
            column(CreditAmtLCY; CreditAmtLCY) { }
            column(StartDateLbl; StartDateLbl) { }
            column(EndDateLbl; EndDateLbl) { }
            column(DebitLbl; DebitLbl) { }
            column(CreditLbl; CreditLbl) { }
            column(Beginning_Balance__LCY_; BeginningBalanceLCY) { }
            column(Ending_Balance__LCY_; EndingBalanceLCY) { }
            column(PrintDetails; PrintDetails) { }

            dataitem("EVK Reconcil. Statement Line"; "EVK Reconcil. Statement Line")
            {
                DataItemLink = "Reconcilation Statement No." = field("No.");
                column(Document_Type; "Document Type") { }
                column(Document_No_; "Document No.") { }
                column(LineDocument_Date; format("Document Date")) { }
                column(Amount; Amount) { }
                column(Amount__LCY_; "Amount (LCY)") { }
                column(Remaining_Amt___LCY_; "Remaining Amt. (LCY)") { }
                column(Currency_Code; "Currency Code") { }
                column(Debit__LCY_; "Debit (LCY)") { }
                column(Credit__LCY_; "Credit (LCY)") { }

                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin
                    Counter += 1;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                IF ("Language Code" = 'LTH') OR ("Language Code" = '') THEN
                    languageIntCode := 1063
                else
                    languageIntCode := 1033;
                GLOBALLANGUAGE := languageIntCode;
                documentDate := format("Document Date", 0, 4);
                if languageIntCode = 1033 then
                    documentDate := ReconsilStatement.getEnglishDate("Document Date");

                CalcFields("Remaining Amt. (LCY)", "Debit (LCY)", "Credit (LCY)");
                RemainingAmtLCY := "Remaining Amt. (LCY)";
                DebitAmtLCY := "Debit (LCY)";
                CreditAmtLCY := "Credit (LCY)";
                SpecifiedDebtAmountTxt := SpecifiedDebtAmountLbl;

                BeginningBalanceLCY := BalanceAtTheBeginningOfThePeriodLbl + ' ' + format("Beginning Balance (LCY)") + ' EUR';
                EndingBalanceLCY := BalanceAtEndOfPeriodLbl + ' ' + format("Ending Balance (LCY)") + ' EUR';

                debtTxt := DebtLbl;

                reconcileDate := format("Reconcile Date", 0, 4);
                if languageIntCode = 1033 then
                    reconcileDate := ReconsilStatement.getEnglishDate("Reconcile Date");
                case type of
                    Type::"Customer":
                        begin
                            SpecifiedDebtAmountTxt := SpecifiedDebtAmountLbl;
                            debtTxt := DebtLbl;
                            PleaseConfirmTxt := '';
                            PleaseConfirmTxt := PleaseConfirmCustomerLbl;
                            if "Remaining Amt. (LCY)" < 0 then begin
                                SpecifiedDebtAmountTxt := SpecifiedOverpayedAmountLbl;
                                debtTxt := OverpaymentLbl;
                                PleaseConfirmTxt += OverpaymentSkolaLbl;
                            end
                            else begin
                                PleaseConfirmTxt += DebtSkolaLbl;
                                debtTxt := DebtLbl;
                                SpecifiedDebtAmountTxt := SpecifiedDebtAmountLbl;
                            end;
                            PleaseConfirmTxt += ToOurCompanyLbl + reconcileDate + AccordingToAccountingInformationLbl;
                        end;
                    Type::"Vendor":
                        begin
                            SpecifiedDebtAmountTxt := SpecifiedDebtAmountLbl;
                            debtTxt := DebtLbl;
                            PleaseConfirmTxt := '';
                            PleaseConfirmTxt := PleaseConfirmVendorLbl;
                            if "Remaining Amt. (LCY)" < 0 then begin
                                PleaseConfirmTxt += DebtSkolaLbl;
                                debtTxt := DebtLbl;
                            end
                            else begin
                                PleaseConfirmTxt += OverpaymentSkolaLbl;
                                debtTxt := OverpaymentLbl;
                                SpecifiedDebtAmountTxt := SpecifiedOverpayedAmountLbl;
                            end;
                            PleaseConfirmTxt += ToYourCompanyLbl + reconcileDate + AccordingToAccountingInformationLbl;
                        end;
                    Type::"Vendor/Customer":
                        begin
                            SpecifiedDebtAmountTxt := SpecifiedDebtAmountLbl;
                            debtTxt := DebtLbl;
                            PleaseConfirmTxt := '';
                            PleaseConfirmTxt := PleaseConfirmVendorLbl;
                            if "Remaining Amt. (LCY)" < 0 then begin
                                PleaseConfirmTxt += DebtSkolaLbl;
                                debtTxt := DebtLbl;
                            end
                            else begin
                                PleaseConfirmTxt += OverpaymentSkolaLbl;
                                debtTxt := OverpaymentLbl;
                                SpecifiedDebtAmountTxt := SpecifiedOverpayedAmountLbl;
                            end;
                            PleaseConfirmTxt += ToYourCompanyLbl + reconcileDate + AccordingToAccountingInformationLbl;
                        end;

                end;

                CustomerAddress := Address + "Address 2";
                if "Post Code" <> '' then
                    CustomerAddress += ', ' + "Post Code";
                if City <> '' then
                    CustomerAddress += ' ' + City;

                startingDate := '';
                endingDate := '';

                if "Use Period" then begin
                    PleaseConfirmTxt := PleaseConfirmLbl;
                    startingDate := StartDateLbl + ' ' + format("Reconcile Start Date");
                    endingDate := EndDateLbl + ' ' + format("Reconcile End Date");
                end;

                Counter := 0;
                CompanyInformation.get();

                CompanyNameTxt := CompanyInformation.Name + CompanyInformation."Name 2";
                if CompanyInformation."Registration No." <> '' then
                    CompanyNameTxt += ', ' + CompanyInformation."Registration No.";
                if CompanyInformation."VAT Registration No." <> '' then
                    CompanyNameTxt += ', ' + CompanyInformation."VAT Registration No.";

                Clear(Employee);
                Employee.Reset();
                Employee.setrange("No.", Accountant);
                jobTitle := AccountantLbl;
                fullEmplName := '';
                if Employee.findfirst() then begin
                    jobTitle := Employee."Job Title";
                    fullEmplName := Employee.FullName();
                    Employee.CALCFIELDS("EVK Employee Signature");
                end;

                InformationTextTxt := OneConfirmedCopyOfDebtsReconsilationStatementLbl + CompanyInformation.Name + Address_Lbl;
                InformationTextTxt += CompanyInformation.Address + ', ' + CompanyInformation."Post Code" + ' ' + CompanyInformation.City;

                DebtReconcilationStatSetup.Get();
                Char10 := 10;
                if DebtReconcilationStatSetup."Statement E-mail" <> '' then
                    InformationTextTxt += ', ' + DebtReconcilationStatSetup."Statement E-mail" + '.';

                InformationTextTxt += format(Char10) + SinceWeHaveNotReceivedDebtConfirmationLbl;

                if ("Language Code" = '') or ("Language Code" = 'LTH') then BEGIN
                    if DebtReconcilationStatSetup."Additional Text" <> '' then
                        InformationTextTxt += format(Char10) + format(Char10) + DebtReconcilationStatSetup."Additional Text";
                END
                else
                    if DebtReconcilationStatSetup."Additional Text ENU" <> '' then
                        InformationTextTxt += format(Char10) + format(Char10) + DebtReconcilationStatSetup."Additional Text ENU";

                FullNameTxt := Name + "Name 2";
                if "Registration No." <> '' then
                    FullNameTxt += ', ' + "Registration No.";
                if "VAT Registration No." <> '' THEN
                    FullNameTxt += ', ' + "VAT Registration No.";

                Clear(ReconsilStatement);
                DebtAmountInWords := ReconsilStatement.AmountInWordsByLangugae(ABS("Remaining Amt. (LCY)"), languageIntCode);
                FulNoTxt := NoLbl + "No.";
            end;
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
                    Caption = 'General', Comment = 'lt-LT="Bendra informacija"';
                    field(PrintDtls; PrintDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Details', Comment = 'lt-LT="Spausdinti detales"';
                        ToolTip = 'Specifies how to print rows.', Comment = 'lt-LT="Nurodo, kaip spausdinti eilutes"';
                        trigger OnValidate()
                        var
                            PageEVKIssuedRecStatementHeader: Record "EVK Issued Rec. Stat. Header";
                        begin
                            PageEVKIssuedRecStatementHeader.CopyFilters("EVK Issued Rec. Stat. Header");
                            if PageEVKIssuedRecStatementHeader.FindFirst() then
                                PageEVKIssuedRecStatementHeader."Print Details" := PrintDetails;
                            PageEVKIssuedRecStatementHeader.Modify();

                        end;
                    }

                    field(OnlyDebts; bPositive)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show only debt entries', Comment = 'lt-LT="Rodyti tik skolų įrašus"';
                        ToolTip = 'Indicates that only debt entries will be printed.', Comment = 'lt-LT="Nurodo, kad bus spausdinami tik skolų įrašai"';
                        Visible = false;
                    }
                }
            }
        }
        trigger OnOpenPage()
        var
            PageEVKIssuedRecStatementHeader: Record "EVK Issued Rec. Stat. Header";
        begin
            PageEVKIssuedRecStatementHeader.CopyFilters("EVK Issued Rec. Stat. Header");
            if PageEVKIssuedRecStatementHeader.FindFirst() then
                PrintDetails := PageEVKIssuedRecStatementHeader."Print Details";

        end;
    }


    var
        CompanyInformation: Record "Company Information";
        Employee: Record Employee;
        DebtReconcilationStatSetup: Record "EVK Debt Reconciliation Setup";
        ReconsilStatement: Codeunit "EVK ReconsilStatement";
        Counter: Integer;
        RemainingAmtLCY: decimal;
        DebitAmtLCY: decimal;
        CreditAmtLCY: decimal;
        languageIntCode: Integer;
        FullNameTxt: Text;
        CompanyNameTxt: Text;
        PleaseConfirmTxt: Text;
        InformationTextTxt: Text;
        SpecifiedDebtAmountTxt: Text;
        DebtAmountInWords: Text;
        FulNoTxt: Text;
        CustomerAddress: Text;
        jobTitle: Text;
        fullEmplName: Text;
        documentDate: Text;
        reconcileDate: Text;
        startingDate: Text;
        endingDate: Text;
        debtTxt: Text;
        BeginningBalanceLCY: Text;
        EndingBalanceLCY: Text;
        Char10: char;
        DebtReconciliationStatementLbl: Label 'Debt reconciliation statement', Comment = 'lt-LT="Skolų suderinimo aktas"';
        NoLbl: Label 'No. ', Comment = 'lt-LT="Nr. "';
        CompanyNameRegistrationNoLbl: Label '(Company name, Registration No., VAT Registration No.)', Comment = 'lt-LT="(Įmonės pavadinimas, Registracijos Nr., PVM Registracijos Nr.)"';
        AddressLbl: Label '(address)', Comment = 'lt-LT="(adresas)"';
        DateLbl: Label '(date)', Comment = 'lt-LT="(data)"';
        PleaseConfirmLbl: Label 'Please confirm the below indicated sum is correct.', Comment = 'lt-LT="Prašome patvirtinti, kad žemiau nurodyta suma yra teisinga"';
        PleaseConfirmCustomerLbl: Label 'Please confirm that the below indicated sum is your company ', Comment = 'lt-LT="Prašome patvirtinti, kad žemiau nurodyta suma yra teisinga"';
        PleaseConfirmVendorLbl: Label 'Please confirm that the below indicated sum is our company ', Comment = 'lt-LT="Prašome patvirtinti, kad žemiau nurodyta suma yra teisinga"';
        ToYourCompanyLbl: Label ' to your company ', Comment = 'lt-LT=" į jūsų kompaniją "';
        ToOurCompanyLbl: Label ' to our company ', Comment = 'lt-LT=" į mūsų kompaniją "';
        DebtSkolaLbl: Label 'debt ', Comment = 'lt-LT="skola "';
        OverpaymentSkolaLbl: Label 'overpayment ', Comment = 'lt-LT="permokėta "';
        AccordingToAccountingInformationLbl: Label ' according to accounting information.', Comment = 'lt-LT=" pagal apskaitos informaciją."';
        InformationAboutDebtDocumentLbl: Label 'Information about debt document', Comment = 'lt-LT="Informacija apie skolos dokumentą"';
        DocumentTypeLbl: Label 'Document Type', Comment = 'lt-LT="Dokumento tipas"';
        DocumentNoLbl: Label 'Document No.', Comment = 'lt-LT="Dokumento nr."';
        DocumentDateLbl: Label 'Document date', Comment = 'lt-LT="Dokumento data"';
        CurrCodeLbl: Label 'Currency Code', Comment = 'lt-LT="Valiutos kodas"';
        AmountLbl: Label 'Amount', Comment = 'lt-LT="Suma"';
        AmountLCYLbl: Label 'Amount (EUR)', Comment = 'lt-LT="Suma (EUR)"';
        RemainingAmountLbl: Label 'Remaining Amount (EUR)', Comment = 'lt-LT="Liko (EUR)"';
        AccountantLbl: Label 'Accountant', Comment = 'lt-LT="Apskaitos specialistas"';
        DebtLbl: Label 'Debt', Comment = 'lt-LT="Skola"';
        OverpaymentLbl: Label 'Overpayment', Comment = 'lt-LT="Permokėta"';
        NameLastNameSignatureLbl: Label '(Name, Last name, Signature)', Comment = 'lt-LT="(Vardas, Pavardė, Parašas)"';
        SpecifiedOverpayedAmountLbl: Label 'Your specified overpayed amount', Comment = 'lt-LT="Jūsų nurodyta permokėta suma"';
        SpecifiedDebtAmountLbl: Label 'Your specified debt amount', Comment = 'lt-LT="Jūsų nurodyta skolos suma"';
        IsCorrectOnlyLbl: Label 'is correct only with these exceptions', Comment = 'lt-LT="yra teisinga tik su šiais išimtymais"';
        OneConfirmedCopyOfDebtsReconsilationStatementLbl: Label 'One confirmed copy of Debts Reconsilation Statement please returnt to: ', Comment = 'lt-LT="Vieną patvirtintą skolų suderinimo akto kopiją prašome grąžinti adresu: "';
        Address_Lbl: Label ' address ', Comment = 'lt-LT=" adresas "';
        SinceWeHaveNotReceivedDebtConfirmationLbl: Label 'Since we have not received any debt confirmation protocol from you, the sum indicated in the protocol shall be considered to be the right one.', Comment = 'lt-LT="Nes mus nebuvo pateikta jokia skolos patvirtinimo protokolo, protokole nurodyta suma bus laikoma teisinga."';
        TotalLbl: Label 'Total:', Comment = 'lt-LT="Iš viso:"';
        ConfirmationLbl: Label 'CONFIRMATION', Comment = 'lt-LT="PATVIRTINIMAS"';
        CurrencyIntegerLbl: Label 'Eur', Comment = 'lt-LT="Eur"';
        CurrencyDecimalLbl: Label 'ct', Comment = 'lt-LT="ct"';
        StartDateLbl: Label 'Start Date', Comment = 'lt-LT="Pradžios data"';
        EndDateLbl: Label 'End Date', Comment = 'lt-LT="Pabaigos data"';
        DebitLbl: Label 'Debit (EUR)', Comment = 'lt-LT="Debitas (EUR)"';
        CreditLbl: Label 'Credit (EUR)', Comment = 'lt-LT="Kreditas (EUR)"';
        PrintDetails: Boolean;
        bPositive: Boolean;
        BalanceAtTheBeginningOfThePeriodLbl: Label 'Balance at the beginning of the period', Comment = 'lt-LT="Likutis pradžios data"';
        BalanceAtEndOfPeriodLbl: Label 'Balance at the end of the period', Comment = 'lt-LT="Likutis pabaigos data"';
}
