Codeunit 70102 "EVK ReconsilStatement"
{
    procedure IssueReconiclationStatement(var ReconcilStatementHeader: Record "EVK Reconcil. Statement Header"; PrintDoc: Option " ",Print,Email; HideDialog: Boolean; PrintDetails: boolean)
    var
        LocalReconcilStatementHeader: Record "EVK Reconcil. Statement Header";
        IssuedDebtRecStatLine: Record "EVK Issued Debt Rec. StatLine";
        IssuedRecStatementHeader: Record "EVK Issued Rec. Stat. Header";
        PrintIssuedRecStatementHeader: Record "EVK Issued Rec. Stat. Header";
        IssuedDebtReconcilStatement: Report "EVK Issued Debt Recon. Stat.";
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        outStreamas: OutStream;
        ToSent: boolean;
    begin
        Clear(LocalReconcilStatementHeader);
        LocalReconcilStatementHeader.Reset();
        LocalReconcilStatementHeader.COPYFILTERS(ReconcilStatementHeader);
        if LocalReconcilStatementHeader.findset() then
            repeat
                Clear(IssuedRecStatementHeader);
                IssuedRecStatementHeader.Reset();
                IssuedRecStatementHeader.setrange("No.", LocalReconcilStatementHeader."No.");
                if IssuedRecStatementHeader.findfirst() then error(DebtReconciliationStatementErr, IssuedRecStatementHeader."No.");

                Clear(IssuedRecStatementHeader);
                IssuedRecStatementHeader.Reset();
                IssuedRecStatementHeader.init();
                IssuedRecStatementHeader.TransferFields(LocalReconcilStatementHeader);
                IssuedRecStatementHeader.insert();
                IssuedRecStatementHeader."Print Details" := PrintDetails;
                IssuedRecStatementHeader.Modify();

                Clear(ReconcilStatementLine);
                ReconcilStatementLine.Reset();
                ReconcilStatementLine.setrange("Reconcilation Statement No.", LocalReconcilStatementHeader."No.");
                if ReconcilStatementLine.IsEmpty then error(DebtReconciliationLinesErr, LocalReconcilStatementHeader."No.");
                if ReconcilStatementLine.findset() then
                    repeat
                        Clear(IssuedDebtRecStatLine);
                        IssuedDebtRecStatLine.Reset();
                        IssuedDebtRecStatLine.init();
                        IssuedDebtRecStatLine.TransferFields(ReconcilStatementLine);
                        IssuedDebtRecStatLine.insert();

                    until ReconcilStatementLine.Next() = 0;
                LocalReconcilStatementHeader.delete(true);

                case PrintDoc of
                    PrintDoc::Print:
                        begin
                            Clear(IssuedDebtReconcilStatement);
                            TempBlob.CreateOutStream(outStreamas, TEXTENCODING::UTF8);
                            Clear(IssuedDebtReconcilStatement);
                            IssuedDebtReconcilStatement.USEREQUESTPAGE := FALSE;

                            Clear(PrintIssuedRecStatementHeader);
                            PrintIssuedRecStatementHeader.Reset();
                            PrintIssuedRecStatementHeader.setrange("No.", IssuedRecStatementHeader."No.");
                            if PrintIssuedRecStatementHeader.findfirst() then begin
                                IssuedDebtReconcilStatement.SETTABLEVIEW(PrintIssuedRecStatementHeader);
                                ToSent := IssuedDebtReconcilStatement.SAVEAS('', REPORTFORMAT::Pdf, outStreamas);
                                if ToSent then
                                    FileManagement.BLOBExport(TempBlob, 'debt_reconcil.pdf', TRUE);
                            end
                        end;
                    PrintDoc::Email:
                        begin
                            Clear(PrintIssuedRecStatementHeader);
                            PrintIssuedRecStatementHeader.Reset();
                            PrintIssuedRecStatementHeader.setrange("No.", IssuedRecStatementHeader."No.");
                            if PrintIssuedRecStatementHeader.findfirst() then
                                PrintIssuedRecStatementHeader.PrintRecords(FALSE, TRUE, HideDialog);

                        end;
                end
            until LocalReconcilStatementHeader.Next() = 0;
    end;

    procedure SuggestReconcilationStatementLinesCustomer(CurrencyCode: Code[3]; var Customer: Record Customer; DocumentDate: date; usePeriod: boolean; ReconcileDate: date; StartDate: date; EndDate: Date; ChiefAccountantName: Text; CustomerFilter: Text; RCNo: Code[20]): Code[20]
    begin
        Clear(Customer);
        Customer.Reset();
        Customer.SetFilter("No.", CustomerFilter);
        if not usePeriod then
            Customer.SetFilter("Date Filter", '..%1', ReconcileDate);
        if Customer.Findfirst() then
            RCNo := copystr(CreateReconcileStatementCustomer(CurrencyCode, Customer, DocumentDate, usePeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName, RCNo), 1, MaxStrLen(RCNo));
        exit(RCNo);
    end;

    procedure CreateCustomerReconcileStatement(CurrencyCode: Code[3]; var Customer: Record Customer; DocumentDate: date; usePeriod: boolean; ReconcileDate: date; StartDate: date; EndDate: Date; ChiefAccountantName: text)
    var
        continue: boolean;
    begin
        if not usePeriod then
            Customer.SetFilter("Date Filter", '..%1', ReconcileDate);
        if Customer.FindSet() then
            repeat

                continue := CheckCustomerVendor(Customer."No.", '');
                if not usePeriod then
                    Customer.CalcFields("Net Change (LCY)", "EVK DEBTBALANCE");

                if continue then
                    CreateReconcileStatementCustomer(CurrencyCode, Customer, DocumentDate, usePeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName, '');
            until Customer.Next() = 0;
    end;

    procedure SuggestReconcilationStatementLinesVendor(CurrencyCode: Code[3]; var Vendor: Record Vendor; DocumentDate: date; usePeriod: boolean; ReconcileDate: date; StartDate: date; EndDate: Date; ChiefAccountantName: Text; VendorFilter: Text; RCNo: Code[20])
    begin
        Clear(Vendor);
        Vendor.Reset();
        Vendor.SetFilter("No.", VendorFilter);
        if not usePeriod then
            Vendor.SetFilter("Date Filter", '..%1', ReconcileDate);
        if Vendor.Findfirst() then
            CreateReconcileStatementVendor(CurrencyCode, Vendor, DocumentDate, usePeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName, RCNo);
    end;

    procedure CreateVendorReconcileStatement(CurrencyCode: Code[3]; var Vendor: Record Vendor; DocumentDate: date; usePeriod: boolean; ReconcileDate: date; StartDate: date; EndDate: Date; ChiefAccountantName: text)
    var
        continue: boolean;
    begin
        if not usePeriod then
            Vendor.SetFilter("Date Filter", '..%1', ReconcileDate);
        if Vendor.FindSet() then
            repeat
                continue := CheckCustomerVendor('', Vendor."No.");
                if not usePeriod then
                    Vendor.CalcFields("Net Change (LCY)");
                if continue then
                    CreateReconcileStatementVendor(CurrencyCode, Vendor, DocumentDate, usePeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName, '');
            until Vendor.Next() = 0;
    end;

    procedure CreateVendorCustomerReconcileStatement(CurrencyCode: Code[3]; var Vendor: Record Vendor; var Customer: Record Customer; DocumentDate: date; usePeriod: boolean; ReconcileDate: date; StartDate: date; EndDate: Date; ChiefAccountantName: text)
    var
        contact_no: Code[20];
        vendor_no: Code[20];
        RCNo: Code[20];
    begin
        Customer.SetFilter("Date Filter", '..%1', ReconcileDate);
        if Customer.FindSet() then
            repeat
                Clear(ContactBusinessRelation);
                ContactBusinessRelation.RESET();
                ContactBusinessRelation.SetCurrentKey("Link to Table", "No.");
                ContactBusinessRelation.setrange("Link to Table", ContactBusinessRelation."Link to Table"::customer);
                ContactBusinessRelation.SetRange("No.", Customer."No.");
                vendor_no := '';
                ContactBusinessRelation.findfirst();
                contact_no := ContactBusinessRelation."Contact No.";
                Clear(ContactBusinessRelation);
                ContactBusinessRelation.RESET();
                ContactBusinessRelation.setrange("Contact No.", contact_no);
                ContactBusinessRelation.setrange("Link to Table", ContactBusinessRelation."Link to Table"::vendor);
                if ContactBusinessRelation.findfirst() then begin
                    vendor_no := ContactBusinessRelation."No.";
                    Clear(Vendor);
                    Vendor.Reset();
                    Vendor.setrange("No.", vendor_no);
                    if not usePeriod then
                        Vendor.SetFilter("Date Filter", '..%1', ReconcileDate);
                    if Vendor.findfirst() then begin
                        RCNo := CreateReconcileStatementVendor(CurrencyCode, Vendor, DocumentDate, usePeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName, '');
                        CreateReconcileStatementCustomer(CurrencyCode, Customer, DocumentDate, usePeriod, ReconcileDate, StartDate, EndDate, ChiefAccountantName, RCNo);
                        Clear("EVK Reconcil. Statement Header");
                        "EVK Reconcil. Statement Header".Reset();
                        "EVK Reconcil. Statement Header".Setrange("No.", RCNo);
                        if "EVK Reconcil. Statement Header".FindFirst() then begin
                            "EVK Reconcil. Statement Header".type := "EVK Reconcil. Statement Header".type::"Vendor/Customer";
                            "EVK Reconcil. Statement Header".modify();
                        end

                    end;
                end;
            until Customer.Next() = 0;

    end;

    local procedure CreateReconcileStatementCustomer(CurrencyCode: Code[3]; var
                                                                                Customer: Record Customer;
                                                                                DocumentDate: date;
                                                                                usePeriod: boolean;
                                                                                ReconcileDate: date;
                                                                                StartDate: date;
                                                                                EndDate: Date;
                                                                                ChiefAccountantName: Text;
                                                                                RCNo: Code[20]): Code[20]
    var
        testi: boolean;
    begin
        Customer.CalcFields("Net Change (LCY)");
        Clear("EVK Reconcil. Statement Header");
        "EVK Reconcil. Statement Header".Reset();
        testi := false;
        if usePeriod then
            testi := true
        else
            IF Customer."Net Change (LCY)" <> 0 THEN
                testi := true;

        if testi then begin
            if RCNo = '' then BEGIN
                "EVK Reconcil. Statement Header".init();
                "EVK Reconcil. Statement Header".insert(true);
                "EVK Reconcil. Statement Header".validate("Customer No.", customer."No.");
                "EVK Reconcil. Statement Header"."Document Date" := DocumentDate;
                "EVK Reconcil. Statement Header"."Reconcile Date" := ReconcileDate;
                "EVK Reconcil. Statement Header".Accountant := copystr(ChiefAccountantName, 1, MaxStrLen("EVK Reconcil. Statement Header".Accountant));
                "EVK Reconcil. Statement Header".Type := "EVK Reconcil. Statement Header".Type::"Customer";
                "EVK Reconcil. Statement Header".modify(true);
                RCNo := "EVK Reconcil. Statement Header"."No.";
            end
            else
                "EVK Reconcil. Statement Header".Get(RCNo);

            Clear(CustLedgerEntry);
            CustLedgerEntry.Reset();
            CustLedgerEntry.SetCurrentKey("Customer No.", Open, Positive, "Due Date", "Currency Code");
            CustLedgerEntry.setrange("Customer No.", Customer."No.");
            CustLedgerEntry.setrange(Reversed, false);

            if not usePeriod then begin
                CustLedgerEntry.SETFILTER("Posting Date", '..%1', ReconcileDate);
                CustLedgerEntry.SETFILTER("Date Filter", '..%1', ReconcileDate);
                "EVK Reconcil. Statement Header"."Reconcile Start Date" := 0D;
                "EVK Reconcil. Statement Header"."Reconcile End Date" := 0D;
                "EVK Reconcil. Statement Header"."Use Period" := false;
                "EVK Reconcil. Statement Header".Modify(false);
            end
            else begin
                CustLedgerEntry.Setrange("Posting Date", StartDate, EndDate);
                "EVK Reconcil. Statement Header"."Reconcile Start Date" := StartDate;
                "EVK Reconcil. Statement Header"."Reconcile End Date" := EndDate;
                "EVK Reconcil. Statement Header"."Use Period" := true;
                "EVK Reconcil. Statement Header"."Reconcile Date" := 0D;

                Customer.SetFilter("Date Filter", '..%1', calcdate('<-1D>', StartDate));
                Customer.CalcFields("Net Change (LCY)");

                "EVK Reconcil. Statement Header"."Beginning Balance (LCY)" := Customer."Net Change (LCY)";
                Customer.SetFilter("Date Filter", '%1..', calcdate('<-1D>', StartDate));
                Customer.CalcFields("Net Change (LCY)");
                "EVK Reconcil. Statement Header"."Ending Balance (LCY)" := Customer."Net Change (LCY)";
                "EVK Reconcil. Statement Header".Modify(false);

            end;

            if CurrencyCode <> '' then
                CustLedgerEntry.setrange("Currency Code", CurrencyCode);

            if CustLedgerEntry.findset() then
                repeat
                    CustLedgerEntry.CalcFields(Amount, "Amount (LCY)", "Remaining Amt. (LCY)", "Remaining Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");
                    IF (CustLedgerEntry."Remaining Amount" <> 0) or (usePeriod) THEN BEGIN
                        row_number := 10000;
                        Clear(ReconcilStatementLine);
                        ReconcilStatementLine.Reset();
                        ReconcilStatementLine.setrange("Reconcilation Statement No.", "EVK Reconcil. Statement Header"."No.");
                        if ReconcilStatementLine.findlast() then row_number := ReconcilStatementLine."Line No." + 10000;

                        Clear(ReconcilStatementLine);
                        ReconcilStatementLine.Reset();
                        ReconcilStatementLine.init();
                        ReconcilStatementLine.validate("Reconcilation Statement No.", "EVK Reconcil. Statement Header"."No.");
                        ReconcilStatementLine.validate("Line No.", row_number);
                        ReconcilStatementLine.insert(true);
                        ReconcilStatementLine.validate("Document Type", CustLedgerEntry."Document Type");
                        if CustLedgerEntry."External Document No." <> '' then
                            ReconcilStatementLine.validate("Document No.", CustLedgerEntry."External Document No.")
                        else
                            ReconcilStatementLine.validate("Document No.", CustLedgerEntry."Document No.");

                        ReconcilStatementLine.validate("Document Date", CustLedgerEntry."Document Date");
                        ReconcilStatementLine.validate("Currency Code", CustLedgerEntry."Currency Code");

                        ReconcilStatementLine.validate(Amount, CustLedgerEntry.Amount);
                        ReconcilStatementLine.validate("Amount (LCY)", CustLedgerEntry."Amount (LCY)");
                        ReconcilStatementLine.validate("Remaining Amt. (LCY)", CustLedgerEntry."Remaining Amt. (LCY)");

                        if not usePeriod then begin
                            if CustLedgerEntry."Remaining Amt. (LCY)" > 0 then begin
                                ReconcilStatementLine.validate("Debit (LCY)", abs(CustLedgerEntry."Remaining Amt. (LCY)"));
                                ReconcilStatementLine.validate("Credit (LCY)", 0);
                            end
                            else begin
                                ReconcilStatementLine.validate("Debit (LCY)", 0);
                                ReconcilStatementLine.validate("Credit (LCY)", abs(CustLedgerEntry."Remaining Amt. (LCY)"));
                            end;
                        end
                        else begin
                            ReconcilStatementLine.validate("Debit (LCY)", CustLedgerEntry."Debit Amount (LCY)");
                            ReconcilStatementLine.validate("Credit (LCY)", CustLedgerEntry."Credit Amount (LCY)");
                        end;
                        ReconcilStatementLine.modify(true);

                    end;
                until CustLedgerEntry.Next() = 0;
        end;
        exit(RCNo);
    end;

    local procedure CreateReconcileStatementVendor(CurrencyCode: Code[3]; var Vendor: Record Vendor; DocumentDate: date; usePeriod: boolean; ReconcileDate: date; StartDate: date; EndDate: Date; ChiefAccountantName: Text; RCNo: Code[20]): Code[20]
    var
        testi: boolean;
    begin
        Vendor.CalcFields("Net Change (LCY)");
        Clear("EVK Reconcil. Statement Header");
        "EVK Reconcil. Statement Header".Reset();
        testi := false;
        if usePeriod then
            testi := true
        else
            IF Vendor."Net Change (LCY)" <> 0 THEN
                testi := true;

        if testi then begin
            if RCNo = '' then BEGIN
                "EVK Reconcil. Statement Header".init();
                "EVK Reconcil. Statement Header".insert(true);
                "EVK Reconcil. Statement Header".validate("Vendor No.", Vendor."No.");
                "EVK Reconcil. Statement Header"."Document Date" := DocumentDate;
                "EVK Reconcil. Statement Header"."Reconcile Date" := ReconcileDate;
                "EVK Reconcil. Statement Header".Accountant := copystr(ChiefAccountantName, 1, MaxStrLen("EVK Reconcil. Statement Header".Accountant));
                "EVK Reconcil. Statement Header".Type := "EVK Reconcil. Statement Header".Type::"Vendor";
                "EVK Reconcil. Statement Header".modify(true);
                RCNo := "EVK Reconcil. Statement Header"."No.";
            end
            else
                "EVK Reconcil. Statement Header".Get(RCNo);

            Clear(VendorLedgerEntry);
            VendorLedgerEntry.Reset();
            VendorLedgerEntry.SetCurrentKey("Vendor No.", Open, Positive, "Due Date", "Currency Code");
            VendorLedgerEntry.setrange("Vendor No.", Vendor."No.");
            if not usePeriod then begin
                VendorLedgerEntry.SETFILTER("Posting Date", '..%1', ReconcileDate);
                VendorLedgerEntry.SETFILTER("Date Filter", '..%1', ReconcileDate);
                "EVK Reconcil. Statement Header"."Reconcile Start Date" := 0D;
                "EVK Reconcil. Statement Header"."Reconcile End Date" := 0D;
                "EVK Reconcil. Statement Header"."Use Period" := false;
                "EVK Reconcil. Statement Header".modify();
            end
            else begin
                VendorLedgerEntry.setrange("Posting Date", StartDate, EndDate);
                "EVK Reconcil. Statement Header"."Reconcile Start Date" := StartDate;
                "EVK Reconcil. Statement Header"."Reconcile End Date" := EndDate;
                "EVK Reconcil. Statement Header"."Use Period" := true;
                "EVK Reconcil. Statement Header"."Reconcile Date" := 0D;
                Vendor.SetFilter("Date Filter", '..%1', calcdate('<-1D>', StartDate));
                Vendor.CalcFields("Net Change (LCY)");

                "EVK Reconcil. Statement Header"."Beginning Balance (LCY)" := Vendor."Net Change (LCY)";
                Vendor.SetFilter("Date Filter", '%1..', calcdate('<-1D>', StartDate));
                Vendor.CalcFields("Net Change (LCY)");
                "EVK Reconcil. Statement Header"."Ending Balance (LCY)" := Vendor."Net Change (LCY)";
                "EVK Reconcil. Statement Header".modify();
            end;

            if CurrencyCode <> '' then
                VendorLedgerEntry.setrange("Currency Code", CurrencyCode);

            if VendorLedgerEntry.findset() then
                repeat
                    VendorLedgerEntry.CalcFields(Amount, "Amount (LCY)", "Remaining Amt. (LCY)", "Remaining Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");
                    IF (VendorLedgerEntry."Remaining Amount" <> 0) or (usePeriod) THEN BEGIN
                        row_number := 10000;
                        Clear(ReconcilStatementLine);
                        ReconcilStatementLine.Reset();
                        ReconcilStatementLine.setrange("Reconcilation Statement No.", "EVK Reconcil. Statement Header"."No.");
                        if ReconcilStatementLine.findlast() then row_number := reconcilStatementLine."Line No." + 10000;

                        Clear(ReconcilStatementLine);
                        ReconcilStatementLine.Reset();
                        ReconcilStatementLine.init();
                        ReconcilStatementLine.validate("Reconcilation Statement No.", "EVK Reconcil. Statement Header"."No.");
                        ReconcilStatementLine.validate("Line No.", row_number);
                        ReconcilStatementLine.insert(true);
                        ReconcilStatementLine.validate("Document Type", VendorLedgerEntry."Document Type");
                        if VendorLedgerEntry."External Document No." <> '' then
                            ReconcilStatementLine.validate("Document No.", VendorLedgerEntry."External Document No.")
                        else
                            ReconcilStatementLine.validate("Document No.", VendorLedgerEntry."Document No.");

                        ReconcilStatementLine.validate("Document Date", VendorLedgerEntry."Document Date");
                        ReconcilStatementLine.validate("Currency Code", VendorLedgerEntry."Currency Code");

                        ReconcilStatementLine.validate(Amount, VendorLedgerEntry.Amount);
                        ReconcilStatementLine.validate("Amount (LCY)", VendorLedgerEntry."Amount (LCY)");
                        ReconcilStatementLine.validate("Remaining Amt. (LCY)", VendorLedgerEntry."Remaining Amt. (LCY)");

                        if not usePeriod then begin

                            if VendorLedgerEntry."Remaining Amt. (LCY)" > 0 then begin
                                ReconcilStatementLine.validate("Debit (LCY)", abs(VendorLedgerEntry."Remaining Amt. (LCY)"));
                                ReconcilStatementLine.validate("Credit (LCY)", 0);
                            end
                            else begin
                                ReconcilStatementLine.validate("Debit (LCY)", 0);
                                ReconcilStatementLine.validate("Credit (LCY)", abs(VendorLedgerEntry."Remaining Amt. (LCY)"));
                            end;
                        end
                        else begin
                            ReconcilStatementLine.validate("Debit (LCY)", VendorLedgerEntry."Debit Amount (LCY)");
                            ReconcilStatementLine.validate("Credit (LCY)", VendorLedgerEntry."Credit Amount (LCY)");
                        end;
                        ReconcilStatementLine.Modify(true);

                    end;
                until VendorLedgerEntry.Next() = 0;
        end;
        exit(RCNo);
    end;

    procedure getEnglishDate(date: date): text
    var
        dateFormatLbl: Label '%1 %2, %3', Comment = 'lt-LT="%1 %2, %3"';
        monthListLbl: Label 'January,February,March,April,May,June,July,August,September,October,November,December', Comment = 'lt-LT="Sausis, Vasaris, Kovas, Balandis, Gegužė, Birželis, Liepa, Rugpjūtis, Rugsėjis, Spalis, Lapkritis, Gruodis"';
        year: Integer;
        month: Integer;
        day: Integer;
        date_string: Text;
    begin
        if date = 0D then exit('');
        year := DATE2DMY(Date, 3);
        month := DATE2DMY(Date, 2);
        day := DATE2DMY(Date, 1);

        date_string := STRSUBSTNO(dateFormatLbl, SELECTSTR(month, monthListLbl), day, year);
        exit(date_string);
    end;

    procedure Amount2TextEUR(Amount: Decimal) AmountText: Text[250]
    var
        Cents: Integer;
        Value1: Decimal;
        Value2: Decimal;
    begin

        Cents := ROUND((Amount - ROUND(Amount, 1, '<')) * 100, 1);
        Amount := ROUND(Amount, 1, '<');

        AmountText := AmountInWords(Amount);

        Value1 := Amount - ROUND(Amount, 10, '<');
        Value2 := (Amount - ROUND(Amount, 100, '<') - Value1) / 10;

        IF (Value1 = 0) OR (Value2 = 1) THEN BEGIN
            IF AmountText <> '' THEN
                AmountText := copystr(AmountText + ' eurų', 1, MaxStrLen(AmountText));
        END
        ELSE
            IF (Value1 = 1) THEN
                AmountText := copystr(AmountText + ' euras', 1, MaxStrLen(AmountText))
            ELSE
                AmountText := copystr(AmountText + ' eurai', 1, MaxStrLen(AmountText));
        IF Cents < 10 THEN
            AmountText := AmountText + STRSUBSTNO(Cent1Lbl, Cents)
        ELSE
            AmountText := AmountText + STRSUBSTNO(Cent2Lbl, Cents);
    end;

    procedure AmountInWords(Amount: Decimal) AmountText: Text[250]
    var
        Vienetai: array[10] of text[10];
        Olika: array[10] of text[20];
        Dešimtys: array[10] of text[20];
        milijard: Decimal;
        milijon: Integer;
        tukst: Integer;
        simt: Integer;
        laikinas: Integer;
    begin
        IF Amount >= 1000000000000.0 THEN
            ERROR(CurrentAmountIsGreaterThanLbl, Amount);

        Vienetai[1] := ' vienas';
        Vienetai[2] := ' du';
        Vienetai[3] := ' trys';
        Vienetai[4] := ' keturi';
        Vienetai[5] := ' penki';
        Vienetai[6] := ' šeši';
        Vienetai[7] := ' septyni';
        Vienetai[8] := ' aštuoni';
        Vienetai[9] := ' devyni';

        Olika[1] := ' vienuolika';
        Olika[2] := ' dvylika';
        Olika[3] := ' trylika';
        Olika[4] := ' keturiolika';
        Olika[5] := ' penkiolika';
        Olika[6] := ' šešiolika';
        Olika[7] := ' septyniolika';
        Olika[8] := ' aštuoniolika';
        Olika[9] := ' devyniolika';

        Dešimtys[1] := ' dešimt';
        Dešimtys[2] := ' dvidešimt';
        Dešimtys[3] := ' trisdešimt';
        Dešimtys[4] := ' keturiasdešimt';
        Dešimtys[5] := ' penkiasdešimt';
        Dešimtys[6] := ' šešiasdešimt';
        Dešimtys[7] := ' septyniasdešimt';
        Dešimtys[8] := ' aštuoniasdešimt';
        Dešimtys[9] := ' devyniasdešimt';

        milijard := 0;
        milijon := 0;
        tukst := 0;
        simt := 0;

        IF Amount >= 1000000000 THEN
            milijard := ROUND(Amount / 1000000000, 1, '<');

        Amount := Amount - milijard * 1000000000;

        IF Amount >= 1000000 THEN
            milijon := ROUND(Amount / 1000000, 1, '<');

        Amount := Amount - milijon * 1000000;

        IF Amount >= 1000 THEN
            tukst := ROUND(Amount / 1000, 1, '<');

        simt := Amount - tukst * 1000;

        AmountText := '';

        IF milijard > 0 THEN BEGIN
            IF (milijard >= 100) AND (milijard < 200) THEN BEGIN
                AmountText := 'vienas šimtas';
                milijard := milijard - 100;
            END ELSE
                IF milijard >= 200 THEN BEGIN
                    laikinas := ROUND(milijard / 100, 1, '<');
                    AmountText := Vienetai[laikinas] + ' šimtai';
                    milijard := milijard - laikinas * 100;
                END;

            IF (milijard > 10) AND (milijard < 20) THEN
                AmountText := AmountText + Olika[milijard - 10]
            ELSE
                IF milijard >= 10 THEN BEGIN
                    laikinas := ROUND(milijard / 10, 1, '<');
                    AmountText := AmountText + Dešimtys[laikinas];
                    milijard := milijard - laikinas * 10;
                END;

            IF milijard = 1 THEN
                AmountText := copystr(AmountText + ' vienas milijardas', 1, MaxStrLen(AmountText))
            ELSE
                IF (milijard > 0) AND (milijard < 10) THEN
                    AmountText := copystr(AmountText + Vienetai[milijard] + ' milijardai', 1, MaxStrLen(AmountText))
                ELSE
                    AmountText := copystr(AmountText + ' milijardų', 1, MaxStrLen(AmountText));
        END;

        IF milijon > 0 THEN BEGIN
            IF (milijon >= 100) AND (milijon < 200) THEN BEGIN
                AmountText := copystr(AmountText + ' vienas šimtas', 1, MaxStrLen(AmountText));
                milijon := milijon - 100;
            END ELSE
                IF milijon >= 200 THEN BEGIN
                    laikinas := ROUND(milijon / 100, 1, '<');
                    AmountText := copystr(AmountText + Vienetai[laikinas] + ' šimtai', 1, MaxStrLen(AmountText));
                    milijon := milijon - laikinas * 100;
                END;

            IF (milijon > 10) AND (milijon < 20) THEN
                AmountText := AmountText + Olika[milijon - 10]
            ELSE
                IF milijon >= 10 THEN BEGIN
                    laikinas := ROUND(milijon / 10, 1, '<');
                    AmountText := AmountText + Dešimtys[laikinas];
                    milijon := milijon - laikinas * 10;
                END;

            IF milijon = 1 THEN
                AmountText := copystr(AmountText + ' vienas milijonas', 1, MaxStrLen(AmountText))
            ELSE
                IF (milijon > 0) AND (milijon < 10) THEN
                    AmountText := copystr(AmountText + Vienetai[milijon] + ' milijonai', 1, MaxStrLen(AmountText))
                ELSE
                    AmountText := copystr(AmountText + ' milijonų', 1, MaxStrLen(AmountText));
        END;

        IF tukst > 0 THEN BEGIN
            IF (tukst >= 100) AND (tukst < 200) THEN BEGIN
                IF STRLEN(AmountText) = 0 THEN
                    AmountText := 'Vienas šimtas'
                ELSE
                    AmountText := copystr(AmountText + ' šimtas', 1, MaxStrLen(AmountText));
                tukst := tukst - 100;
            END ELSE
                IF tukst >= 200 THEN BEGIN
                    laikinas := ROUND(tukst / 100, 1, '<');
                    AmountText := copystr(AmountText + Vienetai[laikinas] + ' šimtai', 1, MaxStrLen(AmountText));
                    tukst := tukst - laikinas * 100;
                END;

            IF (tukst > 10) AND (tukst < 20) THEN
                AmountText := AmountText + Olika[tukst - 10]
            ELSE
                IF tukst >= 10 THEN BEGIN
                    laikinas := ROUND(tukst / 10, 1, '<');
                    AmountText := AmountText + Dešimtys[laikinas];
                    tukst := tukst - laikinas * 10;
                END;

            IF tukst = 1 THEN
                AmountText := copystr(AmountText + ' vienas tūkstantis', 1, MaxStrLen(AmountText))
            ELSE
                IF (tukst > 0) AND (tukst < 10) THEN
                    AmountText := copystr(AmountText + Vienetai[tukst] + ' tūkstančiai', 1, MaxStrLen(AmountText))
                ELSE
                    AmountText := copystr(AmountText + ' tūkstančių', 1, MaxStrLen(AmountText));
        END;

        IF simt > 0 THEN BEGIN
            IF (simt >= 100) AND (simt < 200) THEN BEGIN
                IF STRLEN(AmountText) = 0 THEN
                    AmountText := 'Vienas šimtas'
                ELSE
                    AmountText := copystr(AmountText + ' šimtas', 1, MaxStrLen(AmountText));
                simt := simt - 100;
            END ELSE
                IF simt >= 200 THEN BEGIN
                    laikinas := ROUND(simt / 100, 1, '<');
                    AmountText := AmountText + Vienetai[laikinas] + ' šimtai';
                    simt := simt - laikinas * 100;
                END;

            IF (simt > 10) AND (simt < 20) THEN
                AmountText := AmountText + Olika[simt - 10]
            ELSE
                IF simt >= 10 THEN BEGIN
                    laikinas := ROUND(simt / 10, 1, '<');
                    AmountText := AmountText + Dešimtys[laikinas];
                    simt := simt - laikinas * 10;
                END;
            IF (simt > 0) AND (simt < 10) THEN
                AmountText := AmountText + Vienetai[simt];
        END;

        AmountText := DELCHR(AmountText, '<');
        AmountText := CONVERTSTR(UPPERCASE(COPYSTR(AmountText, 1, 1)), 'ąčęėįšųūž', 'ĄČĘĖĮŠŲŪŽ')
        + COPYSTR(AmountText, 2);

    end;

    procedure AmountInWordsByLangugae(Amount: Decimal; languageIntCode: integer): Text
    var
        repCheck: Report Check;
        NoText: array[2] of text[80];
        AmountTxt: Text;
    begin
        IF languageIntCode = 1063 THEN
            exit(Amount2TextEUR(Amount))
        ELSE BEGIN
            Clear(repCheck);
            repCheck.InitTextVariable();
            repCheck.FormatNoText(NoText, Amount, '');
            AmountTxt := NoText[1] + NoText[2];
            IF COPYSTR(AmountTxt, 1, 5) = '**** ' THEN
                AmountTxt := COPYSTR(AmountTxt, 6);
            EXIT(AmountTxt);
        END;
    end;

    local procedure CheckCustomerVendor(custNo: Code[20]; vendNo: Code[20]): boolean
    var
        contact_no: Code[20];
    begin
        if custNo <> '' then begin
            Clear(ContactBusinessRelation);
            ContactBusinessRelation.RESET();
            ContactBusinessRelation.SetCurrentKey("Link to Table", "No.");
            ContactBusinessRelation.setrange("Link to Table", ContactBusinessRelation."Link to Table"::customer);
            ContactBusinessRelation.SetRange("No.", custNo);
            ContactBusinessRelation.findfirst();

            contact_no := ContactBusinessRelation."Contact No.";
            Clear(ContactBusinessRelation);
            ContactBusinessRelation.RESET();
            ContactBusinessRelation.setrange("Contact No.", contact_no);
            ContactBusinessRelation.setrange("Link to Table", ContactBusinessRelation."Link to Table"::vendor);
            if ContactBusinessRelation.findfirst() then
                exit(false);
        end
        else
            if vendNo <> '' then begin
                Clear(ContactBusinessRelation);
                ContactBusinessRelation.RESET();
                ContactBusinessRelation.SetCurrentKey("Link to Table", "No.");
                ContactBusinessRelation.setrange("Link to Table", ContactBusinessRelation."Link to Table"::vendor);
                ContactBusinessRelation.SetRange("No.", vendNo);
                ContactBusinessRelation.findfirst();

                contact_no := ContactBusinessRelation."Contact No.";
                Clear(ContactBusinessRelation);
                ContactBusinessRelation.RESET();
                ContactBusinessRelation.setrange("Contact No.", contact_no);
                ContactBusinessRelation.setrange("Link to Table", ContactBusinessRelation."Link to Table"::customer);
                if ContactBusinessRelation.findfirst() then
                    exit(false);
            end;
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, 260, 'OnAfterEmailSentSuccesfully', '', false, false)]
    local procedure C260_OnAfterEmailSentSuccesfully(var TempEmailItem: Record "Email Item" temporary; PostedDocNo: Code[20]; ReportUsage: Integer)
    var
        DebtReconcilationStatSetup: Record "EVK Debt Reconciliation Setup";
        IssuedRecStatementHeader: Record "EVK Issued Rec. Stat. Header";
        ReportSelectionUsage: Enum "Report Selection Usage";
    begin
        if (Enum::"Report Selection Usage".FromInteger(ReportUsage) = ReportSelectionUsage::"EVK DEBTRECONCILATIONSTATEMENT") then begin
            DebtReconcilationStatSetup.Get();
            DebtReconcilationStatSetup.TestField("Report Selection Usage");
            if ReportUsage = DebtReconcilationStatSetup."Report Selection Usage" then BEGIN
                Clear(IssuedRecStatementHeader);
                IssuedRecStatementHeader.Reset();
                IssuedRecStatementHeader.SetRange("No.", PostedDocNo);
                if IssuedRecStatementHeader.findfirst() then BEGIN
                    IssuedRecStatementHeader.Sent := IssuedRecStatementHeader.Sent::Email;
                    IssuedRecStatementHeader.Modify(false);
                end
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, 60, 'OnBeforeTrySendToEMail', '', false, false)]
    local procedure T60_OnBeforeTrySendToEMail(ReportUsage: Integer; RecordVariant: Variant; DocumentNoFieldNo: Integer; DocName: Text[150]; CustomerFieldNo: Integer; ShowDialog: Boolean; var Handled: Boolean; var IsCustomer: Boolean)
    var
        RecordRef: RecordRef;
    begin
        RecordRef.GETTABLE(RecordVariant);
        if (RecordRef.Name = '"EVK Issued Rec. Stat. Header"') and (CustomerFieldNo = 40) then IsCustomer := false;
    end;

    [EventSubscriber(ObjectType::Table, 77, 'OnSaveReportAsHTMLOnBeforeSetTempLayoutSelected', '', false, false)]
    local procedure T77_OnSaveReportAsHTMLOnBeforeSetTempLayoutSelected(RecordVariant: Variant; ReportUsage: Enum "Report Selection Usage"; var ReportID: Integer; var LayoutCode: Code[20])
    var
        CustomReportLayout: Record "Custom Report Layout";
        IssuedRecStatementHeader: Record "EVK Issued Rec. Stat. Header";
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        value: Text;

    begin
        Clear(CustomReportLayout);
        CustomReportLayout.Reset();
        CustomReportLayout.setrange(Code, LayoutCode);
        CustomReportLayout.setfilter("EVK Language Code", '<>%1', '');
        if not CustomReportLayout.IsEmpty then
            case ReportUsage of
                ReportUsage::"EVK DEBTRECONCILATIONSTATEMENT":
                    begin
                        RecordRef.GETTABLE(RecordVariant);
                        if RecordRef.Name = '"EVK Issued Rec. Stat. Header"' then begin
                            FieldRef := RecordRef.FIELD(120);
                            value := FieldRef.VALUE;
                            if (value = 'LTH') or (value = '') then BEGIN
                                Clear(CustomReportLayout);
                                CustomReportLayout.Reset();
                                CustomReportLayout.SetCurrentKey("Report ID", "Company Name", Type);
                                CustomReportLayout.setrange("Report ID", ReportID);
                                CustomReportLayout.setfilter("EVK Language Code", '%1|%2', '', 'LTH');
                                if CustomReportLayout.findfirst() then
                                    LayoutCode := CustomReportLayout.Code;
                            end
                            else begin
                                Clear(CustomReportLayout);
                                CustomReportLayout.Reset();
                                CustomReportLayout.SetCurrentKey("Report ID", "Company Name", Type);
                                CustomReportLayout.setrange("Report ID", ReportID);
                                CustomReportLayout.setrange("EVK Language Code", 'ENU');
                                if CustomReportLayout.findfirst() then
                                    LayoutCode := CustomReportLayout.Code;
                            end;
                            Clear(IssuedRecStatementHeader);
                            IssuedRecStatementHeader.Reset();
                        end;
                    end;

            end
    end;

    [EventSubscriber(ObjectType::Codeunit, 8891, 'OnAfterFromReportSelectionUsage', '', false, false)]
    local procedure OnAfterFromReportSelectionUsag(ReportSelectionUsage: Enum "Report Selection Usage"; var EmailScenario: Enum "Email Scenario")
    begin
        if ReportSelectionUsage = ReportSelectionUsage::"EVK DEBTRECONCILATIONSTATEMENT" THEN
            EmailScenario := EmailScenario::"EVK DEBTRECONCILATIONSTATEMENT";
    end;

    [EventSubscriber(ObjectType::Table, 77, 'OnSendEmailInBackgroundOnAfterGetJobQueueParameters', '', false, false)]
    local procedure OnSendEmailInBackgroundOnAfterGetJobQueueParameters(var RecRef: RecordRef; var ParamString: Text)
    begin
        if ParamString = '|Vendor' then
            ParamString := 'Vendor';
    end;

    var

        CustLedgerEntry: record "Cust. Ledger Entry";
        VendorLedgerEntry:
                Record "Vendor Ledger Entry";
        "EVK Reconcil. Statement Header": Record "EVK Reconcil. Statement Header";
        ReconcilStatementLine: Record "EVK Reconcil. Statement Line";
        ContactBusinessRelation: Record "Contact Business Relation";
        row_number: Integer;
        CurrentAmountIsGreaterThanLbl: Label 'Current amount %1 is greater than 1 000 000 000 000', Comment = 'lt-LT="Esama suma %1 didesnė nei 1 000 000 000 000"';
        Cent1Lbl: Label ' 0#1 ct. ', Comment = 'lt-LT=" 0#1 ct. "';
        Cent2Lbl: Label ' #1 ct. ', Comment = 'lt-LT=" #1 ct. "';

        DebtReconciliationStatementErr: Label 'Debt reconcilation statement %1 already issued', Comment = 'lt-LT="Skolos derinimo aktas %1 jau yra išrašytas"';
        DebtReconciliationLinesErr: Label 'Debt reconcilation statement %1 has no lines', Comment = 'lt-LT="Skolos derinimo aktas %1 neturi eilučių"';
}
