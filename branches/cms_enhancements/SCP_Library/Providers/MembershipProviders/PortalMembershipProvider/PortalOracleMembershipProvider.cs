using System;
using System.Collections.Generic;
using System.Text;
using System.Web.Security;
using System.Collections.Specialized;
using System.Configuration;
using System.Data.Common;
using System.Web.Configuration;
using System.Configuration.Provider;
using SharpContent.Security.Membership.Data;
using System.Data;
using System.Security.Cryptography;

namespace SharpContent.Security.Membership
{
    public class PortalOracleMembershipProvider : System.Web.Security.MembershipProvider
    {
        private static DataProvider dataProvider = DataProvider.Instance();
        const int SALT_BYTES = 16;
        private DateTime DefaultDateTime = new DateTime(1754, 1, 1);

        private bool enablePasswordReset;
        private bool enablePasswordRetrieval;
        private int maxInvalidPasswordAttempts;
        private MembershipPasswordFormat passwordFormat;
        private bool requiresQuestionAndAnswer;
        private bool requiresUniqueEmail;
        private int minRequiredNonAlphanumericCharacters;
        private int minRequiredPasswordLength;
        private int passwordAttemptWindow;
        private string passwordStrengthRegularExpression;
        private TimeSpan userIsOnlineTimeWindow;

        private ConnectionStringSettings connectionString;

        private string applicationName;

        private static object lockobj = new object();

        public override void Initialize(string name, NameValueCollection config)
        {
            if (config == null)
                throw new ArgumentNullException("config");

            base.Initialize(name, config);

            applicationName = GetStringConfigValue(config, "applicationName", "/");
            enablePasswordReset = GetBoolConfigValue(config, "enablePasswordReset", true);
            enablePasswordRetrieval = GetBoolConfigValue(config, "enablePasswordRetrieval", false);
            requiresQuestionAndAnswer = GetBoolConfigValue(config, "requiresQuestionAndAnswer", true);
            requiresUniqueEmail = GetBoolConfigValue(config, "requiresUniqueEmail", false);
            passwordFormat = (MembershipPasswordFormat)GetEnumConfigValue(config, "passwordFormat", typeof(MembershipPasswordFormat),
                                                      (int)MembershipPasswordFormat.Hashed);
            maxInvalidPasswordAttempts = GetIntConfigValue(config, "maxInvalidPasswordAttempts", 5);
            minRequiredPasswordLength = GetIntConfigValue(config, "minRequiredPasswordLength", 7);
            minRequiredNonAlphanumericCharacters = GetIntConfigValue(config, "minRequiredNonAlphanumericCharacters", 1);
            passwordAttemptWindow = GetIntConfigValue(config, "passwordAttemptWindow", 10);
            passwordStrengthRegularExpression = GetStringConfigValue(config, "passwordStrengthRegularExpression", "");

            MembershipSection section = (MembershipSection)WebConfigurationManager.GetSection("system.web/membership");

            userIsOnlineTimeWindow = section.UserIsOnlineTimeWindow;

            /* we can't support password retrieval with hashed passwords */
            if (passwordFormat == MembershipPasswordFormat.Hashed && enablePasswordRetrieval)
                throw new ProviderException("Password retrieval cannot be used with hashed passwords.");

            string connectionStringName = config["connectionStringName"];

            if (applicationName.Length > 256)
                throw new ProviderException("The ApplicationName attribute must be 256 characters long or less.");
            if (connectionStringName == null || connectionStringName.Length == 0)
                throw new ProviderException("The ConnectionStringName attribute must be present and non-zero length.");

            connectionString = WebConfigurationManager.ConnectionStrings[connectionStringName];
        }

        public virtual string GeneratePassword()
        {
            return System.Web.Security.Membership.GeneratePassword(MinRequiredPasswordLength + 4, MinRequiredNonAlphanumericCharacters);
        }

        bool GetBoolConfigValue(NameValueCollection config, string name, bool def)
        {
            bool rv = def;
            string val = config[name];
            if (val != null)
            {
                try { rv = Boolean.Parse(val); }
                catch (Exception e)
                {
                    throw new ProviderException(String.Format("{0} must be true or false", name), e);
                }
            }
            return rv;
        }

        int GetIntConfigValue(NameValueCollection config, string name, int def)
        {
            int rv = def;
            string val = config[name];
            if (val != null)
            {
                try { rv = Int32.Parse(val); }
                catch (Exception e)
                {
                    throw new ProviderException(String.Format("{0} must be an integer", name), e);
                }
            }
            return rv;
        }

        int GetEnumConfigValue(NameValueCollection config, string name, Type enumType, int def)
        {
            int rv = def;
            string val = config[name];
            if (val != null)
            {
                try { rv = (int)Enum.Parse(enumType, val); }
                catch (Exception e)
                {
                    throw new ProviderException(String.Format("{0} must be one of the following values: {1}", name, String.Join(",", Enum.GetNames(enumType))), e);
                }
            }
            return rv;
        }

        string GetStringConfigValue(NameValueCollection config, string name, string def)
        {
            string rv = def;
            string val = config[name];
            if (val != null)
                rv = val;
            return rv;
        }

        void CheckParam(string pName, string p, int length)
        {
            if (p == null)
                throw new ArgumentNullException(pName);
            if (p.Length == 0 || p.Length > length || p.IndexOf(",") != -1)
                throw new ArgumentException(String.Format("invalid format for {0}", pName));
        }

        private MembershipUser GetUserFromReader(IDataReader reader)
        {
            while (reader.Read())
            {
                string providerName = System.Web.Security.Membership.Provider.Name;
                string name = reader.GetString(0); /* name */
                Guid providerUserKey = new Guid(reader.GetString(1)); /* providerUserKey */
                string email = reader.IsDBNull(2) ? String.Empty : reader.GetString(2); /* email */
                string passwordQuestion = reader.IsDBNull(3) ? String.Empty : reader.GetString(3); /* passwordQuestion */
                string comment = reader.IsDBNull(4) ? String.Empty : reader.GetString(4); /* comment */
                bool isApproved = reader.GetInt32(5) == 1 ? true : false; /* isApproved */
                bool isLockedOut = reader.GetInt32(6) == 1 ? true : false; /* isLockedOut */
                DateTime creationDate = reader.GetDateTime(7); /* creationDate */
                DateTime lastLoginDate = reader.GetDateTime(8); /* lastLoginDate */
                DateTime lastActivityDate = reader.GetDateTime(9); /* lastActivityDate */
                DateTime lastPasswordChangedDate = reader.GetDateTime(10); /* lastPasswordChangedDate */
                DateTime lastLockoutDate = reader.GetDateTime(11); /* lastLockoutDate */

                return new MembershipUser(
                    providerName,
                    name,
                    providerUserKey,
                    email,
                    passwordQuestion,
                    comment,
                    isApproved,
                    isLockedOut,
                    creationDate,
                    lastLoginDate,
                    lastActivityDate,
                    lastPasswordChangedDate,
                    lastLockoutDate);
            }
            return null;
        }

        public bool ValidateUsingPassword(string username, string password, out MembershipPasswordFormat passwordFormat, out string salt)
        {
            string db_password;

            IDataReader reader = dataProvider.AspNetMembershipGetPassword(applicationName, username);
            reader.Read();
            db_password = reader.GetString(0);            
            salt = reader.GetString(1);
            passwordFormat = (MembershipPasswordFormat)Convert.ToInt32(reader.GetValue(2));
            reader.Close();

            /* do the actual validation */
            password = EncodePassword(password, passwordFormat, salt);

            bool valid = (password == db_password);

            if (!valid)
            {
                dataProvider.AspNetMembershipUpdateMemberInfo(applicationName, username, 1, 0, 0, MaxInvalidPasswordAttempts, PasswordAttemptWindow, DateTime.Now, DateTime.Now, DateTime.Now);
            }

            return valid;
        }

        public bool ValidateUsingPasswordAnswer(string username, string answer, out MembershipPasswordFormat passwordFormat, out string salt)
        {
            string db_answer;

            IDataReader reader = dataProvider.AspNetMembershipGetAnswer(applicationName, username);
            reader.Read();
            db_answer = reader.GetString(0);
            salt = reader.GetString(1);
            passwordFormat = (MembershipPasswordFormat)Convert.ToInt32(reader.GetValue(2));            
            reader.Close();

            /* do the actual password answer check */
            answer = EncodePassword(answer, passwordFormat, salt);           

            bool valid = (answer == db_answer);

            if (!valid)
            {
                dataProvider.AspNetMembershipUpdateMemberInfo(applicationName, username, 0, 0, 0, MaxInvalidPasswordAttempts, PasswordAttemptWindow, DateTime.Now, DateTime.Now, DateTime.Now);
            }

            return valid;
        }

        public void EmitValidatingPassword(string username, string password, bool isNewUser)
        {
            ValidatePasswordEventArgs args = new ValidatePasswordEventArgs(username, password, isNewUser);
            OnValidatingPassword(args);

            /* if we're canceled.. */
            if (args.Cancel)
            {
                if (args.FailureInformation == null)
                    throw new ProviderException("Password validation canceled.");
                else
                    throw args.FailureInformation;
            }
        }

        internal string EncodePassword(string password, MembershipPasswordFormat passwordFormat, string salt)
        {
            byte[] password_bytes;
            byte[] salt_bytes;

            switch (passwordFormat)
            {
                case MembershipPasswordFormat.Clear:
                    return password;
                case MembershipPasswordFormat.Hashed:
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
                case MembershipPasswordFormat.Encrypted:
                    password_bytes = Encoding.Unicode.GetBytes(password);
                    salt_bytes = Convert.FromBase64String(salt);

                    byte[] buf = new byte[password_bytes.Length + salt_bytes.Length];

                    Array.Copy(salt_bytes, 0, buf, 0, salt_bytes.Length);
                    Array.Copy(password_bytes, 0, buf, salt_bytes.Length, password_bytes.Length);

                    return Convert.ToBase64String(EncryptPassword(buf));
                default:
                    /* not reached.. */
                    return null;
            }
        }

        public override string ApplicationName
        {
            get { return applicationName; }
            set { applicationName = value; }
        }

        public override bool EnablePasswordReset
        {
            get { return enablePasswordReset; }
        }

        public override bool EnablePasswordRetrieval
        {
            get { return enablePasswordRetrieval; }
        }

        public override MembershipPasswordFormat PasswordFormat
        {
            get { return passwordFormat; }
        }

        public override bool RequiresQuestionAndAnswer
        {
            get { return requiresQuestionAndAnswer; }
        }

        public override bool RequiresUniqueEmail
        {
            get { return requiresUniqueEmail; }
        }

        public override int MaxInvalidPasswordAttempts
        {
            get { return maxInvalidPasswordAttempts; }
        }

        public override int MinRequiredNonAlphanumericCharacters
        {
            get { return minRequiredNonAlphanumericCharacters; }
        }

        public override int MinRequiredPasswordLength
        {
            get { return minRequiredPasswordLength; }
        }

        public override int PasswordAttemptWindow
        {
            get { return passwordAttemptWindow; }
        }

        public override string PasswordStrengthRegularExpression
        {
            get { return passwordStrengthRegularExpression; }
        }

        public override bool ChangePassword(string username, string oldPassword, string newPassword)
        {
            if (username != null) username = username.Trim();
            if (oldPassword != null) oldPassword = oldPassword.Trim();
            if (newPassword != null) newPassword = newPassword.Trim();

            CheckParam("username", username, 256);
            CheckParam("oldPwd", oldPassword, 128);
            CheckParam("newPwd", newPassword, 128);

            MembershipUser user = GetUser(username, false);
            if (user == null) throw new ProviderException("Could not find user in membership database.");
            if (user.IsLockedOut) throw new MembershipPasswordException("User is currently locked out.");

            try
            {
                MembershipPasswordFormat passwordFormat;
                string db_salt;

                bool valid = ValidateUsingPassword(username, oldPassword, out passwordFormat, out db_salt);
                if (valid)
                {

                    EmitValidatingPassword(username, newPassword, false);

                    string db_password = EncodePassword(newPassword, passwordFormat, db_salt);

                    valid = dataProvider.AspNetMembershipSetPassword(applicationName, username, db_password, db_salt, DateTime.Now, Convert.ToInt32(passwordFormat));
                }
                return valid;
            }
            catch
            {
                return false;
            }
        }

        public override bool ChangePasswordQuestionAndAnswer(string username, string password, string newPasswordQuestion, string newPasswordAnswer)
        {
            if (username != null) username = username.Trim();
            if (newPasswordQuestion != null) newPasswordQuestion = newPasswordQuestion.Trim();
            if (newPasswordAnswer != null) newPasswordAnswer = newPasswordAnswer.Trim();

            CheckParam("username", username, 256);
            if (RequiresQuestionAndAnswer)
                CheckParam("newPasswordQuestion", newPasswordQuestion, 128);
            if (RequiresQuestionAndAnswer)
                CheckParam("newPasswordAnswer", newPasswordAnswer, 128);

            MembershipUser user = GetUser(username, false);
            if (user == null) throw new ProviderException("could not find user in membership database");
            if (user.IsLockedOut) throw new MembershipPasswordException("user is currently locked out"); 

            try
            {
                MembershipPasswordFormat passwordFormat;
                string db_salt;

                bool valid = ValidateUsingPassword(username, password, out passwordFormat, out db_salt);
                if (valid)
                {

                    string db_passwordAnswer = EncodePassword(newPasswordAnswer, passwordFormat, db_salt);

                    valid = dataProvider.AspNetMembershipSetPasswordQAndA(applicationName, username, newPasswordQuestion, db_passwordAnswer);

                }
                return valid;
            }
            catch 
            {
               return false;
            }
        }

        public override MembershipUser CreateUser(string username, string password, string email, string passwordQuestion, string passwordAnswer, bool isApproved, object providerUserKey, out MembershipCreateStatus status)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override bool DeleteUser(string username, bool deleteAllRelatedData)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override MembershipUserCollection FindUsersByEmail(string emailToMatch, int pageIndex, int pageSize, out int totalRecords)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override MembershipUserCollection FindUsersByName(string usernameToMatch, int pageIndex, int pageSize, out int totalRecords)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override MembershipUserCollection GetAllUsers(int pageIndex, int pageSize, out int totalRecords)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override int GetNumberOfUsersOnline()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override string GetPassword(string username, string answer)
        {
            IDataReader reader = dataProvider.AspNetMembershipGetPassword(applicationName, username);
            reader.Read();
            string password = reader.GetString(0);
            reader.Close();
            return password;
        }

        public override MembershipUser GetUser(string username, bool userIsOnline)
        {
            return GetUserFromReader(dataProvider.AspNetMembershipGetUserByName(ApplicationName, username, DateTime.Now, 1));
        }

        public override MembershipUser GetUser(object providerUserKey, bool userIsOnline)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override string GetUserNameByEmail(string email)
        {
            throw new Exception("The method or operation is not implemented.");
        }
        
        public override string ResetPassword(string username, string answer)
        {
            if (!enablePasswordReset)
                throw new NotSupportedException("This provider has not been configured to allow the resetting of passwords.");

            CheckParam("username", username, 256);
            if (RequiresQuestionAndAnswer)
                CheckParam("answer", answer, 128);

            MembershipUser user = GetUser(username, false);
            if (user == null) throw new ProviderException("Could not find user in membership database.");
            if (user.IsLockedOut) throw new MembershipPasswordException("User is currently locked out.");

            try
            {
                MembershipPasswordFormat db_passwordFormat;
                string db_salt;
                string newPassword = null;

                if (ValidateUsingPasswordAnswer(user.UserName, answer, out db_passwordFormat, out db_salt))
                {

                    newPassword = GeneratePassword();

                    string db_password;

                    EmitValidatingPassword(username, newPassword, false);

                    /* otherwise update the user's password in the db */

                    db_password = EncodePassword(newPassword, db_passwordFormat, db_salt);                    
                    if (1 != dataProvider.AspNetMembershipResetPwd(ApplicationName, user.UserName, db_password, MaxInvalidPasswordAttempts, PasswordAttemptWindow, db_salt, DateTime.Now, Convert.ToInt32(db_passwordFormat)))
                        throw new ProviderException("Failed to update Membership table.");                    
                }
                else
                {
                    throw new MembershipPasswordException("The password-answer supplied is wrong.");
                }

                return newPassword;
            }
            catch (MembershipPasswordException)
            {
                throw;
            }
            catch (ProviderException)
            {
                throw;
            }
            catch (Exception e)
            {
                throw new ProviderException("Failed to reset password.", e);
            }
        }

        public override bool UnlockUser(string userName)
        {
            return dataProvider.AspNetMembershipUnlockUser(ApplicationName, userName);
        }

        public override void UpdateUser(MembershipUser user)
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override bool ValidateUser(string username, string password)
        {
            throw new Exception("The method or operation is not implemented.");
        }
    }
}
