#define SourcePath ".."

#ifndef KEBAP_VERSION
  #define KEBAP_VERSION "latest"
#endif

[Setup]
AppId={{D573EDD5-117A-47AD-88AC-62C8EBD11DC7}
AppName="Kebap"
AppVersion={#KEBAP_VERSION}
AppPublisher="j4ckgrey"
AppPublisherURL="https://github.com/j4ckgrey/Kebap"
AppSupportURL="https://github.com/j4ckgrey/Kebap"
AppUpdatesURL="https://github.com/j4ckgrey/Kebap"
DefaultDirName={localappdata}\Programs\Kebap
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputBaseFilename=kebap_setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern

SetupLogging=yes
UninstallLogging=yes
UninstallDisplayName="Kebap"
UninstallDisplayIcon={app}\kebap.exe
SetupIconFile="{#SourcePath}\icons\production\kebap_icon.ico"
LicenseFile="{#SourcePath}\LICENSE"
WizardImageFile={#SourcePath}\assets\windows-installer\kebap-installer-100.bmp,{#SourcePath}\assets\windows-installer\kebap-installer-125.bmp,{#SourcePath}\assets\windows-installer\kebap-installer-150.bmp

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#SourcePath}\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\Kebap"; Filename: "{app}\kebap.exe"
Name: "{autodesktop}\Kebap"; Filename: "{app}\kebap.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\kebap.exe"; Description: "{cm:LaunchProgram,Kebap}"; Flags: nowait postinstall skipifsilent

[Code]
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  case CurUninstallStep of
    usUninstall:
      begin
        if MsgBox('Would you like to delete the application''s data? This action cannot be undone. Synced files will remain unaffected.', mbConfirmation, MB_YESNO) = IDYES then
        begin
            if DelTree(ExpandConstant('{localappdata}\j4ckgrey'), True, True, True) = False then
            begin
                Log(ExpandConstant('{localappdata}\j4ckgrey could not be deleted. Skipping...'));
            end;
        end;
      end;
  end;
end;
