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
    public class DropboxProvider : ItemCmdletProvider
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


        protected override void GetItem(string path)
        {
            // check if the path represented is a drive
            if (PathIsDrive(path))
            {
                WriteItemObject(this.PSDriveInfo, path, true);
                return;
            }// if (PathIsDrive...

            // Get table name and row information from the path and do
            // necessary actions
            string tableName;
            int rowNumber;

            PathType type = GetNamesFromPath(path, out tableName, out rowNumber);

            if (type == PathType.Table)
            {
                DatabaseTableInfo table = GetTable(tableName);
                WriteItemObject(table, path, true);
            }
            else if (type == PathType.Row)
            {
                DatabaseRowInfo row = GetRow(tableName, rowNumber);
                WriteItemObject(row, path, false);
            }
            else
            {
                ThrowTerminatingInvalidPathException(path);
            }

        }

        protected override void SetItem(string path, object values)
       {
           // Get type, table name and row number from the path specified
           string tableName;
           int rowNumber;

           PathType type = GetNamesFromPath(path, out tableName, out rowNumber);

           if (type != PathType.Row)
           {
               WriteError(new ErrorRecord(new NotSupportedException(
                     "SetNotSupported"), "",
                  ErrorCategory.InvalidOperation, path));

               return;
           }

           // Get in-memory representation of table
           OdbcDataAdapter da = GetAdapterForTable(tableName);

           if (da == null)
           {
               return;
           }
           DataSet ds = GetDataSetForTable(da, tableName);
           DataTable table = GetDataTable(ds, tableName);

           if (rowNumber >= table.Rows.Count)
           {
               // The specified row number has to be available. If not
               // NewItem has to be used to add a new row
               throw new ArgumentException("Row specified is not available");
           } // if (rowNum...

           string[] colValues = (values as string).Split(',');

           // set the specified row
           DataRow row = table.Rows[rowNumber];

           for (int i = 0; i < colValues.Length; i++)
           {
               row[i] = colValues[i];
           }

           // Update the table
           if (ShouldProcess(path, "SetItem"))
           {
               da.Update(ds, tableName);
           }

       }

       protected override bool ItemExists(string path)
       {
           // check if the path represented is a drive
           if (PathIsDrive(path))
           {
               return true;
           }

           // Obtain type, table name and row number from path
           string tableName;
           int rowNumber;

           PathType type = GetNamesFromPath(path, out tableName, out rowNumber);

           DatabaseTableInfo table = GetTable(tableName);

           if (type == PathType.Table)
           {
               // if specified path represents a table then DatabaseTableInfo
               // object for the same should exist
               if (table != null)
               {
                   return true;
               }
           }
           else if (type == PathType.Row)
           {
               // if specified path represents a row then DatabaseTableInfo should
               // exist for the table and then specified row number must be within
               // the maximum row count in the table
               if (table != null && rowNumber < table.RowCount)
               {
                   return true;
               }
           }

           return false;

       }

       protected override bool IsValidPath(string path)
       {
           bool result = true;

           // check if the path is null or empty
           if (String.IsNullOrEmpty(path))
           {
               result = false;
           }

           // convert all separators in the path to a uniform one
           path = NormalizePath(path);

           // split the path into individual chunks
           string[] pathChunks = path.Split(pathSeparator.ToCharArray());

           foreach (string pathChunk in pathChunks)
           {
               if (pathChunk.Length == 0)
               {
                   result = false;
               }
           }
           return result;
       }
    }
}
