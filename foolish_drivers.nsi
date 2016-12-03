# Foolish Products Board Driver NSIS Install Script
# Based on the Adafruit Board Driver NSIS Install Script
# by Tony DiCola

# Import some useful functions.
!include WinVer.nsh   # Windows version detection.
!include x64.nsh      # X86/X64 version detection.

# Set attributes that describe the installer.
Icon "Assets\whoa.ico"
Caption "Foolish Products - Whoa Board Driver"
Name "Foolish Products - Whoa Board Driver"
Outfile "foolish_drivers.exe"
ManifestSupportedOS "all"
SpaceTexts "none"

# Install driver files to a temporary location (then dpinst will handle the real install).
InstallDir "$TEMP\foolish_drivers"

# Set properties on the installer exe that will be generated.
VIAddVersionKey /LANG=1033 "ProductName" "Whoa Board Driver"
VIAddVersionKey /LANG=1033 "CompanyName" "Foolish Products"
VIAddVersionKey /LANG=1033 "LegalCopyright" "Foolish Products, LLC"
VIAddVersionKey /LANG=1033 "FileDescription" "Installer for the Whoa Board's drivers."
VIAddVersionKey /LANG=1033 "FileVersion" "1.0.0"
VIProductVersion "1.0.0.0"
VIFileVersion "1.0.0.0"

# Define variables used in sections.
Var dpinst   # Will hold the path and name of dpinst being used (x86 or x64).


# Define the standard pages in the installer.
# License page shows the contents of license.rtf.
PageEx license
  LicenseData "license.rtf"
PageExEnd

# Components page allows user to pick the drivers to install.
PageEx components
  ComponentText "Check the board drivers below that you would like to install.  Click install to start the installation." \
    "" "Select board drivers to install:"
PageExEnd

# Instfiles page does the actual installation.
Page instfiles


# Sections define the components (drivers) that can be installed.
# The section name is displayed in the component select screen and if selected
# the code in the section will be executed during the install.
# Note that /o before the name makes the section optional and not selected by default.

# This first section is hidden and always selected so it runs first and bootstraps
# the install by copying all the files and dpinst to the temp folder location.
Section
  # Copy all the drivers and dpinst exes to the temp location.
  SetOutPath $INSTDIR
  File /r "Drivers"
  File "dpinst-x64.exe"
  File "dpinst-x86.exe"
  # Set dpinst variable based on the current OS type (x86/x64).
  ${If} ${RunningX64}
    StrCpy $dpinst "$INSTDIR\dpinst-x64.exe"
  ${Else}
    StrCpy $dpinst "$INSTDIR\dpinst-x86.exe"
  ${EndIf}
SectionEnd

Section "Whoa Board"
  ExecWait '"$dpinst" /sw /path "$INSTDIR\Drivers\FoolishProducts_WhoaBoard"'
SectionEnd
