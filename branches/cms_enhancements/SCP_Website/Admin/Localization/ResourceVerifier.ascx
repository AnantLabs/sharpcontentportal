<%@ Control Language="C#" AutoEventWireup="true" Inherits="SharpContent.Services.Localization.ResourceVerifier" CodeFile="ResourceVerifier.ascx.cs" %>
<%@ Register TagPrefix="SCPtv" Namespace="SharpContent.UI.WebControls" Assembly="SharpContent.WebControls" %>
<%@ Register TagPrefix="scp" TagName="SectionHead" Src="~/controls/SectionHeadControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<P><asp:linkbutton id="cmdVerify" runat="server" CssClass="CommandButton" resourcekey="cmdVerify" OnClick="cmdVerify_Click">Verify Resource Files</asp:linkbutton>&nbsp;
	<asp:LinkButton id="cmdCancel" runat="server" CssClass="CommandButton" resourcekey="cmdCancel" OnClick="cmdCancel_Click">Cancel</asp:LinkButton></P>
<P><asp:placeholder id="PlaceHolder1" runat="server"></asp:placeholder></P>
