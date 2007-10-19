using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class Portal_SubHost : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string domainName = String.Empty;
        string serverPath = String.Empty;
        bool isEndLoop = false;

        // parse the Request URL into a Domain Name token 
        string[] url = Request.Url.ToString().Split(new string[]{"/"}, StringSplitOptions.RemoveEmptyEntries);
        for (int i = 2; i < url.Length && !isEndLoop; i++)
        {
            switch (url[i].ToLower())
            {
                case "admin":
                case "desktopmodules":
                case "mobilemodules":
                case "premiummodules":
                    i = url.Length;
                    break;
                default:
                    // check if filename
                    if (url[i].IndexOf(".aspx") >= 0)
                    {
                        domainName += (!String.IsNullOrEmpty(domainName) ? "/" : "") + url[i];
                    }
                    else
                    {
                        i = url.Length;
                    }
                    break;
            }
        }              

        // format the Request.ApplicationPath
        serverPath = Request.ApplicationPath;
        if (!serverPath.EndsWith("/"))
        {
            serverPath = serverPath + "/";
        }
        
        domainName = serverPath + "Default.aspx?alias=" + domainName;

        Response.Redirect(domainName, true);
    }
}
