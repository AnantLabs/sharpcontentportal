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
using System.Web.UI;
using SharpContent.Common.Utilities;

namespace SharpContent.UI.WebControls
{
    /// <Summary>
    /// The IntegerEditControl control provides a standard UI component for editing
    /// integer properties.
    /// </Summary>
    [ToolboxData( "<{0}:IntegerEditControl runat=server></{0}:IntegerEditControl>" )]
    public class IntegerEditControl : EditControl
    {

        /// <Summary>
        /// IntegerValue returns the Integer representation of the Value
        /// </Summary>
        protected int IntegerValue
        {
            get
            {
                int intValue = Null.NullInteger;
                try
                {
                    //Try and cast the value to an Integer
                    intValue = Convert.ToInt32(Value);
                }
                catch (Exception)
                {
                }
                return intValue;
            }
        }

        /// <Summary>
        /// OldIntegerValue returns the Integer representation of the OldValue
        /// </Summary>
        protected int OldIntegerValue
        {
            get
            {
                int intValue = Null.NullInteger;
                try
                {
                    //Try and cast the value to an Integer
                    intValue = Convert.ToInt32(OldValue);
                }
                catch (Exception)
                {
                }
                return intValue;
            }
        }

        /// <Summary>
        /// StringValue is the value of the control expressed as a String
        /// </Summary>
        protected override string StringValue
        {
            get
            {
                return this.IntegerValue.ToString();
            }
            set
            {
                int setValue = int.Parse(value);
                this.Value = setValue;
            }
        }
        /// <Summary>Constructs an IntegerEditControl</Summary>
        public IntegerEditControl()
        {
            this.SystemType = "System.Int32";
        }

        /// <Summary>
        /// OnDataChanged runs when the PostbackData has changed.  It raises the ValueChanged
        /// Event
        /// </Summary>
        protected override void OnDataChanged( EventArgs e )
        {
            PropertyEditorEventArgs args = new PropertyEditorEventArgs(Name);
            args.Value = IntegerValue;
            args.OldValue = OldIntegerValue;
            args.StringValue = StringValue;
            base.OnValueChanged(args);
        }

        /// <Summary>RenderEditMode renders the Edit mode of the control</Summary>
        /// <Param name="writer">A HtmlTextWriter.</Param>
        protected override void RenderEditMode( HtmlTextWriter writer )
        {
            ControlStyle.AddAttributesToRender(writer);
            writer.AddAttribute(HtmlTextWriterAttribute.Type, "text");
            writer.AddAttribute(HtmlTextWriterAttribute.Size, "5");
            writer.AddAttribute(HtmlTextWriterAttribute.Value, StringValue);
            writer.AddAttribute(HtmlTextWriterAttribute.Name, this.UniqueID);
            writer.RenderBeginTag(HtmlTextWriterTag.Input);
            writer.RenderEndTag();
        }
    }
}