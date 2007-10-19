<%@ Page Language="C#" ValidateRequest="false" Trace="false" AutoEventWireup="true" Inherits="SharpContent.HtmlEditor.FTBImageGallery" %>
<%@ Register TagPrefix="scp" Namespace="SharpContent.HtmlEditor" Assembly="SharpContent.Ftb3HtmlEditorProvider" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>
		<%=Title%>
	</title>
</head>
<body>
    <form id="Form1" runat="server" enctype="multipart/form-data">  
		<scp:SCPImageGallery id="imgGallery" runat="Server" />
	</form>
</body>
</html>
