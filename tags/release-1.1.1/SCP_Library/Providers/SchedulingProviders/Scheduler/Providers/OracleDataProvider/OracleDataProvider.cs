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
using SharpContent.Common.Utilities;
using SharpContent.Framework.Providers;
using SharpContent.ApplicationBlocks.Data;
using Oracle.DataAccess.Client;

namespace SharpContent.Services.Scheduling.PortalScheduling
{
    public class OracleDataProvider : DataProvider
    {
        private const string ProviderType = "data";

        private ProviderConfiguration providerConfiguration;
        private string _connectionString;
        private string _providerPath;
        private string _packageName;
        private string _databaseOwner;

        public OracleDataProvider()
        {
            providerConfiguration = ProviderConfiguration.GetProviderConfiguration( ProviderType );

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
            if( !String.IsNullOrEmpty(_packageName) && _packageName.EndsWith( "_" ) == false )
            {
                _packageName += "_";
            }

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

        // general
        private object GetNull( object Field )
        {
            return Null.GetNull( Field, DBNull.Value );
        }

        public override IDataReader GetSchedule()
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_server", OracleDbType.Varchar2), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = DBNull.Value;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSCHEDULE", parms);
        }

        public override IDataReader GetSchedule( string i_server )
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_server", OracleDbType.Varchar2), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_server);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSCHEDULE", parms);
        }

        public override IDataReader GetSchedule( int i_scheduleid )
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_scheduleid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_scheduleid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSCHEDULEBYSCHEDULEID", parms);
        }

        public override IDataReader GetSchedule(string i_typefullname, string i_server)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_typefullname", OracleDbType.Varchar2), 
		    new OracleParameter("i_server", OracleDbType.Varchar2), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_typefullname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_server);
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSCHEDULEBYTYPEFULLNAME", parms);
        }

        public override IDataReader GetNextScheduledTask(string i_server)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_server", OracleDbType.Varchar2), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_server);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSCHEDULENEXTTASK", parms);
        }

        public override IDataReader GetScheduleByEvent(string i_eventname, string i_server)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_eventname", OracleDbType.Varchar2), 
		    new OracleParameter("i_server", OracleDbType.Varchar2), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_eventname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_server);
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSCHEDULEBYEVENT", parms);
        }

        public override IDataReader GetScheduleHistory(int i_scheduleid)
        {
            OracleParameter[] parms = {
		new OracleParameter("i_scheduleid", OracleDbType.Int32), 
		new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_scheduleid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSCHEDULEHISTORY", parms);
        }

        public override int AddSchedule(string i_typefullname, int i_timelapse, string i_timelapsemeasurement, int i_retrytimelapse, string i_retrytimelapsemeasurement, int i_retainhistorynum, string i_attachtoevent, bool i_catchupenabled, bool i_enabled, string i_objectdependencies, string i_servers)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_typefullname", OracleDbType.Varchar2), 
		    new OracleParameter("i_timelapse", OracleDbType.Int32), 
		    new OracleParameter("i_timelapsemeasurement", OracleDbType.Varchar2), 
		    new OracleParameter("i_retrytimelapse", OracleDbType.Int32), 
		    new OracleParameter("i_retrytimelapsemeasurement", OracleDbType.Varchar2), 
		    new OracleParameter("i_retainhistorynum", OracleDbType.Int32), 
		    new OracleParameter("i_attachtoevent", OracleDbType.Varchar2), 
		    new OracleParameter("i_catchupenabled", OracleDbType.Int32), 
		    new OracleParameter("i_enabled", OracleDbType.Int32), 
		    new OracleParameter("i_objectdependencies", OracleDbType.Varchar2), 
		    new OracleParameter("i_servers", OracleDbType.NVarchar2), 
		    new OracleParameter("o_scheduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_typefullname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_timelapse;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_timelapsemeasurement;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_retrytimelapse;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_retrytimelapsemeasurement;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_retainhistorynum;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_attachtoevent;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_catchupenabled ? 1 : 0;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_enabled ? 1 : 0;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_objectdependencies;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = GetNull(i_servers);
            parms[11].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDSCHEDULE", parms);
            return Convert.ToInt32(parms[11].Value.ToString());
        }

        public override void UpdateSchedule(int i_scheduleid, string i_typefullname, int i_timelapse, string i_timelapsemeasurement, int i_retrytimelapse, string i_retrytimelapsemeasurement, int i_retainhistorynum, string i_attachtoevent, bool i_catchupenabled, bool i_enabled, string i_objectdependencies, string i_servers)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_scheduleid", OracleDbType.Int32), 
		    new OracleParameter("i_typefullname", OracleDbType.Varchar2), 
		    new OracleParameter("i_timelapse", OracleDbType.Int32), 
		    new OracleParameter("i_timelapsemeasurement", OracleDbType.Varchar2), 
		    new OracleParameter("i_retrytimelapse", OracleDbType.Int32), 
		    new OracleParameter("i_retrytimelapsemeasurement", OracleDbType.Varchar2), 
		    new OracleParameter("i_retainhistorynum", OracleDbType.Int32), 
		    new OracleParameter("i_attachtoevent", OracleDbType.Varchar2), 
		    new OracleParameter("i_catchupenabled", OracleDbType.Int32), 
		    new OracleParameter("i_enabled", OracleDbType.Int32), 
		    new OracleParameter("i_objectdependencies", OracleDbType.Varchar2), 
		    new OracleParameter("i_servers", OracleDbType.Varchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_scheduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_typefullname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_timelapse;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_timelapsemeasurement;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_retrytimelapse;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_retrytimelapsemeasurement;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_retainhistorynum;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_attachtoevent;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_catchupenabled ? 1 : 0;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_enabled ? 1 : 0;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_objectdependencies;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = GetNull(i_servers);

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATESCHEDULE", parms);
        }

        public override void DeleteSchedule(int i_scheduleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_scheduleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_scheduleid;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETESCHEDULE", parms);
        }

        public override IDataReader GetScheduleItemSettings(int i_scheduleid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_scheduleid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_scheduleid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSCHEDULEITEMSETTINGS", parms);
        }

        public override void AddScheduleItemSetting(int i_scheduleid, string i_name, string i_value)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_scheduleid", OracleDbType.Int32), 
		    new OracleParameter("i_name", OracleDbType.NVarchar2), 
		    new OracleParameter("i_value", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_scheduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_name;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_value;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDSCHEDULEITEMSETTING", parms);
        }

        public override int AddScheduleHistory(int i_scheduleid, DateTime i_startdate, string i_server)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_scheduleid", OracleDbType.Int32), 
		    new OracleParameter("i_startdate", OracleDbType.Date), 
		    new OracleParameter("i_server", OracleDbType.NVarchar2), 
		    new OracleParameter("o_schedulehistoryid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_scheduleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_startdate;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_server;
            parms[3].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDSCHEDULEHISTORY", parms);
            return Convert.ToInt32(parms[3].Value.ToString());
        }

        public override void UpdateScheduleHistory(int i_schedulehistoryid, DateTime i_enddate, bool i_succeeded, string i_lognotes, DateTime i_nextstart)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_schedulehistoryid", OracleDbType.Int32), 
		    new OracleParameter("i_enddate", OracleDbType.Date), 
		    new OracleParameter("i_succeeded", OracleDbType.Int32), 
		    new OracleParameter("i_lognotes", OracleDbType.NClob), 
		    new OracleParameter("i_nextstart", OracleDbType.Date)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_schedulehistoryid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_enddate);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_succeeded ? 1 : -1);
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_lognotes;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = GetNull(i_nextstart);

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATESCHEDULEHISTORY", parms);
        }

        public override void PurgeScheduleHistory()
        {
            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "PURGESCHEDULEHISTORY", null);
        }
    }
}