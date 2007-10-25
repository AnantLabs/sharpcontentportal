<%@ Register TagPrefix="scp" Namespace="SharpContent.UI.WebControls" Assembly="SharpContent.WebControls" %>
<%@ Control language="C#" Inherits="SharpContent.Modules.Content.ContentModule" CodeFile="ContentModule.ascx.cs" AutoEventWireup="true" %>

<scp:SCPLabelEdit id="lblContent" runat="server" cssclass="Normal" enableviewstate="False" MouseOverCssClass="LabelEditOverClassML"
	LabelEditCssClass="LabelEditTextClass" EditEnabled="False" MultiLine="True" RichTextEnabled="True"
	ToolBarId="tbEIPHTML" RenderAsDiv="True" EventName="none" LostFocusSave="False" CallBackType="Simple" ClientAPIScriptPath="" LabelEditScriptPath="" WorkCssClass=""></scp:SCPLabelEdit>

<scp:SCPToolBar id="tbEIPHTML" runat="server" CssClass="eipbackimg" ReuseToolbar="true"
	DefaultButtonCssClass="eipbuttonbackimg" DefaultButtonHoverCssClass="eipborderhover">
	<scp:SCPToolBarButton ControlAction="edit" ID="tbEdit" ToolTip="Edit" CssClass="eipbutton_edit" runat="server"/>
	<scp:SCPToolBarButton ControlAction="save" ID="tbSave" ToolTip="Update" CssClass="eipbutton_save" runat="server"/>
	<scp:SCPToolBarButton ControlAction="cancel" ID="tbCancel" ToolTip="Cancel" runat="server"/>
	<scp:SCPToolBarButton ControlAction="bold" ID="tbBold" ToolTip="Bold" runat="server"/>
	<scp:SCPToolBarButton ControlAction="italic" ID="tbItalic" ToolTip="Italic" runat="server"/>
	<scp:SCPToolBarButton ControlAction="underline" ID="tbUnderline" ToolTip="Underline" runat="server"/>
	<scp:SCPToolBarButton ControlAction="justifyleft" ID="tbJustifyLeft" ToolTip="Justify Left" runat="server"/>
	<scp:SCPToolBarButton ControlAction="justifycenter" ID="tbJustifyCenter" ToolTip="Justify Center" runat="server"/>
	<scp:SCPToolBarButton ControlAction="justifyright" ID="tbJustifyRight" ToolTip="Justify Right" runat="server"/>
	<scp:SCPToolBarButton ControlAction="insertorderedlist" ID="tbOrderedList" ToolTip="Ordered List" runat="server"/>
	<scp:SCPToolBarButton ControlAction="insertunorderedlist" ID="tbUnorderedList" ToolTip="Unordered List" runat="server"/>
	<scp:SCPToolBarButton ControlAction="outdent" ID="tbOutdent" ToolTip="Outdent" runat="server"/>
	<scp:SCPToolBarButton ControlAction="indent" ID="tbIndent" ToolTip="Indent" runat="server"/>
	<scp:SCPToolBarButton ControlAction="createlink" ID="tbCreateLink" ToolTip="Create Link" runat="server"/>
</scp:SCPToolBar>