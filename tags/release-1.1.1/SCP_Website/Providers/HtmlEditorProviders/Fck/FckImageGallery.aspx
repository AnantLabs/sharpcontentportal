<%@ Page Language="C#" ValidateRequest="false" Trace="false" CodeFile="FckImageGallery.aspx.cs" AutoEventWireup="true" Inherits="SharpContent.HtmlEditor.FckHtmlEditorProvider.FckImageGallery" %>
<HTML>
	<HEAD id="Head" runat="server">
		<title>
			<%= title %>
		</title>
		<meta http-equiv="PAGE-ENTER" content="RevealTrans(Duration=0,Transition=1)">
		<style id="StylePlaceholder" runat="server"></style>
		<asp:placeholder id="CSS" runat="server"></asp:placeholder>
		<asp:placeholder id="phSCPHead" runat="server"></asp:placeholder>
		<base target="_self" />
	</HEAD>
	<body id="Body" runat="server">
		<noscript></noscript>
		<script language="javascript">
	function OpenFile( fileUrl )
{
	if (!window.top.opener) {
		window.returnValue = fileUrl;
		window.close();
	}
	else {
		window.top.opener.SetUrl( fileUrl ) ;
		window.top.close() ;
		window.top.opener.focus() ;
	}
}

function OpenFlashFile( fileUrl, width, height )
{
	if (!window.top.opener) {
		window.returnValue = fileUrl;
		window.close();
	}
	else {
		window.top.opener.SetUrl( fileUrl ,width, height) ;
		window.top.close() ;
		window.top.opener.focus() ;
	}
}
		</script>
		<form id="Form" runat="server" encType="multipart/form-data">
			<asp:PlaceHolder id="phContent" runat="server"></asp:PlaceHolder>
			<input id="ScrollTop" runat="server" name="ScrollTop" type="hidden">
			<input id="__scpVariable" runat="server" name="__scpVariable" type="hidden">            
		</form>
		
	</body>
</HTML>
