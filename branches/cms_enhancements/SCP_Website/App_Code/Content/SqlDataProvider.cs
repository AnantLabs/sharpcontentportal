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
    public class SqlDataProvider : DataProvider
    {


        #region "Private Members"

        private const string ProviderType = "data";

        private Framework.Providers.ProviderConfiguration _providerConfiguration = Framework.Providers.ProviderConfiguration.GetProviderConfiguration(ProviderType);
        private string _connectionString;
        private string _upgradeConnectionString;
        private string _providerPath;
        private string _objectQualifier;
        private string _databaseOwner;
        private string _packageName;

        #endregion

        #region "Constructors"

        public SqlDataProvider()
        {

            // Read the configuration specific information for this provider
            Framework.Providers.Provider _objProvider = (Framework.Providers.Provider)_providerConfiguration.Providers[_providerConfiguration.DefaultProvider];

            // Read the attributes for this provider

            //Get Connection string from web.config
            _connectionString = Config.GetConnectionString();

            if (_connectionString == "")
            {
                // Use connection string specified in provider
                _connectionString = _objProvider.Attributes["connectionString"];
            }

            _providerPath = _objProvider.Attributes["providerPath"];

            _objectQualifier = _objProvider.Attributes["objectQualifier"];
            if (!String.IsNullOrEmpty(_objectQualifier) && _objectQualifier.EndsWith("_") == false)
            {
                _objectQualifier += "_";
            }

            _databaseOwner = _objProvider.Attributes["databaseOwner"];
            if (!String.IsNullOrEmpty(_databaseOwner) && _databaseOwner.EndsWith(".") == false)
            {
                _databaseOwner += ".";
            }

            if (Convert.ToString(_objProvider.Attributes["upgradeConnectionString"]) != "")
            {
                _upgradeConnectionString = _objProvider.Attributes["upgradeConnectionString"];
            }
            else
            {
                _upgradeConnectionString = _connectionString;
            }
        }

        #endregion

        #region "Properties"

        public string ConnectionString
        {
            get { return _upgradeConnectionString; }
        }

        public string ProviderPath
        {
            get { return _providerPath; }
        }

        public string ObjectQualifier
        {
            get { return _objectQualifier; }
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

        public override int AddContent(int contentId, int moduleId, string desktopHtml, string desktopSummary, int userId, bool publish)
        {
            return Convert.ToInt32(SqlHelper.ExecuteScalar(ConnectionString, DatabaseOwner + ObjectQualifier + "AddContent", contentId, moduleId, desktopHtml, desktopSummary, userId, publish));
        }

        public override IDataReader GetContentVersions(int moduleId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "GetContentVersions", moduleId);
        }

        public override IDataReader GetContent(int moduleId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "GetContent", moduleId);
        }

        public override IDataReader GetContentById(int contentId)
        {
            return SqlHelper.ExecuteReader(ConnectionString, DatabaseOwner + ObjectQualifier + "GetContentById", contentId);
        }

        public override void UpdateContent(int contentId, string desktopHtml, string desktopSummary, int userId, bool publish)
        {
            SqlHelper.ExecuteNonQuery(ConnectionString, DatabaseOwner + ObjectQualifier + "UpdateContent", contentId, desktopHtml, desktopSummary, userId, publish);
        }
        #endregion

    }

}
