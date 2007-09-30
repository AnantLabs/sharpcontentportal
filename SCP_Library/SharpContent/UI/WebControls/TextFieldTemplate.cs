
using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using SharpContent.Common.Utilities;

namespace SharpContent.UI.WebControls
{
    /// <Summary>
    /// The TextColumnTemplate provides a Template for the TextColumn
    /// </Summary>
    public class TextFieldTemplate : ITemplate
    {
        private string mDataField;
        private bool mDesignMode;
        private ListItemType mItemType;
        private string mText;
        private Unit mWidth;
        private object obj;

        /// <Summary>The Data Field is the field that binds to the Text Column</Summary>
        public string DataField
        {
            get
            {
                return this.mDataField;
            }
            set
            {
                this.mDataField = value;
            }
        }

        /// <Summary>Gets or sets the Design Mode of the Column</Summary>
        public bool DesignMode
        {
            get
            {
                return this.mDesignMode;
            }
            set
            {
                this.mDesignMode = value;
            }
        }

        /// <Summary>The type of Template to Create</Summary>
        public ListItemType ItemType
        {
            get
            {
                return this.mItemType;
            }
            set
            {
                this.mItemType = value;
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

        /// <Summary>Gets or sets the Width of the Column</Summary>
        public Unit Width
        {
            get
            {
                return this.mWidth;
            }
            set
            {
                this.mWidth = value;
            }
        }

        public TextFieldTemplate( ListItemType itemType )
        {
            this.mItemType = ListItemType.Item;
            this.ItemType = itemType;
        }

        public TextFieldTemplate() : this(ListItemType.Item)
        {
        }

        /// <Summary>Gets the value of the Data Field</Summary>
        /// <Param name="container">The parent container (DataGridItem)</Param>
        private string GetValue(GridViewRow container)
        {
            string itemValue = Null.NullString;
            if (!String.IsNullOrEmpty(DataField))
            {
                if (DesignMode)
                {
                    itemValue = "DataBound to " + DataField;
                }
                else
                {
                    if (container.DataItem != null)
                    {
                        obj = DataBinder.Eval(container.DataItem, DataField);
                        if( obj != null )
                        {
                            itemValue = obj.ToString();
                        }
                    }
                }
            }

            return itemValue;
        }
        
        /// <Summary>
        /// InstantiateIn instantiates the template (implementation of ITemplate)
        /// </Summary>
        /// <Param name="container">The parent container (DataGridItem)</Param>
        public virtual void InstantiateIn( Control container )
        {
            Label lblText;

            if( ItemType == ListItemType.Item )
            {
                //Add a Text Label
                lblText = new Label();
                lblText.Width = Width;
                lblText.DataBinding += new EventHandler( Item_DataBinding );
                container.Controls.Add( lblText );
            }
            else if( ItemType == ListItemType.AlternatingItem )
            {
                //Add a Text Label
                lblText = new Label();
                lblText.Width = Width;
                lblText.DataBinding += new EventHandler( Item_DataBinding );
                container.Controls.Add( lblText );
            }
            else if( ItemType == ListItemType.SelectedItem )
            {
                //Add a Text Label
                lblText = new Label();
                lblText.Width = Width;
                lblText.DataBinding += new EventHandler( Item_DataBinding );
                container.Controls.Add( lblText );
            }
            else if( ItemType == ListItemType.EditItem )
            {
                //Add a Text Box
                TextBox txtText = new TextBox();
                txtText.Width = Width;
                txtText.DataBinding += new EventHandler( Item_DataBinding );
                container.Controls.Add( txtText );
            }
            else if( ItemType == ListItemType.Footer )
            {
                container.Controls.Add( new LiteralControl( Text ) );
            }
            else if( ItemType == ListItemType.Header )
            {
                container.Controls.Add( new LiteralControl( Text ) );
            }
        }

        /// <Summary>
        /// Item_DataBinding runs when an Item of type ListItemType.Item is being data-bound
        /// </Summary>
        /// <Param name="sender">The object that triggers the event</Param>
        /// <Param name="e">An EventArgs object</Param>
        private void Item_DataBinding( object sender, EventArgs e )
        {
            GridViewRow container;
            int keyValue = SharpContent.Common.Utilities.Null.NullInteger;
            Label lblText;
            if( ItemType == ListItemType.Item )
            {
                lblText = (Label)sender;
                container = (GridViewRow)lblText.NamingContainer;
                lblText.Text = GetValue( container );
            }
            else if( ItemType == ListItemType.AlternatingItem )
            {
                lblText = (Label)sender;
                container = (GridViewRow)lblText.NamingContainer;
                lblText.Text = GetValue( container );
            }
            else if( ItemType == ListItemType.SelectedItem )
            {
                lblText = (Label)sender;
                container = (GridViewRow)lblText.NamingContainer;
                lblText.Text = GetValue( container );
            }
            else if( ItemType == ListItemType.EditItem )
            {
                TextBox txtText = (TextBox)sender;
                container = (GridViewRow)txtText.NamingContainer;
                txtText.Text = GetValue( container );
            }
        }
    }
}