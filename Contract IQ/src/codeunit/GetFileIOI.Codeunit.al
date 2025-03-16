namespace IOI.ContractIQ;

using System.Utilities;
using System.IO;

codeunit 70005 "GetFile IOI"
{
    procedure TestGetFile()
    var
        AppMetaFiles: Record "App Meta Files IOI";
        AppMeta: Record "App Meta IOI";
        AppFilesMgt: Codeunit "App Files Mgt. IOI";
        PersistentBlob: Codeunit "Persistent Blob";
        TempBlob: Codeunit "Temp Blob";
        DataCompression: Codeunit "Data Compression";
        PersistentBlobId: BigInteger;
        OutStream: OutStream;
        InStream: InStream;
        ZipOutStream: OutStream;
        ZipInStream: InStream;
        FileName: Text;
        ZipFileName: Text;
    begin

        AppMeta.Reset();
        AppMeta.FindFirst();
        DataCompression.CreateZipArchive();

        AppMetaFiles.Reset();
        AppMetaFiles.SetRange(id, AppMeta.id);
        AppMetaFiles.SetRange(version, AppMeta.version);
        IF AppMetaFiles.FindSet() THEN
            repeat
                PersistentBlobId := AppFilesMgt.GetSingleFile(AppMetaFiles);
                TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
                PersistentBlob.CopyToOutStream(PersistentBlobId, OutStream);
                TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
                CASE AppMetaFiles.type of
                    AppMetaFiles.type::Structure:
                        FileName := AppMetaFiles.name + '.' + AppMetaFiles.fileextension.Names.Get(AppMetaFiles.fileextension.Ordinals.IndexOf(AppMetaFiles.fileextension.AsInteger()));
                    AppMetaFiles.type::Table:
                        FileName := 'src\tables\' + AppMetaFiles.name + '.' + AppMetaFiles.fileextension.Names.Get(AppMetaFiles.fileextension.Ordinals.IndexOf(AppMetaFiles.fileextension.AsInteger()));
                end;
                DataCompression.AddEntry(InStream, FileName);
                PersistentBlob.Delete(PersistentBlobId);
            until AppMetaFiles.Next() = 0;

        TempBlob.CreateOutStream(ZipOutStream, TextEncoding::UTF8);
        DataCompression.SaveZipArchive(ZipOutStream);
        DataCompression.CloseZipArchive();
        TempBlob.CreateInStream(ZipInStream, TextEncoding::UTF8);
        ZipFileName := AppMeta.name + '.app';
        DownloadFromStream(ZipInStream, '', '', '', ZipFileName)
    end;


}


