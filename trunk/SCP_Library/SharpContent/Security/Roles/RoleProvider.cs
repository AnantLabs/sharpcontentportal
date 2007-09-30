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
using System.Collections;
using SharpContent.Entities.Users;
using SharpContent.Framework;

namespace SharpContent.Security.Roles
{
    public abstract class RoleProvider
    {
        // singleton reference to the instantiated object
        private static RoleProvider objProvider = null;

        // constructor
        static RoleProvider()
        {
            CreateProvider();
        }

        // dynamically create provider
        private static void CreateProvider()
        {
            objProvider = (RoleProvider)Reflection.CreateObject( "roles" );
        }

        // return the provider
        public new static RoleProvider Instance()
        {
            return objProvider;
        }

        //Roles
        public abstract bool CreateRole( int portalId, ref RoleInfo role );
        public abstract void DeleteRole( int portalId, ref RoleInfo role );
        public abstract RoleInfo GetRole( int portalId, int roleId );
        public abstract RoleInfo GetRole( int portalId, string roleName );
        public abstract string[] GetRoleNames( int portalId );
        public abstract string[] GetRoleNames( int portalId, int userId );
        public abstract ArrayList GetRoles( int portalId );
        public abstract ArrayList GetRolesByGroup( int portalId, int roleGroupId );
        public abstract void UpdateRole( RoleInfo role );

        //Role Groups
        public abstract int CreateRoleGroup( RoleGroupInfo roleGroup );
        public abstract void DeleteRoleGroup( RoleGroupInfo roleGroup );
        public abstract RoleGroupInfo GetRoleGroup( int portalId, int roleGroupId );
        public abstract ArrayList GetRoleGroups( int portalId );
        public abstract void UpdateRoleGroup( RoleGroupInfo roleGroup );

        //User Roles
        public abstract bool AddUserToRole( int portalId, UserInfo user, UserRoleInfo userRole );
        public abstract UserRoleInfo GetUserRole( int portalId, int userId, int roleId );
        public abstract ArrayList GetUserRoles( int portalId, int userId, bool includePrivate );
        public abstract ArrayList GetUserRoles(int portalId, int userId, int roleId, int pageIndex, int pageSize, ref int totalRecords);
        public abstract ArrayList GetUsersByRoleName( int portalId, string roleName );
        public abstract ArrayList GetUserRolesByRoleId(int portalId, int roleId, int pageIndex, int pageSize, ref int totalRecords);
        public abstract void RemoveUserFromRole( int portalId, UserInfo user, UserRoleInfo userRole );
        public abstract void UpdateUserRole( UserRoleInfo userRole );
    }
}