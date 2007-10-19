using System.Collections;

namespace SharpContent.Security.Membership
{
    /// <summary>
    /// The MembershipController class provides Business Layer methods for membership
    /// </summary>
    public class MembershipController
    {
        private static MembershipProvider provider = MembershipProvider.Instance();

        /// <summary>
        /// Gets an ArrayList of PasswordQuestonInfo objects
        /// </summary>
        /// <param name="locale">The locale of the user</param>
        /// <returns>An ArrayList of PasswordQuestonInfo</returns>
        public static ArrayList GetPasswordQuestons(string locale)
        {
            return provider.GetPasswordQuestions(locale);
        }
    }
}
