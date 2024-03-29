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
using System.Drawing;
using System.Web.UI.WebControls;
using SharpContent.Common.Utilities;
using SharpContent.Entities.Modules;
using SharpContent.Entities.Modules.Actions;
using SharpContent.Security;
using SharpContent.Services.Exceptions;
using SharpContent.Services.Localization;
using SharpContent.Services.Vendors;

namespace SharpContent.Modules.Admin.Vendors
{
    public partial class DisplayBanners : PortalModuleBase, IActionable
    {
        // The Page_Load event handler on this User Control is used to
        // obtain a DataReader of banner information from the Banners
        // table, and then databind the results to a templated DataList
        // server control.  It uses the SharpContent.BannerDB()
        // data component to encapsulate all data functionality.
        protected void Page_Load( Object sender, EventArgs e )
        {
            try
            {
                int intPortalId=0;
                int intBannerTypeId=0;
                string strBannerGroup;
                int intBanners = 0;

                // banner parameters
                switch( Convert.ToString( Settings["bannersource"] ) )
                {
                    case "L": // local
                        intPortalId = PortalId;
                        break;

                    case "":

                        intPortalId = PortalId;
                        break;
                    case "G": // global

                        intPortalId = Null.NullInteger;
                        break;
                }
                if( Convert.ToString( Settings["bannertype"] ) != "" )
                {
                    intBannerTypeId = int.Parse( Convert.ToString( Settings["bannertype"] ) );
                }
                strBannerGroup = Convert.ToString( Settings["bannergroup"] );
                if( Convert.ToString( Settings["bannercount"] ) != "" )
                {
                    intBanners = int.Parse( Convert.ToString( Settings["bannercount"] ) );
                }
                if( Convert.ToString( Settings["padding"] ) != "" )
                {
                    lstBanners.CellPadding = int.Parse( Convert.ToString( Settings["padding"] ) );
                }

                // load banners
                if( intBanners != 0 )
                {
                    BannerController objBanners = new BannerController();
                    lstBanners.DataSource = objBanners.LoadBanners( intPortalId, ModuleId, intBannerTypeId, strBannerGroup, intBanners );
                    lstBanners.DataBind();
                }

                // set banner display characteristics
                if( lstBanners.Items.Count != 0 )
                {
                    // container attributes
                    lstBanners.RepeatLayout = RepeatLayout.Table;
                    if( Convert.ToString( Settings["orientation"] ) != "" )
                    {
                        switch( Convert.ToString( Settings["orientation"] ) )
                        {
                            case "H":

                                lstBanners.RepeatDirection = RepeatDirection.Horizontal;
                                break;
                            case "V":

                                lstBanners.RepeatDirection = RepeatDirection.Vertical;
                                break;
                        }
                    }
                    else
                    {
                        lstBanners.RepeatDirection = RepeatDirection.Vertical;
                    }
                    if( Convert.ToString( Settings["border"] ) != "" )
                    {
                        lstBanners.ItemStyle.BorderWidth = Unit.Parse( Convert.ToString( Settings["border"] ) + "px" );
                    }
                    if( Convert.ToString( Settings["bordercolor"] ) != "" )
                    {
                        ColorConverter objColorConverter = new ColorConverter();
                        lstBanners.ItemStyle.BorderColor = (Color)objColorConverter.ConvertFrom( Convert.ToString( Settings["bordercolor"] ) );
                    }

                    // item attributes
                    lstBanners.ItemStyle.VerticalAlign = VerticalAlign.Middle;
                    if( Convert.ToString( Settings["rowheight"] ) != "" )
                    {
                        lstBanners.ItemStyle.Height = Unit.Parse( Convert.ToString( Settings["rowheight"] ) + "px" );
                    }
                    if( Convert.ToString( Settings["colwidth"] ) != "" )
                    {
                        lstBanners.ItemStyle.Width = Unit.Parse( Convert.ToString( Settings["colwidth"] ) + "px" );
                    }
                }
                else
                {
                    lstBanners.Visible = false;
                }
            }
            catch( Exception exc ) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException( this, exc );
            }
        }

        public string FormatItem( int VendorId, int BannerId, int BannerTypeId, string BannerName, string ImageFile, string Description, string URL, int Width, int Height )
        {
            BannerController objBanners = new BannerController();
            return objBanners.FormatBanner( VendorId, BannerId, BannerTypeId, BannerName, ImageFile, Description, URL, Width, Height, Convert.ToString( Settings["bannersource"] ), PortalSettings.HomeDirectory );
        }

        public ModuleActionCollection ModuleActions
        {
            get
            {
                ModuleActionCollection actions = new ModuleActionCollection();
                actions.Add( GetNextActionID(), Localization.GetString( ModuleActionType.AddContent, LocalResourceFile ), ModuleActionType.AddContent, "", "", EditUrl(), false, SecurityAccessLevel.Edit, true, false );
                return actions;
            }
        }
    }
}