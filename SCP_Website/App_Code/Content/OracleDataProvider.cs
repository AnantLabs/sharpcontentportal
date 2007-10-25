//
// Sharp Content Portal - http://www.sharpcontentportal.com
// Copyright (c) 2002-2005
// by Perpetual Motion Interactive Systems Inc. ( http://www.perpetualmotion.ca )
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
//

using System;
using System.Data;
using Oracle.DataAccess.Client;
using SharpContent.ApplicationBlocks.Data;
using SharpContent.Common.Utilities;

namespace SharpContent.Modules.Content
{

	/// -----------------------------------------------------------------------------
	/// <summary>
	/// The OracleDataProvider Class is an Oracle implementation of the DataProvider Abstract
	/// class that provides the DataLayer for the HTML Module.
	/// </summary>
	/// <remarks>
	/// </remarks>
	/// <history>
	/// </history>
	/// -----------------------------------------------------------------------------
	public class OracleDataProvider : DataProvider
	{


	    #region "Private Members"

	    private const string ProviderType = "data";

	    private Framework.Providers.ProviderConfiguration _providerConfiguration = Framework.Providers.ProviderConfiguration.GetProviderConfiguration(ProviderType);
	    private string _connectionString;
	    private string _providerPath;
	    private string _databaseOwner;
          private string _packageName;

	    #endregion

	    #region "Constructors"

	    public OracleDataProvider()
	    {

		    // Read the configuration specific information for this provider
		    Framework.Providers.Provider objProvider = (Framework.Providers.Provider)_providerConfiguration.Providers[_providerConfiguration.DefaultProvider];

		    // Read the attributes for this provider
		    _connectionString = Config.GetConnectionString();

		    _providerPath = objProvider.Attributes["providerPath"];

		    _databaseOwner = objProvider.Attributes["databaseOwner"];
		    if (_databaseOwner != "" & _databaseOwner.EndsWith(".") == false)
		    {
			    _databaseOwner += ".";
		    }
               _packageName = "scp_htmltext_pkg.scp_";
	    }

	    #endregion

	    #region "Properties"

	    public string ConnectionString {
		    get { return _connectionString; }
	    }

	    public string ProviderPath {
		    get { return _providerPath; }
	    }

          public string PackageName {
               get { return _packageName; }
	    }

          public string DatabaseOwner
          {
               get { return _databaseOwner; }
          }

	    #endregion

	    #region "Public Methods"

	    private object GetNull(object Field)
	    {
		    return Common.Utilities.Null.GetNull(Field, DBNull.Value);
	    }

         public override void AddContent(int i_contentid, int i_moduleid, string i_desktophtml, string i_desktopsummary, int i_userid, bool i_publish)
         {
             OracleParameter[] parms = {
              new OracleParameter("i_contentid", OracleDbType.Int32),
		    new OracleParameter("i_moduleid", OracleDbType.Int32), 
		    new OracleParameter("i_desktophtml", OracleDbType.NClob), 
		    new OracleParameter("i_desktopsummary", OracleDbType.NClob), 
		    new OracleParameter("i_userid", OracleDbType.Int32),
              new OracleParameter("i_publish", OracleDbType.Int32)};
             parms[0].Direction = ParameterDirection.Input;
             parms[0].Value = i_contentid;
             parms[1].Direction = ParameterDirection.Input;
             parms[1].Value = i_moduleid;
             parms[2].Direction = ParameterDirection.Input;
             parms[2].Value = i_desktophtml;
             parms[3].Direction = ParameterDirection.Input;
             parms[3].Value = i_desktopsummary;
             parms[4].Direction = ParameterDirection.Input;
             parms[4].Value = i_userid;
             parms[5].Direction = ParameterDirection.Input;
             parms[5].Value = i_publish == true ? 1 : 0;

             OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "ADDCONTENT", parms);
         }

         public override IDataReader GetContentVersions(int i_moduleid)
         {
             OracleParameter[] parms = {
		    new OracleParameter("i_moduleid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
             parms[0].Direction = ParameterDirection.Input;
             parms[0].Value = i_moduleid;
             parms[1].Direction = ParameterDirection.Output;

             return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETCONTENTVERSIONS", parms);
         }

         public override IDataReader GetContent(int i_moduleid)
         {
             OracleParameter[] parms = {
		    new OracleParameter("i_moduleid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
             parms[0].Direction = ParameterDirection.Input;
             parms[0].Value = i_moduleid;
             parms[1].Direction = ParameterDirection.Output;

             return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETCONTENT", parms);
         }

         public override IDataReader GetContentById(int i_contentid)
         {
             OracleParameter[] parms = {
		    new OracleParameter("i_contentid", OracleDbType.Int32), 
		    new OracleParameter("o_rc1", OracleDbType.RefCursor)};
             parms[0].Direction = ParameterDirection.Input;
             parms[0].Value = i_contentid;
             parms[1].Direction = ParameterDirection.Output;

             return OracleHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "GETCONTENTBYID", parms);
         }

         public override void UpdateContent(int i_contentid, string i_desktophtml, string i_desktopsummary, int i_userid, bool i_publish)
         {
             OracleParameter[] parms = {
		    new OracleParameter("i_contentid", OracleDbType.Int32),
              new OracleParameter("i_moduleid", OracleDbType.Int32), 
		    new OracleParameter("i_desktophtml", OracleDbType.NClob), 
		    new OracleParameter("i_desktopsummary", OracleDbType.NClob), 
		    new OracleParameter("i_userid", OracleDbType.Int32),
              new OracleParameter("i_publish", OracleDbType.Int32)};
             parms[0].Direction = ParameterDirection.Input;
             parms[0].Value = i_contentid;
             parms[1].Direction = ParameterDirection.Input;
             parms[1].Value = i_desktophtml;
             parms[2].Direction = ParameterDirection.Input;
             parms[2].Value = i_desktopsummary;
             parms[3].Direction = ParameterDirection.Input;
             parms[3].Value = i_userid;
             parms[4].Direction = ParameterDirection.Input;
             parms[4].Value = i_publish == true ? 1 : 0;

             OracleHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, DatabaseOwner + PackageName + "UPDATECONTENT", parms);
         }

		#endregion

	}

}
