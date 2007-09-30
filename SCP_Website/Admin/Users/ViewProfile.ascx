<%@ Control Language="C#" EnableViewState="true" CodeFile="ViewProfile.ascx.cs" AutoEventWireup="true" Inherits="SharpContent.Modules.Admin.Users.ViewProfile" %>
<%@ Register TagPrefix="scp" TagName="Profile" Src="~/Admin/Users/ProfileModule.ascx" %>
<%@ Register TagPrefix="scp" Assembly="SharpContent" Namespace="SharpContent.UI.WebControls"%>
<scp:Profile id="ctlProfile" runat="server" EditorMode="View" ShowUpdate="False" />
