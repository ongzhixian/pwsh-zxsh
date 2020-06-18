#class Demo : System.Management.Automation.Provider.CmdletProvider {}

class AccessDBPSDriveInfo : System.Management.Automation.PSDriveInfo
{
    [string] $connectionString = $null

    AccessDBPSDriveInfo([System.Management.Automation.PSDriveInfo]$driveInfo) : base($driveInfo) 
    {

    }

    # private OdbcConnection connection;

    # /// <summary>
    # /// ODBC connection information.
    # /// </summary>
    # public OdbcConnection Connection
    # {
    #     get { return connection; }
    #     set { connection = value; }
    # }

    # /// <summary>
    # /// Constructor that takes one argument
    # /// </summary>
    # /// <param name="driveInfo">Drive provided by this provider</param>
    # public AccessDBPSDriveInfo(PSDriveInfo driveInfo)
    #     : base(driveInfo)
    # { }

} # // class AccessDBPSDriveInfo


class AccessDBProvider : System.Management.Automation.Provider.DriveCmdletProvider
{
    [System.Management.Automation.PSDriveInfo] NewDrive([System.Management.Automation.PSDriveInfo] $drive)
    {
        # // check if drive object is null
        # if (drive == null)
        # {
        #     WriteError(new ErrorRecord(
        #         new ArgumentNullException("drive"), 
        #         "NullDrive",
        #         ErrorCategory.InvalidArgument, 
        #         null)
        #     );
        
        #     return null;
        # }
        
        #    // check if drive root is not null or empty
        #    // and if its an existing file
        #        if (String.IsNullOrEmpty(drive.Root) || (File.Exists(drive.Root) == false))
        #        {
        #            WriteError(new ErrorRecord(
        #                new ArgumentException("drive.Root"), 
        #                "NoRoot",
        #                ErrorCategory.InvalidArgument, 
        #                drive)
        #            );
    
        #            return null;
        #        }

        #        // create a new drive and create an ODBC connection to the new drive
        #        AccessDBPSDriveInfo accessDBPSDriveInfo = new AccessDBPSDriveInfo(drive);

        #        OdbcConnectionStringBuilder builder = new OdbcConnectionStringBuilder();

        #        builder.Driver = "Microsoft Access Driver (*.mdb)";
        #        builder.Add("DBQ", drive.Root);
            
        #        OdbcConnection conn = new OdbcConnection(builder.ConnectionString);
        #        conn.Open();
        #        accessDBPSDriveInfo.Connection = conn;

        #        return accessDBPSDriveInfo;

        [AccessDBPSDriveInfo] $psDriveInfo = [AccessDBPSDriveInfo]::new($drive)
        return $psDriveInfo
    } 

    [System.Management.Automation.PSDriveInfo] RemoveDrive([System.Management.Automation.PSDriveInfo] $drive)
    {
        # // check if drive object is null
        # if (drive == null)
        # {
        #     WriteError(new ErrorRecord(
        #         new ArgumentNullException("drive"), 
        #         "NullDrive",
        #         ErrorCategory.InvalidArgument, 
        #         drive)
        #     );

        #    return null;
        # }

        # // close ODBC connection to the drive
        [AccessDBPSDriveInfo] $psDriveInfo = $drive;

        # if (accessDBPSDriveInfo == null)
        # {
        #     return null;
        # }
        # accessDBPSDriveInfo.Connection.Close();
      
        return $psDriveInfo;
    } 

}