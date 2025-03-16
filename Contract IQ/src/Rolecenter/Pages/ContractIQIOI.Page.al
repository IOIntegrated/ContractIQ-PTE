namespace IOI.ContractIQ;
using Microsoft.Finance.GeneralLedger.Ledger;
using System.Reflection;

page 70008 "Contract IQ IOI"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Contract IQ';
    SourceTable = "ContractIQ Settings IOI";
    DataCaptionFields = Name, Version;


    layout
    {
        area(content)
        {
            usercontrol(WatermarkAddIn; "Banner IOI")
            {
                ApplicationArea = All;
            }
            group(Tasks)
            {
                Caption = 'ChargeMapper';

                grid(grid)
                {
                    // Linke Spalte
                    group(LeftTasks)
                    {
                        ShowCaption = false;

                        field(ContractIQSetting; ContractIQSettingLbl)
                        {
                            ShowCaption = false; // Label ausblenden
                            Editable = false;
                            ToolTip = 'Prepare application setup';
                            trigger OnDrillDown()
                            var
                                ContractIQSetting: Page "ContractIQ Setting List IOI";
                            begin
                                ContractIQSetting.RunModal();
                            end;
                        }
                        field(InputStructure; InputStructureLbl)
                        {
                            ShowCaption = false; // Label ausblenden
                            Editable = false;
                            ToolTip = 'Prepare input and output table structures';
                            trigger OnDrillDown()
                            var
                                Fields: Record "Fields IOI";
                                FieldList: Page "Field List IOI";
                            begin
                                Fields.SetRange(ID, Rec.ID);
                                Fields.SetRange("Table No.", 99999);
                                FieldList.SetTableView(Fields);
                                FieldList.RunModal();
                            end;
                        }
                        field(LookupTable; LookupTableLbl)
                        {
                            ShowCaption = false; // Label ausblenden
                            Editable = false;
                            ToolTip = 'Prepare input and output table structures';
                            trigger OnDrillDown()
                            var
                                AppTables: Record "Tables IOI";
                                AppTableList: Page "Table List IOI";
                            begin
                                AppTables.SetRange(ID, Rec.ID);
                                AppTables.SetRange(Usage, AppTables.Usage::"Lookup table");
                                AppTableList.SetTableView(AppTables);
                                AppTableList.RunModal();
                            end;
                        }
                        field(Enums; EnumsLbl)
                        {
                            ShowCaption = false; // Label ausblenden
                            Editable = false;
                            ToolTip = 'Prepare input and output table structures';
                            trigger OnDrillDown()
                            var
                                AppTables: Record "Tables IOI";
                                AppTableList: Page "Table List IOI";
                            begin
                                AppTables.SetRange(ID, Rec.ID);
                                AppTables.SetRange(Usage, AppTables.Usage::Enum);
                                AppTableList.SetTableView(AppTables);
                                AppTableList.RunModal();
                            end;
                        }
                        field(Events; EventsLbl)
                        {
                            ShowCaption = false; // Label ausblenden
                            Editable = false;
                            ToolTip = 'List of all Events';
                            trigger OnDrillDown()
                            begin
                                Page.Run(Page::"Event List IOI");
                            end;
                        }
                        field(DownloadExtensions; DownloadExtensionsLbl)
                        {
                            ShowCaption = false; // Label ausblenden
                            Editable = false;
                            ToolTip = 'List of all Events';
                            trigger OnDrillDown()
                            var
                                Extension: record "App Loader Extension IOI";
                                DownloadSymbols: Codeunit "Download Symbols IOI";
                                Progressbar: Codeunit "Progressbar IOI";
                                DeviceCodeFlow: Page "Device Code Flow Page IOI";
                                AccessToken: Text;
                            begin

                                if not DeviceCodeFlow.GetAccessToken(AccessToken) then begin
                                    Commit();
                                    DeviceCodeFlow.RunModal();
                                end;
                                if DeviceCodeFlow.GetAccessToken(AccessToken) then
                                    if DownloadSymbols.GetExtensionList(AccessToken) then
                                        if Extension.FindSet() then begin
                                            Progressbar.ProgressbarInit();
                                            repeat
                                                Progressbar.ProgressbarUpdate(3, Extension.displayName);
                                                DownloadSymbols.DownloadExtension(AccessToken, Extension, Progressbar);
                                            until Extension.Next() = 0;
                                            Progressbar.ProgressbarClose();
                                        end;
                            end;
                        }
                    }

                    // Rechte Spalte
                    group(CenterTask)
                    {
                        ShowCaption = false;
                    }
                    // Rechte Spalte
                    group(RightTasks)
                    {
                        ShowCaption = false;
                    }
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
            }
        }
    }

    var
        ContractIQSettingLbl: Label 'Contract IQ Setting';
        InputStructureLbl: Label 'Input Structure';
        LookupTableLbl: Label 'Lookups';
        EnumsLbl: Label 'Enumerations';
        EventsLbl: Label 'Events';
        ImportSymbolLbl: Label 'Import Symbols';
        DownloadExtensionsLbl: Label 'Download Extensions';
        ExtensionNameText: Text;

    trigger OnAfterGetRecord()
    begin
        CurrPage.Caption := Rec.Name + ' - ' + Rec.Version;
    end;


}
