namespace IOI.ContractIQ;

using System.Reflection;

table 70007 "SR Object Detail IOI"
{
    Caption = 'SR Object Detail';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Object Type"; Enum "SR Object Type IOI")
        {
            Caption = 'Object Type';
            DataClassification = CustomerContent;
        }
        field(2; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            DataClassification = CustomerContent;
        }
        field(3; "Object Name"; Text[250])
        {
            Caption = 'Object Name';
            TableRelation = "SR Object IOI"."Object ID";
            FieldClass = FlowField;
            CalcFormula = lookup("SR Object IOI"."Object Name" where("Object Type" = field("Object Type"), "Object ID" = field("Object ID")));
        }
        field(4; "Detail ID"; Integer)
        {
            Caption = 'Detail ID';
            DataClassification = CustomerContent;
        }
        field(5; "Detail Sortorder ID"; Integer)
        {
            Caption = 'Detail ID';
            DataClassification = CustomerContent;
        }
        field(6; "Detail Name"; Text[250])
        {
            Caption = 'Detail Name';
            DataClassification = CustomerContent;
        }
        field(7; "Detail Value"; Text[250])
        {
            Caption = 'Detail Value';
            DataClassification = CustomerContent;
        }
        field(8; "Detail Type"; Enum "SR Object Detail Type IOI")
        {
            Caption = 'Detail Type';
        }
        field(9; "Detail Type Name"; Text[250])
        {
            Caption = 'Detail Type Name';
            DataClassification = CustomerContent;
        }
        field(10; "Detail SubType ID"; Integer)
        {
            Caption = 'Detail SubType ID';
            DataClassification = CustomerContent;
        }
        field(11; "Detail SubType Name"; Text[250])
        {
            Caption = 'Detail SubType Name';
            DataClassification = CustomerContent;
        }
        field(12; "Detail Arguments"; Text[250])
        {
            Caption = 'Detail Arguments';
            DataClassification = CustomerContent;
        }
        field(13; "Detail Type Definition"; Text[250])
        {
            Caption = 'Detail Type Definition';
            DataClassification = CustomerContent;
        }
        field(14; "Return Type Definition"; Text[250])
        {
            Caption = 'Return Type Definition';
            DataClassification = CustomerContent;
        }
        field(15; "Is Internal Method"; boolean)
        {
            Caption = 'Is Internal Method';
        }
        field(16; "Is Var"; boolean)
        {
            Caption = 'Is Var';
        }
    }
    keys
    {
        key(PK; "Object Type", "Object ID", "Detail Type", "Detail ID", "Detail Sortorder ID", "Detail Name", "Detail SubType ID")
        {
            Clustered = true;
        }
    }
}
