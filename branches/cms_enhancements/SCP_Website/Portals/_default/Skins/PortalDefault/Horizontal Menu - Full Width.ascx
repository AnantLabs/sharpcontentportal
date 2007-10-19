<%@ Control Language="C#" AutoEventWireup="true" Inherits="SharpContent.UI.Skins.Skin" %>
<%@ Register TagPrefix="scp" TagName="LOGO" Src="~/Admin/Skins/Logo.ascx" %>
<%@ Register TagPrefix="scp" TagName="BANNER" Src="~/Admin/Skins/Banner.ascx" %>
<%@ Register TagPrefix="scp" TagName="MENU" Src="~/Admin/Skins/SolPartMenu.ascx" %>
<%@ Register TagPrefix="scp" TagName="SEARCH" Src="~/Admin/Skins/Search.ascx" %>
<%@ Register TagPrefix="scp" TagName="CURRENTDATE" Src="~/Admin/Skins/CurrentDate.ascx" %>
<%@ Register TagPrefix="scp" TagName="BREADCRUMB" Src="~/Admin/Skins/BreadCrumb.ascx" %>
<%@ Register TagPrefix="scp" TagName="USER" Src="~/Admin/Skins/User.ascx" %>
<%@ Register TagPrefix="scp" TagName="LOGIN" Src="~/Admin/Skins/Login.ascx" %>
<%@ Register TagPrefix="scp" TagName="COPYRIGHT" Src="~/Admin/Skins/Copyright.ascx" %>
<%@ Register TagPrefix="scp" TagName="TERMS" Src="~/Admin/Skins/Terms.ascx" %>
<%@ Register TagPrefix="scp" TagName="PRIVACY" Src="~/Admin/Skins/Privacy.ascx" %>
<%@ Register TagPrefix="scp" TagName="SharpContent" Src="~/Admin/Skins/SharpContent.ascx" %>
<%@ Register TagPrefix="scp" TagName="LANGUAGE" Src="~/Admin/Skins/Language.ascx" %>
<table class="pagemaster" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td valign="top">
            <table class="skinmaster" width="100%" border="0" align="center" cellspacing="0"
                cellpadding="0">
                <tr>
                    <td id="ControlPanel" runat="server" class="contentpane" valign="top" align="center">
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <table class="skinheader" cellspacing="0" cellpadding="3" width="100%" border="0">
                            <tr>
                                <td valign="top" align="left" nowrap>
                                    <scp:CURRENTDATE runat="server" ID="CURRENTDATE1" />
                                </td>
                                <td valign="top" align="right" nowrap>
                                    <scp:USER runat="server" ID="USER1" />
                                    &nbsp;|&nbsp;<scp:LOGIN runat="server" ID="LOGIN1" />
                                </td>
                            </tr>
                            <tr>
                                <td valign="middle" align="left">
                                    <scp:LOGO runat="server" ID="SCPLOGO" />
                                </td>
                                <td valign="middle" align="right">
                                    <scp:BANNER runat="server" ID="SCPBANNER" />
                                </td>
                            </tr>
                        </table>
                        <table class="skingradient" cellspacing="0" cellpadding="3" width="100%" border="0">
                            <tr>
                                <td width="100%" valign="middle" align="left" nowrap>
                                    <scp:MENU runat="server" ID="SCPMENU" />
                                </td>
                                <td class="skingradient" valign="middle" align="right" nowrap>
                                    <scp:SEARCH runat="server" ID="SCPSEARCH" />
                                    <scp:LANGUAGE runat="server" ID="SCPLANGUAGE" />
                                </td>
                            </tr>
                        </table>
                        <table cellspacing="0" cellpadding="3" width="100%" border="0">
                            <tr>
                                <td width="100%" valign="top" align="left" nowrap style="height: 23px">
                                    <asp:Label ID="lblBreadCrumb" runat="server" Text="You are here:" CssClass="SkinObject"></asp:Label>&nbsp;
                                    <scp:BREADCRUMB runat="server" ID="SCPBREADCRUMB" RootLevel="0" Separator="&nbsp;&rArr;&nbsp;"
                                        UseTitle="false" />
                                </td>
                                <td width="200" valign="top" align="center" style="height: 23px">
                                </td>
                                <td width="200" valign="top" align="right" nowrap style="height: 23px">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="top" height="100%">
                        <table cellspacing="3" cellpadding="3" width="100%" border="0">
                            <tr>
                                <td class="toppane" colspan="3" id="TopPane" runat="server" valign="top" align="center">
                                </td>
                            </tr>
                            <tr valign="top">
                                <td class="leftpane" id="LeftPane" runat="server" valign="top" align="center">
                                </td>
                                <td class="contentpane" id="ContentPane" runat="server" valign="top" align="center">
                                </td>
                                <td class="rightpane" id="RightPane" runat="server" valign="top" align="center">
                                </td>
                            </tr>
                            <tr>
                                <td class="bottompane" colspan="3" id="BottomPane" runat="server" valign="top" align="center">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <table class="skingradient" cellspacing="0" cellpadding="0" width="100%" border="0">
                            <tr>
                                <td valign="middle" align="center">
                                    <scp:COPYRIGHT runat="server" ID="SCPCOPYRIGHT" />
                                    &nbsp;&nbsp;<scp:TERMS runat="server" ID="SCPTERMS" />
                                    &nbsp;&nbsp;<scp:PRIVACY runat="server" ID="SCPPRIVACY" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign="top" align="center">
                        <scp:SharpContent runat="server" ID="SCPSharpContent" />
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
