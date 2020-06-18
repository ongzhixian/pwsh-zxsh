# dotnet CLI

dotnet sln add DropboxProvider

dotnet add package PowerShellStandard.Library --version 5.1.0

## False starts

dotnet add package Microsoft.PowerShell.SDK --version 7.0.0

  <ItemGroup>
    <Reference Include="System.Management.Automation">
      <HintPath>..\lib\System.Management.Automation.dll</HintPath>
      <Private>true</Private>
    </Reference>
  </ItemGroup>