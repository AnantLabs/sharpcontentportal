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
using SharpContent.Entities.Users;
using SharpContent.Security.Membership.Data;
//using SharpContent.Security.Roles;
using SharpContent.Services.Exceptions;

namespace SharpContent.Security.Roles
{
    /// <summary>
    /// The PortalRoleProvider overrides the default MembershipProvider to provide
    /// a purely Portal Membership Component implementation
    /// </summary>
    /// <remarks>
    /// </remarks>
    /// <history>
    ///     [cnurse]	03/28/2006	created
    /// </history>
    public class PortalRoleProvider : RoleProvider
    {
        private static DataProvider dataProvider;

        static PortalRoleProvider()
        {
            dataProvider = DataProvider.Instance();
        }

        private RoleInfo FillRoleInfo(IDataReader dr)
        {
            return FillRoleInfo(dr, true);
        }

        private RoleInfo FillRoleInfo(IDataReader dr, bool CheckForOpenDataReader)
        {
            RoleInfo objRoleInfo = null;

            // read datareader
            bool canContinue = true;
            if (CheckForOpenDataReader)
            {
                canContinue = false;
                if (dr.Read())
                {
                    canContinue = true;
                }
            }
            if (canContinue)
            {
                objRoleInfo = new RoleInfo();
                objRoleInfo.RoleID = Convert.ToInt32(Null.SetNull(dr["RoleId"], objRoleInfo.RoleID));
                objRoleInfo.PortalID = Convert.ToInt32(Null.SetNull(dr["PortalID"], objRoleInfo.PortalID));
                objRoleInfo.RoleGroupID = Convert.ToInt32(Null.SetNull(dr["RoleGroupId"], objRoleInfo.RoleGroupID));
                objRoleInfo.RoleName = Convert.ToString(Null.SetNull(dr["RoleName"], objRoleInfo.RoleName));
                objRoleInfo.Description = Convert.ToString(Null.SetNull(dr["Description"], objRoleInfo.Description));
                objRoleInfo.ServiceFee = Convert.ToSingle(Null.SetNull(dr["ServiceFee"], objRoleInfo.ServiceFee));
                objRoleInfo.BillingPeriod = Convert.ToInt32(Null.SetNull(dr["BillingPeriod"], objRoleInfo.BillingPeriod));
                objRoleInfo.BillingFrequency = Convert.ToString(Null.SetNull(dr["BillingFrequency"], objRoleInfo.BillingFrequency));
                objRoleInfo.TrialFee = Convert.ToSingle(Null.SetNull(dr["TrialFee"], objRoleInfo.TrialFee));
                objRoleInfo.TrialPeriod = Convert.ToInt32(Null.SetNull(dr["TrialPeriod"], objRoleInfo.TrialPeriod));
                objRoleInfo.TrialFrequency = Convert.ToString(Null.SetNull(dr["TrialFrequency"], objRoleInfo.TrialFrequency));
                objRoleInfo.IsPublic = Convert.ToBoolean(Null.SetNull(dr["IsPublic"], objRoleInfo.IsPublic));
                objRoleInfo.AutoAssignment = Convert.ToBoolean(Null.SetNull(dr["AutoAssignment"], objRoleInfo.AutoAssignment));
                objRoleInfo.RSVPCode = Convert.ToString(Null.SetNull(dr["RSVPCode"], objRoleInfo.RSVPCode));
                objRoleInfo.IconFile = Convert.ToString(Null.SetNull(dr["IconFile"], objRoleInfo.IconFile));
            }

            return objRoleInfo;
        }

        private ArrayList FillRoleInfoCollection(IDataReader dr)
        {
            ArrayList arr = new ArrayList();
            try
            {
                RoleInfo obj = null;
                while (dr.Read())
                {
                    // fill business object
                    obj = FillRoleInfo(dr, false);
                    // add to collection
                    arr.Add(obj);
                }
            }
            catch (Exception exc)
            {
                Exceptions.LogException(exc);
            }
            finally
            {
                // close datareader
                if (dr != null)
                {
                    dr.Close();
                }
            }
            return arr;
        }

        /// <summary>
        /// adds a Portal UserRole
        /// </summary>
        /// <param name="userRole">The role to add the user to.</param>
        /// <returns>The added UserRoleInfo object</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        private UserRoleInfo AddPortalUserRole( UserRoleInfo userRole )
        {
            //Add UserRole to Portal
            userRole.UserRoleID = Convert.ToInt32( dataProvider.AddUserRole( userRole.PortalID, userRole.UserID, userRole.RoleID, userRole.EffectiveDate, userRole.ExpiryDate ) );
            userRole = GetUserRole( userRole.PortalID, userRole.UserID, userRole.RoleID );

            return userRole;
        }

        /// <summary>
        /// AddUserToRole adds a User to a Role
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <param name="portalId">Id of the portal</param>
        /// <param name="user">The user to add.</param>
        /// <param name="userRole">The role to add the user to.</param>
        /// <returns>A Boolean indicating success or failure.</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override bool AddUserToRole( int portalId, UserInfo user, UserRoleInfo userRole )
        {
            bool createStatus = true;

            try
            {
                //Add UserRole to Portal
                userRole = AddPortalUserRole( userRole );
            }
            catch( Exception )
            {
                //Clear User (duplicate User information)
                userRole = null;
                createStatus = false;
            }

            return createStatus;
        }

        /// <summary>
        /// CreateRole persists a Role to the Data Store
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <param name="portalId">Id of the portal</param>
        /// <param name="role">The role to persist to the Data Store.</param>
        /// <returns>A Boolean indicating success or failure.</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override bool CreateRole( int portalId, ref RoleInfo role )
        {
            bool createStatus = true;

            try
            {
                role.RoleID = Convert.ToInt32( dataProvider.AddRole( role.PortalID, role.RoleGroupID, role.RoleName, role.Description, role.ServiceFee, role.BillingPeriod.ToString(), role.BillingFrequency, role.TrialFee, role.TrialPeriod, role.TrialFrequency, role.IsPublic, role.AutoAssignment, role.RSVPCode, role.IconFile ) );
            }
            catch( Exception )
            {
                //Clear User (duplicate User information)
                role = null;
                createStatus = false;
            }

            return createStatus;
        }

        /// <summary>
        /// CreateRoleGroup persists a RoleGroup to the Data Store
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <param name="roleGroup">The RoleGroup to persist to the Data Store.</param>
        /// <returns>A Boolean indicating success or failure.</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override int CreateRoleGroup( RoleGroupInfo roleGroup )
        {
            roleGroup.RoleGroupID = Convert.ToInt32( dataProvider.AddRoleGroup( roleGroup.PortalID, roleGroup.RoleGroupName, roleGroup.Description ) );
            return 1;
        }

        /// <summary>
        /// GetRole gets a role from the Data Store
        /// </summary>
        /// <remarks>This overload gets the role by its ID</remarks>
        /// <param name="portalId">Id of the portal</param>
        /// <param name="roleId">The Id of the role to retrieve.</param>
        /// <returns>A RoleInfo object</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override RoleInfo GetRole(int portalId, int roleId)
        {
            RoleInfo role = null;
            IDataReader dr = dataProvider.GetRole(roleId, portalId);
            try
            {
                role = FillRoleInfo(dr);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
            return role;
        }

        /// <summary>
        /// GetRole gets a role from the Data Store
        /// </summary>
        /// <remarks>This overload gets the role by its name</remarks>
        /// <param name="portalId">Id of the portal</param>
        /// <param name="roleName">The name of the role to retrieve.</param>
        /// <returns>A RoleInfo object</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override RoleInfo GetRole(int portalId, string roleName)
        {
            RoleInfo role = null;
            IDataReader dr = dataProvider.GetRoleByName(portalId, roleName);
            try
            {
                role = FillRoleInfo(dr);
            }
            finally
            {
                if (dr != null)
                {
                    dr.Close();
                }
            }
            return role;
        }

        /// <summary>
        /// GetRoleGroup gets a RoleGroup from the Data Store
        /// </summary>
        /// <param name="portalId">Id of the portal</param>
        /// <param name="roleGroupId">The Id of the RoleGroup to retrieve.</param>
        /// <returns>A RoleGroupInfo object</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override RoleGroupInfo GetRoleGroup( int portalId, int roleGroupId )
        {
            return ( (RoleGroupInfo)CBO.FillObject( dataProvider.GetRoleGroup( portalId, roleGroupId ), typeof( RoleGroupInfo ) ) );
        }

        /// <summary>
        /// Get the RoleGroups for a portal
        /// </summary>
        /// <param name="portalId">Id of the portal.</param>
        /// <returns>An ArrayList of RoleGroupInfo objects</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override ArrayList GetRoleGroups( int portalId )
        {
            return ( (ArrayList)CBO.FillCollection( dataProvider.GetRoleGroups( portalId ), typeof( RoleGroupInfo ) ) );
        }

        /// <summary>
        /// GetRoleNames gets an array of roles for a portal
        /// </summary>
        /// <param name="portalId">Id of the portal</param>
        /// <returns>A RoleInfo object</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override string[] GetRoleNames( int portalId )
        {
            string[] roles = new string[] {};
            string strRoles = "";

            ArrayList arrRoles = GetRoles( portalId );
            foreach( RoleInfo role in arrRoles )
            {
                strRoles += role.RoleName + "|";
            }

            if( strRoles.IndexOf( "|" ) > 0 )
            {
                roles = strRoles.Substring( 0, strRoles.Length - 1 ).Split( '|' );
            }

            return roles;
        }

        /// <summary>
        /// GetRoleNames gets an array of roles
        /// </summary>
        /// <param name="portalId">Id of the portal</param>
        /// <param name="userId">The Id of the user whose roles are required. (If -1 then all
        /// rolenames in a portal are retrieved.</param>
        /// <returns>A RoleInfo object</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override string[] GetRoleNames( int portalId, int userId )
        {
            string[] roles = new string[] {};
            string strRoles = "";

            IDataReader dr = dataProvider.GetRolesByUser( userId, portalId );
            try
            {
                while( dr.Read() )
                {
                    strRoles += Convert.ToString( dr["RoleName"] ) + "|";
                }
            }
            finally
            {
                if( dr != null )
                {
                    dr.Close();
                }
            }

            if( strRoles.IndexOf( "|" ) > 0 )
            {
                roles = strRoles.Substring( 0, strRoles.Length - 1 ).Split( '|' );
            }

            return roles;
        }

        /// <summary>
        /// Get the roles for a portal
        /// </summary>
        /// <param name="portalId">Id of the portal (If -1 all roles for all portals are
        /// retrieved.</param>
        /// <returns>An ArrayList of RoleInfo objects</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override ArrayList GetRoles(int portalId)
        {
            ArrayList arrRoles = null;

            if (portalId == Null.NullInteger)
            {
                arrRoles = FillRoleInfoCollection(dataProvider.GetRoles());
            }
            else
            {
                arrRoles = FillRoleInfoCollection(dataProvider.GetPortalRoles(portalId));
            }

            return arrRoles;
        }

        /// <summary>
        /// Get the roles for a Role Group
        /// </summary>
        /// <param name="portalId">Id of the portal</param>
        /// <param name="roleGroupId">Id of the Role Group (If -1 all roles for the portal are
        /// retrieved).</param>
        /// <returns>An ArrayList of RoleInfo objects</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override ArrayList GetRolesByGroup(int portalId, int roleGroupId)
        {
            return FillRoleInfoCollection(dataProvider.GetRolesByGroup(roleGroupId, portalId));
        }

        /// <summary>
        /// GetUserRole gets a User/Role object from the Data Store
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <param name="portalId">Id of the portal</param>
        /// <param name="userId">The Id of the User</param>
        /// <param name="roleId">The Id of the Role.</param>
        /// <returns>The UserRoleInfo object</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override UserRoleInfo GetUserRole( int portalId, int userId, int roleId )
        {
            return ( (UserRoleInfo)CBO.FillObject( dataProvider.GetUserRole( portalId, userId, roleId ), typeof( UserRoleInfo ) ) );
        }

        /// <summary>
        /// GetUserRoles gets a collection of User/Role objects from the Data Store
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <param name="portalId">Id of the portal</param>
        /// <param name="userId">The user to fetch roles for</param>
        /// <returns>An ArrayList of UserRoleInfo objects</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override ArrayList GetUserRoles( int portalId, int userId, bool includePrivate )
        {
            if( includePrivate )
            {
                return CBO.FillCollection( dataProvider.GetUserRoles( portalId, userId ), typeof( UserRoleInfo ) );
            }
            else
            {
                return CBO.FillCollection( dataProvider.GetServices( portalId, userId ), typeof( UserRoleInfo ) );
            }
        }

        /// <summary>
        /// GetUserRoles gets a collection of User/Role objects from the Data Store
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <param name="portalId">Id of the portal</param>
        /// <param name="userName">The user to fetch roles for</param>
        /// <param name="roleName">The role to fetch users for</param>
        /// <returns>An ArrayList of UserRoleInfo objects</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override ArrayList GetUserRoles(int portalId, int userId, int roleId, int pageIndex, int pageSize, ref int totalRecords)
        {
            return CBO.FillCollection(dataProvider.GetUserRolesByUserId(portalId, userId, roleId, pageIndex, pageSize), typeof(UserRoleInfo), ref totalRecords);
        }

        /// <summary>
        /// Get the users in a role (as UserRole objects)
        /// </summary>
        /// <param name="portalId">Id of the portal (If -1 all roles for all portals are
        /// retrieved.</param>
        /// <param name="roleName">The role to fetch users for</param>
        /// <returns>An ArrayList of UserRoleInfo objects</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override ArrayList GetUserRolesByRoleId(int portalId, int roleId, int pageIndex, int pageSize, ref int totalRecords)
        {
            return GetUserRoles(portalId, -1, roleId, pageIndex, pageSize, ref totalRecords);
        }

        /// <summary>
        /// Get the users in a role (as User objects)
        /// </summary>
        /// <param name="portalId">Id of the portal (If -1 all roles for all portals are
        /// retrieved.</param>
        /// <param name="roleName">The role to fetch users for</param>
        /// <returns>An ArrayList of UserInfo objects</returns>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override ArrayList GetUsersByRoleName( int portalId, string roleName )
        {
            return CBO.FillCollection( dataProvider.GetUsersByRolename( portalId, roleName ), typeof( UserInfo ) );
        }

        /// <summary>
        /// DeleteRole deletes a Role from the Data Store
        /// </summary>
        /// <param name="portalId">Id of the portal</param>
        /// <param name="role">The role to delete from the Data Store.</param>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override void DeleteRole( int portalId, ref RoleInfo role )
        {
            dataProvider.DeleteRole( role.RoleID );
        }

        /// <summary>
        /// DeleteRoleGroup deletes a RoleGroup from the Data Store
        /// </summary>
        /// <param name="roleGroup">The RoleGroup to delete from the Data Store.</param>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override void DeleteRoleGroup( RoleGroupInfo roleGroup )
        {
            dataProvider.DeleteRoleGroup( roleGroup.RoleGroupID );
        }

        /// <summary>
        /// Remove a User from a Role
        /// </summary>
        /// <remarks>
        /// </remarks>
        /// <param name="portalId">Id of the portal</param>
        /// <param name="user">The user to remove.</param>
        /// <param name="userRole">The role to remove the user from.</param>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override void RemoveUserFromRole( int portalId, UserInfo user, UserRoleInfo userRole )
        {
            dataProvider.DeleteUserRole( userRole.UserID, userRole.RoleID );
        }

        /// <summary>
        /// Update a role
        /// </summary>
        /// <param name="role">The role to update</param>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override void UpdateRole( RoleInfo role )
        {
            dataProvider.UpdateRole( role.RoleID, role.RoleGroupID, role.Description, role.ServiceFee, role.BillingPeriod.ToString(), role.BillingFrequency, role.TrialFee, role.TrialPeriod, role.TrialFrequency, role.IsPublic, role.AutoAssignment, role.RSVPCode, role.IconFile );
        }

        /// <summary>
        /// Update a RoleGroup
        /// </summary>
        /// <param name="roleGroup">The RoleGroup to update</param>
        /// <history>
        ///     [cnurse]	03/28/2006	created
        /// </history>
        public override void UpdateRoleGroup( RoleGroupInfo roleGroup )
        {
            dataProvider.UpdateRoleGroup( roleGroup.RoleGroupID, roleGroup.RoleGroupName, roleGroup.Description );
        }

        /// <summary>
        /// Updates a User/Role
        /// </summary>
        /// <param name="userRole">The User/Role to update</param>
        /// <history>
        ///     [cnurse]	12/15/2005	created
        /// </history>
        public override void UpdateUserRole( UserRoleInfo userRole )
        {
            dataProvider.UpdateUserRole( userRole.UserRoleID, userRole.EffectiveDate, userRole.ExpiryDate );
        }
    }
}