pageextension 70152 "EVK EmployeeCard" extends "Employee Card"
{
    layout
    {
        addafter("Privacy Blocked")
        {
            field("EVK Employee Signature"; Rec."EVK Employee Signature")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the employee signature.', Comment = 'lt-LT="Nurodo darbuotojo parašą"';
            }
        }
    }

    actions
    {
        addfirst(Processing)
        {
            action("EVK DELETEEmployeesignature")
            {
                Caption = 'Delete Employee Signature', Comment = 'lt-LT="Ištrinti darbuotojo parašą"';
                ApplicationArea = All;
                ToolTip = 'Delete the employee signature.', Comment = 'lt-LT="Ištrina darbuotojo parašą"';
                Image = Delete;

                trigger OnAction()
                begin
                    if Rec."EVK Employee Signature".HasValue then
                        if Confirm(ConfirmDeletePictureLbl) then begin
                            Clear(Rec."EVK Employee Signature");
                            CurrPage.SaveRecord();
                        end;
                end;
            }
        }
    }
    var
        ConfirmDeletePictureLbl: Label 'Do you want to delete company stamp?', Comment = 'lt-LT="Ar norite ištrinti kompanijos antspaudą?"';
}
