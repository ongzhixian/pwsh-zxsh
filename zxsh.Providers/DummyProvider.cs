using System;
using System.Management.Automation;
using System.Management.Automation.Provider;
using System.ComponentModel;
using System.IO;

namespace ZXSH.Providers
{

    [CmdletProvider("SampleProv", ProviderCapabilities.None)]
    public class SampleProvider : CmdletProvider
    {
        string x = "";
    }
}
