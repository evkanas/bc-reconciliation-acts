tableextension 70152 "EVK Employee" extends Employee
{
    fields
    {
        field(70150; "EVK Employee Signature"; Blob)
        {
            Caption = 'Employee Signature', Comment = 'lt-LT="Darbuotojo parašas"';
            DataClassification = CustomerContent;
            SubType = "Bitmap";
        }
    }

}
