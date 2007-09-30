#region SharpContent License
// Sharp Content Portal - http://www.SharpContentPortal.com
// Copyright (c) 2002-2006
// by SharpContent Corporation
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
using SharpContent.Common.Utilities;
using SharpContent.Framework.Providers;
using SharpContent.ApplicationBlocks.Data;

namespace SharpContent.Services.Log.EventLog.DBLoggingProvider.Data
{
    public class OracleDataProvider : DataProvider
    {
        private const string ProviderType = "data";
        private ProviderConfiguration providerConfiguration = ProviderConfiguration.GetProviderConfiguration(ProviderType);
        private string _connectionString;
        private string _providerPath;
        private string _packageName;
        private string _databaseOwner;

        public OracleDataProvider()
        {
            // Read the configuration specific information for this provider
            Provider objProvider = (Provider)providerConfiguration.Providers[providerConfiguration.DefaultProvider];

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
            if( !String.IsNullOrEmpty(_databaseOwner) && _databaseOwner.EndsWith( "." ) == false )
            {
                _databaseOwner += ".";
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

        private object GetNull( object Field )
        {
            return Null.GetNull( Field, DBNull.Value );
        }
        
        public override void AddLog(string i_logguid, string i_logtypekey, int i_loguserid, string i_logusername, int i_logportalid, string i_logportalname, DateTime i_logcreatedate, string i_logservername, string i_logproperties, int i_logconfigid)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_logguid", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		        new OracleParameter("i_loguserid", OracleDbType.Int32), 
		        new OracleParameter("i_logusername", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logportalid", OracleDbType.Int32), 
		        new OracleParameter("i_logportalname", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logcreatedate", OracleDbType.Date), 
		        new OracleParameter("i_logservername", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logproperties", OracleDbType.NClob), 
		        new OracleParameter("i_logconfigid", OracleDbType.Int32)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_logguid;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = i_logtypekey;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = i_loguserid;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = i_logusername;
	        parms[4].Direction = ParameterDirection.Input;
	        parms[4].Value = i_logportalid;
	        parms[5].Direction = ParameterDirection.Input;
	        parms[5].Value = i_logportalname;
	        parms[6].Direction = ParameterDirection.Input;
	        parms[6].Value = i_logcreatedate;
	        parms[7].Direction = ParameterDirection.Input;
	        parms[7].Value = i_logservername;
	        parms[8].Direction = ParameterDirection.Input;
	        parms[8].Value = i_logproperties;
	        parms[9].Direction = ParameterDirection.Input;
	        parms[9].Value = i_logconfigid;

	        OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDEVENTLOG", parms);
        }
        
        public override void AddLogTypeConfigInfo( bool i_loggingisactive, string i_logtypekey, string i_logtypeportalid, int i_keepmostrecent, bool i_emailnotificationisactive, int i_notificationthreshold, int i_notificationthresholdtime, int i_notificationthresholdtype, string i_mailfromaddress, string i_mailtoaddress)
        
        {
            int portalID;
            if( i_logtypekey == "*" )
            {
                i_logtypekey = "";
            }
            if( i_logtypeportalid == "*" )
            {
                portalID = - 1;
            }
            else
            {
                portalID = Convert.ToInt32( i_logtypeportalid );
            }

            OracleParameter[] parms = {
		    new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		    new OracleParameter("i_logtypeportalid", OracleDbType.Int32), 
		    new OracleParameter("i_loggingisactive", OracleDbType.Int32), 
		    new OracleParameter("i_keepmostrecent", OracleDbType.Int32), 
		    new OracleParameter("i_emailnotificationisactive", OracleDbType.Int32), 
		    new OracleParameter("i_notificationthreshold", OracleDbType.Int32), 
		    new OracleParameter("i_notificationthresholdtime", OracleDbType.Int32), 
		    new OracleParameter("i_notificationthresholdtype", OracleDbType.Int32), 
		    new OracleParameter("i_mailfromaddress", OracleDbType.NVarchar2), 
		    new OracleParameter("i_mailtoaddress", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_logtypekey;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = portalID;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_loggingisactive ? 1 : 0;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_keepmostrecent;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_emailnotificationisactive ? 1 : 0;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_notificationthreshold;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_notificationthresholdtime;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_notificationthresholdtype;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_mailfromaddress;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_mailtoaddress;

            OracleHelper.ExecuteNonQuery( ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDEVENTLOGCONFIG", parms);
        }

        public override void UpdateLogTypeConfigInfo(string i_id, bool i_loggingisactive, string i_logtypekey, string i_logtypeportalid, int i_keepmostrecent, string i_logfilename, bool i_emailnotificationisactive, int i_notificationthreshold, int i_notificationthresholdtime, int i_notificationthresholdtype, string i_mailfromaddress, string i_mailtoaddress)
        {
	       int portalID;
            if( i_logtypekey == "*" )
            {
                i_logtypekey = "";
            }
            if( i_logtypeportalid == "*" )
            {
                portalID = - 1;
            }
            else
            {
                portalID = Convert.ToInt32( i_logtypeportalid );
            }
 
            OracleParameter[] parms = {
		        new OracleParameter("i_id", OracleDbType.Int32), 
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logtypeportalid", OracleDbType.Int32), 
		        new OracleParameter("i_loggingisactive", OracleDbType.Int32), 
		        new OracleParameter("i_keepmostrecent", OracleDbType.Int32), 
		        new OracleParameter("i_emailnotificationisactive", OracleDbType.Int32), 
		        new OracleParameter("i_notificationthreshold", OracleDbType.Int32), 
		        new OracleParameter("i_notificationthresholdtime", OracleDbType.Int32), 
		        new OracleParameter("i_notificationthresholdtype", OracleDbType.Int32), 
		        new OracleParameter("i_mailfromaddress", OracleDbType.NVarchar2), 
		        new OracleParameter("i_mailtoaddress", OracleDbType.NVarchar2)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = int.Parse(i_id);
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = i_logtypekey;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = portalID;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = i_loggingisactive ? 1 : 0;
	        parms[4].Direction = ParameterDirection.Input;
	        parms[4].Value = i_keepmostrecent;
	        parms[5].Direction = ParameterDirection.Input;
	        parms[5].Value = i_emailnotificationisactive ? 1 : 0;
	        parms[6].Direction = ParameterDirection.Input;
	        parms[6].Value = i_notificationthreshold;
	        parms[7].Direction = ParameterDirection.Input;
	        parms[7].Value = i_notificationthresholdtime;
	        parms[8].Direction = ParameterDirection.Input;
	        parms[8].Value = i_notificationthresholdtype;
	        parms[9].Direction = ParameterDirection.Input;
	        parms[9].Value = i_mailfromaddress;
	        parms[10].Direction = ParameterDirection.Input;
	        parms[10].Value = i_mailtoaddress;

	        OracleHelper.ExecuteNonQuery( ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEEVENTLOGCONFIG", parms);
        }

        public override void ClearLog()
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_logguid", OracleDbType.NVarchar2)};
	        parms[0].Direction = ParameterDirection.Input;
             parms[0].Value = DBNull.Value;

	        OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEEVENTLOG", parms);
        }

        public override void DeleteLog(string i_logguid)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_logguid", OracleDbType.NVarchar2)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_logguid;

	        OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEEVENTLOG", parms);
        }

        public override void DeleteLogTypeConfigInfo( string i_id )
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_id", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_id;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEEVENTLOGCONFIG", parms);
        }

        public override IDataReader GetSingleLog(string i_logguid)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_logguid", OracleDbType.NVarchar2), 
		        new OracleParameter("o_rc1", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_logguid;
	        parms[1].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOGBYLOGGUID", parms);
        }

        public override IDataReader GetLog()
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_portalid", OracleDbType.Int32), 
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		        new OracleParameter("i_pagesize", OracleDbType.Int32), 
		        new OracleParameter("i_pageindex", OracleDbType.Int32), 
		        new OracleParameter("o_rc1", OracleDbType.RefCursor),
		        new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = DBNull.Value;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = DBNull.Value;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = DBNull.Value;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = DBNull.Value;
             parms[4].Direction = ParameterDirection.Output;
             parms[5].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOG", parms);
        }

        public override IDataReader GetLog(int i_portalid)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_portalid", OracleDbType.Int32), 
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		        new OracleParameter("i_pagesize", OracleDbType.Int32), 
		        new OracleParameter("i_pageindex", OracleDbType.Int32), 
		        new OracleParameter("o_rc1", OracleDbType.RefCursor),
		        new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_portalid;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = DBNull.Value;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = DBNull.Value;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = DBNull.Value;
             parms[4].Direction = ParameterDirection.Output;
             parms[5].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOG", parms);
       }

        public override IDataReader GetLog(int i_portalid, string i_logtypekey)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_portalid", OracleDbType.Int32), 
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		        new OracleParameter("i_pagesize", OracleDbType.Int32), 
		        new OracleParameter("i_pageindex", OracleDbType.Int32), 
		        new OracleParameter("o_rc1", OracleDbType.RefCursor),
		        new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_portalid;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = i_logtypekey;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = DBNull.Value;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = DBNull.Value;
             parms[4].Direction = ParameterDirection.Output;
             parms[5].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOG", parms);
        }

        public override IDataReader GetLog(string i_logtypekey)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_portalid", OracleDbType.Int32), 
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		        new OracleParameter("i_pagesize", OracleDbType.Int32), 
		        new OracleParameter("i_pageindex", OracleDbType.Int32), 
		        new OracleParameter("o_rc1", OracleDbType.RefCursor),
		        new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = DBNull.Value;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = i_logtypekey;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = DBNull.Value;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = DBNull.Value;
             parms[4].Direction = ParameterDirection.Output;
             parms[5].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOG", parms);
        }

        public override IDataReader GetLog(int i_pagesize, int i_pageindex)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_portalid", OracleDbType.Int32), 
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		        new OracleParameter("i_pagesize", OracleDbType.Int32), 
		        new OracleParameter("i_pageindex", OracleDbType.Int32), 
		        new OracleParameter("o_rc1", OracleDbType.RefCursor),
		        new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = DBNull.Value;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = DBNull.Value;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = i_pagesize;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = i_pageindex;
             parms[4].Direction = ParameterDirection.Output;
             parms[5].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOG", parms);
        }

        public override IDataReader GetLog(int i_portalid, int i_pagesize, int i_pageindex)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_portalid", OracleDbType.Int32), 
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		        new OracleParameter("i_pagesize", OracleDbType.Int32), 
		        new OracleParameter("i_pageindex", OracleDbType.Int32), 
		        new OracleParameter("o_rc1", OracleDbType.RefCursor),
		        new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_portalid;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = DBNull.Value;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = i_pagesize;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = i_pageindex;
	        parms[4].Direction = ParameterDirection.Output;
	        parms[5].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOG", parms);
        }

        public override IDataReader GetLog(int i_portalid, string i_logtypekey, int i_pagesize, int i_pageindex)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_portalid", OracleDbType.Int32), 
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		        new OracleParameter("i_pagesize", OracleDbType.Int32), 
		        new OracleParameter("i_pageindex", OracleDbType.Int32), 
		        new OracleParameter("o_rc1", OracleDbType.RefCursor),
		        new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_portalid;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = i_logtypekey;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = i_pagesize;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = i_pageindex;
	        parms[4].Direction = ParameterDirection.Output;
	        parms[5].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOG", parms);
        }

        public override IDataReader GetLog(string i_logtypekey, int i_pagesize, int i_pageindex)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_portalid", OracleDbType.Int32), 
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		        new OracleParameter("i_pagesize", OracleDbType.Int32), 
		        new OracleParameter("i_pageindex", OracleDbType.Int32), 
		        new OracleParameter("o_rc1", OracleDbType.RefCursor),
		        new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = DBNull.Value;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = i_logtypekey;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = i_pagesize;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = i_pageindex;
             parms[4].Direction = ParameterDirection.Output;
             parms[5].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOG", parms);
         }

        public override IDataReader GetLogTypeConfigInfo()
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_id", OracleDbType.Int32), 
		        new OracleParameter("o_rc1", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = DBNull.Value;
	        parms[1].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOGCONFIG", parms);
        }

        public override IDataReader GetLogTypeConfigInfoByID(int i_id)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_id", OracleDbType.Int32), 
		        new OracleParameter("o_rc1", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_id;
	        parms[1].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOGCONFIG", parms);
         }

        public override IDataReader GetLogTypeInfo()
        {
	        OracleParameter[] parms = {
		        new OracleParameter("o_rc1", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOGTYPE", parms);
        }

        public override void PurgeLog()
        {
	        OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "PURGEEVENTLOG", null);
        }

        public override void AddLogType(string i_logtypekey, string i_logtypefriendlyname, string i_logtypedescription, string i_logtypecssclass, string i_logtypeowner)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logtypefriendlyname", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logtypedescription", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logtypeowner", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logtypecssclass", OracleDbType.NVarchar2)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_logtypekey;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = i_logtypefriendlyname;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = i_logtypedescription;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = i_logtypeowner;
	        parms[4].Direction = ParameterDirection.Input;
	        parms[4].Value = i_logtypecssclass;

	        OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDEVENTLOGTYPE", parms);
        }

        public override void UpdateLogType(string i_logtypekey, string i_logtypefriendlyname, string i_logtypedescription, string i_logtypeowner, string i_logtypecssclass)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logtypefriendlyname", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logtypedescription", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logtypeowner", OracleDbType.NVarchar2), 
		        new OracleParameter("i_logtypecssclass", OracleDbType.NVarchar2)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_logtypekey;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = i_logtypefriendlyname;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = i_logtypedescription;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = i_logtypeowner;
	        parms[4].Direction = ParameterDirection.Input;
	        parms[4].Value = i_logtypecssclass;

	        OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEEVENTLOGTYPE", parms);
        }

        public override void DeleteLogType(string i_logtypekey)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_logtypekey", OracleDbType.NVarchar2)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_logtypekey;

	        OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEEVENTLOGTYPE", parms);
        }

        public override IDataReader GetEventLogPendingNotifConfig()
        {
	        OracleParameter[] parms = {
		        new OracleParameter("o_rc1", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOGPENDINGNOTIFCO", parms);
        }

        public override IDataReader GetEventLogPendingNotif(int i_logconfigid)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_logconfigid", OracleDbType.Int32), 
		        new OracleParameter("o_rc1", OracleDbType.RefCursor)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_logconfigid;
	        parms[1].Direction = ParameterDirection.Output;

	        return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETEVENTLOGPENDINGNOTIF", parms);
        }

        public override void UpdateEventLogPendingNotif(int i_logconfigid)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_logconfigid", OracleDbType.Int32)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_logconfigid;

	        OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEEVENTLOGPENDINGNOTI", parms);
        }
    }
}