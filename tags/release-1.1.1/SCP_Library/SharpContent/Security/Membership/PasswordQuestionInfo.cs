using System.Xml.Serialization;

namespace SharpContent.Security.Membership
{
    /// <summary>
    /// The PasswordQuestionInfo class provides the PasswordQuestionInfo object
    /// </summary>
    [XmlRoot("question", IsNullable = false)]
    public class PasswordQuestionInfo
    {
        private int _questionId;
        private string _questonText;
        private string _locale;

        /// <summary>
        /// Gets and sets the question ID
        /// </summary>
        /// <value>An int representing the ID of the question.</value>
        [XmlElement("id")]
        public int Id
        {
            get
            {
                return _questionId;
            }
            set
            {
                _questionId = value;
            }
        }

        /// <summary>
        /// Gets and sets the question
        /// </summary>
        /// <value>An string representing the question.</value>
        [XmlElement("text")]
        public string Text
        {
            get
            {
                return _questonText;
            }
            set
            {
                _questonText = value;
            }
        }

        /// <summary>
        /// Gets and sets the locale of the question
        /// </summary>
        /// <value>An string representing the locale of the question.</value>
        [XmlElement("locale")]
        public string Locale
        {
            get
            {
                return _locale;
            }
            set
            {
                _locale = value;
            }
        }
    }
}
