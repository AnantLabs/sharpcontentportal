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
using System.Web.Configuration;
using System.Web.Security;
using System;
using System.Text;
using System.Security.Cryptography;
using System.Configuration.Provider;
using System.IO;

namespace SharpContent.Security.Membership
{
    public abstract class MembershipProvider
    {
        // singleton reference to the instantiated object
        private static MembershipProvider objProvider = null;

        // constructor
        static MembershipProvider()
        {
            CreateProvider();
        }

        // dynamically create provider
        private static void CreateProvider()
        {
            objProvider = (MembershipProvider)Reflection.CreateObject("members");
        }

        // return the provider
        public static MembershipProvider Instance()
        {
            return objProvider;
        }

        public abstract bool CanEditProviderProperties { get; }
        public abstract int MaxInvalidPasswordAttempts { get; set; }
        public abstract int MinPasswordLength { get; set; }
        public abstract int MinNonAlphanumericCharacters { get; set; }
        public abstract int PasswordAttemptWindow { get; set; }
        public abstract PasswordFormat PasswordFormat { get; set; }
        public abstract bool PasswordResetEnabled { get; set; }
        public abstract bool PasswordRetrievalEnabled { get; set; }
        public abstract string PasswordStrengthRegularExpression { get; set; }
        public abstract bool RequiresQuestionAndAnswer { get; set; }

        //Password Questions
        public abstract ArrayList GetPasswordQuestions(string locale);        

        //Users
        public abstract bool ChangePassword(UserInfo user, string oldPassword, string newPassword);
        public abstract bool ChangePasswordQuestionAndAnswer(UserInfo user, string password, string passwordQuestion, string passwordAnswer);
        public abstract UserCreateStatus CreateUser(ref UserInfo user);
        public abstract bool DeleteUser(UserInfo user);
        public abstract string GeneratePassword();
        public abstract string GeneratePassword(int length);
        public abstract string GetPassword(UserInfo user, string passwordAnswer);
        public abstract UserInfo GetUser(int portalId, int userId, bool isHydrated);
        public abstract UserInfo GetUserByUserName(int portalId, string username, bool isHydrated);
        public abstract int GetUserCountByPortal(int portalId);
        public abstract void GetUserMembership(ref UserInfo user);
        public abstract ArrayList GetUnAuthorizedUsers(int portalId, bool isHydrated);
        public abstract ArrayList GetUsers(int portalId, bool isHydrated, int pageIndex, int pageSize, ref int totalRecords);
        public abstract ArrayList GetUsersByEmail(int portalId, bool isHydrated, string emailToMatch, int pageIndex, int pageSize, ref int totalRecords);
        public abstract ArrayList GetUsersByUserName(int portalId, bool isHydrated, string userNameToMatch, int pageIndex, int pageSize, ref int totalRecords);
        public abstract ArrayList GetUsersByProfileProperty(int portalId, bool isHydrated, string propertyName, string propertyValue, int pageIndex, int pageSize, ref int totalRecords);
        public abstract string ResetPassword(UserInfo user, string passwordQuestion, string passwordAnswer, bool forcePasswordReset);
        public abstract bool UnLockUser(UserInfo user);
        public abstract void UpdateUser(UserInfo user);
        public abstract UserInfo UserLogin(int portalId, string username, string password, string verificationCode, ref UserLoginStatus loginStatus);

        //Users Online
        public abstract void DeleteUsersOnline(int timeWindow);
        public abstract void DeleteUserOnline(int userId);
        public abstract ArrayList GetOnlineUsers(int PortalId);
        public abstract bool IsUserOnline(UserInfo user);
        public abstract void UpdateUsersOnline(Hashtable UserList);

        //Legacy
        public abstract void TransferUsersToMembershipProvider();

        //Password Encoding
        protected virtual byte[] DecryptData(byte[] encodedPassword)
        {
            RijndaelManaged aes = new RijndaelManaged();
            byte[] key = GetMachineKey(KeyType.Encryption);
            byte[] IV = GetMachineKey(KeyType.Validation);

            //Get an encryptor.
            ICryptoTransform decryptor = aes.CreateDecryptor(key, IV);

            // create the streams
            MemoryStream msEncrypt = new MemoryStream();
            CryptoStream csEncrypt = new CryptoStream(msEncrypt, decryptor, CryptoStreamMode.Write);

            //Write all data to the crypto stream and flush it.
            csEncrypt.Write(encodedPassword, 0, encodedPassword.Length);
            csEncrypt.FlushFinalBlock();

            //return bytes
            return msEncrypt.ToArray();
        }

        protected virtual byte[] EncryptData(byte[] password)
        {
            RijndaelManaged aes = new RijndaelManaged();
            byte[] key = GetMachineKey(KeyType.Encryption);
            byte[] IV = GetMachineKey(KeyType.Validation);

            // create an encryptor.
            ICryptoTransform encryptor = aes.CreateEncryptor(key, IV);

            // create the in/out streams
            MemoryStream msEncrypt = new MemoryStream();
            CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write);

            // write all data to the crypto stream and flush it.
            csEncrypt.Write(password, 0, password.Length);
            csEncrypt.FlushFinalBlock();

            // get encrypted array of bytes.
            return msEncrypt.ToArray();
        }

        protected string EncodePassword(string password, SharpContent.Security.Membership.PasswordFormat passwordFormat, string salt)
        {
            byte[] password_bytes;
            byte[] salt_bytes;

            switch (passwordFormat)
            {
                case PasswordFormat.Clear:
                    return password;
                case PasswordFormat.Hashed:
                    password_bytes = Encoding.Unicode.GetBytes(password);
                    salt_bytes = Convert.FromBase64String(salt);

                    byte[] hashBytes = new byte[salt_bytes.Length + password_bytes.Length];

                    Buffer.BlockCopy(salt_bytes, 0, hashBytes, 0, salt_bytes.Length);
                    Buffer.BlockCopy(password_bytes, 0, hashBytes, salt_bytes.Length, password_bytes.Length);

                    MembershipSection section = (MembershipSection)WebConfigurationManager.GetSection("system.web/membership");
                    string alg_type = section.HashAlgorithmType;
                    if (alg_type == "")
                    {
                        MachineKeySection keysection = (MachineKeySection)WebConfigurationManager.GetSection("system.web/machineKey");
                        alg_type = keysection.Validation.ToString();
                    }
                    using (HashAlgorithm hash = HashAlgorithm.Create(alg_type))
                    {
                        hash.TransformFinalBlock(hashBytes, 0, hashBytes.Length);
                        return Convert.ToBase64String(hash.Hash);
                    }
                case PasswordFormat.Encrypted:
                    password_bytes = Encoding.Unicode.GetBytes(password);
                    salt_bytes = Convert.FromBase64String(salt);

                    byte[] buf = new byte[password_bytes.Length + salt_bytes.Length];

                    Array.Copy(salt_bytes, 0, buf, 0, salt_bytes.Length);
                    Array.Copy(password_bytes, 0, buf, salt_bytes.Length, password_bytes.Length);

                    return Convert.ToBase64String(EncryptData(buf));
                default:
                    /* not reached.. */
                    return null;
            }
        }

        protected string DecodePassword(string password, SharpContent.Security.Membership.PasswordFormat passwordFormat)
        {
            switch (passwordFormat)
            {
                case PasswordFormat.Clear:
                    return password;
                case PasswordFormat.Hashed:
                    throw new ProviderException("Hashed passwords cannot be decoded.");
                case PasswordFormat.Encrypted:
                    return Encoding.Unicode.GetString(DecryptData(Convert.FromBase64String(password)));
                default:
                    /* not reached.. */
                    return null;
            }
        }

        private byte[] GetMachineKey(KeyType keyType)
        {
            MachineKeySection section = (MachineKeySection)WebConfigurationManager.GetSection("system.web/machineKey");
            
            byte[] key = null;

            switch (keyType)
            {
                case KeyType.Encryption:
                    key = Encoding.UTF8.GetBytes(section.DecryptionKey);
                    break;
                case KeyType.Validation:
                    key = Encoding.UTF8.GetBytes(section.ValidationKey);
                    break;
            }

            return key;

        }

        private enum KeyType
        {
            Encryption,
            Validation
        }

        protected virtual void OnValidatingPassword(ValidatePasswordEventArgs args)
        {
            if (ValidatingPassword != null)
                ValidatingPassword(this, args);
        }

        public event MembershipValidatePasswordEventHandler ValidatingPassword;
    }
}