<%@ Register TagPrefix="scp" Namespace="SharpContent.Common.Controls" Assembly="SharpContent" %>
<%@ Page Language="C#" ValidateRequest="false" Trace="false" CodeFile="FckHtmlEditorOptions.aspx.cs" AutoEventWireup="true" Inherits="SharpContent.HtmlEditor.FckHtmlEditorProvider.FckHtmlEditorOptions" %>

<%@ Register Src="FckInstanceOptions.ascx" TagName="FckInstanceOptions" TagPrefix="uc1" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head id="Head" runat="server">
    <title>
        <%= title %>
    </title>
    <style id="StylePlaceholder" runat="server"></style>
    <asp:placeholder id="CSS" runat="server"></asp:placeholder>
    <asp:placeholder id="FAVICON" runat="server"></asp:placeholder>
    <asp:literal id="_clientScript" runat="server"></asp:literal>
    <asp:placeholder id="phSCPHead" runat="server"></asp:placeholder>
    <base target="_self">
</head>
<body id="Body" runat="server" onscroll="bodyscroll()" bottommargin="5" leftmargin="5"
    topmargin="5" rightmargin="5">

    <script language="JavaScript">
         function bodyscroll() 
         {
           var F=document.forms[0];
           F.ScrollTop.value=Body.scrollTop;
         }
         
    </script>

    <form id="form" runat="server">
        <asp:PlaceHolder ID="phControls" runat="server"></asp:PlaceHolder>
        <input id="ScrollTop" type="hidden" name="ScrollTop" runat="server">
        <input id="__scpVariable" runat="server" name="__scpVariable" type="hidden">
    </form>
</body>
</html>
