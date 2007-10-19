<%@ Control Language="C#" AutoEventWireup="true" Inherits="SharpContent.UI.Containers.Title" CodeFile="Title.ascx.cs" %>
<%@ Register TagPrefix="scp" Namespace="SharpContent.UI.WebControls" Assembly="SharpContent.WebControls" %>
<scp:SCPLabelEdit id="lblTitle" runat="server" cssclass="Head" enableviewstate="False" MouseOverCssClass="LabelEditOverClass"
	LabelEditCssClass="LabelEditTextClass" EditEnabled="True" OnUpdateLabel="lblTitle_UpdateLabel"></scp:SCPLabelEdit>
