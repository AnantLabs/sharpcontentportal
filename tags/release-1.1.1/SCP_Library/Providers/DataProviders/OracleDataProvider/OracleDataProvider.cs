#region DotNetNuke License
// DotNetNuke® - http://www.dotnetnuke.com
// Copyright (c) 2002-2006
// by DotNetNuke Corporation
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and 
// to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions 
// of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
// TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
#endregion

using System;
using System.Data;
using Oracle.DataAccess.Client;
using System.IO;
using System.Web;
using SharpContent.Common.Utilities;
using SharpContent.Framework.Providers;
using SharpContent.ApplicationBlocks.Data;

namespace SharpContent.Data
{
    public class OracleDataProvider : DataProvider
    {
        private const string ProviderType = "data";

        private ProviderConfiguration _providerConfiguration = ProviderConfiguration.GetProviderConfiguration( ProviderType );
        private string _connectionString;
        private string _providerPath;
        private string _packageName;
        private string _databaseOwner;
        private string _upgradeConnectionString;

        public OracleDataProvider()
        {
            // Read the configuration specific information for this provider
            Provider objProvider = (Provider)_providerConfiguration.Providers[_providerConfiguration.DefaultProvider];

            // Read the attributes for this provider

            //Get Connection string from web.config
            _connectionString = Config.GetConnectionString();

            if( _connectionString == "" )
            {
                // Use connection string specified in provider
                _connectionString = objProvider.Attributes["connectionString"];
            }

            _providerPath = objProvider.Attributes["providerPath"];

            _packageName = "scpuke_pkg.scp_";

            _databaseOwner = objProvider.Attributes["databaseOwner"];
            if( !String.IsNullOrEmpty( _databaseOwner ) && _databaseOwner.EndsWith( "." ) == false )
            {
                _databaseOwner += ".";
            }

            if( Convert.ToString( objProvider.Attributes["upgradeConnectionString"] ) != "" )
            {
                _upgradeConnectionString = objProvider.Attributes["upgradeConnectionString"];
            }
            else
            {
                _upgradeConnectionString = _connectionString;
            }
        }

        public string ConnectionString
        {
            get
            {
                return _connectionString;
            }
        }

        public string ProviderPath
        {
            get
            {
                return _providerPath;
            }
        }

        public string PackageName
        {
            get
            {
                return _packageName;
            }
        }

        public string DatabaseOwner
        {
            get
            {
                return _databaseOwner;
            }
        }

        public string UpgradeConnectionString
        {
            get
            {
                return _upgradeConnectionString;
            }
        }

        private static void ExecuteADOScript( OracleTransaction trans, string SQL )
        {
            //Create a new command (with no timeout)
            OracleCommand command = new OracleCommand(SQL, trans.Connection);
            command.CommandTimeout = 0;
            trans = trans.Connection.BeginTransaction(IsolationLevel.ReadCommitted);
            try
            {
                command.ExecuteNonQuery();
                trans.Commit();
            }
            catch
            {
                trans.Rollback();
            }
        }

        private void ExecuteADOScript( string SQL )
        {
            //Create a new connection            
            OracleConnection connection = new OracleConnection(UpgradeConnectionString);

            //Create a new command (with no timeout)
            OracleCommand command = new OracleCommand(SQL, connection);
            command.CommandTimeout = 0;

            connection.Open();

            command.ExecuteNonQuery();

            connection.Close();
        }

        //Generic Methods
        //===============
        //

        /// <summary>
        /// ExecuteReader executes a stored procedure or "dynamic sql" statement, against
        /// the database
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <param name="ProcedureName">The name of the Stored Procedure to Execute</param>
        /// <param name="commandParameters">An array of parameters to pass to the Database</param>
        /// <history>
        /// 	[cnurse]	12/11/2005	created
        /// </history>
        public override void ExecuteNonQuery( string ProcedureName, params object[] commandParameters )
        {
            OracleHelper.ExecuteNonQuery( ConnectionString, DatabaseOwner + PackageName + ProcedureName, commandParameters );
        }

        public override IDataReader ExecuteReader( string ProcedureName, params object[] commandParameters )
        {
            return OracleHelper.ExecuteReader( ConnectionString, DatabaseOwner + PackageName + ProcedureName, commandParameters );
        }

        public override object ExecuteScalar( string ProcedureName, params object[] commandParameters )
        {
            return OracleHelper.ExecuteScalar( ConnectionString, DatabaseOwner + PackageName + ProcedureName, commandParameters );
        }

        // general
        public override object GetNull( object Field )
        {
            return Null.GetNull( Field, DBNull.Value );
        }

        // upgrade
        public override string GetProviderPath()
        {
            string returnValue;
            HttpContext objHttpContext = HttpContext.Current;

            returnValue = ProviderPath;

            if( !String.IsNullOrEmpty( returnValue ) )
            {
                returnValue = objHttpContext.Server.MapPath( returnValue );

                if( Directory.Exists( returnValue ) )
                {
                    try
                    {
                        // check if database is initialized
                        IDataReader dr = GetDatabaseVersion();
                        dr.Close();
                    }
                    catch
                    {
                        // initialize the database
                        StreamReader objStreamReader;
                        objStreamReader = File.OpenText( returnValue + "00.00.00." + _providerConfiguration.DefaultProvider + ".sql" );
                        string strScript = objStreamReader.ReadToEnd();
                        objStreamReader.Close();

                        string errorMsg = ExecuteScript( strScript );

                        if (!String.IsNullOrEmpty(errorMsg))
                        {
                            returnValue = "ERROR: Could not connect to database specified in connectionString for OracleDataProvider <br /><br />";
                            returnValue += "ERROR MESSAGE: " + errorMsg;
                        }
                    }
                }
                else
                {
                    returnValue = "ERROR: _providerPath folder " + returnValue + " specified for OracleDataProvider does not exist on web server";
                }
            }
            else
            {
                returnValue = "ERROR: _providerPath folder value not specified in web.config for OracleDataProvider";
            }
            return returnValue;
        }

        public override string ExecuteScript( string script )
        {
            return ExecuteScript( script, false );
        }

        public override string ExecuteScript( string script, bool useTransactions )
        {
            string SQL = "";
            string exceptions = "";
            string[] Delimiter = new string[1] {"/" + "\n"};

            script = script.Replace("\r\n", "\n");
            string[] arrSQL = script.Split(Delimiter, StringSplitOptions.RemoveEmptyEntries);

            if( useTransactions )
            {
                OracleConnection Conn = new OracleConnection( UpgradeConnectionString );
                Conn.Open();
                try
                {
                    OracleTransaction trans = Conn.BeginTransaction();

                    foreach (string tempLoopVar_SQL in arrSQL)
                    {
                        SQL = PLSQLFormater(tempLoopVar_SQL);
                        if (!SQL.StartsWith("/*"))
                        {
                            if( SQL.Trim() != "" )
                            {
                                // script dynamic substitution
                                SQL = SQL.Replace( "{databaseOwner}", DatabaseOwner );
                                if (SQL.EndsWith("\n"))
                                {
                                    SQL = SQL.Remove(SQL.LastIndexOf("\n"), 1);
                                }
                                if (SQL.EndsWith("/"))
                                {
                                    SQL = SQL.Remove(SQL.LastIndexOf("/"), 1);
                                }
                                if (SQL.ToUpper().StartsWith("ALTER TABLE") || SQL.ToUpper().StartsWith("CREATE TABLE"))
                                {

                                    SQL = SQL.TrimEnd(new char[] { ';' });
                                }

                                bool ignoreErrors = false;

                                if( SQL.Trim().StartsWith( "{IgnoreError}" ) )
                                {
                                    ignoreErrors = true;
                                    SQL = SQL.Replace( "{IgnoreError}", "" );
                                }

                                try
                                {
                                    ExecuteADOScript( trans, SQL );
                                }
                                catch( OracleException objException )
                                {
                                    if( ! ignoreErrors )
                                    {
                                        exceptions += objException + "\r\n" + "\r\n" + SQL + "\r\n" + "\r\n";
                                    }
                                }
                            }
                        }
                    }
                    if( exceptions.Length == 0 )
                    {
                        //No exceptions so go ahead and commit
                        trans.Commit();
                    }
                    else
                    {
                        //Found exceptions, so rollback db
                        trans.Rollback();
                        exceptions += "SQL Execution failed.  Database was rolled back" + "\r\n" + "\r\n" + SQL + "\r\n" + "\r\n";
                    }
                }
                finally
                {
                    Conn.Close();
                }
            }
            else
            {
                foreach( string tempLoopVar_SQL in arrSQL )
                {
                    SQL = PLSQLFormater(tempLoopVar_SQL);
                    if (!SQL.StartsWith("/*"))
                    {                       
                        if (SQL.Trim() != "")
                        {
                            // script dynamic substitution
                            SQL = SQL.Replace("{databaseOwner}", DatabaseOwner);                            
                            try
                            {
                                ExecuteADOScript(SQL);
                            }
                            catch (OracleException objException)
                            {
                                exceptions += objException + "\r\n" + "\r\n" + SQL + "\r\n" + "\r\n";
                            }
                        }
                    }
                }
            }

            // if the upgrade connection string is specified
            if( UpgradeConnectionString != ConnectionString )
            {
                try
                {
                    // grant execute rights to the public role for all stored procedures. This is
                    // necesary because the UpgradeConnectionString will create stored procedures
                    // which restrict execute permissions for the ConnectionString user account.
                    exceptions += GrantStoredProceduresPermission( "EXECUTE", "public" );
                }
                catch( OracleException objException )
                {
                    exceptions += objException + "\r\n" + "\r\n" + SQL + "\r\n" + "\r\n";
                }
                try
                {
                    // grant execute or select rights to the public role for all user defined functions based
                    // on what type of function it is (scalar function or table function). This is
                    // necesary because the UpgradeConnectionString will create user defined functions
                    // which restrict execute permissions for the ConnectionString user account.
                    exceptions += GrantUserDefinedFunctionsPermission( "EXECUTE", "SELECT", "public" );
                }
                catch( OracleException objException )
                {
                    exceptions += objException + "\r\n" + "\r\n" + SQL + "\r\n" + "\r\n";
                }
            }

            return exceptions;
        }

        private string PLSQLFormater(string plSql)
        {
            string formatedSQL = plSql.Trim();

            if (formatedSQL.EndsWith("\n") || formatedSQL.StartsWith("\n"))
            {
                while(formatedSQL.StartsWith("\n"))
                {
                    formatedSQL = formatedSQL.Remove(0,1);
                }
                while(formatedSQL.EndsWith("\n"))
                {
                    formatedSQL = formatedSQL.Remove(formatedSQL.LastIndexOf("\n"), 1);
                }
            }
            if (formatedSQL.EndsWith("/"))
            {
                formatedSQL = formatedSQL.Remove(formatedSQL.LastIndexOf("/"), 1);
            }
            if (formatedSQL.EndsWith("\n"))
            {                
                while (formatedSQL.EndsWith("\n"))
                {
                    formatedSQL = formatedSQL.Remove(formatedSQL.LastIndexOf("\n"), 1);
                }
            }
            //if (formatedSQL.ToUpper().StartsWith("ALTER TABLE") || 
            //    formatedSQL.ToUpper().StartsWith("CREATE TABLE") ||
            //    formatedSQL.ToUpper().StartsWith("CREATE UNIQUE INDEX") ||
            //    formatedSQL.ToUpper().StartsWith("CREATE INDEX") ||
            //    formatedSQL.ToUpper().StartsWith("CREATE GLOBAL TEMPORARY TABLE") ||
            //    formatedSQL.ToUpper().StartsWith("CREATE TEMPORARY TABLE") ||
            //    formatedSQL.ToUpper().StartsWith("CREATE SEQUENCE"))
            //{

            //    formatedSQL = formatedSQL.TrimEnd(new char[] { ';' });
            //}
            if (!formatedSQL.ToUpper().StartsWith("DECLARE") &&
                !formatedSQL.ToUpper().StartsWith("BEGIN") &&
                !formatedSQL.ToUpper().StartsWith("CREATE OR REPLACE") )
            {

                formatedSQL = formatedSQL.TrimEnd(new char[] { ';' });
            }
            if (formatedSQL.StartsWith("/*"))
            {
                formatedSQL += "*/";
            }

            return formatedSQL;
        }

        // TODO: This needs to be deleted or converted.
        private string GrantStoredProceduresPermission( string Permission, string LoginOrRole )
        {
            string SQL = "";
            string exceptions = "";
            try
            {
                // grant rights to a login or role for all stored procedures
                SQL += "declare @exec nvarchar(2000) ";
                SQL += "declare @name varchar(150) ";
                SQL += "declare sp_cursor cursor for select o.name as name ";
                SQL += "from dbo.sysobjects o ";
                SQL += "where ( OBJECTPROPERTY(o.id, N'IsProcedure') = 1 or OBJECTPROPERTY(o.id, N'IsExtendedProc') = 1 or OBJECTPROPERTY(o.id, N'IsReplProc') = 1 ) ";
                SQL += "and OBJECTPROPERTY(o.id, N'IsMSShipped') = 0 ";
                SQL += "and o.name not like N'#%%' ";
                SQL += "and (left(o.name,len('" + PackageName + "')) = '" + PackageName + "' or left(o.name,7) = 'aspnet_') ";
                SQL += "open sp_cursor ";
                SQL += "fetch sp_cursor into @name ";
                SQL += "while @@fetch_status >= 0 ";
                SQL += "begin";
                SQL += "  select @exec = 'grant " + Permission + " on ' +  @name  + ' to " + LoginOrRole + "'";
                SQL += "  execute (@exec)";
                SQL += "  fetch sp_cursor into @name ";
                SQL += "end ";
                SQL += "deallocate sp_cursor";
                OracleHelper.ExecuteNonQuery( UpgradeConnectionString, CommandType.Text, SQL );
            }
            catch( OracleException objException )
            {
                exceptions += objException + "\r\n" + "\r\n" + SQL + "\r\n" + "\r\n";
            }
            return exceptions;
        }

        // TODO: This needs to be deleted or converted.
        private string GrantUserDefinedFunctionsPermission(string ScalarPermission, string TablePermission, string LoginOrRole)
        {
            string SQL = "";
            string exceptions = "";
            try
            {
                // grant EXECUTE rights to a login or role for all functions
                SQL += "declare @exec nvarchar(2000) ";
                SQL += "declare @name varchar(150) ";
                SQL += "declare @isscalarfunction int ";
                SQL += "declare @istablefunction int ";
                SQL += "declare sp_cursor cursor for select o.name as name, OBJECTPROPERTY(o.id, N'IsScalarFunction') as IsScalarFunction ";
                SQL += "from dbo.sysobjects o ";
                SQL += "where ( OBJECTPROPERTY(o.id, N'IsScalarFunction') = 1 OR OBJECTPROPERTY(o.id, N'IsTableFunction') = 1 ) ";
                SQL += "and OBJECTPROPERTY(o.id, N'IsMSShipped') = 0 ";
                SQL += "and o.name not like N'#%%' ";
                SQL += "and (left(o.name,len('" + PackageName + "')) = '" + PackageName + "' or left(o.name,7) = 'aspnet_') ";
                SQL += "open sp_cursor ";
                SQL += "fetch sp_cursor into @name, @isscalarfunction ";
                SQL += "while @@fetch_status >= 0 ";
                SQL += "begin ";
                SQL += "if @IsScalarFunction = 1 ";
                SQL += "begin";
                SQL += "  select @exec = 'grant " + ScalarPermission + " on ' +  @name  + ' to " + LoginOrRole + "'";
                SQL += "  execute (@exec)";
                SQL += "  fetch sp_cursor into @name, @isscalarfunction  ";
                SQL += "end ";
                SQL += "else ";
                SQL += "begin";
                SQL += "  select @exec = 'grant " + TablePermission + " on ' +  @name  + ' to " + LoginOrRole + "'";
                SQL += "  execute (@exec)";
                SQL += "  fetch sp_cursor into @name, @isscalarfunction  ";
                SQL += "end ";
                SQL += "end ";
                SQL += "deallocate sp_cursor";
                OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.Text, SQL);
            }
            catch (OracleException objException)
            {
                exceptions += objException + "\r\n" + "\r\n" + SQL + "\r\n" + "\r\n";
            }
            return exceptions;
        }

        public override IDataReader ExecuteSQL( string SQL )
        {
            return ExecuteSQL( SQL, null );
        }

        public override IDataReader ExecuteSQL( string SQL, params IDataParameter[] commandParameters )
        {
            OracleParameter[] sqlCommandParameters = null;
            if( commandParameters != null )
            {
                sqlCommandParameters = new OracleParameter[commandParameters.Length];
                for( int intIndex = 0; intIndex < commandParameters.Length; intIndex++ )
                {
                    sqlCommandParameters[intIndex] = (OracleParameter)( commandParameters[intIndex] );
                }
            }

            SQL = SQL.Replace( "{databaseOwner}", DatabaseOwner );
            SQL = SQL.Replace( "{packageName}", PackageName );

            try
            {
                return OracleHelper.ExecuteReader( ConnectionString, CommandType.Text, SQL, sqlCommandParameters );
            }
            catch
            {
                // error in SQL query
                return null;
            }
        }

        public override IDataReader GetFields( string TableName )
        {
            string SQL = "SELECT * FROM {packageName}" + TableName + " WHERE 1 = 0";
            return ExecuteSQL( SQL );
        }
        
        public override int AddAffiliate(int i_vendorid, DateTime i_startdate, DateTime i_enddate, double i_cpc, double i_cpa)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_vendorid", OracleDbType.Int32), 
		      new OracleParameter("i_startdate", OracleDbType.Date), 
		      new OracleParameter("i_enddate", OracleDbType.Date), 
		      new OracleParameter("i_cpc", OracleDbType.Decimal), 
		      new OracleParameter("i_cpa", OracleDbType.Decimal), 
		      new OracleParameter("o_affiliateid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_vendorid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_startdate);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_enddate);
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_cpc;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_cpa;
            parms[5].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDAFFILIATE", parms);
            return Convert.ToInt32(parms[5].Value.ToString());
        }

        public override int AddBanner(string i_bannername, int i_vendorid, string i_imagefile, string i_url, int i_impressions, double i_cpm, DateTime i_startdate, DateTime i_enddate, string i_username, int i_bannertypeid, string i_description, string i_groupname, int i_criteria, int i_width, int i_height)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_bannername", OracleDbType.NVarchar2), 
		      new OracleParameter("i_vendorid", OracleDbType.Int32), 
		      new OracleParameter("i_imagefile", OracleDbType.NVarchar2), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2), 
		      new OracleParameter("i_impressions", OracleDbType.Int32), 
		      new OracleParameter("i_cpm", OracleDbType.Decimal), 
		      new OracleParameter("i_startdate", OracleDbType.Date), 
		      new OracleParameter("i_enddate", OracleDbType.Date), 
		      new OracleParameter("i_username", OracleDbType.NVarchar2), 
		      new OracleParameter("i_bannertypeid", OracleDbType.Int32), 
		      new OracleParameter("i_description", OracleDbType.NVarchar2), 
		      new OracleParameter("i_groupname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_criteria", OracleDbType.Int32), 
		      new OracleParameter("i_width", OracleDbType.Int32), 
		      new OracleParameter("i_height", OracleDbType.Int32), 
		      new OracleParameter("o_bannerid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_bannername;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_vendorid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_imagefile;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_url;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_impressions;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_cpm;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = GetNull(i_startdate);
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = GetNull(i_enddate);
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_username;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_bannertypeid;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_description;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = i_groupname;
            parms[12].Direction = ParameterDirection.Input;
            parms[12].Value = i_criteria;
            parms[13].Direction = ParameterDirection.Input;
            parms[13].Value = i_width;
            parms[14].Direction = ParameterDirection.Input;
            parms[14].Value = i_height;
            parms[15].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDBANNER", parms);
            return Convert.ToInt32(parms[15].Value.ToString());
        }

        public override int AddDesktopModule(string i_modulename, string i_foldername, string i_friendlyname, string i_description, string i_version, bool i_ispremium, bool i_isadmin, string i_businesscontroller, int i_supportedfeatures, string i_compatibleversions)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_modulename", OracleDbType.NVarchar2), 
		      new OracleParameter("i_foldername", OracleDbType.NVarchar2), 
		      new OracleParameter("i_friendlyname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_description", OracleDbType.NVarchar2), 
		      new OracleParameter("i_version", OracleDbType.NVarchar2), 
		      new OracleParameter("i_ispremium", OracleDbType.Int32), 
		      new OracleParameter("i_isadmin", OracleDbType.Int32), 
		      new OracleParameter("i_businesscontroller", OracleDbType.NVarchar2), 
		      new OracleParameter("i_supportedfeatures", OracleDbType.Int32), 
		      new OracleParameter("i_compatibleversions", OracleDbType.NVarchar2), 
		      new OracleParameter("o_desktopmoduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_modulename;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_foldername;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_friendlyname;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_description;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_version;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_ispremium ? 1 : 0;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_isadmin ? 1 : 0;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_businesscontroller;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_supportedfeatures;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_compatibleversions;
            parms[10].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDDESKTOPMODULE", parms);
            return Convert.ToInt32(parms[10].Value.ToString());
        }

        public override int AddFile(int i_portalid, string i_filename, string i_extension, long i_size, int i_width, int i_height, string i_contenttype, string i_folder, int i_folderid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_filename", OracleDbType.NVarchar2), 
		      new OracleParameter("i_extension", OracleDbType.NVarchar2), 
		      new OracleParameter("i_size", OracleDbType.Int32), 
		      new OracleParameter("i_width", OracleDbType.Int32), 
		      new OracleParameter("i_height", OracleDbType.Int32), 
		      new OracleParameter("i_contenttype", OracleDbType.NVarchar2), 
		      new OracleParameter("i_folder", OracleDbType.NVarchar2), 
		      new OracleParameter("i_folderid", OracleDbType.Int32), 
		      new OracleParameter("o_fileid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_filename;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_extension;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_size;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_width;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_height;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_contenttype;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_folder;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_folderid;
            parms[9].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDFILE", parms);
            return Convert.ToInt32(parms[9].Value.ToString());
        }

        public override int AddFolder(int i_portalid, string i_folderpath, int i_storagelocation, bool i_isprotected, bool i_iscached, DateTime i_lastupdated)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_folderpath", OracleDbType.NVarchar2), 
		      new OracleParameter("i_storagelocation", OracleDbType.Int32), 
		      new OracleParameter("i_isprotected", OracleDbType.Int32), 
		      new OracleParameter("i_iscached", OracleDbType.Int32), 
		      new OracleParameter("i_lastupdated", OracleDbType.Date), 
		      new OracleParameter("o_folderid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_folderpath;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_storagelocation;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_isprotected ? 1 : 0;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_iscached ? 1 : 0;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = GetNull(i_lastupdated);
            parms[6].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDFOLDER", parms);
            return Convert.ToInt32(parms[6].Value.ToString());
        }

        public override int AddFolderPermission(int i_folderid, int i_permissionid, int i_roleid, bool i_allowaccess)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_folderid", OracleDbType.Int32), 
		      new OracleParameter("i_permissionid", OracleDbType.Int32), 
		      new OracleParameter("i_roleid", OracleDbType.Int32), 
		      new OracleParameter("i_allowaccess", OracleDbType.Int32), 
		      new OracleParameter("o_folderpermissionid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_folderid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_permissionid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_roleid;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_allowaccess ? 1 : 0;
            parms[4].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDFOLDERPERMISSION", parms);
            return Convert.ToInt32(parms[4].Value.ToString());
        }
        
        public override void AddHostSetting(string i_settingname, string i_settingvalue, bool i_settingissecure)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_settingname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_settingvalue", OracleDbType.NVarchar2), 
		      new OracleParameter("i_settingissecure", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_settingname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_settingvalue;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_settingissecure ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDHOSTSETTING", parms);
        }

        public override int AddListEntry(string i_listname, string i_value, string i_text, string i_parentkey, bool i_enablesortorder, int i_definitionid, string i_description)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_listname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_value", OracleDbType.NVarchar2), 
		      new OracleParameter("i_text", OracleDbType.NVarchar2), 
		      new OracleParameter("i_parentkey", OracleDbType.NVarchar2), 
		      new OracleParameter("i_enablesortorder", OracleDbType.Int32), 
		      new OracleParameter("i_definitionid", OracleDbType.Int32), 
		      new OracleParameter("i_description", OracleDbType.NVarchar2), 
		      new OracleParameter("o_entryid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_listname;
            parms[1].Direction = ParameterDirection.Input;
            // We need to pass in a single space for value if it is an empty stringbecause a unique 
            // record is made by the combination of listname and value.  Oracle handles enpty strings 
            // as null values and saves them that way.  A null value can not be used as a unique 
            // constaint hence why we are passing in a single space.  This will have to be handled on 
            // the return in the code.
            parms[1].Value = i_value;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_text;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_parentkey;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_enablesortorder ? 1 : 0;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_definitionid;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_description;
            parms[7].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDLISTENTRY", parms);
            return Convert.ToInt32(parms[7].Value.ToString());
        }

        public override int AddModule(int i_portalid, int i_moduledefid, string i_moduletitle, bool i_alltabs, string i_header, string i_footer, DateTime i_startdate, DateTime i_enddate, bool i_inheritviewpermissions, bool i_isdeleted)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_moduledefid", OracleDbType.Int32), 
		      new OracleParameter("i_moduletitle", OracleDbType.NVarchar2), 
		      new OracleParameter("i_alltabs", OracleDbType.Int32), 
		      new OracleParameter("i_header", OracleDbType.NClob), 
		      new OracleParameter("i_footer", OracleDbType.NClob), 
		      new OracleParameter("i_startdate", OracleDbType.Date), 
		      new OracleParameter("i_enddate", OracleDbType.Date), 
		      new OracleParameter("i_inheritviewpermissions", OracleDbType.Int32), 
		      new OracleParameter("i_isdeleted", OracleDbType.Int32), 
		      new OracleParameter("o_moduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_moduledefid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_moduletitle;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_alltabs ? 1 : 0;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = GetNull(i_header);
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = GetNull(i_footer);
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = GetNull(i_startdate);
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = GetNull(i_enddate);
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_inheritviewpermissions ? 1 : 0;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_isdeleted ? 1 : 0;
            parms[10].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDMODULE", parms);
            return Convert.ToInt32(parms[10].Value.ToString());
        }

        public override int AddModuleControl(int i_moduledefid, string i_controlkey, string i_controltitle, string i_controlsrc, string i_iconfile, int i_controltype, int i_vieworder, string i_helpurl)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduledefid", OracleDbType.Int32), 
		      new OracleParameter("i_controlkey", OracleDbType.NVarchar2), 
		      new OracleParameter("i_controltitle", OracleDbType.NVarchar2), 
		      new OracleParameter("i_controlsrc", OracleDbType.NVarchar2), 
		      new OracleParameter("i_iconfile", OracleDbType.NVarchar2), 
		      new OracleParameter("i_controltype", OracleDbType.Int32), 
		      new OracleParameter("i_vieworder", OracleDbType.Int32), 
		      new OracleParameter("i_helpurl", OracleDbType.NVarchar2), 
		      new OracleParameter("o_modulecontrolid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_moduledefid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_controlkey);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_controltitle);
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_controlsrc;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = GetNull(i_iconfile);
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_controltype;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = GetNull(i_vieworder);
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = GetNull(i_helpurl);
            parms[8].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDMODULECONTROL", parms);
                return Convert.ToInt32(parms[8].Value.ToString());
            }
            catch
            {
                return -1;
            }
        }

        public override int AddModuleDefinition(int i_desktopmoduleid, string i_friendlyname, int i_defaultcachetime)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_desktopmoduleid", OracleDbType.Int32), 
		      new OracleParameter("i_friendlyname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_defaultcachetime", OracleDbType.Int32), 
		      new OracleParameter("o_moduledefid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_desktopmoduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_friendlyname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_defaultcachetime;
            parms[3].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDMODULEDEFINITION", parms);
            return Convert.ToInt32(parms[3].Value.ToString());
        }
        
        public override int AddModulePermission(int i_moduleid, int i_permissionid, int i_roleid, bool i_allowaccess)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_permissionid", OracleDbType.Int32), 
		      new OracleParameter("i_roleid", OracleDbType.Int32), 
		      new OracleParameter("i_allowaccess", OracleDbType.Int32), 
		      new OracleParameter("o_modulepermissionid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_permissionid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_roleid;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_allowaccess ? 1 : 0;
            parms[4].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDMODULEPERMISSION", parms);
            return Convert.ToInt32(parms[4].Value.ToString());
        }

        public override void AddModuleSetting(int i_moduleid, string i_settingname, string i_settingvalue)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_settingname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_settingvalue", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_settingname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_settingvalue;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDMODULESETTING", parms);
        }

        public override int AddPermission(string i_permissioncode, int i_moduledefid, string i_permissionkey, string i_permissionname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduledefid", OracleDbType.Int32), 
		      new OracleParameter("i_permissioncode", OracleDbType.NVarchar2), 
		      new OracleParameter("i_permissionkey", OracleDbType.NVarchar2), 
		      new OracleParameter("i_permissionname", OracleDbType.NVarchar2), 
		      new OracleParameter("o_permissionid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduledefid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_permissioncode;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_permissionkey;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_permissionname;
            parms[4].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDPERMISSION", parms);
            return Convert.ToInt32(parms[4].Value.ToString());
        }

        public override int AddPortalAlias(int i_portalid, string i_httpalias)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_httpalias", OracleDbType.NVarchar2), 
		      new OracleParameter("o_portalaliasid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_httpalias;
            parms[2].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDPORTALALIAS", parms);
            return Convert.ToInt32(parms[2].Value.ToString());
        }

        public override int AddPortalDesktopModule(int i_portalid, int i_desktopmoduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_desktopmoduleid", OracleDbType.Int32), 
		      new OracleParameter("o_portaldesktopmoduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_desktopmoduleid;
            parms[2].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDPORTALDESKTOPMODULE", parms);
            return Convert.ToInt32(parms[2].Value.ToString());
        }
        
        public override int AddPortalInfo(string i_portalname, string i_currency, string i_firstname, string i_lastname, string i_username, string i_password, string i_email, DateTime i_expirydate, double i_hostfee, double i_hostspace, int i_pagequota, int i_userquota, int i_siteloghistory, string i_homedirectory)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_currency", OracleDbType.Char), 
		      new OracleParameter("i_expirydate", OracleDbType.Date), 
		      new OracleParameter("i_hostfee", OracleDbType.Int32), 
		      new OracleParameter("i_hostspace", OracleDbType.Int32), 
		      new OracleParameter("i_pagequota", OracleDbType.Int32), 
		      new OracleParameter("i_userquota", OracleDbType.Int32), 
		      new OracleParameter("i_siteloghistory", OracleDbType.Int32), 
		      new OracleParameter("i_homedirectory", OracleDbType.NVarchar2), 
		      new OracleParameter("o_portalid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_portalname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_currency;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_expirydate);
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_hostfee;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_hostspace;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_pagequota;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_userquota;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_siteloghistory;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_homedirectory;
            parms[9].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDPORTALINFO", parms);
            return Convert.ToInt32(parms[9].Value.ToString());
        }

        public override void AddProfile(int i_userid, int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_userid", OracleDbType.Int32), 
		      new OracleParameter("i_portalid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_userid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDPROFILE", parms);
        }

        public override int AddPropertyDefinition(int i_portalid, int i_moduledefid, int i_datatype, string i_defaultvalue, string i_propertycategory, string i_propertyname, bool i_required, string i_validationexpression, int i_vieworder, bool i_visible, int i_length, bool i_searchable)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_moduledefid", OracleDbType.Int32), 
		      new OracleParameter("i_datatype", OracleDbType.Int32), 
		      new OracleParameter("i_defaultvalue", OracleDbType.NVarchar2), 
		      new OracleParameter("i_propertycategory", OracleDbType.NVarchar2), 
		      new OracleParameter("i_propertyname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_required", OracleDbType.Int32), 
		      new OracleParameter("i_validationexpression", OracleDbType.NVarchar2), 
		      new OracleParameter("i_vieworder", OracleDbType.Int32), 
		      new OracleParameter("i_visible", OracleDbType.Int32), 
		      new OracleParameter("i_length", OracleDbType.Int32), 
		      new OracleParameter("i_searchable", OracleDbType.Int32),
		      new OracleParameter("o_propertydefinitionid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_moduledefid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_datatype;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_defaultvalue;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_propertycategory;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_propertyname;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_required ? 1 : 0;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_validationexpression;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_vieworder;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_visible ? 1 : 0;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_length;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = i_visible ? 1 : 0;
            parms[12].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDPROPERTYDEFINITION", parms);
            return Convert.ToInt32(parms[12].Value.ToString());
        }                
        
        public override int AddSearchItem(string i_title, string i_description, int i_author, DateTime i_pubdate, int i_moduleid, string i_searchkey, string i_guid, int i_imagefileid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_title", OracleDbType.NVarchar2), 
		      new OracleParameter("i_description", OracleDbType.NVarchar2), 
		      new OracleParameter("i_author", OracleDbType.Int32), 
		      new OracleParameter("i_pubdate", OracleDbType.Date), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_searchkey", OracleDbType.NVarchar2), 
		      new OracleParameter("i_guid", OracleDbType.NVarchar2), 
		      new OracleParameter("i_imagefileid", OracleDbType.Int32), 
		      new OracleParameter("o_searchitemid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_title;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_description;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_author);
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = GetNull(i_pubdate);
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_moduleid;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_searchkey;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_guid;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_imagefileid;
            parms[8].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDSEARCHITEM", parms);
            return Convert.ToInt32(parms[8].Value.ToString());
        }

        public override int AddSearchItemWord(int i_searchitemid, int i_searchwordsid, int i_occurrences)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_searchitemid", OracleDbType.Int32), 
		      new OracleParameter("i_searchwordsid", OracleDbType.Int32), 
		      new OracleParameter("i_occurrences", OracleDbType.Int32), 
		      new OracleParameter("o_searchitemwordid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_searchitemid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_searchwordsid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_occurrences;
            parms[3].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDSEARCHITEMWORD", parms);
            return Convert.ToInt32(parms[3].Value.ToString());
        }

        public override void AddSearchItemWordPosition(int i_searchitemwordid, string i_contentpositions)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_searchitemwordid", OracleDbType.Int32), 
		      new OracleParameter("i_contentpositions", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_searchitemwordid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_contentpositions;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDSEARCHITEMWORDPOSITION", parms);
        }

        public override int AddSearchWord(string i_word)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_word", OracleDbType.NVarchar2), 
		      new OracleParameter("o_searchwordsid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_word;
            parms[1].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDSEARCHWORD", parms);
            return Convert.ToInt32(parms[1].Value.ToString());
        }

        public override void AddSiteLog(DateTime i_datetime, int i_portalid, int i_userid, string i_referrer, string i_url, string i_useragent, string i_userhostaddress, string i_userhostname, int i_tabid, int i_affiliateid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_datetime", OracleDbType.Date), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_userid", OracleDbType.Int32), 
		      new OracleParameter("i_referrer", OracleDbType.NVarchar2), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2), 
		      new OracleParameter("i_useragent", OracleDbType.NVarchar2), 
		      new OracleParameter("i_userhostaddress", OracleDbType.NVarchar2), 
		      new OracleParameter("i_userhostname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_affiliateid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_datetime);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_userid;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_referrer;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_url;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_useragent;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_userhostaddress;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_userhostname;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_tabid;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_affiliateid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDSITELOG", parms);
        }

        public override int AddSkin(string i_skinroot, int i_portalid, int i_skintype, string i_skinsrc)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_skinroot", OracleDbType.NVarchar2), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_skintype", OracleDbType.Int32), 
		      new OracleParameter("i_skinsrc", OracleDbType.NVarchar2), 
		      new OracleParameter("o_skinid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_skinroot;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_skintype;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_skinsrc;
            parms[4].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDSKIN", parms);
            return Convert.ToInt32(parms[4].Value.ToString());
        }
       
        public override int AddTab(int i_portalid, string i_tabname, bool i_isvisible, bool i_disablelink, int i_parentid, string i_iconfile, string i_title, string i_description, string i_keywords, string i_url, string i_skinsrc, string i_containersrc, string i_tabpath, DateTime i_startdate, DateTime i_enddate, int i_refreshinterval, string i_pageheadtext)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_tabname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_isvisible", OracleDbType.Int32), 
		      new OracleParameter("i_disablelink", OracleDbType.Int32), 
		      new OracleParameter("i_parentid", OracleDbType.Int32), 
		      new OracleParameter("i_iconfile", OracleDbType.NVarchar2), 
		      new OracleParameter("i_title", OracleDbType.NVarchar2), 
		      new OracleParameter("i_description", OracleDbType.NVarchar2), 
		      new OracleParameter("i_keywords", OracleDbType.NVarchar2), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2), 
		      new OracleParameter("i_skinsrc", OracleDbType.NVarchar2), 
		      new OracleParameter("i_containersrc", OracleDbType.NVarchar2), 
		      new OracleParameter("i_tabpath", OracleDbType.NVarchar2), 
		      new OracleParameter("i_startdate", OracleDbType.Date), 
		      new OracleParameter("i_enddate", OracleDbType.Date), 
		      new OracleParameter("i_refreshinterval", OracleDbType.Int32), 
		      new OracleParameter("i_pageheadtext", OracleDbType.NVarchar2), 
		      new OracleParameter("o_tabid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_tabname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_isvisible ? 1 : 0;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_disablelink ? 1 : 0;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = GetNull(i_parentid);
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_iconfile;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_title;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_description;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_keywords;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_url;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_skinsrc;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = i_containersrc;
            parms[12].Direction = ParameterDirection.Input;
            parms[12].Value = i_tabpath;
            parms[13].Direction = ParameterDirection.Input;
            parms[13].Value = GetNull(i_startdate);
            parms[14].Direction = ParameterDirection.Input;
            parms[14].Value = GetNull(i_enddate);
            parms[15].Direction = ParameterDirection.Input;
            parms[15].Value = GetNull(i_refreshinterval);
            parms[16].Direction = ParameterDirection.Input;
            parms[16].Value = i_pageheadtext;
            parms[17].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDTAB", parms);
            return Convert.ToInt32(parms[17].Value.ToString());
        }

        public override void AddTabModule(int i_tabid, int i_moduleid, int i_moduleorder, string i_panename, int i_cachetime, string i_alignment, string i_color, string i_border, string i_iconfile, int i_visibility, string i_containersrc, bool i_displaytitle, bool i_displayprint, bool i_displaysyndicate)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_moduleorder", OracleDbType.Int32), 
		      new OracleParameter("i_panename", OracleDbType.NVarchar2), 
		      new OracleParameter("i_cachetime", OracleDbType.Int32), 
		      new OracleParameter("i_alignment", OracleDbType.NVarchar2), 
		      new OracleParameter("i_color", OracleDbType.NVarchar2), 
		      new OracleParameter("i_border", OracleDbType.NVarchar2), 
		      new OracleParameter("i_iconfile", OracleDbType.NVarchar2), 
		      new OracleParameter("i_visibility", OracleDbType.Int32), 
		      new OracleParameter("i_containersrc", OracleDbType.NVarchar2), 
		      new OracleParameter("i_displaytitle", OracleDbType.Int32), 
		      new OracleParameter("i_displayprint", OracleDbType.Int32), 
		      new OracleParameter("i_displaysyndicate", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_moduleid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_moduleorder;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_panename;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_cachetime;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_alignment;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_color;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_border;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_iconfile;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_visibility;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_containersrc;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = i_displaytitle ? 1 : 0;
            parms[12].Direction = ParameterDirection.Input;
            parms[12].Value = i_displayprint ? 1 : 0;
            parms[13].Direction = ParameterDirection.Input;
            parms[13].Value = i_displaysyndicate ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDTABMODULE", parms);
        }

        public override void AddTabModuleSetting(int i_tabmoduleid, string i_settingname, string i_settingvalue)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabmoduleid", OracleDbType.Int32), 
		      new OracleParameter("i_settingname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_settingvalue", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabmoduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_settingname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_settingvalue;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDTABMODULESETTING", parms);
        }
        
        public override int AddTabPermission(int i_tabid, int i_permissionid, int i_roleid, bool i_allowaccess)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_permissionid", OracleDbType.Int32), 
		      new OracleParameter("i_roleid", OracleDbType.Int32), 
		      new OracleParameter("i_allowaccess", OracleDbType.Int32), 
		      new OracleParameter("o_tabpermissionid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_permissionid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_roleid;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_allowaccess ? 1 : 0;
            parms[4].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDTABPERMISSION", parms);
            return Convert.ToInt32(parms[4].Value.ToString());
        }

        public override void AddUrl(int i_portalid, string i_url)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_url;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDURL", parms);
        }

        public override void AddUrlLog(int i_urltrackingid, int i_userid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_urltrackingid", OracleDbType.Int32), 
		      new OracleParameter("i_userid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_urltrackingid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_userid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDURLLOG", parms);
        }

        public override void AddUrlTracking(int i_portalid, string i_url, string i_urltype, bool i_logactivity, bool i_trackclicks, int i_moduleid, bool i_newwindow)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2), 
		      new OracleParameter("i_urltype", OracleDbType.Char), 
		      new OracleParameter("i_logactivity", OracleDbType.Int32), 
		      new OracleParameter("i_trackclicks", OracleDbType.Int32), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_newwindow", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_url;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_urltype;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_logactivity ? 1 : 0;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_trackclicks ? 1 : 0;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_moduleid;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_newwindow ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDURLTRACKING", parms);
        }
        
        public override int AddVendor(int i_portalid, string i_vendorname, string i_unit, string i_street, string i_city, string i_region, string i_country, string i_postalcode, string i_telephone, string i_fax, string i_cell, string i_email, string i_website, string i_firstname, string i_lastname, string i_username, string i_logofile, string i_keywords, string i_authorized)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_vendorname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_unit", OracleDbType.NVarchar2), 
		      new OracleParameter("i_street", OracleDbType.NVarchar2), 
		      new OracleParameter("i_city", OracleDbType.NVarchar2), 
		      new OracleParameter("i_region", OracleDbType.NVarchar2), 
		      new OracleParameter("i_country", OracleDbType.NVarchar2), 
		      new OracleParameter("i_postalcode", OracleDbType.NVarchar2), 
		      new OracleParameter("i_telephone", OracleDbType.NVarchar2), 
		      new OracleParameter("i_fax", OracleDbType.NVarchar2), 
		      new OracleParameter("i_cell", OracleDbType.NVarchar2), 
		      new OracleParameter("i_email", OracleDbType.NVarchar2), 
		      new OracleParameter("i_website", OracleDbType.NVarchar2), 
		      new OracleParameter("i_firstname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_lastname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_username", OracleDbType.NVarchar2), 
		      new OracleParameter("i_logofile", OracleDbType.NVarchar2), 
		      new OracleParameter("i_keywords", OracleDbType.Clob), 
		      new OracleParameter("i_authorized", OracleDbType.Int32), 
		      new OracleParameter("o_vendorid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_vendorname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_unit;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_street;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_city;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_region;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_country;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_postalcode;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_telephone;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_fax;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_cell;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = i_email;
            parms[12].Direction = ParameterDirection.Input;
            parms[12].Value = i_website;
            parms[13].Direction = ParameterDirection.Input;
            parms[13].Value = i_firstname;
            parms[14].Direction = ParameterDirection.Input;
            parms[14].Value = i_lastname;
            parms[15].Direction = ParameterDirection.Input;
            parms[15].Value = i_username;
            parms[16].Direction = ParameterDirection.Input;
            parms[16].Value = i_logofile;
            parms[17].Direction = ParameterDirection.Input;
            parms[17].Value = i_keywords;
            parms[18].Direction = ParameterDirection.Input;
            parms[18].Value = bool.Parse(i_authorized);
            parms[19].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDVENDOR", parms);
            return Convert.ToInt32(parms[19].Value.ToString());
        }

        public override int AddVendorClassification(int i_vendorid, int i_classificationid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_vendorid", OracleDbType.Int32), 
		      new OracleParameter("i_classificationid", OracleDbType.Int32), 
		      new OracleParameter("o_vendorclassificationid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_vendorid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_classificationid;
            parms[2].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDVENDORCLASSIFICATION", parms);
            return Convert.ToInt32(parms[2].Value.ToString());
        }

        public override int CreatePortal(string i_portalname, string i_currency, DateTime i_expirydate, double i_hostfee, double i_hostspace, int i_pagequota, int i_userquota, int i_siteloghistory, string i_homedirectory)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_currency", OracleDbType.Char), 
		      new OracleParameter("i_expirydate", OracleDbType.Date), 
		      new OracleParameter("i_hostfee", OracleDbType.Double), 
		      new OracleParameter("i_hostspace", OracleDbType.Double), 
		      new OracleParameter("i_pagequota", OracleDbType.Int32), 
		      new OracleParameter("i_userquota", OracleDbType.Int32), 
		      new OracleParameter("i_siteloghistory", OracleDbType.Int32), 
		      new OracleParameter("i_homedirectory", OracleDbType.NVarchar2), 
		      new OracleParameter("o_portalid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_portalname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_currency;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_expirydate);
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_hostfee;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_hostspace;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_pagequota;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_userquota;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_siteloghistory;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_homedirectory;
            parms[9].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDPORTALINFO", parms);
            return Convert.ToInt32(parms[9].Value.ToString());
        }


        public override void DeleteAffiliate(int i_affiliateid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_affiliateid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_affiliateid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEAFFILIATE", parms);
        }

        public override void DeleteBanner(int i_bannerid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_bannerid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_bannerid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEBANNER", parms);
        }

        public override void DeleteDesktopModule(int i_desktopmoduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_desktopmoduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_desktopmoduleid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEDESKTOPMODULE", parms);
        }
                
        public override void DeleteFile(int i_portalid, string i_filename, int i_folderid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_filename", OracleDbType.NVarchar2), 
		      new OracleParameter("i_folderid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_filename;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_folderid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEFILE", parms);
        }

        public override void DeleteFiles(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEFILES", parms);
        }

        public override void DeleteFolder(int i_portalid, string i_folderpath)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_folderpath", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_folderpath;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEFOLDER", parms);
        }

        public override void DeleteFolderPermission(int i_folderpermissionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_folderpermissionid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_folderpermissionid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEFOLDERPERMISSION", parms);
        }

        public override void DeleteFolderPermissionsByFolderPath(int i_portalid, string i_folderpath)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_folderpath", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_folderpath;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELFOLDERPERMSBYPATH", parms);
        }

        public override void DeleteList(string i_listname, string i_parentkey)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_listname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_parentkey", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_listname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_parentkey;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETELIST", parms);
        }

        public override void DeleteListEntryByID(int i_entryid, bool i_deletechild)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_entryid", OracleDbType.Int32), 
		      new OracleParameter("i_deletechild", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_entryid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_deletechild ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETELISTENTRYBYID", parms);
        }

        public override void DeleteListEntryByListName(string i_listname, string i_value, bool i_deletechild)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override void DeleteModule(int i_moduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEMODULE", parms);
        }

        public override void DeleteModuleControl(int i_modulecontrolid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_modulecontrolid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_modulecontrolid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEMODULECONTROL", parms);
        }

        public override void DeleteModuleDefinition(int i_moduledefid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduledefid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduledefid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEMODULEDEFINITION", parms);
        }

        public override void DeleteModulePermission(int i_modulepermissionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_modulepermissionid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_modulepermissionid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEMODULEPERMISSION", parms);
        }

        public override void DeleteModulePermissionsByModuleID(int i_moduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELMODPERMSBYMODID", parms);
        }

        public override void DeleteModuleSetting(int i_moduleid, string i_settingname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_settingname", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_settingname;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEMODULESETTING", parms);
        }

        public override void DeleteModuleSettings(int i_moduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEMODULESETTINGS", parms);
        }

        public override void DeletePermission(int i_permissionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_permissionid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_permissionid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEPERMISSION", parms);
        }

        public override void DeletePortalAlias(int i_portalaliasid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalaliasid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_portalaliasid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEPORTALALIAS", parms);
        }

        public override void DeletePortalDesktopModules(int i_portalid, int i_desktopmoduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_desktopmoduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_desktopmoduleid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEPORTALDESKTOPMODULE", parms);
        }

        public override void DeletePortalInfo(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEPORTALINFO", parms);
        }

        public override void DeletePropertyDefinition(int i_propertydefinitionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_propertydefinitionid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_propertydefinitionid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEPROPERTYDEFINITION", parms);
        }       
        
        public override void DeleteSearchItem(int i_searchitemid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_searchitemid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_searchitemid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETESEARCHITEM", parms);
        }

        public override void DeleteSearchItems(int i_moduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETESEARCHITEMS", parms);
        }

        public override void DeleteSearchItemWords(int i_searchitemid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_searchitemid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_searchitemid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETESEARCHITEMWORDS", parms);
        }

        public override void DeleteSiteLog(DateTime i_datetime, int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_datetime", OracleDbType.Date), 
		      new OracleParameter("i_portalid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_datetime);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETESITELOG", parms);
        }

        public override void DeleteSkin(string i_skinroot, int i_portalid, int i_skintype)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_skinroot", OracleDbType.NVarchar2), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_skintype", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_skinroot;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_skintype;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETESKIN", parms);
        }

        public override void DeleteTab(int i_tabid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETETAB", parms);
        }

        public override void DeleteTabModule(int i_tabid, int i_moduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_moduleid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETETABMODULE", parms);
        }

        public override void DeleteTabModuleSetting(int i_tabmoduleid, string i_settingname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabmoduleid", OracleDbType.Int32), 
		      new OracleParameter("i_settingname", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabmoduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_settingname;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETETABMODULESETTING", parms);
        }

        public override void DeleteTabModuleSettings(int i_tabmoduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabmoduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabmoduleid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETETABMODULESETTINGS", parms);
        }

        public override void DeleteTabPermission(int i_tabpermissionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabpermissionid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabpermissionid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETETABPERMISSION", parms);
        }

        public override void DeleteTabPermissionsByTabID(int i_tabid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETETABPERMISSIONSBYTAB", parms);
        }

        public override void DeleteUrl(int i_portalid, string i_url)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_url;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEURL", parms);
        }

        public override void DeleteUrlTracking(int i_portalid, string i_url, int i_moduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_url;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_moduleid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEURLTRACKING", parms);
        }

        public override void DeleteVendor(int i_vendorid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_vendorid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_vendorid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEVENDOR", parms);
        }

        public override void DeleteVendorClassifications(int i_vendorid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_vendorid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_vendorid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELVENDORCLASSIFICATIONS", parms);
        }

        public override IDataReader FindBanners(int i_portalid, int i_bannertypeid, string i_groupname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_bannertypeid", OracleDbType.Int32), 
		      new OracleParameter("i_groupname", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_bannertypeid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_groupname;
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "FINDBANNERS", parms);
        }

        public override IDataReader FindDatabaseVersion(int i_major, int i_minor, int i_build)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_major", OracleDbType.Int32), 
		      new OracleParameter("i_minor", OracleDbType.Int32), 
		      new OracleParameter("i_build", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_major;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_minor;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_build;
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "FINDDATABASEVERSION", parms);
        }

        public override IDataReader GetAffiliate(int i_affiliateid, int i_vendorid, int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_affiliateid", OracleDbType.Int32), 
		      new OracleParameter("i_vendorid", OracleDbType.Int32), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_affiliateid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_vendorid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_portalid);
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETAFFILIATE", parms);
        }

        public override IDataReader GetAffiliates(int i_vendorid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_vendorid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_vendorid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETAFFILIATES", parms);
        }

        public override DataTable GetAllFiles()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteDataset(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETALLFILES", parms).Tables[0];

        }

        public override IDataReader GetAllModules()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETALLMODULES", parms);
        }

        public override IDataReader GetAllProfiles()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETALLPROFILES", parms);
        }

        public override IDataReader GetAllTabs()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETALLTABS", parms);
        }
        
        public override IDataReader GetAllTabsModules(int i_portalid, bool i_alltabs)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_alltabs", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_alltabs ? 1 : 0;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETALLTABSMODULES", parms);
        }

        public override IDataReader GetBanner(int i_bannerid, int i_vendorid, int i_portalid)
        {
	       OracleParameter[] parms = {
		      new OracleParameter("i_bannerid", OracleDbType.Int32), 
		      new OracleParameter("i_vendorid", OracleDbType.Int32), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
	       parms[0].Direction = ParameterDirection.Input;
	       parms[0].Value = i_bannerid;
	       parms[1].Direction = ParameterDirection.Input;
	       parms[1].Value = i_vendorid;
	       parms[2].Direction = ParameterDirection.Input;
	       parms[2].Value = GetNull(i_portalid);
	       parms[3].Direction = ParameterDirection.Output;

	       return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETBANNER", parms);
        }

        public override DataTable GetBannerGroups(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteDataset(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETBANNERGROUPS", parms).Tables[0];
        }

        public override IDataReader GetBanners(int i_vendorid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_vendorid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_vendorid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETBANNERS", parms);
        }
        
        public override IDataReader GetDatabaseVersion()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETDATABASEVERSION", parms);
        }

        public override IDataReader GetDefaultLanguageByModule(string i_modulelist)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_modulelist", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_modulelist;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETDEFAULTLANGUAGEBYMOD", parms);
        }

        public override IDataReader GetDesktopModule(int i_desktopmoduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_desktopmoduleid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_desktopmoduleid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETDESKTOPMODULE", parms);
        }

        public override IDataReader GetDesktopModuleByModuleName(string i_modulename)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_modulename", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_modulename;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETDESKTOPMODULEBYMODNAME", parms);
        }

        public override IDataReader  GetDesktopModuleByFriendlyName(string i_friendlyname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_friendlyname", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_friendlyname;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETDESKTOPMODULEBYNAME", parms);
        }

        public override IDataReader GetDesktopModules()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETDESKTOPMODULES", parms);
        }

        public override IDataReader GetDesktopModulesByPortal(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETDESKTOPMODULESBYPORTAL", parms);
        }
                
        public override IDataReader GetExpiredPortals()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEXPIREDPORTALS", parms);
        }

        public override IDataReader GetFile(string i_filename, int i_portalid, int i_folderid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_filename", OracleDbType.NVarchar2), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_folderid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_filename;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_folderid;
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETFILE", parms);
        }

        public override IDataReader GetFileById(int i_fileid, int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_fileid", OracleDbType.Int32), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_fileid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETFILEBYID", parms);
        }

        public override IDataReader GetFileContent(int i_fileid, int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_fileid", OracleDbType.Int32), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_fileid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETFILECONTENT", parms);
        }

        public override IDataReader GetFiles(int i_portalid, int i_folderid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_folderid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_folderid;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETFILES", parms);
        }

        public override IDataReader GetFolder(int i_portalid, int i_folderid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_folderid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_folderid;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETFOLDERBYFOLDERID", parms);
        }

        public override IDataReader GetFolder(int i_portalid, string i_folderpath)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_folderpath", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = String.IsNullOrEmpty(i_folderpath.Trim()) ? null : i_folderpath;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETFOLDERBYFOLDERPATH", parms);
        }

        public override IDataReader GetFolderPermission(int i_folderpermissionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_folderpermissionid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_folderpermissionid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETFOLDERPERMISSION", parms);
        }
        public override IDataReader GetFolderPermissionsByFolderPath(int i_portalid, string i_folderpath, int i_permissionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_folderpath", OracleDbType.NVarchar2), 
		      new OracleParameter("i_permissionid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_folderpath;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_permissionid;
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETFOLDERPERMISSIONBYPATH", parms);
        }

        public override IDataReader GetFoldersByPortal(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_folderid", OracleDbType.Int32), 
		      new OracleParameter("i_folderpath", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = -1;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = String.Empty;
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETFOLDERS", parms);
        }
        
        public override IDataReader GetFoldersByUser(int i_portalid, int i_userid, bool i_includesecure, bool i_includedatabase, bool i_allowaccess, string i_permissionkeys)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_userid", OracleDbType.Int32), 
		      new OracleParameter("i_includesecure", OracleDbType.Int32), 
		      new OracleParameter("i_includedatabase", OracleDbType.Int32), 
		      new OracleParameter("i_allowaccess", OracleDbType.Int32), 
		      new OracleParameter("i_permissionkeys", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_userid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_includesecure ? 1 : 0;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_includedatabase ? 1 : 0;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_allowaccess ? 1 : 0;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_permissionkeys;
            parms[6].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETFOLDERSBYUSER", parms);
        }

        public override IDataReader GetHostSetting(string i_settingname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_settingname", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_settingname;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETHOSTSETTING", parms);
        }

        public override IDataReader GetHostSettings()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETHOSTSETTINGS", parms);
        }

        public override IDataReader GetList(string i_listname, string i_parentkey, int i_definitionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_listname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_parentkey", OracleDbType.NVarchar2), 
		      new OracleParameter("i_definitionid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_listname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_parentkey;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_definitionid;
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETLIST", parms);
        }

        public override IDataReader GetListEntries(string i_listname, string i_parentkey, int i_entryid, int i_definitionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_listname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_parentkey", OracleDbType.NVarchar2), 
		      new OracleParameter("i_entryid", OracleDbType.Int32), 
		      new OracleParameter("i_definitionid", OracleDbType.Int32), 
		      new OracleParameter("i_value", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_listname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_parentkey;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_entryid;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_definitionid;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = DBNull.Value;
            parms[5].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETLISTENTRIES", parms);
        }

        public override IDataReader GetListEntriesByListName(string i_listname, string i_value, string i_parentkey)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_listname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_parentkey", OracleDbType.NVarchar2), 
		      new OracleParameter("i_entryid", OracleDbType.Int32), 
		      new OracleParameter("i_definitionid", OracleDbType.Int32), 
		      new OracleParameter("i_value", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_listname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_parentkey;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = -1;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = -1;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_value;
            parms[5].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETLISTENTRIES", parms);
        }

        public override IDataReader GetListGroup()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override IDataReader GetModule(int i_moduleid, int i_tabid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_tabid);
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULE", parms);
        }

        public override IDataReader GetModuleByDefinition(int i_portalid, string i_friendlyname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_friendlyname", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_friendlyname;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULEBYDEFINITION", parms);
        }

        public override IDataReader GetModuleControl(int i_modulecontrolid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_modulecontrolid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_modulecontrolid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULECONTROL", parms);
        }

        public override IDataReader  GetModuleControlByKeyAndSrc(int i_moduledefid, string i_controlkey, string i_controlsrc)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduledefid", OracleDbType.Int32), 
		      new OracleParameter("i_controlkey", OracleDbType.NVarchar2), 
		      new OracleParameter("i_controlsrc", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduledefid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_controlkey;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_controlsrc;
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULECONTROLBYKEYSCR", parms);
        }

        public override IDataReader GetModuleControls(int i_moduledefid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduledefid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_moduledefid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULECONTROLS", parms);
        }

        public override IDataReader GetModuleControlsByKey(string i_controlkey, int i_moduledefid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_controlkey", OracleDbType.NVarchar2), 
		      new OracleParameter("i_moduledefid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_controlkey;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_moduledefid);
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULECONTROLSBYKEY", parms);
        }

        public override IDataReader GetModuleDefinition(int i_moduledefid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduledefid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduledefid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULEDEFINITION", parms);
        }

        public override IDataReader GetModuleDefinitionByName(int i_desktopmoduleid, string i_friendlyname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_desktopmoduleid", OracleDbType.Int32), 
		      new OracleParameter("i_friendlyname", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_desktopmoduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_friendlyname;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULEDEFINITIONBYNAME", parms);
        }

        public override IDataReader GetModuleDefinitions(int i_desktopmoduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_desktopmoduleid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_desktopmoduleid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULEDEFINITIONS", parms);
        }

        public override IDataReader GetModulePermission(int i_modulepermissionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_modulepermissionid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_modulepermissionid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULEPERMISSION", parms);
        }

        public override IDataReader  GetModulePermissionsByModuleID(int i_moduleid, int i_permissionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_permissionid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_permissionid;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULEPERMISSIONSBYMOD", parms);
        }


        public override IDataReader  GetModulePermissionsByPortal(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULEPERMISSIONSBYPTL", parms);
        }

        public override IDataReader GetModulePermissionsByTabID(int i_tabid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULEPERMISSIONSBYTAB", parms);
        }

        public override IDataReader GetModules(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULES", parms);
        }

        public override IDataReader GetModuleSetting(int i_moduleid, string i_settingname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_settingname", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_settingname;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULESETTING", parms);
        }

        public override IDataReader GetModuleSettings(int i_moduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETMODULESETTINGS", parms);
        }
                
        public override IDataReader GetPermission(int i_permissionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_permissionid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_permissionid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPERMISSION", parms);
        }

        public override IDataReader GetPermissionByCodeAndKey(string i_permissioncode, string i_permissionkey)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_permissioncode", OracleDbType.NVarchar2), 
		      new OracleParameter("i_permissionkey", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_permissioncode;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_permissionkey;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPERMISSIONBYCODEANDKEY", parms);
        }

        public override IDataReader  GetPermissionsByFolderPath(int i_portalid, string i_folderpath)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_folderpath", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_folderpath;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPERMISSIONSBYFOLDERPTH", parms);
        }

        public override IDataReader  GetPermissionsByModuleDefID(int i_moduledefid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduledefid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduledefid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPERMISSIONSBYMODDEFID", parms);
        }

        public override IDataReader GetPermissionsByModuleID(int i_moduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPERMISSIONSBYMODULEID", parms);
        }

        public override IDataReader GetPermissionsByTabID(int i_tabid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPERMISSIONSBYTABID", parms);
        }

        public override IDataReader GetPortal(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTAL", parms);
        }

        public override IDataReader  GetPortalAlias(string i_httpalias, int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_httpalias", OracleDbType.NVarchar2), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_httpalias;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTALALIAS", parms);
        }
        public override IDataReader GetPortalAliasByPortalAliasID(int i_portalaliasid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalaliasid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_portalaliasid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTALALIASBYALIASID", parms);
        }

        public override IDataReader GetPortalAliasByPortalID(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_portalid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTALALIASBYPORTALID", parms);
        }

        public override IDataReader GetPortalByAlias(string i_httpalias)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_httpalias", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_httpalias;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTALBYALIAS", parms);
        }

        public override IDataReader GetPortalByPortalAliasID(int i_portalaliasid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalaliasid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_portalaliasid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTALBYPORTALALIASID", parms);
        }

        public override IDataReader GetPortalByTab(int i_tabid, string i_httpalias)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_httpalias", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_httpalias;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTALBYTAB", parms);
        }

        public override int GetPortalCount()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_count", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTALCOUNT", parms);
            return Convert.ToInt32(parms[0].Value.ToString());
        }

        public override IDataReader GetPortalDesktopModules(int i_portalid, int i_desktopmoduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_desktopmoduleid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_desktopmoduleid;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTALDESKTOPMODULES", parms);
        }            

        public override IDataReader GetPortals()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTALS", parms);
        }

        public override IDataReader GetPortalsByName(string i_nametomatch, int i_pageindex, int i_pagesize)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_nametomatch", OracleDbType.NVarchar2), 
		      new OracleParameter("i_pageindex", OracleDbType.Int32), 
		      new OracleParameter("i_pagesize", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor),
		      new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_nametomatch;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_pageindex;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_pagesize;
            parms[3].Direction = ParameterDirection.Output;
            parms[4].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTALSBYNAME", parms);
        }

        public override IDataReader GetPortalSpaceUsed(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTALSPACEUSED", parms);
        }

        public override IDataReader GetPortalTabModules(int i_portalid, int i_tabid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABMODULES", parms);            
        }

        public override IDataReader GetProfile(int i_userid, int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_userid", OracleDbType.Int32), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_userid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPROFILE", parms);
        }  

        public override IDataReader  GetPropertyDefinitionsByCategory(int i_portalid, string i_category)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_category", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_category;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPROPERTYDEFBYCATEGORY", parms);
        }

        public override IDataReader  GetPropertyDefinitionByName(int portalid, string name)
        {
            OracleParameter[] parms = {
		      new OracleParameter("portalid", OracleDbType.Int32), 
		      new OracleParameter("name", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = portalid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = name;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPROPERTYDEFBYNAME", parms);
        }

        public override IDataReader  GetPropertyDefinitionsByPortal(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPROPERTYDEFBYPORTAL", parms);
        }

        public override IDataReader GetPropertyDefinition(int i_propertydefinitionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_propertydefinitionid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_propertydefinitionid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPROPERTYDEFINITION", parms);
        }
               
        public override IDataReader  GetSearchCommonWordsByLocale(string i_locale)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_locale", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_locale;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSEARCHCOMMONWORDSBYLOC", parms);
        }

        public override IDataReader GetSearchIndexers()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSEARCHINDEXERS", parms);
        }

        public override IDataReader GetSearchItem(int i_moduleid, string i_searchkey)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_searchkey", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_searchkey;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSEARCHITEM", parms);
        }

        public override IDataReader GetSearchItems(int i_portalid, int i_tabid, int i_moduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_tabid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_moduleid;
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSEARCHITEMS", parms);
        }

        public override IDataReader GetSearchModules(int i_portalid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_portalid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSEARCHMODULES", parms);
        }

        public override IDataReader GetSearchResultModules(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSEARCHRESULTMODULES", parms);
        }

        public override IDataReader GetSearchResults(int i_portalid, string i_word)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_word", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_word;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSEARCHRESULTS", parms);
        }

        public override IDataReader GetSearchSettings(int i_moduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSEARCHSETTINGS", parms);
        }        

        public override IDataReader GetSearchWords()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSEARCHWORDS", parms);
        }        

        public override IDataReader GetSiteLog(int i_portalid, string i_portalalias, string ReportName, DateTime i_startdate, DateTime i_enddate)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_portalalias", OracleDbType.NVarchar2), 
		      new OracleParameter("i_startdate", OracleDbType.Date), 
		      new OracleParameter("i_enddate", OracleDbType.Date), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_portalalias;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_startdate);
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = GetNull(i_enddate);
            parms[4].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + ReportName, parms);
        }

        public override IDataReader GetSiteLogReports()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override IDataReader GetSkin(string i_skinroot, int i_portalid, int i_skintype)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_skinroot", OracleDbType.NVarchar2), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_skintype", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_skinroot;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_skintype;
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSKIN", parms);
        }

        public override IDataReader GetSkins(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSKINS", parms);
        }

        public override IDataReader GetTab(int i_tabid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTAB", parms);
        }

        public override IDataReader GetTabByName(string i_tabname, int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABBYNAME", parms);
        }

        public override int GetTabCount(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_tabcount", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABCOUNT", parms);
            return Convert.ToInt32(parms[1].Value.ToString());
        }

        public override IDataReader GetTables()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABLES", parms);
        }

        public override IDataReader GetTabModuleOrder(int i_tabid, string i_panename)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_panename", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_panename;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABMODULEORDER", parms);
        }       

        public override IDataReader GetTabModules(int i_tabid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABMODULES", parms);
        }

        public override IDataReader GetTabModuleSetting(int i_tabmoduleid, string i_settingname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabmoduleid", OracleDbType.Int32), 
		      new OracleParameter("i_settingname", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabmoduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_settingname;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABMODULESETTING", parms);
        }

        public override IDataReader GetTabModuleSettings(int i_tabmoduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabmoduleid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabmoduleid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABMODULESETTINGS", parms);
        }

        public override IDataReader GetTabPanes(int i_tabid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABPANES", parms);
        }             

        public override IDataReader GetTabPermissionsByPortal(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABPERMISSIONSBYPORTAL", parms);
        }
        
        public override IDataReader GetTabPermissionsByTabID(int i_tabid, int i_permissionid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_permissionid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_permissionid;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABPERMISSIONSBYTABID", parms);
        }

        public override IDataReader GetTabs(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABS", parms);
        }

        public override IDataReader GetTabsByParentId(int i_parentid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_parentid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_parentid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETTABSBYPARENTID", parms);
        }             

        public override IDataReader GetUrl(int i_portalid, string i_url)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_url;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETURL", parms);
        }

        public override IDataReader GetUrlLog(int i_urltrackingid, DateTime i_startdate, DateTime i_enddate)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_urltrackingid", OracleDbType.Int32), 
		      new OracleParameter("i_startdate", OracleDbType.Date), 
		      new OracleParameter("i_enddate", OracleDbType.Date), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_urltrackingid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_startdate);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_enddate);
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETURLLOG", parms);
        }

        public override IDataReader GetUrls(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETURLS", parms);
        }

        public override IDataReader GetUrlTracking(int i_portalid, string i_url, int i_moduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_url;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_moduleid;
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETURLTRACKING", parms);
        }
                
        public override IDataReader GetVendorClassifications(int i_vendorid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_vendorid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_vendorid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETVENDORCLASSIFICATIONS", parms);
        }

        public override IDataReader GetVendor(int i_vendorid, int i_portalid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_vendorid", OracleDbType.Int32), 
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_vendorid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETVENDOR", parms);
        }

        public override IDataReader GetVendors(int i_portalid, bool i_unauthorized, int i_pagesize, int i_pageindex)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_unauthorized", OracleDbType.Int32), 
		      new OracleParameter("i_pagesize", OracleDbType.Int32), 
		      new OracleParameter("i_pageindex", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor),
                new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_unauthorized ? 1 : 0;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_pagesize;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_pageindex;
            parms[4].Direction = ParameterDirection.Output;
            parms[5].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETVENDORS", parms);
        }

        public override IDataReader GetVendorsByEmail(string i_filter, int i_portalid, int i_pagesize, int i_pageindex)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_filter", OracleDbType.NVarchar2), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_pagesize", OracleDbType.Int32), 
		      new OracleParameter("i_pageindex", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor),
                new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_filter;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_pagesize;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_pageindex;
            parms[4].Direction = ParameterDirection.Output;
            parms[5].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETVENDORSBYEMAIL", parms);
        }

        public override IDataReader GetVendorsByName(string i_filter, int i_portalid, int i_pagesize, int i_pageindex)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_filter", OracleDbType.NVarchar2), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_pagesize", OracleDbType.Int32), 
		      new OracleParameter("i_pageindex", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor),
                new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_filter;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_pagesize;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_pageindex;
            parms[4].Direction = ParameterDirection.Output;
            parms[5].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETVENDORSBYNAME", parms);
        }

        public override void UpdateAffiliate(int i_affiliateid, DateTime i_startdate, DateTime i_enddate, double i_cpc, double i_cpa)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_affiliateid", OracleDbType.Int32), 
		      new OracleParameter("i_startdate", OracleDbType.Date), 
		      new OracleParameter("i_enddate", OracleDbType.Date), 
		      new OracleParameter("i_cpc", OracleDbType.Decimal), 
		      new OracleParameter("i_cpa", OracleDbType.Decimal)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_affiliateid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_startdate);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_enddate);
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_cpc;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_cpa;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEAFFILIATE", parms);
        }

        public override void UpdateAffiliateStats(int i_affiliateid, int i_clicks, int i_acquisitions)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_affiliateid", OracleDbType.Int32), 
		      new OracleParameter("i_clicks", OracleDbType.Int32), 
		      new OracleParameter("i_acquisitions", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_affiliateid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_clicks;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_acquisitions;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEAFFILIATESTATS", parms);
        }        

        public override void UpdateBanner(int i_bannerid, string i_bannername, string i_imagefile, string i_url, int i_impressions, double i_cpm, DateTime i_startdate, DateTime i_enddate, string i_username, int i_bannertypeid, string i_description, string i_groupname, int i_criteria, int i_width, int i_height)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_bannerid", OracleDbType.Int32), 
		      new OracleParameter("i_bannername", OracleDbType.NVarchar2), 
		      new OracleParameter("i_imagefile", OracleDbType.NVarchar2), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2), 
		      new OracleParameter("i_impressions", OracleDbType.Int32), 
		      new OracleParameter("i_cpm", OracleDbType.Decimal), 
		      new OracleParameter("i_startdate", OracleDbType.Date), 
		      new OracleParameter("i_enddate", OracleDbType.Date), 
		      new OracleParameter("i_username", OracleDbType.NVarchar2), 
		      new OracleParameter("i_bannertypeid", OracleDbType.Int32), 
		      new OracleParameter("i_description", OracleDbType.NVarchar2), 
		      new OracleParameter("i_groupname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_criteria", OracleDbType.Int32), 
		      new OracleParameter("i_width", OracleDbType.Int32), 
		      new OracleParameter("i_height", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_bannerid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_bannername;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_imagefile;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_url;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_impressions;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_cpm;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = GetNull(i_startdate);
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = GetNull(i_enddate);
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_username;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_bannertypeid;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_description;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = i_groupname;
            parms[12].Direction = ParameterDirection.Input;
            parms[12].Value = i_criteria;
            parms[13].Direction = ParameterDirection.Input;
            parms[13].Value = i_width;
            parms[14].Direction = ParameterDirection.Input;
            parms[14].Value = i_height;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEBANNER", parms);
        }

        public override void UpdateBannerClickThrough(int i_bannerid, int i_vendorid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_bannerid", OracleDbType.Int32), 
		      new OracleParameter("i_vendorid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_bannerid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_vendorid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEBANNERCLICKTHROUGH", parms);
        }

        public override void UpdateBannerViews(int i_bannerid, DateTime i_startdate, DateTime i_enddate)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_bannerid", OracleDbType.Int32), 
		      new OracleParameter("i_startdate", OracleDbType.Date), 
		      new OracleParameter("i_enddate", OracleDbType.Date)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_bannerid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_startdate);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_enddate);

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEBANNERVIEWS", parms);
        }

        public override void UpdateDatabaseVersion(int i_major, int i_minor, int i_build)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_major", OracleDbType.Int32), 
		      new OracleParameter("i_minor", OracleDbType.Int32), 
		      new OracleParameter("i_build", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_major;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_minor;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_build;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEDATABASEVERSION", parms);
        }
        
        public override void UpdateDesktopModule(int i_desktopmoduleid, string i_modulename, string i_foldername, string i_friendlyname, string i_description, string i_version, bool i_ispremium, bool i_isadmin, string i_businesscontroller, int i_supportedfeatures, string i_compatibleversions)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_desktopmoduleid", OracleDbType.Int32), 
		      new OracleParameter("i_modulename", OracleDbType.NVarchar2), 
		      new OracleParameter("i_foldername", OracleDbType.NVarchar2), 
		      new OracleParameter("i_friendlyname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_description", OracleDbType.NVarchar2), 
		      new OracleParameter("i_version", OracleDbType.NVarchar2), 
		      new OracleParameter("i_ispremium", OracleDbType.Int32), 
		      new OracleParameter("i_isadmin", OracleDbType.Int32), 
		      new OracleParameter("i_businesscontroller", OracleDbType.NVarchar2), 
		      new OracleParameter("i_supportedfeatures", OracleDbType.Int32), 
		      new OracleParameter("i_compatibleversions", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_desktopmoduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_modulename;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_foldername;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_friendlyname;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_description;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_version;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_ispremium ? 1 : 0;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_isadmin ? 1 : 0;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_businesscontroller;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_supportedfeatures;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_compatibleversions;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEDESKTOPMODULE", parms);
        }
       
        public override void UpdateFile(int i_fileid, string i_filename, string i_extension, long i_size_, int i_width, int i_height, string i_contenttype, string i_folder, int i_folderid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_fileid", OracleDbType.Int32), 
		      new OracleParameter("i_filename", OracleDbType.NVarchar2), 
		      new OracleParameter("i_extension", OracleDbType.NVarchar2), 
		      new OracleParameter("i_size_", OracleDbType.Int32), 
		      new OracleParameter("i_width", OracleDbType.Int32), 
		      new OracleParameter("i_height", OracleDbType.Int32), 
		      new OracleParameter("i_contenttype", OracleDbType.NVarchar2), 
		      new OracleParameter("i_folder", OracleDbType.NVarchar2), 
		      new OracleParameter("i_folderid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_fileid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_filename;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_extension;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_size_;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_width;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_height;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_contenttype;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_folder;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_folderid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEFILE", parms);
        }

        public override void UpdateFileContent(int i_fileid, byte[] content)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_fileid", OracleDbType.Int32), 
		      new OracleParameter("content", OracleDbType.Blob)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_fileid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = content;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEFILECONTENT", parms);
        }
        
        public override void UpdateFolder(int i_portalid, int i_folderid, string i_folderpath, int i_storagelocation, bool i_isprotected, bool i_iscached, DateTime i_lastupdated)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_folderid", OracleDbType.Int32), 
		      new OracleParameter("i_folderpath", OracleDbType.NVarchar2), 
		      new OracleParameter("i_storagelocation", OracleDbType.Int32), 
		      new OracleParameter("i_isprotected", OracleDbType.Int32), 
		      new OracleParameter("i_iscached", OracleDbType.Int32), 
		      new OracleParameter("i_lastupdated", OracleDbType.Date)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_folderid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_folderpath;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_storagelocation;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_isprotected ? 1 : 0;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_iscached ? 1 : 0;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = GetNull(i_lastupdated);

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEFOLDER", parms);
        }

        public override void UpdateFolderPermission(int i_folderpermissionid, int i_folderid, int i_permissionid, int i_roleid, bool i_allowaccess)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_folderpermissionid", OracleDbType.Int32), 
		      new OracleParameter("i_folderid", OracleDbType.Int32), 
		      new OracleParameter("i_permissionid", OracleDbType.Int32), 
		      new OracleParameter("i_roleid", OracleDbType.Int32), 
		      new OracleParameter("i_allowaccess", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_folderpermissionid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_folderid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_permissionid;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_roleid;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_allowaccess ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEFOLDERPERMISSION", parms);
        }
        
        public override void UpdateHostSetting(string i_settingname, string i_settingvalue, bool i_settingissecure)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_settingname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_settingvalue", OracleDbType.NVarchar2), 
		      new OracleParameter("i_settingissecure", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_settingname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_settingvalue;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_settingissecure ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEHOSTSETTING", parms);
        }

        public override void UpdateListEntry(int i_entryid, string i_listname, string i_value, string i_text, string i_description)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_entryid", OracleDbType.Int32), 
		      new OracleParameter("i_listname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_value", OracleDbType.NVarchar2), 
		      new OracleParameter("i_text", OracleDbType.NVarchar2), 
		      new OracleParameter("i_description", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_entryid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_listname;
            parms[2].Direction = ParameterDirection.Input;
            // We need to pass in a single space for value if it is an empty stringbecause a unique 
            // record is made by the combination of listname and value.  Oracle handles enpty strings 
            // as null values and saves them that way.  A null value can not be used as a unique 
            // constaint hence why we are passing in a single space.  This will have to be handled on 
            // the return in the code.
            parms[2].Value = i_value;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_text;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_description;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATELISTENTRY", parms);
        }
        
        public override void UpdateListSortOrder(int i_entryid, bool i_moveup)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_entryid", OracleDbType.Int32), 
		      new OracleParameter("i_moveup", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_entryid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_moveup ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATELISTSORTORDER", parms);
        }

        public override void UpdateModule(int i_moduleid, string i_moduletitle, bool i_alltabs, string i_header, string i_footer, DateTime i_startdate, DateTime i_enddate, bool i_inheritviewpermissions, bool i_isdeleted)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_moduletitle", OracleDbType.NVarchar2), 
		      new OracleParameter("i_alltabs", OracleDbType.Int32), 
		      new OracleParameter("i_header", OracleDbType.NClob), 
		      new OracleParameter("i_footer", OracleDbType.NClob), 
		      new OracleParameter("i_startdate", OracleDbType.Date), 
		      new OracleParameter("i_enddate", OracleDbType.Date), 
		      new OracleParameter("i_inheritviewpermissions", OracleDbType.Int32), 
		      new OracleParameter("i_isdeleted", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_moduletitle;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_alltabs ? 1 : 0;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_header;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_footer;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = GetNull(i_startdate);
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = GetNull(i_enddate);
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_inheritviewpermissions ? 1 : 0;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_isdeleted ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEMODULE", parms);
        }

        public override void UpdateModuleControl(int i_modulecontrolid, int i_moduledefid, string i_controlkey, string i_controltitle, string i_controlsrc, string i_iconfile, int i_controltype, int i_vieworder, string i_helpurl)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_modulecontrolid", OracleDbType.Int32), 
		      new OracleParameter("i_moduledefid", OracleDbType.Int32), 
		      new OracleParameter("i_controlkey", OracleDbType.NVarchar2), 
		      new OracleParameter("i_controltitle", OracleDbType.NVarchar2), 
		      new OracleParameter("i_controlsrc", OracleDbType.NVarchar2), 
		      new OracleParameter("i_iconfile", OracleDbType.NVarchar2), 
		      new OracleParameter("i_controltype", OracleDbType.Int32), 
		      new OracleParameter("i_vieworder", OracleDbType.Int32), 
		      new OracleParameter("i_helpurl", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_modulecontrolid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_moduledefid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_controlkey);
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = GetNull(i_controltitle);
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_controlsrc;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = GetNull(i_iconfile);
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_controltype;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = GetNull(i_vieworder);
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = GetNull(i_helpurl);

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEMODULECONTROL", parms);
        }

        public override void UpdateModuleDefinition(int i_moduledefid, string i_friendlyname, int i_defaultcachetime)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduledefid", OracleDbType.Int32), 
		      new OracleParameter("i_friendlyname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_defaultcachetime", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduledefid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_friendlyname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_defaultcachetime;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEMODULEDEFINITION", parms);
        }

        public override void UpdateModuleOrder(int i_tabid, int i_moduleid, int i_moduleorder, string i_panename)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_moduleorder", OracleDbType.Int32), 
		      new OracleParameter("i_panename", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_moduleid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_moduleorder;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_panename;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEMODULEORDER", parms);
        }

        public override void UpdateModulePermission(int i_modulepermissionid, int i_moduleid, int i_permissionid, int i_roleid, bool i_allowaccess)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_modulepermissionid", OracleDbType.Int32), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_permissionid", OracleDbType.Int32), 
		      new OracleParameter("i_roleid", OracleDbType.Int32), 
		      new OracleParameter("i_allowaccess", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_modulepermissionid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_moduleid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_permissionid;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_roleid;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_allowaccess ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEMODULEPERMISSION", parms);
        }

        public override void UpdateModuleSetting(int i_moduleid, string i_settingname, string i_settingvalue)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_settingname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_settingvalue", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_moduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_settingname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_settingvalue;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEMODULESETTING", parms);
        }
                
        public override void UpdatePermission(int i_permissionid, string i_permissioncode, int i_moduledefid, string i_permissionkey, string i_permissionname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_permissionid", OracleDbType.Int32), 
		      new OracleParameter("i_permissioncode", OracleDbType.NVarchar2), 
		      new OracleParameter("i_moduledefid", OracleDbType.Int32), 
		      new OracleParameter("i_permissionkey", OracleDbType.NVarchar2), 
		      new OracleParameter("i_permissionname", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_permissionid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_permissioncode;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_moduledefid;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_permissionkey;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_permissionname;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEPERMISSION", parms);
        }

        public override void UpdatePortalAlias(string i_portalalias)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalalias", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_portalalias;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEPORTALALIASONINSTAL", parms);
        }

        public override void UpdatePortalAliasInfo(int i_portalaliasid, int i_portalid, string i_httpalias)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalaliasid", OracleDbType.Int32), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_httpalias", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_portalaliasid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_httpalias;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEPORTALALIAS", parms);
        }

        public override void UpdatePortalInfo(int i_portalid, string i_portalname, string i_logofile, string i_footertext, DateTime i_expirydate, int i_userregistration, int i_banneradvertising, string i_currency, int i_administratorid, double i_hostfee, double i_hostspace, int i_pagequota, int i_userquota, string i_paymentprocessor, string i_processoruserid, string i_processorpassword, string i_description, string i_keywords, string i_backgroundfile, int i_siteloghistory, int i_splashtabid, int i_hometabid, int i_logintabid, int i_usertabid, string i_defaultlanguage, int i_timezoneoffset, string i_homedirectory)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_portalname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_logofile", OracleDbType.NVarchar2), 
		      new OracleParameter("i_footertext", OracleDbType.NVarchar2), 
		      new OracleParameter("i_expirydate", OracleDbType.Date), 
		      new OracleParameter("i_userregistration", OracleDbType.Int32), 
		      new OracleParameter("i_banneradvertising", OracleDbType.Int32), 
		      new OracleParameter("i_currency", OracleDbType.Char), 
		      new OracleParameter("i_administratorid", OracleDbType.Int32), 
		      new OracleParameter("i_hostfee", OracleDbType.Int32), 
		      new OracleParameter("i_hostspace", OracleDbType.Int32), 
		      new OracleParameter("i_pagequota", OracleDbType.Int32), 
		      new OracleParameter("i_userquota", OracleDbType.Int32), 
		      new OracleParameter("i_paymentprocessor", OracleDbType.NVarchar2), 
		      new OracleParameter("i_processoruserid", OracleDbType.NVarchar2), 
		      new OracleParameter("i_processorpassword", OracleDbType.NVarchar2), 
		      new OracleParameter("i_description", OracleDbType.NVarchar2), 
		      new OracleParameter("i_keywords", OracleDbType.NVarchar2), 
		      new OracleParameter("i_backgroundfile", OracleDbType.NVarchar2), 
		      new OracleParameter("i_siteloghistory", OracleDbType.Int32), 
		      new OracleParameter("i_splashtabid", OracleDbType.Int32), 
		      new OracleParameter("i_hometabid", OracleDbType.Int32), 
		      new OracleParameter("i_logintabid", OracleDbType.Int32), 
		      new OracleParameter("i_usertabid", OracleDbType.Int32), 
		      new OracleParameter("i_defaultlanguage", OracleDbType.NVarchar2), 
		      new OracleParameter("i_timezoneoffset", OracleDbType.Int32), 
		      new OracleParameter("i_homedirectory", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_portalname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_logofile;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_footertext;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = GetNull(i_expirydate);
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_userregistration;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_banneradvertising;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_currency;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_administratorid;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_hostfee;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_hostspace;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = i_pagequota;
            parms[12].Direction = ParameterDirection.Input;
            parms[12].Value = i_userquota;
            parms[13].Direction = ParameterDirection.Input;
            parms[13].Value = i_paymentprocessor;
            parms[14].Direction = ParameterDirection.Input;
            parms[14].Value = i_processoruserid;
            parms[15].Direction = ParameterDirection.Input;
            parms[15].Value = i_processorpassword;
            parms[16].Direction = ParameterDirection.Input;
            parms[16].Value = i_description;
            parms[17].Direction = ParameterDirection.Input;
            parms[17].Value = i_keywords;
            parms[18].Direction = ParameterDirection.Input;
            parms[18].Value = i_backgroundfile;
            parms[19].Direction = ParameterDirection.Input;
            parms[19].Value = i_siteloghistory;
            parms[20].Direction = ParameterDirection.Input;
            parms[20].Value = GetNull(i_splashtabid);
            parms[21].Direction = ParameterDirection.Input;
            parms[21].Value = GetNull(i_hometabid);
            parms[22].Direction = ParameterDirection.Input;
            parms[22].Value = GetNull(i_logintabid);
            parms[23].Direction = ParameterDirection.Input;
            parms[23].Value = GetNull(i_usertabid);
            parms[24].Direction = ParameterDirection.Input;
            parms[24].Value = i_defaultlanguage;
            parms[25].Direction = ParameterDirection.Input;
            parms[25].Value = i_timezoneoffset;
            parms[26].Direction = ParameterDirection.Input;
            parms[26].Value = i_homedirectory;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEPORTALINFO", parms);
        }

        public override void UpdatePortalSetup(int i_portalid, int i_administratorid, int i_administratorroleid, int i_poweruserroleid, int i_registeredroleid, int i_splashtabid, int i_hometabid, int i_logintabid, int i_usertabid, int i_admintabid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_administratorid", OracleDbType.Int32), 
		      new OracleParameter("i_administratorroleid", OracleDbType.Int32),
                new OracleParameter("i_poweruserroleid", OracleDbType.Int32), 
		      new OracleParameter("i_registeredroleid", OracleDbType.Int32), 
		      new OracleParameter("i_splashtabid", OracleDbType.Int32), 
		      new OracleParameter("i_hometabid", OracleDbType.Int32), 
		      new OracleParameter("i_logintabid", OracleDbType.Int32), 
		      new OracleParameter("i_usertabid", OracleDbType.Int32), 
		      new OracleParameter("i_admintabid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_administratorid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_administratorroleid;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_poweruserroleid;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_registeredroleid;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_splashtabid;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_hometabid;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_logintabid;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_usertabid;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_admintabid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEPORTALSETUP", parms);
        }

        public override void UpdateProfile(int i_userid, int i_portalid, string i_profiledata)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_userid", OracleDbType.Int32), 
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_profiledata", OracleDbType.NClob)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_userid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_profiledata;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEPROFILE", parms);
        }

        public override void UpdatePropertyDefinition(int i_propertydefinitionid, int i_datatype, string i_defaultvalue, string i_propertycategory, string i_propertyname, bool i_required, string i_validationexpression, int i_vieworder, bool i_visible, int i_length, bool i_searchable)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_propertydefinitionid", OracleDbType.Int32), 
		      new OracleParameter("i_datatype", OracleDbType.Int32), 
		      new OracleParameter("i_defaultvalue", OracleDbType.NVarchar2), 
		      new OracleParameter("i_propertycategory", OracleDbType.NVarchar2), 
		      new OracleParameter("i_propertyname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_required", OracleDbType.Int32), 
		      new OracleParameter("i_validationexpression", OracleDbType.NVarchar2), 
		      new OracleParameter("i_vieworder", OracleDbType.Int32), 
		      new OracleParameter("i_visible", OracleDbType.Int32), 
		      new OracleParameter("i_length", OracleDbType.Int32), 
		      new OracleParameter("i_searchable", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_propertydefinitionid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_datatype;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_defaultvalue;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_propertycategory;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_propertyname;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_required ? 1 : 0;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_validationexpression;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_vieworder;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_visible ? 1 : 0;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_length;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_searchable ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEPROPERTYDEFINITION", parms);
        }
        
        public override void UpdateSearchItem(int i_searchitemid, string i_title, string i_description, int i_author, DateTime i_pubdate, int i_moduleid, string i_searchkey, string i_guid, int i_hitcount, int i_imagefileid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_searchitemid", OracleDbType.Int32), 
		      new OracleParameter("i_title", OracleDbType.NVarchar2), 
		      new OracleParameter("i_description", OracleDbType.NVarchar2), 
		      new OracleParameter("i_author", OracleDbType.Int32), 
		      new OracleParameter("i_pubdate", OracleDbType.Date), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_searchkey", OracleDbType.NVarchar2), 
		      new OracleParameter("i_guid", OracleDbType.NVarchar2), 
		      new OracleParameter("i_hitcount", OracleDbType.Int32), 
		      new OracleParameter("i_imagefileid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_searchitemid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_title;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_description;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_author;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = GetNull(i_pubdate);
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_moduleid;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_searchkey;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_guid;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_hitcount;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_imagefileid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATESEARCHITEM", parms);
        }

        [Obsolete("This method is used for legacy support during the upgrade process (pre v3.1.1). It has been replaced by one that adds the RefreshInterval and PageHeadText variables.")]
        public override void UpdateTab(int TabId, string TabName, bool IsVisible, bool DisableLink, int ParentId, string IconFile, string Title, string Description, string KeyWords, bool IsDeleted, string Url, string SkinSrc, string ContainerSrc, string TabPath, DateTime StartDate, DateTime EndDate)
        {
            throw new Exception("The method or operation is obsolete.");
        }
       
        public override void UpdateTab(int i_tabid, string i_tabname, bool i_isvisible, bool i_disablelink, int i_parentid, string i_iconfile, string i_title, string i_description, string i_keywords, bool i_isdeleted, string i_url, string i_skinsrc, string i_containersrc, string i_tabpath, DateTime i_startdate, DateTime i_enddate, int i_refreshinterval, string i_pageheadtext)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_tabname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_isvisible", OracleDbType.Int32), 
		      new OracleParameter("i_disablelink", OracleDbType.Int32), 
		      new OracleParameter("i_parentid", OracleDbType.Int32), 
		      new OracleParameter("i_iconfile", OracleDbType.NVarchar2), 
		      new OracleParameter("i_title", OracleDbType.NVarchar2), 
		      new OracleParameter("i_description", OracleDbType.NVarchar2), 
		      new OracleParameter("i_keywords", OracleDbType.NVarchar2), 
		      new OracleParameter("i_isdeleted", OracleDbType.Int32), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2), 
		      new OracleParameter("i_skinsrc", OracleDbType.NVarchar2), 
		      new OracleParameter("i_containersrc", OracleDbType.NVarchar2), 
		      new OracleParameter("i_tabpath", OracleDbType.NVarchar2), 
		      new OracleParameter("i_startdate", OracleDbType.Date), 
		      new OracleParameter("i_enddate", OracleDbType.Date), 
		      new OracleParameter("i_refreshinterval", OracleDbType.Int32), 
		      new OracleParameter("i_pageheadtext", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_tabname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_isvisible ? 1 : 0;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_disablelink ? 1 : 0;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = GetNull(i_parentid);
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_iconfile;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_title;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_description;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_keywords;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_isdeleted ? 1 : 0;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_url;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = i_skinsrc;
            parms[12].Direction = ParameterDirection.Input;
            parms[12].Value = i_containersrc;
            parms[13].Direction = ParameterDirection.Input;
            parms[13].Value = i_tabpath;
            parms[14].Direction = ParameterDirection.Input;
            parms[14].Value = GetNull(i_startdate);
            parms[15].Direction = ParameterDirection.Input;
            parms[15].Value = GetNull(i_enddate);
            parms[16].Direction = ParameterDirection.Input;
            parms[16].Value = GetNull(i_refreshinterval);
            parms[17].Direction = ParameterDirection.Input;
            parms[17].Value = i_pageheadtext;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATETAB", parms);
        }
 
        public override void UpdateTabModule(int i_tabid, int i_moduleid, int i_moduleorder, string i_panename, int i_cachetime, string i_alignment, string i_color, string i_border, string i_iconfile, int i_visibility, string i_containersrc, bool i_displaytitle, bool i_displayprint, bool i_displaysyndicate)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_moduleorder", OracleDbType.Int32), 
		      new OracleParameter("i_panename", OracleDbType.NVarchar2), 
		      new OracleParameter("i_cachetime", OracleDbType.Int32), 
		      new OracleParameter("i_alignment", OracleDbType.NVarchar2), 
		      new OracleParameter("i_color", OracleDbType.NVarchar2), 
		      new OracleParameter("i_border", OracleDbType.NVarchar2), 
		      new OracleParameter("i_iconfile", OracleDbType.NVarchar2), 
		      new OracleParameter("i_visibility", OracleDbType.Int32), 
		      new OracleParameter("i_containersrc", OracleDbType.NVarchar2), 
		      new OracleParameter("i_displaytitle", OracleDbType.Int32), 
		      new OracleParameter("i_displayprint", OracleDbType.Int32), 
		      new OracleParameter("i_displaysyndicate", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_moduleid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_moduleorder;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_panename;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_cachetime;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_alignment;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_color;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_border;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_iconfile;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_visibility;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_containersrc;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = i_displaytitle ? 1 : 0;
            parms[12].Direction = ParameterDirection.Input;
            parms[12].Value = i_displayprint ? 1 : 0;
            parms[13].Direction = ParameterDirection.Input;
            parms[13].Value = i_displaysyndicate ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATETABMODULE", parms);
        }

        public override void UpdateTabModuleSetting(int i_tabmoduleid, string i_settingname, string i_settingvalue)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabmoduleid", OracleDbType.Int32), 
		      new OracleParameter("i_settingname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_settingvalue", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabmoduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_settingname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_settingvalue;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATETABMODULESETTING", parms);
        }

        public override void UpdateTabOrder(int i_tabid, int i_taborder, int i_level, int i_parentid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_taborder", OracleDbType.Int32), 
		      new OracleParameter("i_level", OracleDbType.Int32), 
		      new OracleParameter("i_parentid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_taborder;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_level;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = GetNull(i_parentid);

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATETABORDER", parms);
        }

        public override void UpdateTabPermission(int i_tabpermissionid, int i_tabid, int i_permissionid, int i_roleid, bool i_allowaccess)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_tabpermissionid", OracleDbType.Int32), 
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("i_permissionid", OracleDbType.Int32), 
		      new OracleParameter("i_roleid", OracleDbType.Int32), 
		      new OracleParameter("i_allowaccess", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_tabpermissionid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_tabid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_permissionid;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_roleid;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_allowaccess ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATETABPERMISSION", parms);
        }

        public override void UpdateUrlTracking(int i_portalid, string i_url, bool i_logactivity, bool i_trackclicks, int i_moduleid, bool i_newwindow)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2), 
		      new OracleParameter("i_logactivity", OracleDbType.Int32), 
		      new OracleParameter("i_trackclicks", OracleDbType.Int32), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32), 
		      new OracleParameter("i_newwindow", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_url;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_logactivity ? 1 : 0;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_trackclicks ? 1 : 0;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_moduleid;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_newwindow ? 1 : 0;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEURLTRACKING", parms);
        }

        public override void UpdateUrlTrackingStats(int i_portalid, string i_url, int i_moduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_url", OracleDbType.NVarchar2), 
		      new OracleParameter("i_moduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_url;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_moduleid;

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEURLTRACKINGSTATS", parms);
        }
        
        public override void UpdateVendor(int i_vendorid, string i_vendorname, string i_unit, string i_street, string i_city, string i_region, string i_country, string i_postalcode, string i_telephone, string i_fax, string i_cell, string i_email, string i_website, string i_firstname, string i_lastname, string i_username, string i_logofile, string i_keywords, string i_authorized)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_vendorid", OracleDbType.Int32), 
		      new OracleParameter("i_vendorname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_unit", OracleDbType.NVarchar2), 
		      new OracleParameter("i_street", OracleDbType.NVarchar2), 
		      new OracleParameter("i_city", OracleDbType.NVarchar2), 
		      new OracleParameter("i_region", OracleDbType.NVarchar2), 
		      new OracleParameter("i_country", OracleDbType.NVarchar2), 
		      new OracleParameter("i_postalcode", OracleDbType.NVarchar2), 
		      new OracleParameter("i_telephone", OracleDbType.NVarchar2), 
		      new OracleParameter("i_fax", OracleDbType.NVarchar2), 
		      new OracleParameter("i_cell", OracleDbType.NVarchar2), 
		      new OracleParameter("i_email", OracleDbType.NVarchar2), 
		      new OracleParameter("i_website", OracleDbType.NVarchar2), 
		      new OracleParameter("i_firstname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_lastname", OracleDbType.NVarchar2), 
		      new OracleParameter("i_username", OracleDbType.NVarchar2), 
		      new OracleParameter("i_logofile", OracleDbType.NVarchar2), 
		      new OracleParameter("i_keywords", OracleDbType.Clob), 
		      new OracleParameter("i_authorized", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_vendorid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_vendorname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_unit;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_street;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_city;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_region;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_country;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_postalcode;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_telephone;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_fax;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_cell;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = i_email;
            parms[12].Direction = ParameterDirection.Input;
            parms[12].Value = i_website;
            parms[13].Direction = ParameterDirection.Input;
            parms[13].Value = i_firstname;
            parms[14].Direction = ParameterDirection.Input;
            parms[14].Value = i_lastname;
            parms[15].Direction = ParameterDirection.Input;
            parms[15].Value = i_username;
            parms[16].Direction = ParameterDirection.Input;
            parms[16].Value = i_logofile;
            parms[17].Direction = ParameterDirection.Input;
            parms[17].Value = i_keywords;
            parms[18].Direction = ParameterDirection.Input;
            parms[18].Value = bool.Parse(i_authorized);

            OracleHelper.ExecuteNonQuery(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEVENDOR", parms);
        }

        public override IDataReader VerifyPortal(int i_portalid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "VERIFYPORTAL", parms);
        }

        public override IDataReader VerifyPortalTab(int i_portalid, int i_tabid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_portalid", OracleDbType.Int32), 
		      new OracleParameter("i_tabid", OracleDbType.Int32), 
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_tabid;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(UpgradeConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "VERIFYPORTALTAB", parms);
        }

        public override void UpgradeDatabaseSchema(int Major, int Minor, int Build)
        {
            // not necessary for SQL Server - use Transact-SQL scripts
            throw new Exception("The method or operation is obsolete.");            
        }
    }
}