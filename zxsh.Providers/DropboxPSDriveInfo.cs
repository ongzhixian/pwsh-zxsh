using System;
using System.IO;
using System.Data;
using System.Management.Automation;
using System.Management.Automation.Provider;
using System.ComponentModel;

namespace ZXSH.Providers
{
    /// <summary>
    /// Any state associated with the drive should be held here.
    /// In this case, it's the connection to the database.
    /// </summary>
    internal class DropboxPSDriveInfo : PSDriveInfo
    {
        // private OdbcConnection connection;

        // /// <summary>
        // /// ODBC connection information.
        // /// </summary>
        // public OdbcConnection Connection
        // {
        //     get { return connection; }
        //     set { connection = value; }
        // }

        /// <summary>
        /// Constructor that takes one argument
        /// </summary>
        /// <param name="driveInfo">Drive provided by this provider</param>
        public DropboxPSDriveInfo(PSDriveInfo driveInfo)
            : base(driveInfo)
        { 
            
        }

    } // class DropboxPSDriveInfo

}