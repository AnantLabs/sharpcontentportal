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
using System.Web.UI;
using SharpContent.Common;
using SharpContent.Entities.Portals;
using SharpContent.Entities.Tabs;

namespace SharpContent.UI.WebControls
{
    /// <Summary>
    /// The SCPPageEditControl control provides a standard UI component for selecting
    /// a SCP Page
    /// </Summary>
    [ToolboxData( "<{0}:SCPPageEditControl runat=server></{0}:SCPPageEditControl>" )]
    public class SCPPageEditControl : IntegerEditControl
    {
        /// <Summary>Constructs a SCPPageEditControl</Summary>
        public SCPPageEditControl()
        {
        }

        /// <Summary>RenderEditMode renders the Edit mode of the control</Summary>
        /// <Param name="writer">A HtmlTextWriter.</Param>
        protected override void RenderEditMode( HtmlTextWriter writer )
        {
            PortalSettings _portalSettings = Globals.GetPortalSettings();

            //Get the Pages
            ArrayList tabs = Globals.GetPortalTabs(_portalSettings.PortalId, true, true, false, false, false);

            //Render the Select Tag
            ControlStyle.AddAttributesToRender(writer);
            writer.AddAttribute(HtmlTextWriterAttribute.Name, this.UniqueID);
            writer.RenderBeginTag(HtmlTextWriterTag.Select);

            for (int tabIndex = 0; tabIndex <= tabs.Count - 1; tabIndex++)
            {
                TabInfo tab = (TabInfo)tabs[tabIndex];

                //Add the Value Attribute
                writer.AddAttribute(HtmlTextWriterAttribute.Value, tab.TabID.ToString());

                if (tab.TabID == IntegerValue)
                {
                    //Add the Selected Attribute
                    writer.AddAttribute(HtmlTextWriterAttribute.Selected, "selected");
                }

                //Render Option Tag
                writer.RenderBeginTag(HtmlTextWriterTag.Option);
                writer.Write(tab.TabName);
                writer.RenderEndTag();
            }

            //Close Select Tag
            writer.RenderEndTag();
        }
    }
}