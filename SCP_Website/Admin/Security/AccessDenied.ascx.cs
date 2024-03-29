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
using System.Web;
using SharpContent.Entities.Modules;
using SharpContent.Services.Localization;
using SharpContent.UI.Skins.Controls;

namespace SharpContent.Modules.Admin.Security
{
    public partial class AccessDeniedPage : PortalModuleBase
    {
        protected void Page_Load( Object sender, EventArgs e )
        {
            if( Request.QueryString["message"] != "" )
            {
                UI.Skins.Skin.AddModuleMessage(this, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(Request.QueryString["message"])), ModuleMessageType.YellowWarning);
            }
            else
            {
                UI.Skins.Skin.AddModuleMessage( this, Localization.GetString( "AccessDenied", this.LocalResourceFile ), ModuleMessageType.YellowWarning );
            }
        }
    }
}