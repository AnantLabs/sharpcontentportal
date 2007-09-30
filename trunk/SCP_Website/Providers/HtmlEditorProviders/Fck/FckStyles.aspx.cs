//
// Sharp Content Portal - http://www.SharpContentPortal.com
// Copyright (c) 2002-2006
// by Perpetual Motion Interactive Systems Inc. ( http://www.perpetualmotion.ca )
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
//
// File Author(s):
// Mauricio Márquez Anze - http://dnn.tiendaboliviana.com
//
// FCKeditor - The text editor for internet - http://www.fckeditor.net
// Copyright (C) 2003-2006 Frederico Caldeira Knabben
//

using System;
using SharpContent.Common;
using SharpContent.Common.Utilities;
using SharpContent.Entities.Portals;
using SharpContent.Security;
using SharpContent.Framework.Providers;
using System.Web.UI.WebControls;
using System.IO;
using System.Web;
using System.Collections;

namespace SharpContent.HtmlEditor.FckHtmlEditorProvider
{

	public partial class FckStylesGenerator : SharpContent.Framework.PageBase
	{
		private ArrayList _Styles;
		private string _StyleExclusions = "";
		private bool _StyleCaseSensitive = true;
		private const string ProviderType = "htmlEditor";
		private ProviderConfiguration _providerConfiguration;
		private string filenames = "";

		private void Page_Load(object sender, System.EventArgs e)
		{

			string MyKey = "FCKXMLStyles_" + this.PortalSettings.PortalId.ToString() + "_" + SharpContent.Common.Globals.CreateValidID(PortalSettings.ActiveTab.SkinSrc);
			object Mydata = DataCache.GetCache(MyKey);
			if (Mydata == null)
			{
				_providerConfiguration = ProviderConfiguration.GetProviderConfiguration(ProviderType);
				Provider objProvider = (Provider)_providerConfiguration.Providers[_providerConfiguration.DefaultProvider];
				_StyleCaseSensitive = Convert.ToBoolean(objProvider.Attributes["DynamicStylesCaseSensitive"]);
				//Get possible exclusions
				if ((Request.QueryString["FCKStyleFilter"] != null))
				{
					//_StyleExclusions = SharpContent.Common.Globals.QueryStringDecode(Request.QueryString["FCKStyleFilter"])
					_StyleExclusions = Request.QueryString["FCKStyleFilter"];
				}
				if (_StyleExclusions == "")
				{
					_StyleExclusions = "" + objProvider.Attributes["DynamicStylesGeneratorFilter"];
				}

				_Styles = new ArrayList();
				//Parse default css
				ParseStyleSheet(SharpContent.Common.Globals.HostPath + "default.css");

				//Parse skin stylesheet(s)
				ParseStyleSheet(PortalSettings.ActiveTab.SkinPath + "skin.css");


				ParseStyleSheet(PortalSettings.ActiveTab.SkinSrc.Replace(".ascx", ".css"));

				//Parse portal stylesheets
				ParseStyleSheet(PortalSettings.HomeDirectory + "portal.css");

				_Styles.Sort();
				System.Text.StringBuilder sb = new System.Text.StringBuilder();
				sb.Append("<?xml version=\"1.0\" encoding=\"utf-8\" ?>" + Environment.NewLine);
				sb.Append("<Styles>" + Environment.NewLine);
				string ts;
				for (int i = 0; i <= _Styles.Count - 1; i++) {
					ts = _Styles[i].ToString();
					sb.Append("<Style name=\"" + ts + " (img)\" element=\"img\">");
					sb.Append("<Attribute name=\"class\" value=\"" + ts + "\" />");
					sb.Append("</Style>" + Environment.NewLine);
					sb.Append("<Style name=\"" + ts + " (span)\" element=\"span\">");
					sb.Append("<Attribute name=\"class\" value=\"" + ts + "\" />");
					sb.Append("</Style>" + Environment.NewLine);
					sb.Append("<Style name=\"" + ts + " (td)\" element=\"td\">");
					sb.Append("<Attribute name=\"class\" value=\"" + ts + "\" />");
					sb.Append("</Style>" + Environment.NewLine);
					sb.Append("<Style name=\"" + ts + " (table)\" element=\"table\">");
					sb.Append("<Attribute name=\"class\" value=\"" + ts + "\" />");
					sb.Append("</Style>" + Environment.NewLine);
					sb.Append("<Style name=\"" + ts + " (link)\" element=\"a\">");
					sb.Append("<Attribute name=\"class\" value=\"" + ts + "\" />");
					sb.Append("</Style>" + Environment.NewLine);

				}
				sb.Append("</Styles>" + Environment.NewLine);
				Mydata = sb.ToString();

				//Vary cache based on each css file status
				string[] MyFiles = filenames.Split(',');
				System.Web.Caching.CacheDependency cd = new System.Web.Caching.CacheDependency(MyFiles);
				DataCache.SetCache(MyKey, Mydata, cd);
			}

			Response.Clear();
			Response.Cache.SetNoServerCaching();
			Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
			Response.Cache.SetNoStore();
			Response.Cache.SetExpires(new DateTime(1900, 1, 1, 0, 0, 0, 0));
			Response.ContentType = "text/xml";
			Response.Write((string)Mydata);
			Response.Flush();
			Response.End();

		}

		private void ParseStyleSheet(string strCssFile)
		{
			string file = HttpContext.Current.Server.MapPath(strCssFile);

			if (File.Exists(file))
			{

				StreamReader objStreamReader;
				string strStyleLine;
				ArrayList alStyles = new ArrayList();
				int i;
				string RealStyle;

				objStreamReader = File.OpenText(HttpContext.Current.Server.MapPath(strCssFile));

				while (objStreamReader.Peek() != -1) {
					strStyleLine = objStreamReader.ReadLine();

					if (strStyleLine.Trim().Substring(0, 1) == ".")
					{

						//Find end of the style header and remove style body
						i = strStyleLine.IndexOf("{");
						if (i != -1)
						{
							strStyleLine = strStyleLine.Substring(0, i);
						}

						//try to find more than one style per line
						string[] multi = strStyleLine.Split(',');
						foreach (string myStyleDef in multi) {
							//Let's remove specific tags inside the style
							string style = myStyleDef.Trim();
							i = style.IndexOf(" ");
							if (i != -1)
							{
								style = style.Substring(0, i);
							}

							if (_StyleCaseSensitive)
							{
								RealStyle = style.TrimStart('.').Trim();
							}
							else
							{
								RealStyle = style.TrimStart('.').Trim().ToLower();
							}

							if (RealStyle != "" && !isExcludedStyle(RealStyle))
							{
								if (!_Styles.Contains(RealStyle))
								{
									_Styles.Add(RealStyle);
								}
							}

						}


					}

				}

				objStreamReader.Close();
				if (filenames == "")
				{
					filenames = file;
				}
				else
				{
                        filenames += "," + file;
				}
			}
		}

		private bool isExcludedStyle(string MyStyle)
		{
			if (_StyleExclusions != "")
			{
				return System.Text.RegularExpressions.Regex.IsMatch(MyStyle, _StyleExclusions, System.Text.RegularExpressions.RegexOptions.IgnoreCase);
			}
			else
			{
				return false;
			}
		}

		#region " Web Form Designer Generated Code "

		//This call is required by the Web Form Designer.
		[System.Diagnostics.DebuggerStepThrough()]
		private void InitializeComponent()
		{

		}

		//NOTE: The following placeholder declaration is required by the Web Form Designer.
		//Do not delete or move it.
		private object designerPlaceholderDeclaration;

		private void Page_Init(object sender, System.EventArgs e)
		{
			//CODEGEN: This method call is required by the Web Form Designer
			//Do not modify it using the code editor.
			InitializeComponent();
		}

		#endregion


	}


}

