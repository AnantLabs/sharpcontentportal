<%@ Control language="C#" AutoEventWireup="true"  Inherits="SharpContent.UI.Skins.Skin" %>
<%@ Register TagPrefix="scp" TagName="LOGO" Src="~/Admin/Skins/Logo.ascx" %>
<%@ Register TagPrefix="scp" TagName="BANNER" Src="~/Admin/Skins/Banner.ascx" %>
<%@ Register TagPrefix="scp" TagName="SEARCH" Src="~/Admin/Skins/Search.ascx" %>
<%@ Register TagPrefix="scp" TagName="CURRENTDATE" Src="~/Admin/Skins/CurrentDate.ascx" %>
<%@ Register TagPrefix="scp" TagName="BREADCRUMB" Src="~/Admin/Skins/BreadCrumb.ascx" %>
<%@ Register TagPrefix="scp" TagName="USER" Src="~/Admin/Skins/User.ascx" %>
<%@ Register TagPrefix="scp" TagName="LOGIN" Src="~/Admin/Skins/Login.ascx" %>
<%@ Register TagPrefix="scp" TagName="COPYRIGHT" Src="~/Admin/Skins/Copyright.ascx" %>
<%@ Register TagPrefix="scp" TagName="TERMS" Src="~/Admin/Skins/Terms.ascx" %>
<%@ Register TagPrefix="scp" TagName="PRIVACY" Src="~/Admin/Skins/Privacy.ascx" %>
<%@ Register TagPrefix="scp" TagName="SharpContent" Src="~/Admin/Skins/SharpContent.ascx" %>
<%@ Register TagPrefix="scp" TagName="TREEVIEW" Src="~/admin/Skins/TreeViewMenu.ascx"%>
<%@ Register TagPrefix="scp" TagName="LANGUAGE" Src="~/Admin/Skins/Language.ascx" %>
<TABLE class="pagemaster" border="0" cellspacing="0" cellpadding="0">
<TR>
<TD valign="top">
<TABLE class="skinmaster" width="970" border="0" align="center" cellspacing="0" cellpadding="0">
<TR>
<TD id="ControlPanel" runat="server" class="contentpane" valign="top" align="center"></TD>
</TR>
<TR>
<TD valign="top">
<TABLE class="skinheader" cellSpacing="0" cellPadding="3" width="100%" border="0">
  <TR>
    <TD vAlign="middle" align="left"><scp:LOGO runat="server" id="SCPLOGO" /></TD>
    <TD vAlign="middle" align="right"><scp:BANNER runat="server" id="SCPBANNER" /></TD>
  </TR>
</TABLE>
<TABLE class="skingradient" cellSpacing="0" cellPadding="3" width="100%" border="0">
  <TR>
    <TD width="100%" vAlign="middle" align="left" nowrap>&nbsp;</TD>
    <TD class="skingradient" vAlign="middle" align="right" nowrap><scp:SEARCH runat="server" id="SCPSEARCH" /><scp:LANGUAGE runat="server" id="SCPLANGUAGE" /></TD>
  </TR>
</TABLE>
<TABLE cellSpacing="0" cellPadding="3" width="100%" border="0">
  <TR>
    <TD width="200" vAlign="top" align="left" nowrap><scp:CURRENTDATE runat="server" id="SCPCURRENTDATE" /></TD>
    <TD width="100%" vAlign="top" align="center"><B>..::</B>&nbsp;<scp:BREADCRUMB runat="server" id="SCPBREADCRUMB" RootLevel="0" Separator="&nbsp;&raquo;&nbsp;" /><B>::..</B></TD>
    <TD width="200" vAlign="top" align="right" nowrap><scp:USER runat="server" id="SCPUSER" />&nbsp;&nbsp;<scp:LOGIN runat="server" id="SCPLOGIN" /></TD>
  </TR>
</TABLE>
</TD>
</TR>
<TR>
<TD valign="top" height="100%">
<TABLE cellspacing="3" cellpadding="3" width="100%" border="0">
  <TR>
    <TD class="toppane" colspan="3" id="TopPane" runat="server" valign="top" align="center"></TD>
  </TR>
  <TR valign="top">
    <TD class="leftpane" id="LeftPane" runat="server" valign="top" align="center">
      <scp:TREEVIEW id="SCPTreeView" runat="server"
	  			bodyCssClass="Normal" 
		  		CssClass="TreeViewMenu"
				headerCssClass="TreeViewMenu_Header" 
				headerTextCssClass="Head" 
				level="root" 
				nowrap="true"
				treeIndentWidth="5"/>
      <BR>
    </TD>
    <TD class="contentpane" id="ContentPane" runat="server" valign="top" align="center"></TD>
    <TD class="rightpane" id="RightPane" runat="server" valign="top" align="center"></TD>
  </TR>
  <TR>
    <TD class="bottompane" colspan="3" id="BottomPane" runat="server" valign="top" align="center"></TD>
  </TR>
</TABLE>
</TD>
</TR>
<TR>
<TD valign="top">
<TABLE class="skingradient" cellSpacing="0" cellPadding="0" width="100%" border="0">
  <TR>
    <TD valign="middle" align="center"><scp:COPYRIGHT runat="server" id="SCPCOPYRIGHT" />&nbsp;&nbsp;<scp:TERMS runat="server" id="SCPTERMS" />&nbsp;&nbsp;<scp:PRIVACY runat="server" id="SCPPRIVACY" /></TD>
  </TR>
</TABLE>
</TD>
</TR>
<TR>
<TD valign="top" align="center"><scp:SharpContent runat="server" id="SCPSharpContent" /></TD>
</TR>
</TABLE>
</TD>
</TR>
</TABLE>