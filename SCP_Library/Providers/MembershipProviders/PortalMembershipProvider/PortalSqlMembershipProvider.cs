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
using System.Web;
using AspNetSecurity = System.Web.Security;

namespace SharpContent.Security.Membership
{
    /// Project:    SharpContent
    /// Namespace:  SharpContent.Security.Membership
    /// Class:      PortalSQLMembershipProvider
    /// <summary>
    /// The AspNetSQLMembershipProvider overrides the default SqlMembershipProvider of
    /// the AspNet Membership Component (MemberRole)
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <history>
    ///     [cnurse]	12/08/2005	documented, and renamed to meet new provider mechanism
    /// </history>
    public class PortalSqlMembershipProvider : System.Web.Security.SqlMembershipProvider
    {
        /// <summary>
        /// The ApplicationName is used by the AspNet Membership Component (MemberRole)
        /// to segregate the users between Applications.
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <history>
        ///     [cnurse]	12/08/2005	documented
        /// </history>
        public override string ApplicationName
        {
            get
            {
                if( Convert.ToString( HttpContext.Current.Items["ApplicationName"] ) == "" )
                {
                    return "/";
                }
                else
                {
                    return Convert.ToString( HttpContext.Current.Items["ApplicationName"] );
                }
            }
            set
            {
                HttpContext.Current.Items["ApplicationName"] = value;
            }
        }
    }
}