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
using SharpContent.Security.Roles;

namespace SharpContent.Entities.Users
{
    /// <Summary>
    /// The UserRoleInfo class provides Business Layer model for a User/Role
    /// </Summary>
    public class UserRoleInfo : RoleInfo
    {
        private string _accountnumber;
        private string _username;
        private string _firstName;
        private string _lastName;
        private string _displayName;
        private DateTime _EffectiveDate;
        private string _Email;
        private DateTime _ExpiryDate;
        private string _FullName;
        private bool _IsTrialUsed;
        private bool _Subscribed;
        private int _UserID;
        private int _UserRoleID;

        public string AccountNumber
        {
            get 
            {
                return this._accountnumber;
            }
            set
            {
                this._accountnumber  = value;
            }
        }

        public string UserName
        {
            get 
            {
                return this._username;
            }
            set
            {
                this._username  = value;
            }
        }

        public string FirstName
        {
            get 
            {
                return this._firstName;
            }
            set
            {
                this._firstName  = value;
            }
        }

        public string LastName
        {
            get 
            {
                return this._lastName;
            }
            set
            {
                this._lastName  = value;
            }
        }

        public string DisplayName
        {
            get
            {
                return this._displayName;
            }
            set
            {
                this._displayName = value;
            }
        }

        public DateTime EffectiveDate
        {
            get
            {
                return this._EffectiveDate;
            }
            set
            {
                this._EffectiveDate = value;
            }
        }

        public string Email
        {
            get
            {
                return this._Email;
            }
            set
            {
                this._Email = value;
            }
        }

        public DateTime ExpiryDate
        {
            get
            {
                return this._ExpiryDate;
            }
            set
            {
                this._ExpiryDate = value;
            }
        }

        public string FullName
        {
            get
            {
                return this._FullName;
            }
            set
            {
                this._FullName = value;
            }
        }

        public bool IsTrialUsed
        {
            get
            {
                return this._IsTrialUsed;
            }
            set
            {
                this._IsTrialUsed = value;
            }
        }

        public bool Subscribed
        {
            get
            {
                return this._Subscribed;
            }
            set
            {
                this._Subscribed = value;
            }
        }

        public int UserID
        {
            get
            {
                return this._UserID;
            }
            set
            {
                this._UserID = value;
            }
        }

        public int UserRoleID
        {
            get
            {
                return this._UserRoleID;
            }
            set
            {
                this._UserRoleID = value;
            }
        }
    }
}