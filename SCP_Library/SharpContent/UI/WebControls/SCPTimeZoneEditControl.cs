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
using System.Web.UI.WebControls;
using SharpContent.Common;
using SharpContent.Entities.Portals;
using SharpContent.Framework;
using SharpContent.Services.Localization;

namespace SharpContent.UI.WebControls
{
    /// <Summary>
    /// The SCPTimeZoneEditControl control provides a standard UI component for selecting
    /// a Time Zone
    /// </Summary>
    [ToolboxData( "<{0}:SCPTimeZoneEditControl runat=server></{0}:SCPTimeZoneEditControl>" )]
    public class SCPTimeZoneEditControl : IntegerEditControl
    {
        /// <Summary>Constructs a SCPTimeZoneEditControl</Summary>
        public SCPTimeZoneEditControl()
        {
        }

        /// <Summary>RenderEditMode renders the Edit mode of the control</Summary>
        /// <Param name="writer">A HtmlTextWriter.</Param>
        protected override void RenderEditMode( HtmlTextWriter writer )
        {
            PortalSettings _portalSettings = Globals.GetPortalSettings();

            //For convenience create a DropDownList to use
            DropDownList cboTimeZones = new DropDownList();

            //Load the List with Time Zones
            Localization.LoadTimeZoneDropDownList(cboTimeZones, ((PageBase)Page).PageCulture.Name, Convert.ToString(_portalSettings.TimeZoneOffset));

            //Select the relevant item
            if (cboTimeZones.Items.FindByValue(StringValue) != null)
            {
                cboTimeZones.ClearSelection();
                cboTimeZones.Items.FindByValue(StringValue).Selected = true;
            }

            //Render the Select Tag
            ControlStyle.AddAttributesToRender(writer);
            writer.AddAttribute(HtmlTextWriterAttribute.Name, this.UniqueID);
            writer.RenderBeginTag(HtmlTextWriterTag.Select);

            for (int I = 0; I <= cboTimeZones.Items.Count - 1; I++)
            {
                string timeZoneValue = cboTimeZones.Items[I].Value;
                string timeZoneName = cboTimeZones.Items[I].Text;
                bool isSelected = cboTimeZones.Items[I].Selected;

                //Add the Value Attribute
                writer.AddAttribute(HtmlTextWriterAttribute.Value, timeZoneValue);

                if (isSelected)
                {
                    //Add the Selected Attribute
                    writer.AddAttribute(HtmlTextWriterAttribute.Selected, "selected");
                }

                //Render Option Tag
                writer.RenderBeginTag(HtmlTextWriterTag.Option);
                writer.Write(timeZoneName.PadRight(100).Substring(0, 50));
                writer.RenderEndTag();
            }

            //Close Select Tag
            writer.RenderEndTag();
        }

        /// <Summary>
        /// RenderViewMode renders the View (readonly) mode of the control
        /// </Summary>
        /// <Param name="writer">A HtmlTextWriter.</Param>
        protected override void RenderViewMode( HtmlTextWriter writer )
        {
            PortalSettings _portalSettings = Globals.GetPortalSettings();

            //For convenience create a DropDownList to use
            DropDownList cboTimeZones = new DropDownList();

            //Load the List with Time Zones
            Localization.LoadTimeZoneDropDownList(cboTimeZones, ((PageBase)Page).PageCulture.Name, Convert.ToString(_portalSettings.TimeZoneOffset));

            //Select the relevant item
            if (cboTimeZones.Items.FindByValue(StringValue) != null)
            {
                cboTimeZones.ClearSelection();
                cboTimeZones.Items.FindByValue(StringValue).Selected = true;
            }

            ControlStyle.AddAttributesToRender(writer);
            writer.RenderBeginTag(HtmlTextWriterTag.Span);
            writer.Write(cboTimeZones.SelectedItem.Text);
            writer.RenderEndTag();
        }
    }
}