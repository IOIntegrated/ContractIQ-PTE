namespace IOI.ContractIQ;

table 70006 "SR Object IOI"
{
    Caption = 'SymbolReference Object';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Object Type"; enum "SR Object Type IOI")
        {
        }
        field(3; "Object ID"; Integer)
        {
        }
        field(4; "Object Name"; Text[250])
        {
        }
        field(5; "Reference Source File Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Object Caption"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("SR Object Detail IOI"."Detail Value" where("Object ID" = field("Object ID")
                                                                           , "Object Type" = field("Object Type")
                                                                           , "Detail ID" = filter(0)
                                                                           , "Detail Type" = filter(6)
                                                                           , "Detail Name" = filter('Caption')
                                                                           ));
        }
        field(11; "Object Extensible"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("SR Object Detail IOI"."Detail Value" where("Object ID" = field("Object ID")
                                                                           , "Object Type" = field("Object Type")
                                                                           , "Detail ID" = filter(0)
                                                                           , "Detail Type" = filter(6)
                                                                           , "Detail Name" = filter('Extensible')
                                                                           ));
        }
        field(60; "App Package ID"; Guid)
        {
        }
        field(100; Namespace; Text[250])
        {
        }
    }
    keys
    {
        key(PK; "Object Type", "Object ID")
        {
            Clustered = true;
        }
    }
    FieldGroups
    {
        fieldgroup("DropDown"; "Object ID", "Object Type", "Object Name")
        {

        }
    }
}
