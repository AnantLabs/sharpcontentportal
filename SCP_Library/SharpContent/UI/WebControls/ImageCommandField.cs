
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SharpContent.UI.WebControls
{
    /// <Summary>
    /// The ImageCommandColumn control provides an Image Command (or Hyperlink) column
    /// for a Data Grid
    /// </Summary>
    public class ImageCommandField : TemplateField
    {
        private string mCommandName;
        private ImageCommandColumnEditMode mEditMode;
        private string mImageURL;
        private string mKeyField;
        private string mNavigateURL;
        private string mNavigateURLFormatString;
        private string mOnClickJS;
        private bool mShowImage;
        private string mText;
        private bool mVisible;
        private string mVisibleField;

        /// <Summary>Gets or sets the CommandName for the Column</Summary>
        public string CommandName
        {
            get
            {
                return this.mCommandName;
            }
            set
            {
                this.mCommandName = value;
            }
        }

        /// <Summary>Gets or sets the CommandName for the Column</Summary>
        public ImageCommandColumnEditMode EditMode
        {
            get
            {
                return this.mEditMode;
            }
            set
            {
                this.mEditMode = value;
            }
        }

        /// <Summary>Gets or sets the URL of the Image</Summary>
        public string ImageURL
        {
            get
            {
                return this.mImageURL;
            }
            set
            {
                this.mImageURL = value;
            }
        }

        /// <Summary>The Key Field that provides a Unique key to the data Item</Summary>
        public string KeyField
        {
            get
            {
                return this.mKeyField;
            }
            set
            {
                this.mKeyField = value;
            }
        }

        /// <Summary>
        /// Gets or sets the URL of the Link (unless DataBinding through KeyField)
        /// </Summary>
        public string NavigateURL
        {
            get
            {
                return this.mNavigateURL;
            }
            set
            {
                this.mNavigateURL = value;
            }
        }

        /// <Summary>Gets or sets the URL Formatting string</Summary>
        public string NavigateURLFormatString
        {
            get
            {
                return this.mNavigateURLFormatString;
            }
            set
            {
                this.mNavigateURLFormatString = value;
            }
        }

        /// <Summary>Javascript text to attach to the OnClick Event</Summary>
        public string OnClickJS
        {
            get
            {
                return this.mOnClickJS;
            }
            set
            {
                this.mOnClickJS = value;
            }
        }

        /// <Summary>Gets or sets whether an Image is displayed</Summary>
        public bool ShowImage
        {
            get
            {
                return this.mShowImage;
            }
            set
            {
                this.mShowImage = value;
            }
        }

        /// <Summary>Gets or sets the Text (for Header/Footer Templates)</Summary>
        public string Text
        {
            get
            {
                return this.mText;
            }
            set
            {
                this.mText = value;
            }
        }

        /// <Summary>An flag that indicates whether the buttons are visible.</Summary>
        public string VisibleField
        {
            get
            {
                return this.mVisibleField;
            }
            set
            {
                this.mVisibleField = value;
            }
        }

        public ImageCommandField()
        {
            this.mEditMode = ImageCommandColumnEditMode.Command;
            this.mShowImage = true;
            this.mVisible = true;
        }

        /// <Summary>Creates a ImageCommandColumnTemplate</Summary>
        /// <Returns>A ImageCommandFieldTemplate</Returns>
        private ImageCommandFieldTemplate CreateTemplate( ListItemType type )
        {
            bool isDesignMode = false;
            if (HttpContext.Current == null)
            {
                isDesignMode = true;
            }
            ImageCommandFieldTemplate template = new ImageCommandFieldTemplate(type);
            if (type != ListItemType.Header)
            {
                template.ImageURL = ImageURL;
                if (!isDesignMode)
                {
                    template.CommandName = CommandName;
                    template.VisibleField = VisibleField;
                    template.KeyField = KeyField;
                }
            }
            template.EditMode = EditMode;
            template.NavigateURL = NavigateURL;
            template.NavigateURLFormatString = NavigateURLFormatString;
            template.OnClickJS = OnClickJS;
            template.ShowImage = ShowImage;
            template.Visible = Visible;

            if (type == ListItemType.Header)
            {
                template.Text = this.HeaderText;
            }
            else
            {
                template.Text = Text;
            }

            //Set Design Mode to True
            template.DesignMode = isDesignMode;

            return template;
        }

        /// <Summary>Initialises the Column</Summary>
        public override bool Initialize(bool sortingEnabled, Control control)        
        {
            this.ItemTemplate = CreateTemplate(ListItemType.Item);
            this.EditItemTemplate = CreateTemplate(ListItemType.EditItem);
            this.HeaderTemplate = CreateTemplate(ListItemType.Header);

            if (HttpContext.Current == null)
            {
                this.HeaderStyle.Font.Names = new string[] { "Tahoma, Verdana, Arial" };
                this.HeaderStyle.Font.Size = new FontUnit("10pt");
                this.HeaderStyle.Font.Bold = true;
            }

            this.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            this.HeaderStyle.HorizontalAlign = HorizontalAlign.Center;

            return true;
        }
    }
}