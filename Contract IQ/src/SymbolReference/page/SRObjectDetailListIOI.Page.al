namespace IOI.ContractIQ;

page 70013 "SR Object Detail List IOI"
{
    ApplicationArea = All;
    Caption = 'Symbol Reference Detail List';
    PageType = List;
    SourceTable = "SR Object Detail IOI";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Object Type"; Rec."Object Type")
                {
                    ToolTip = 'Specifies the value of the Object Type field.', Comment = '%';
                    Visible = false;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ToolTip = 'Specifies the value of the Object ID field.', Comment = '%';
                    Visible = false;
                }
                field("Object Name"; Rec."Object Name")
                {
                    ToolTip = 'Specifies the value of the Object Name field.', Comment = '%';
                    Visible = false;
                }
                field("Detail Type"; Rec."Detail Type")
                {
                    ToolTip = 'Specifies the value of the Detail Type field.', Comment = '%';
                }
                field("Detail Type Name"; Rec."Detail Type Name")
                {
                    ToolTip = 'Specifies the value of the Detail Type Name field.', Comment = '%';
                }
                field("Detail ID"; Rec."Detail ID")
                {
                    ToolTip = 'Specifies the value of the Detail ID field.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        SRDetailListRec: Record "SR Object Detail IOI";
                        SRDetailList: Page "SR Object Detail List IOI";
                    begin
                        SRDetailListRec.SetRange("Object ID", Rec."Object ID");
                        SRDetailListRec.SetRange("Object Type", Rec."Object Type");
                        SRDetailListRec.SetRange("Detail ID", Rec."Detail ID");
                        case Rec."Detail Type" of
                            Rec."Detail Type"::Field:
                                SRDetailListRec.SetRange("Detail Type", SRDetailListRec."Detail Type"::TypeDefinition);
                            Rec."Detail Type"::Method:
                                SRDetailListRec.SetFilter("Detail Type", StrSubstNo('%1|%2', SRDetailListRec."Detail Type"::Parameter, SRDetailListRec."Detail Type"::Attribute));
                            Rec."Detail Type"::Parameter:
                                SRDetailListRec.SetRange("Detail Type", SRDetailListRec."Detail Type"::TypeDefinition);
                        end;
                        SRDetailList.SetTableView(SRDetailListRec);
                        SRDetailList.Run();
                    end;

                }
                field("Is Var"; rec."Is Var")
                {
                    ToolTip = 'Specifies the value of the Is Var field.', Comment = '%';
                }
                field("Detail Name"; Rec."Detail Name")
                {
                    ToolTip = 'Specifies the value of the Detail Name field.', Comment = '%';
                }
                field("Detail Type Definition"; Rec."Detail Type Definition")
                {
                    ToolTip = 'Specifies the value of the Detail Type Definition field.', Comment = '%';
                }
                field("Detail SubType ID"; Rec."Detail SubType ID")
                {
                    ToolTip = 'Specifies the value of the Detail SubType ID field.', Comment = '%';
                }
                field("Detail SubType Name"; Rec."Detail SubType Name")
                {
                    ToolTip = 'Specifies the value of the Detail SubType Name field.', Comment = '%';
                }
                field("Return Type Definition"; Rec."Return Type Definition")
                {
                    ToolTip = 'Specifies the value of the Return Type Definition field.', Comment = '%';
                }
                field("Is Internal Method"; Rec."Is Internal Method")
                {
                    ToolTip = 'Specifies the value of the Is Internal Method field.', Comment = '%';
                }
                field("Detail Value"; Rec."Detail Value")
                {
                    ToolTip = 'Specifies the value of the Detail Value field.', Comment = '%';
                }
                field("Detail Arguments"; Rec."Detail Arguments")
                {
                    ToolTip = 'Specifies the value of the Detail Arguments field.', Comment = '%';
                }
            }
        }
    }
}
