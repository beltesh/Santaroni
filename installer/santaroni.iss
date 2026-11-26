; Windows installer for Santaroni, built with Inno Setup 6
; (https://jrsoftware.org/isinfo.php).
;
; Build the app first (flutter build windows --release), then from the
; repository root:
;   iscc /DAppVersion=1.0.0 installer\santaroni.iss
; The installer is written to dist\.

#ifndef AppVersion
  #error Pass the version: iscc /DAppVersion=1.0.0 installer\santaroni.iss
#endif

#define AppName "Santaroni"
#define AppPublisher "Lux Aeterna Soft"
#define AppUrl "https://github.com/beltesh/Santaroni"
#define AppExe "santaroni.exe"
#define BuildDir "..\build\windows\x64\runner\Release"

[Setup]
; Never change AppId: Windows uses it to recognize upgrades and uninstall.
AppId={{9BE6114E-5334-45CF-80B8-A843971B87BD}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppUrl}
AppSupportURL={#AppUrl}/issues
AppUpdatesURL={#AppUrl}/releases
AppCopyright=Copyright (C) 2026 {#AppPublisher}. Licensed under GPL-3.0.
VersionInfoVersion={#AppVersion}
VersionInfoCompany={#AppPublisher}
VersionInfoProductName={#AppName}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
; Installs for the current user without admin rights by default; the
; first page offers installing for everyone instead.
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
LicenseFile=..\LICENSE
SetupIconFile=..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#AppExe}
UninstallDisplayName={#AppName}
OutputDir=..\dist
OutputBaseFilename=Santaroni-{#AppVersion}-windows-setup
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern
; Close a running Santaroni before upgrading it.
CloseApplications=yes

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "pt"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#BuildDir}\*"; DestDir: "{app}"; Excludes: "*.pdb"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent

; Events, settings and the saved password live in the user's AppData and the
; Windows credential store, not in {app}, so uninstalling (or upgrading)
; never deletes them.
