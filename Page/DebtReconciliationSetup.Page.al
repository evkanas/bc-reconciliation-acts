page 70117 "EVK Debt Reconciliation Setup"
{
    PageType = Card;
    SourceTable = "EVK Debt Reconciliation Setup";
    UsageCategory = Administration;
    Caption = 'Debt Reconcilation Statement Setup', Comment = 'lt-LT="Skolų suderinimo akto nustatymai"';
    ApplicationArea = Basic, Suite;
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'lt-LT="Bendra informacija"';
                field("Reconcilation Statement Nos."; Rec."Reconcilation Statement Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Reconcilation Statement Nos.', Comment = 'lt-LT="Nurodo suderinimo akto numerius"';
                }
                field("Registration No. Field"; Rec."Registration No. Field")
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer "Registration No." field No. in customer card.', Comment = 'lt-LT="Kliento "Registracijos numeris" laukas kliento korteleje"';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Field: Record Field;
                        PFields: Page "EVK RSAllObj";
                    begin
                        Clear(Field);
                        Field.RESET();
                        Field.SETRANGE(TableNo, 18);
                        Clear(PFields);
                        PFields.SETTABLEVIEW(Field);
                        PFields.LOOKUPMODE(true);
                        IF PFields.RUNMODAL() = Action::LookupOK THEN begin
                            PFields.GETRECORD(Field);
                            Rec."Registration No. Field" := Field."No.";
                        END;
                    end;
                }
                field("Vendor Registration No. Field"; Rec."Vendor Registration No. Field")
                {
                    ApplicationArea = All;
                    ToolTip = 'Vendor "Registration No." field No. in vendor card.', Comment = 'lt-LT="Tiekėjo "Registracijos numeris" laukas tiekėjo korteleje"';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Field: Record Field;
                        PFields: Page "EVK RSAllObj";
                    begin
                        Clear(Field);
                        Field.RESET();
                        Field.SETRANGE(TableNo, 23);
                        Clear(PFields);
                        PFields.SETTABLEVIEW(Field);
                        PFields.LOOKUPMODE(true);
                        IF PFields.RUNMODAL() = Action::LookupOK THEN begin
                            PFields.GETRECORD(Field);
                            Rec."Vendor Registration No. Field" := Field."No.";
                        END;
                    end;
                }
                field("Report Selection Usage"; Rec."Report Selection Usage")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies report selection usage for debt reconsi statement.', Comment = 'lt-LT="Nurodo skolų suderinimo akto ataskaitos pasirinkimo naudojimą"';
                }
                field("Statement E-mail"; Rec."Statement E-mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies where to send the statement.', Comment = 'lt-LT="Nurodo, kur išsiųsti akto"';
                }
                field("Additional Text"; Rec."Additional Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional text for the statement.', Comment = 'lt-LT="Nurodo papildomą tekstą akto"';
                    MultiLine = true;
                }

                field("Additional Text ENU"; Rec."Additional Text ENU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies additional text for the statement in eglish language.', Comment = 'lt-LT="Nurodo papildomą tekstą akto anglų kalba"';
                    MultiLine = true;
                }

            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.RESET();
        IF NOT Rec.GET() THEN BEGIN
            Rec.INIT();
            Rec.INSERT();
        END;

    end;
}
