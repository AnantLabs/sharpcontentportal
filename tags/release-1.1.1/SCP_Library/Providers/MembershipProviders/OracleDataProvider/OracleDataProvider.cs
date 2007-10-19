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
using System.Collections;
using System.Data;
using Oracle.DataAccess.Client;
using SharpContent.Common.Utilities;
using SharpContent.Entities.Users;
using SharpContent.Framework.Providers;
using SharpContent.ApplicationBlocks.Data;

namespace SharpContent.Security.Membership.Data
{
    /// <summary>
    /// The SqlDataProvider provides a concrete SQL Server implementation of the
    /// Data Access Layer for the project
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <history>
    ///     [cnurse]	03/28/2006	created
    /// </history>
    public class OracleDataProvider : DataProvider
    {
        private const string ProviderType = "data";
        private ProviderConfiguration _providerConfiguration = ProviderConfiguration.GetProviderConfiguration(ProviderType);
        private string _connectionString;
        private string _providerPath;
        private string _packageName;
        private string _aspnetProviderPackageName;
        private string _databaseOwner;

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
            if( !String.IsNullOrEmpty(_packageName) && _packageName.EndsWith( "_" ) == false )
            {
                _packageName += "_";
            }

            _aspnetProviderPackageName = "aspnet_provider.aspnet_";
            if (!String.IsNullOrEmpty(_aspnetProviderPackageName) && _aspnetProviderPackageName.EndsWith("_") == false)
            {
                _aspnetProviderPackageName += "_";
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

        public string AspnetProviderPackageName
        {
            get
            {
                return _aspnetProviderPackageName;
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

        private string GetFullyQualifiedName( string name )
        {
            return DatabaseOwner + PackageName + name;
        }

        //Security
        public override IDataReader UserLogin(string i_username, string i_password)
        {
            throw new Exception("The method or operation is not implemented.");
        }
        
        public override IDataReader GetAuthRoles( int i_portalId, int i_moduleid )
        {
            throw new Exception("The method or operation is not implemented.");
        }

        //Users
        public override int AddRole(int i_portalid, int i_rolegroupid, string i_rolename, string i_description, float i_servicefee, string i_billingperiod, string i_billingfrequency, float i_trialfee, int i_trialperiod, string i_trialfrequency, bool i_ispublic, bool i_autoassignment, string i_rsvpcode, string i_iconfile)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_rolegroupid", OracleDbType.Int32), 
		    new OracleParameter("i_rolename", OracleDbType.NVarchar2), 
		    new OracleParameter("i_description", OracleDbType.NVarchar2), 
		    new OracleParameter("i_servicefee", OracleDbType.Int32), 
		    new OracleParameter("i_billingperiod", OracleDbType.Int32), 
		    new OracleParameter("i_billingfrequency", OracleDbType.Char), 
		    new OracleParameter("i_trialfee", OracleDbType.Int32), 
		    new OracleParameter("i_trialperiod", OracleDbType.Int32), 
		    new OracleParameter("i_trialfrequency", OracleDbType.Char), 
		    new OracleParameter("i_ispublic", OracleDbType.Int32), 
		    new OracleParameter("i_autoassignment", OracleDbType.Int32), 
		    new OracleParameter("i_rsvpcode", OracleDbType.NVarchar2), 
		    new OracleParameter("i_iconfile", OracleDbType.NVarchar2), 
		    new OracleParameter("o_roleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_rolegroupid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_rolename;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_description;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_servicefee;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = int.Parse(i_billingperiod);
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_billingfrequency;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_trialfee;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_trialperiod;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_trialfrequency;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_ispublic ? 1 : 0;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = i_autoassignment ? 1 : 0;
            parms[12].Direction = ParameterDirection.Input;
            parms[12].Value = i_rsvpcode;
            parms[13].Direction = ParameterDirection.Input;
            parms[13].Value = i_iconfile;
            parms[14].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDROLE", parms);
            return Convert.ToInt32(parms[14].Value.ToString());
        }

        public override int AddRoleGroup(int i_portalid, string i_rolegroupname, string i_description)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_rolegroupname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_description", OracleDbType.NVarchar2), 
		    new OracleParameter("o_rolegroupid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_rolegroupname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_description;
            parms[3].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDROLEGROUP", parms);
            return Convert.ToInt32(parms[3].Value.ToString());
        }
        
        public override int AddUser(int i_portalid, string i_username, string i_firstname, string i_lastname, int i_affiliateid, bool i_issuperuser, string i_email, string i_displayname, bool i_updatepassword, bool i_authorised)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32),
		    new OracleParameter("i_username", OracleDbType.NVarchar2), 
		    new OracleParameter("i_firstname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_lastname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_affiliateid", OracleDbType.Int32), 
		    new OracleParameter("i_issuperuser", OracleDbType.Int32), 
		    new OracleParameter("i_email", OracleDbType.NVarchar2), 
		    new OracleParameter("i_displayname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_updatepassword", OracleDbType.Int32), 
		    new OracleParameter("i_authorised", OracleDbType.Int32), 
		    new OracleParameter("o_userid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_firstname;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_lastname;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = GetNull(i_affiliateid);
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_issuperuser ? 1 : 0;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_email;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_displayname;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = i_updatepassword ? 1 : 0;
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_authorised ? 1 : 0;
            parms[10].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDUSER", parms);
                return Convert.ToInt32(parms[10].Value.ToString());
            }
            catch // duplicate
            {
                return -1;
            }

        }
        
        public override int AddUserRole(int i_portalid, int i_userid, int i_roleid, DateTime i_effectivedate, DateTime i_expirydate)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_userid", OracleDbType.Int32), 
		    new OracleParameter("i_roleid", OracleDbType.Int32), 
		    new OracleParameter("i_effectivedate", OracleDbType.Date), 
		    new OracleParameter("i_expirydate", OracleDbType.Date), 
		    new OracleParameter("o_userroleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_userid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_roleid;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = GetNull(i_effectivedate);
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = GetNull(i_expirydate);
            parms[5].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDUSERROLE", parms);
            return Convert.ToInt32(parms[5].Value.ToString());
        }

        public override void DeleteRole(int i_roleid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_roleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_roleid;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEROLE", parms);
        }

        public override void DeleteRoleGroup(int i_rolegroupid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_rolegroupid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_rolegroupid;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEROLEGROUP", parms);
        }

        public override void DeleteUser(int i_userid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_userid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_userid;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEUSER", parms);
        }

        public override void DeleteUserPortal(int i_userid, int i_portalid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_userid", OracleDbType.Int32), 
		    new OracleParameter("i_portalid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_userid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEUSERPORTAL", parms);
        }

        public override void DeleteUserRole(int i_userid, int i_roleid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_userid", OracleDbType.Int32), 
		    new OracleParameter("i_roleid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_userid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_roleid;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEUSERROLE", parms);
        }

        public override void DeleteUsersOnline(int i_timewindow)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_timewindow", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_timewindow;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEUSERSONLINE", parms);
        }

        public override void DeleteUserOnline(int i_userid)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_userid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_userid;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "DELETEUSERONLINE", parms);
        }

        public override IDataReader GetAllUsers(int i_portalid, int i_pageindex, int i_pagesize)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_pageindex", OracleDbType.Int32), 
		    new OracleParameter("i_pagesize", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor),
              new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_pageindex;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_pagesize;
            parms[3].Direction = ParameterDirection.Output;
            parms[4].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETALLUSERS", parms);
        }

        public override IDataReader GetOnlineUser(int i_userid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_userid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_userid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETONLINEUSER", parms);
        }

        public override IDataReader GetOnlineUsers(int i_portalid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETONLINEUSERS", parms);
        }

        public override IDataReader GetPortalRoles(int i_portalid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPORTALROLES", parms);
        }

        public override IDataReader GetRole(int i_roleid, int i_portalid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_roleid", OracleDbType.Int32), 
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_roleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETROLE", parms);
        }

        public override IDataReader GetRoleByName(int i_portalid, string i_rolename)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_rolename", OracleDbType.NVarchar2), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_rolename;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETROLEBYNAME", parms);
        }

        public override IDataReader GetRoleGroup(int i_portalid, int i_rolegroupid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_rolegroupid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_rolegroupid;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETROLEGROUP", parms);
        }

        public override IDataReader GetRoleGroups(int i_portalid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETROLEGROUPS", parms);
        }

        public override IDataReader GetRoles()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETROLES", parms);
        }

        public override IDataReader GetRolesByGroup(int i_rolegroupid, int i_portalid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_rolegroupid", OracleDbType.Int32), 
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_rolegroupid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETROLESBYGROUP", parms);
        }

        public override IDataReader GetRolesByUser(int i_userid, int i_portalid)
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

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETROLESBYUSER", parms);
        }

        public override IDataReader GetServices(int i_portalid, int i_userid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_userid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_userid;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSERVICES", parms);
        }

        public override IDataReader GetSuperUsers()
        {
            OracleParameter[] parms = {
		      new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETSUPERUSERS", parms);
        }

        public override IDataReader GetUnAuthorizedUsers(int i_portalid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUNAUTHORIZEDUSERS", parms);
        }

        public override IDataReader GetUser(int i_portalid, int i_userid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_userid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_userid;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUSER", parms);
        }
        
        public override IDataReader GetUserByUsername(int i_portalid, string i_username)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32),
		    new OracleParameter("i_username", OracleDbType.NVarchar2), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUSERBYUSERNAME", parms);
        }

        public override int GetUserCountByPortal(int i_portalid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("o_usercount", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUSERCOUNTBYPORTAL", parms);
            return Convert.ToInt32(parms[1].Value.ToString());
        }

        public override IDataReader GetUserProfile(int i_userid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_userid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_userid;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUSERPROFILE", parms);
        }

        public override IDataReader GetUserRole(int i_portalid, int i_userid, int i_roleid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_userid", OracleDbType.Int32), 
		    new OracleParameter("i_roleid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_userid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_roleid;
            parms[3].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUSERROLE", parms);
        }

        public override IDataReader GetUserRoles(int i_portalid, int i_userid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_userid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_userid;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUSERROLES", parms);
        }

        public override IDataReader GetUserRolesByUserId(int i_portalid, int i_userid, int i_roleid, int i_pageindex, int i_pagesize)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_userid", OracleDbType.Int32), 
		    new OracleParameter("i_roleid", OracleDbType.Int32), 
		    new OracleParameter("i_pageindex", OracleDbType.Int32), 
		    new OracleParameter("i_pagesize", OracleDbType.Int32),  
		    new OracleParameter("o_rc1", OracleDbType.RefCursor),
              new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_userid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_roleid);
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_pageindex;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_pagesize;
            parms[5].Direction = ParameterDirection.Output;
            parms[6].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUSERROLESBYUSERID", parms);
        }

        public override IDataReader GetUsers(int i_portalid)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUSERS", parms);
        }

        public override IDataReader GetUsersByEmail(int i_portalid, string i_emailtomatch, int i_pageindex, int i_pagesize)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_emailtomatch", OracleDbType.NVarchar2), 
		    new OracleParameter("i_pageindex", OracleDbType.Int32), 
		    new OracleParameter("i_pagesize", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor),
		    new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_emailtomatch;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_pageindex;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_pagesize;
            parms[4].Direction = ParameterDirection.Output;
            parms[5].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUSERSBYEMAIL", parms);
        }

        public override IDataReader GetUsersByProfileProperty(int i_portalid, string i_propertyname, string i_propertyvalue, int i_pageindex, int i_pagesize)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_propertyname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_propertyvalue", OracleDbType.NVarchar2), 
		    new OracleParameter("i_pageindex", OracleDbType.Int32), 
		    new OracleParameter("i_pagesize", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor),
		    new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_propertyname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_propertyvalue;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_pageindex;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_pagesize;
            parms[5].Direction = ParameterDirection.Output;
            parms[6].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUSERSBYPROFILEPROPERTY", parms);
        }
        
        public override IDataReader GetUsersByRolename(int i_portalid, string i_rolename)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_rolename", OracleDbType.NVarchar2), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_rolename;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUSERSBYROLENAME", parms);
        }

        public override IDataReader GetUsersByUsername(int i_portalid, string i_usernametomatch, int i_pageindex, int i_pagesize)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_usernametomatch", OracleDbType.NVarchar2), 
		    new OracleParameter("i_pageindex", OracleDbType.Int32), 
		    new OracleParameter("i_pagesize", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor),
		    new OracleParameter("o_totalrecords", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = GetNull(i_portalid);
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_usernametomatch;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_pageindex;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_pagesize;
            parms[4].Direction = ParameterDirection.Output;
            parms[5].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETUSERSBYUSERNAME", parms);
        }

        public override void UpdateRole(int i_roleid, int i_rolegroupid, string i_description, float i_servicefee, string i_billingperiod, string i_billingfrequency, float i_trialfee, int i_trialperiod, string i_trialfrequency, bool i_ispublic, bool i_autoassignment, string i_rsvpcode, string i_iconfile)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_roleid", OracleDbType.Int32), 
		    new OracleParameter("i_rolegroupid", OracleDbType.Int32), 
		    new OracleParameter("i_description", OracleDbType.NVarchar2), 
		    new OracleParameter("i_servicefee", OracleDbType.Int32), 
		    new OracleParameter("i_billingperiod", OracleDbType.Int32), 
		    new OracleParameter("i_billingfrequency", OracleDbType.Char), 
		    new OracleParameter("i_trialfee", OracleDbType.Int32), 
		    new OracleParameter("i_trialperiod", OracleDbType.Int32), 
		    new OracleParameter("i_trialfrequency", OracleDbType.Char), 
		    new OracleParameter("i_ispublic", OracleDbType.Int32), 
		    new OracleParameter("i_autoassignment", OracleDbType.Int32), 
		    new OracleParameter("i_rsvpcode", OracleDbType.NVarchar2), 
		    new OracleParameter("i_iconfile", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_roleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_rolegroupid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_description;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_servicefee;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = int.Parse(i_billingperiod);
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = GetNull(i_billingfrequency);
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_trialfee;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_trialperiod;
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = GetNull(i_trialfrequency);
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_ispublic ? 1 : 0;
            parms[10].Direction = ParameterDirection.Input;
            parms[10].Value = i_autoassignment ? 1 : 0;
            parms[11].Direction = ParameterDirection.Input;
            parms[11].Value = i_rsvpcode;
            parms[12].Direction = ParameterDirection.Input;
            parms[12].Value = i_iconfile;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEROLE", parms);
        }

        public override void UpdateRoleGroup(int i_rolegroupid, string i_rolegroupname, string i_description)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_rolegroupid", OracleDbType.Int32), 
		    new OracleParameter("i_rolegroupname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_description", OracleDbType.NVarchar2)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_rolegroupid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_rolegroupname;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_description;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEROLEGROUP", parms);
        }
        
        public override void UpdateUser(int i_userid, int i_portalid, string i_firstname, string i_lastname, string i_email, string i_displayname, bool i_updatepassword, bool i_authorised)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_userid", OracleDbType.Int32), 
		    new OracleParameter("i_portalid", OracleDbType.Int32), 
		    new OracleParameter("i_firstname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_lastname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_email", OracleDbType.NVarchar2), 
		    new OracleParameter("i_displayname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_updatepassword", OracleDbType.Int32), 
		    new OracleParameter("i_authorised", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_userid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_portalid);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_firstname;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_lastname;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_email;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_displayname;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_updatepassword ? 1 : 0;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_authorised ? 1 : 0;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEUSER", parms);
        }

        public override void UpdateProfileProperty(int i_profileid, int i_userid, int i_propertydefinitionid, string i_propertyvalue, int i_visibility, DateTime i_lastupdateddate)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_profileid", OracleDbType.Int32), 
		    new OracleParameter("i_userid", OracleDbType.Int32), 
		    new OracleParameter("i_propertydefinitionid", OracleDbType.Int32), 
		    new OracleParameter("i_propertyvalue", OracleDbType.NClob), 
		    new OracleParameter("i_visibility", OracleDbType.Int32), 
		    new OracleParameter("i_lastupdateddate", OracleDbType.Date), 
		    new OracleParameter("o_profileid", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_profileid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_userid;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_propertydefinitionid;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_propertyvalue;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_visibility;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = GetNull(i_lastupdateddate);
            parms[6].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEUSERPROFILEPROPERTY", parms);
        }

        public override void UpdateUserRole(int i_userroleid, DateTime i_effectivedate, DateTime i_expirydate)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_userroleid", OracleDbType.Int32), 
		      new OracleParameter("i_effectivedate", OracleDbType.Date), 
		      new OracleParameter("i_expirydate", OracleDbType.Date)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_userroleid;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = GetNull(i_effectivedate);
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_expirydate);

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEUSERROLE", parms);
        }

        public override void UpdateUsersOnline(Hashtable userList)
        {
            if (userList.Count == 0)
            {
                //No users to process, quit method
                return;
            }
            foreach (string key in userList.Keys)
            {
                if (userList[key] is AnonymousUserInfo)
                {
                    AnonymousUserInfo user = (AnonymousUserInfo)userList[key];
                    OracleParameter[] parms = {
				    new OracleParameter("i_userid", OracleDbType.Char), 
				    new OracleParameter("i_portalid", OracleDbType.Int32), 
				    new OracleParameter("i_tabid", OracleDbType.Int32), 
				    new OracleParameter("i_lastactivedate", OracleDbType.Date)};
                    parms[0].Direction = ParameterDirection.Input;
                    parms[0].Value = user.UserID;
                    parms[1].Direction = ParameterDirection.Input;
                    parms[1].Value = user.PortalID;
                    parms[2].Direction = ParameterDirection.Input;
                    parms[2].Value = user.TabID;
                    parms[3].Direction = ParameterDirection.Input;
                    parms[3].Value = GetNull(user.LastActiveDate);

                    OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEANONYMOUSUSER", parms);
                }
                else if (userList[key] is OnlineUserInfo)
                {
                    OnlineUserInfo user = (OnlineUserInfo)userList[key];
                    OracleParameter[] parms = {
				    new OracleParameter("i_userid", OracleDbType.Int32), 
				    new OracleParameter("i_portalid", OracleDbType.Int32), 
				    new OracleParameter("i_tabid", OracleDbType.Int32), 
				    new OracleParameter("i_lastactivedate", OracleDbType.Date)};
                    parms[0].Direction = ParameterDirection.Input;
                    parms[0].Value = user.UserID;
                    parms[1].Direction = ParameterDirection.Input;
                    parms[1].Value = user.PortalID;
                    parms[2].Direction = ParameterDirection.Input;
                    parms[2].Value = user.TabID;
                    parms[3].Direction = ParameterDirection.Input;
                    parms[3].Value = GetNull(user.LastActiveDate);

                    OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATEONLINEUSER", parms);
                }
            }
        }

        #region "Oracle MemberShipProvider Methods"

        public override IDataReader AspNetMembershipGetUserByName(string i_applicationname, string i_username, DateTime i_currenttimeutc, int i_updatelastactivity)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_username", OracleDbType.NVarchar2), 
		    new OracleParameter("i_currenttimeutc", OracleDbType.Date), 
		    new OracleParameter("i_updatelastactivity", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor), 
		    new OracleParameter("o_returnvalue", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = GetNull(i_currenttimeutc);
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_updatelastactivity;
            parms[4].Direction = ParameterDirection.Output;
            parms[5].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_GETBYNAME", parms);
        }

        public override bool AspNetMembershipSetPassword(string i_applicationname, string i_username, string i_newpassword, string i_passwordsalt, DateTime i_currenttimeutc, int i_passwordformat)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_username", OracleDbType.NVarchar2), 
		    new OracleParameter("i_newpassword", OracleDbType.NVarchar2), 
		    new OracleParameter("i_passwordsalt", OracleDbType.NVarchar2), 
		    new OracleParameter("i_currenttimeutc", OracleDbType.Date), 
		    new OracleParameter("i_passwordformat", OracleDbType.Int32), 
		    new OracleParameter("o_returnvalue", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_newpassword;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_passwordsalt;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_currenttimeutc;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_passwordformat;
            parms[6].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_SETPASSWORD", parms);
            return Convert.ToInt32(parms[6].Value.ToString()) == 1 ? true : false;
        }

        public override bool AspNetMembershipSetPasswordQAndA(string i_applicationname, string i_username, string i_newpasswordquestion, string i_passwordanswer)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_username", OracleDbType.NVarchar2), 
		    new OracleParameter("i_newpasswordquestion", OracleDbType.NVarchar2), 
		    new OracleParameter("i_passwordanswer", OracleDbType.NVarchar2),
		    new OracleParameter("o_returnvalue", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_newpasswordquestion;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_passwordanswer;
            parms[4].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_SETPWDQANDA", parms);
            return Convert.ToInt32(parms[4].Value.ToString()) == 1 ? true : false;
        }

        public override int AspNetMembershipResetPwd(string i_applicationname, string i_username, string i_newpassword, int i_maxinvalidpasswordattempts, int i_passwordattemptwindow, string i_passwordsalt, DateTime i_currenttimeutc, int i_passwordformat)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_username", OracleDbType.NVarchar2), 
		    new OracleParameter("i_newpassword", OracleDbType.NVarchar2), 
		    new OracleParameter("i_maxinvalidpasswordattempts", OracleDbType.Int32), 
		    new OracleParameter("i_passwordattemptwindow", OracleDbType.Int32), 
		    new OracleParameter("i_passwordsalt", OracleDbType.NVarchar2), 
		    new OracleParameter("i_currenttimeutc", OracleDbType.Date), 
		    new OracleParameter("i_passwordformat", OracleDbType.Int32), 
		    new OracleParameter("o_returnvalue", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_newpassword;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_maxinvalidpasswordattempts;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_passwordattemptwindow;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_passwordsalt;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_currenttimeutc;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = i_passwordformat;
            parms[8].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_RESETPWD", parms);
            return Convert.ToInt32(parms[8].Value.ToString());
        }

        public override int AspNetMembershipUserExists(string i_applicationname, string i_username)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_username", OracleDbType.NVarchar2),
              new OracleParameter("o_returnvalue", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_USEREXISTS", parms);
            return Convert.ToInt32(parms[2].Value.ToString());
        }

        public override Guid AspNetMembershipCreateUser(string i_applicationname, string i_username, string i_password, string i_passwordsalt, string i_email, string i_passwordquestion, string i_passwordanswer, bool i_isapproved, DateTime i_currenttimeutc, DateTime i_createdate, bool i_uniqueemail, int i_passwordformat)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		        new OracleParameter("i_username", OracleDbType.NVarchar2), 
		        new OracleParameter("i_password", OracleDbType.NVarchar2), 
		        new OracleParameter("i_passwordsalt", OracleDbType.NVarchar2), 
		        new OracleParameter("i_email", OracleDbType.NVarchar2), 
		        new OracleParameter("i_passwordquestion", OracleDbType.NVarchar2), 
		        new OracleParameter("i_passwordanswer", OracleDbType.NVarchar2), 
		        new OracleParameter("i_isapproved", OracleDbType.Int32), 
		        new OracleParameter("i_currenttimeutc", OracleDbType.Date), 
		        new OracleParameter("i_createdate", OracleDbType.Date), 
		        new OracleParameter("i_uniqueemail", OracleDbType.Int32), 
		        new OracleParameter("i_passwordformat", OracleDbType.Int32), 
		        new OracleParameter("o_userid", OracleDbType.NVarchar2, 51),
                  new OracleParameter("o_returnvalue", OracleDbType.Int32)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_applicationname;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = i_username;
	        parms[2].Direction = ParameterDirection.Input;
	        parms[2].Value = i_password;
	        parms[3].Direction = ParameterDirection.Input;
	        parms[3].Value = i_passwordsalt;
	        parms[4].Direction = ParameterDirection.Input;
	        parms[4].Value = i_email;
	        parms[5].Direction = ParameterDirection.Input;
	        parms[5].Value = i_passwordquestion;
	        parms[6].Direction = ParameterDirection.Input;
	        parms[6].Value = i_passwordanswer;
	        parms[7].Direction = ParameterDirection.Input;
	        parms[7].Value = i_isapproved ? 1 : 0;
	        parms[8].Direction = ParameterDirection.Input;
	        parms[8].Value = GetNull(i_currenttimeutc);
	        parms[9].Direction = ParameterDirection.Input;
	        parms[9].Value = GetNull(i_createdate);
	        parms[10].Direction = ParameterDirection.Input;
	        parms[10].Value = i_uniqueemail ? 1 : 0;
	        parms[11].Direction = ParameterDirection.Input;
	        parms[11].Value = i_passwordformat;
	        parms[12].Direction = ParameterDirection.Output;
             parms[13].Direction = ParameterDirection.Output;
             
             OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_CREATEUSER", parms);
             return new Guid(parms[12].Value.ToString());
        }

        public override int AspNetMembershipEmailExists(string i_applicationname, string i_email)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_email", OracleDbType.NVarchar2),
              new OracleParameter("o_returnvalue", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_email;
            parms[2].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_EMAILEXISTS", parms);
            return Convert.ToInt32(parms[2].Value.ToString());
        }

        public override int AspNetMembershipUsrKeyExists(string i_applicationname, object i_userkey)
        {
	        OracleParameter[] parms = {
		        new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		        new OracleParameter("i_userkey", OracleDbType.NVarchar2),
                  new OracleParameter("o_returnvalue", OracleDbType.Int32)};
	        parms[0].Direction = ParameterDirection.Input;
	        parms[0].Value = i_applicationname;
	        parms[1].Direction = ParameterDirection.Input;
	        parms[1].Value = i_userkey;
             parms[2].Direction = ParameterDirection.Output;

             OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_USRKEYEXISTS", parms);
             return Convert.ToInt32(parms[2].Value.ToString());
        }

        public override Guid AspNetApplicationGetAppId(string i_applicationname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_applicationname", OracleDbType.NVarchar2),
                new OracleParameter("o_returnvalue", OracleDbType.NVarchar2, 51)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "APPLICATIONS_GETAPPID", parms);
            return new Guid(parms[1].Value.ToString());
        }

        public override Guid AspNetApplicationCreateApp(string i_applicationname)
        {
            OracleParameter[] parms = {
		      new OracleParameter("i_applicationname", OracleDbType.NVarchar2),
                new OracleParameter("o_applicationid", OracleDbType.NVarchar2, 51)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "APPLICATIONS_CREATEAPP", parms);
            return new Guid(parms[1].Value.ToString());
        }

        public override bool AspNetUsersDeleteUser(string i_applicationname, string i_username)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_username", OracleDbType.NVarchar2), 
		    new OracleParameter("i_tablestodeletefrom", OracleDbType.Int32), 
		    new OracleParameter("i_numtablesdeletedfrom", OracleDbType.Int32),
              new OracleParameter("o_returnvalue", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = DBNull.Value;
            parms[3].Direction = ParameterDirection.Output;
            parms[4].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "USERS_DELETEUSER", parms);
            return Convert.ToInt32(parms[4].Value.ToString()) == 0 ? true : false;
        }

        public override int AspNetMembershipUpdateMemberInfo(string i_applicationname, string i_username, int i_updatepwdattempts, int i_iscorrect, int i_updatelastloginactivitydate, int i_maxinvalidattempts, int i_attemptwindow, DateTime i_currenttime, DateTime i_lastlogindate, DateTime i_lastactivitydate)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_username", OracleDbType.NVarchar2),
              new OracleParameter("i_updatepwdattempts", OracleDbType.Int32), 
		    new OracleParameter("i_iscorrect", OracleDbType.Int32), 
		    new OracleParameter("i_updatelastloginactivitydate", OracleDbType.Int32), 
		    new OracleParameter("i_maxinvalidattempts", OracleDbType.Int32), 
		    new OracleParameter("i_attemptwindow", OracleDbType.Int32), 
		    new OracleParameter("i_currenttime", OracleDbType.Date), 
		    new OracleParameter("i_lastlogindate", OracleDbType.Date), 
		    new OracleParameter("i_lastactivitydate", OracleDbType.Date),
              new OracleParameter("i_returnvalue", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_updatepwdattempts;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_iscorrect;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = i_updatelastloginactivitydate;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_maxinvalidattempts;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = i_attemptwindow;
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = GetNull(i_currenttime);
            parms[8].Direction = ParameterDirection.Input;
            parms[8].Value = GetNull(i_lastlogindate);
            parms[9].Direction = ParameterDirection.Input;
            parms[9].Value = i_lastactivitydate;
            parms[10].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_UPDATEINFO", parms);
            return Convert.ToInt32(parms[10].Value.ToString());

        }

        public override bool AspNetMembershipUnlockUser(string i_applicationname, string i_username)
        {
            OracleParameter[] parms = {
		new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		new OracleParameter("i_username", OracleDbType.NVarchar2),
          new OracleParameter("o_returnvalue", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_UNLOCKUSER", parms);
            return Convert.ToInt32(parms[2].Value.ToString()) == 1 ? true : false;
        }

        public override IDataReader AspNetMembershipGetAnswer(string i_applicationname, string i_username)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_username", OracleDbType.NVarchar2), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_GETANSWER", parms);
        }

        public override IDataReader AspNetMembershipGetPassword(string i_applicationname, string i_username)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_username", OracleDbType.NVarchar2), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_GETPASSWORD", parms);
        }

        public override void AspNetMembershipUpdateUser(string i_applicationname, string i_username, string i_email, bool i_requiresuniqueemail, string i_comment, bool i_isapproved, DateTime i_lastlogindate, DateTime i_lastactivitydate)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_applicationname", OracleDbType.NVarchar2), 
		    new OracleParameter("i_username", OracleDbType.NVarchar2), 
		    new OracleParameter("i_email", OracleDbType.NVarchar2), 
		    new OracleParameter("i_requiresuniqueemail", OracleDbType.Int32), 
		    new OracleParameter("i_comment", OracleDbType.NClob), 
		    new OracleParameter("i_isapproved", OracleDbType.Int32), 
		    new OracleParameter("i_lastlogindate", OracleDbType.Date), 
		    new OracleParameter("i_lastactivitydate", OracleDbType.Date),
              new OracleParameter("o_returnvalue", OracleDbType.Int32)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_applicationname;
            parms[1].Direction = ParameterDirection.Input;
            parms[1].Value = i_username;
            parms[2].Direction = ParameterDirection.Input;
            parms[2].Value = i_email;
            parms[3].Direction = ParameterDirection.Input;
            parms[3].Value = i_requiresuniqueemail ? 1 : 0;
            parms[4].Direction = ParameterDirection.Input;
            parms[4].Value = String.IsNullOrEmpty(i_comment) ? "" : i_comment;
            parms[5].Direction = ParameterDirection.Input;
            parms[5].Value = i_isapproved ? 1 : 0;
            parms[6].Direction = ParameterDirection.Input;
            parms[6].Value = GetNull(i_lastlogindate);
            parms[7].Direction = ParameterDirection.Input;
            parms[7].Value = GetNull(i_lastactivitydate);
            parms[8].Direction = ParameterDirection.Output;

            OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + AspnetProviderPackageName + "MEMBERSHIP_UPDATEUSER", parms);
        }

        #endregion

        public override IDataReader GetPasswordQuestons(string i_locale)
        {
            OracleParameter[] parms = {
		    new OracleParameter("i_locale", OracleDbType.NVarchar2),
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
            parms[0].Direction = ParameterDirection.Input;
            parms[0].Value = i_locale;
            parms[1].Direction = ParameterDirection.Output;

            return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETPASSWORDQUESTIONS", parms);
        }
    }
}