tableextension 70151 "EVK Custom Report Layout" extends "Custom Report Layout"
{
    fields
    {
        field(70151; "EVK Language Code"; Code[10])
        {
            Caption = 'Language Code', Comment = 'lt-LT="Kalbos kodas"';
            DataClassification = CustomerContent;
            TableRelation = Language;
        }
    }

}
