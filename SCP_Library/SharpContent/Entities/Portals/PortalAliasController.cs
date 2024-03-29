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
using SharpContent.Common.Utilities;
using SharpContent.Data;

namespace SharpContent.Entities.Portals
{
    public class PortalAliasController
    {
        public int AddPortalAlias(PortalAliasInfo objPortalAliasInfo)
        {
            SharpContent.Common.Utilities.DataCache.ClearHostCache(false);

            return SharpContent.Data.DataProvider.Instance().AddPortalAlias(objPortalAliasInfo.PortalID, objPortalAliasInfo.HTTPAlias);
        }

        public PortalAliasInfo GetPortalAlias(string PortalAlias, int PortalID)
        {
            return ((PortalAliasInfo)SharpContent.Common.Utilities.CBO.FillObject(SharpContent.Data.DataProvider.Instance().GetPortalAlias(PortalAlias, PortalID), typeof(PortalAliasInfo)));
        }

        public ArrayList GetPortalAliasArrayByPortalID(int PortalID)
        {
            IDataReader dr = SharpContent.Data.DataProvider.Instance().GetPortalAliasByPortalID(PortalID);
            try
            {
                ArrayList arr = new ArrayList();
                while (dr.Read())
                {
                    PortalAliasInfo objPortalAliasInfo = new PortalAliasInfo();
                    objPortalAliasInfo.PortalAliasID = Convert.ToInt32(dr["PortalAliasID"]);
                    objPortalAliasInfo.PortalID = Convert.ToInt32(dr["PortalID"]);
                    objPortalAliasInfo.HTTPAlias = Convert.ToString(dr["HTTPAlias"]).ToLower();
                    arr.Add(objPortalAliasInfo);
                }
                return arr;
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public PortalAliasInfo GetPortalAliasByPortalAliasID(int PortalAliasID)
        {
            return ((PortalAliasInfo)SharpContent.Common.Utilities.CBO.FillObject((SharpContent.Data.DataProvider.Instance().GetPortalAliasByPortalAliasID(PortalAliasID)), typeof(PortalAliasInfo)));
        }

        public PortalAliasCollection GetPortalAliasByPortalID(int PortalID)
        {
            IDataReader dr = SharpContent.Data.DataProvider.Instance().GetPortalAliasByPortalID(PortalID);
            try
            {
                PortalAliasCollection objPortalAliasCollection = new PortalAliasCollection();
                while (dr.Read())
                {
                    PortalAliasInfo objPortalAliasInfo = new PortalAliasInfo();
                    objPortalAliasInfo.PortalAliasID = Convert.ToInt32(dr["PortalAliasID"]);
                    objPortalAliasInfo.PortalID = Convert.ToInt32(dr["PortalID"]);
                    objPortalAliasInfo.HTTPAlias = Convert.ToString(dr["HTTPAlias"]);
                    objPortalAliasCollection.Add(Convert.ToString(dr["HTTPAlias"]).ToLower(), objPortalAliasInfo);
                }
                return objPortalAliasCollection;
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
        }

        public PortalAliasCollection GetPortalAliases()
        {
            return GetPortalAliasByPortalID(-1);
        }

        public PortalInfo GetPortalByPortalAliasID(int PortalAliasId)
        {
            return ((PortalInfo)SharpContent.Common.Utilities.CBO.FillObject(SharpContent.Data.DataProvider.Instance().GetPortalByPortalAliasID(PortalAliasId), typeof(PortalInfo)));
        }

        public void DeletePortalAlias(int PortalAliasID)
        {
            SharpContent.Common.Utilities.DataCache.ClearHostCache(false);

            SharpContent.Data.DataProvider.Instance().DeletePortalAlias(PortalAliasID);
        }

        public void UpdatePortalAliasInfo(PortalAliasInfo objPortalAliasInfo)
        {
            SharpContent.Common.Utilities.DataCache.ClearHostCache(false);

            SharpContent.Data.DataProvider.Instance().UpdatePortalAliasInfo(objPortalAliasInfo.PortalAliasID, objPortalAliasInfo.PortalID, objPortalAliasInfo.HTTPAlias);
        }
    }
}