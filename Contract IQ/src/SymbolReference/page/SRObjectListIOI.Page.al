namespace IOI.ContractIQ;

page 70012 "SR Object List IOI"
{
    ApplicationArea = All;
    Caption = 'Symbol Reference Object List';
    PageType = List;
    SourceTable = "SR Object IOI";
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
                }
                field("Object ID"; Rec."Object ID")
                {
                    ToolTip = 'Specifies the value of the Object ID field.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        SRDetailListRec: Record "SR Object Detail IOI";
                        SRDetailList: Page "SR Object Detail List IOI";
                    begin
                        SRDetailListRec.SetRange("Object ID", Rec."Object ID");
                        SRDetailListRec.SetRange("Object Type", Rec."Object Type");
                        case Rec."Object Type" of
                            Rec."Object Type"::Table:
                                SRDetailListRec.SetRange("Detail Type", SRDetailListRec."Detail Type"::Field);
                            Rec."Object Type"::Codeunit:
                                SRDetailListRec.SetRange("Detail Type", SRDetailListRec."Detail Type"::Method);
                        end;
                        SRDetailList.SetTableView(SRDetailListRec);
                        SRDetailList.Run();
                    end;
                }
                field("Object Name"; Rec."Object Name")
                {
                    ToolTip = 'Specifies the value of the Object Name field.', Comment = '%';
                }
                field("Object Caption"; Rec."Object Caption")
                {
                    ToolTip = 'Specifies the value of the Object Name field.', Comment = '%';
                }
                field("Object Extensible"; Rec."Object Extensible")
                {
                    ToolTip = 'Specifies the value of the Object Name field.', Comment = '%';
                }
                field(Namespace; Rec.Namespace)
                {
                    ToolTip = 'Specifies the value of the Namespace field.', Comment = '%';
                }
                field("App Package ID"; Rec."App Package ID")
                {
                    ToolTip = 'Specifies the value of the App Package ID field.', Comment = '%';
                }
                field("Reference Source File Name"; Rec."Reference Source File Name")
                {
                    ToolTip = 'Specifies the value of the Reference Source File Name field.', Comment = '%';
                }
            }
        }
    }
}
