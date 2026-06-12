page 70124 "EVK RSAllObj"
{
    PageType = List;
    SourceTable = Field;
    UsageCategory = Lists;
    Caption = 'All objects', Comment = 'lt-LT="Visi objektai"';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General', Comment = 'lt-LT="Bendras"';
                field(TableNo; Rec.TableNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source table number, if any, for this Codeunit.', Comment = 'lt-LT="Nurodo šaltinio lentelės numerį, jei toks yra, šiai codeunitės"';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the field.', Comment = 'lt-LT="Nurodo lauko numerį"';
                }
                field(TableName; Rec.TableName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the table.', Comment = 'lt-LT="Nurodo lentelės pavadinimą"';
                }
                field(FieldName; Rec.FieldName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the field.', Comment = 'lt-LT="Nurodo lauko pavadinimą"';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the data type of the selected field.', Comment = 'lt-LT="Nurodo pasirinkto lauko duomenų tipą"';
                }
                field(Class; Rec.Class)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the class of the field.', Comment = 'lt-LT="Nurodo lauko klasę"';
                }
                field(Len; Rec.Len)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the length of the field.', Comment = 'lt-LT="Nurodo lauko ilgį"';
                }

            }
        }
    }
}
