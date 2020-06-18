using System;
using System.Management.Automation;
using System.Management.Automation.Provider;
using System.ComponentModel;
using System.IO;

namespace ZXSH.Providers
{

    /// <summary>
    /// Simple provider.
    /// </summary>
    [CmdletProvider("DropboxProvider", ProviderCapabilities.None)]
    public class DropboxProvider : DriveCmdletProvider
    {

        /// <summary>
        /// Create a new drive.  Create a connection to the database file and set
        /// the Connection property in the PSDriveInfo.
        /// </summary>
        /// <param name="drive">
        /// Information describing the drive to add.
        /// </param>
        /// <returns>The added drive.</returns>
        protected override PSDriveInfo NewDrive(PSDriveInfo drive)
        {
            // check if drive object is null
            if (drive == null)
            {
                WriteError(new ErrorRecord(
                    new ArgumentNullException("drive"),
                    "NullDrive",
                    ErrorCategory.InvalidArgument,
                    null)
                );

                return null;
            }

            // check if drive root is not null or empty
            // and if its an existing file
            if (String.IsNullOrEmpty(drive.Root) || (File.Exists(drive.Root) == false))
            {
                WriteError(new ErrorRecord(
                    new ArgumentException("drive.Root"),
                    "NoRoot",
                    ErrorCategory.InvalidArgument,
                    drive)
                );

                return null;
            }

            //    // create a new drive and create an ODBC connection to the new drive
            //    AccessDBPSDriveInfo accessDBPSDriveInfo = new AccessDBPSDriveInfo(drive);

            //    OdbcConnectionStringBuilder builder = new OdbcConnectionStringBuilder();

            //    builder.Driver = "Microsoft Access Driver (*.mdb)";
            //    builder.Add("DBQ", drive.Root);

            //    OdbcConnection conn = new OdbcConnection(builder.ConnectionString);
            //    conn.Open();
            //    accessDBPSDriveInfo.Connection = conn;

            //    return accessDBPSDriveInfo;

            DropboxPSDriveInfo psDriveInfo = new DropboxPSDriveInfo(drive);

            return psDriveInfo;

        } // NewDrive


        /// <summary>
        /// Removes a drive from the provider.
        /// </summary>
        /// <param name="drive">The drive to remove.</param>
        /// <returns>The drive removed.</returns>
        protected override PSDriveInfo RemoveDrive(PSDriveInfo drive)
        {
            // check if drive object is null
            if (drive == null)
            {
                WriteError(new ErrorRecord(
                    new ArgumentNullException("drive"),
                    "NullDrive",
                    ErrorCategory.InvalidArgument,
                    drive)
                );

                return null;
            }

            // close ODBC connection to the drive
            DropboxPSDriveInfo psDriveInfo = drive as DropboxPSDriveInfo;

            if (psDriveInfo == null)
            {
                return null;
            }
            //accessDBPSDriveInfo.Connection.Close();

            return psDriveInfo;

        } // RemoveDrive

    }
}
