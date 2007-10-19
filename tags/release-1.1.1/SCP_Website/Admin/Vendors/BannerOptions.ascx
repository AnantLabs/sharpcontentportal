<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register Assembly="SharpContent.WebControls" Namespace="SharpContent.UI.WebControls" TagPrefix="scp" %>
<%@ Control Language="C#" CodeFile="BannerOptions.ascx.cs" AutoEventWireup="true" Inherits="SharpContent.Modules.Admin.Vendors.BannerOptions" %>
<style type="text/css">
.GroupSuggestMenu {
    width: 250px;
}
</style>
<table cellSpacing="2" cellPadding="0" width="560" summary="Banner Options Design Table">
	<tr valign="bottom">
		<td class="SubHead" width="125" vAlign="top"><scp:label id="plSource" runat="server" controlname="optSource" suffix=":"></scp:label></td>
		<td vAlign="top">
			<asp:RadioButtonList id="optSource" runat="server" CssClass="NormalBold" RepeatDirection="Horizontal">
				<asp:ListItem Value="G" resourcekey="Host">Host</asp:ListItem>
				<asp:ListItem Value="L" resourcekey="Site">Site</asp:ListItem>
			</asp:RadioButtonList>
		</td>
	</tr>
	<tr valign="bottom">
		<td class="SubHead" width="125" vAlign="top"><scp:label id="plType" runat="server" controlname="cboType" suffix=":"></scp:label></td>
		<td vAlign="top">
			<asp:DropDownList ID="cboType" Runat="server" CssClass="NormalTextBox" Width="250px" DataTextField="BannerTypeName"
				DataValueField="BannerTypeId"></asp:DropDownList>
		</td>
	</tr>
	<tr valign="bottom">
		<td class="SubHead" width="125" vAlign="top"><scp:label id="plGroup" runat="server" controlname="txtGroup" suffix=":"></scp:label></td>
        <td valign="top">
            <scp:SCPTextSuggest ID="SCPTxtBannerGroup" runat="server" Columns="30" CssClass="NormalTextBox" DefaultNodeCssClassOver="SuggestNodeOver" LookupDelay="500" MaxLength="100"
                TextSuggestCssClass="SuggestTextMenu GroupSuggestMenu" Width="250px">
            </scp:SCPTextSuggest></td>
	</tr>
	<tr valign="bottom">
		<td class="SubHead" width="125" vAlign="top"><scp:label id="plCount" runat="server" controlname="txtCount" suffix=":"></scp:label></td>
		<td vAlign="top">
			<asp:TextBox id="txtCount" Runat="server" CssClass="NormalTextBox" Columns="30" Width="250px"></asp:TextBox>
			<asp:RegularExpressionValidator id="valCount" ControlToValidate="txtCount" ValidationExpression="^[0-9]*$" Display="Dynamic"
				resourcekey="valCount.ErrorMessage" runat="server" CssClass="NormalRed" />
		</td>
	</tr>
	<tr valign="bottom">
		<td class="SubHead" width="125" vAlign="top"><scp:label id="plOrientation" runat="server" controlname="optOrientation" suffix=":"></scp:label></td>
		<td vAlign="top">
			<asp:RadioButtonList id="optOrientation" runat="server" CssClass="NormalBold" RepeatDirection="Horizontal">
				<asp:ListItem Value="V" resourcekey="Vertical">Vertical</asp:ListItem>
				<asp:ListItem Value="H" resourcekey="Horizontal">Horizontal</asp:ListItem>
			</asp:RadioButtonList>
		</td>
	</tr>
	<tr valign="bottom">
		<td class="SubHead" width="125" vAlign="top"><scp:label id="plBorder" runat="server" controlname="txtBorder" suffix=":"></scp:label></td>
		<td vAlign="top">
			<asp:TextBox id="txtBorder" Runat="server" CssClass="NormalTextBox" Columns="30" Width="250px"></asp:TextBox>
			<asp:RegularExpressionValidator id="valBorder" ControlToValidate="txtBorder" ValidationExpression="^[0-9]*$" Display="Dynamic"
				resourcekey="valBorder.ErrorMessage" runat="server" CssClass="NormalRed" />
		</td>
	</tr>
	<tr valign="bottom">
		<td class="SubHead" width="125" vAlign="top"><scp:label id="plBorderColor" runat="server" controlname="txtBorderColor" suffix=":"></scp:label></td>
		<td vAlign="top">
			<asp:TextBox id="txtBorderColor" Runat="server" CssClass="NormalTextBox" Columns="30" Width="250px"></asp:TextBox>
		</td>
	</tr>
	<TR>
		<TD class="SubHead" vAlign="top" width="125">
			<scp:label id="plPadding" suffix=":" controlname="txtPadding" runat="server"></scp:label></TD>
		<TD vAlign="top">
			<asp:TextBox id="txtPadding" CssClass="NormalTextBox" Width="250px" Runat="server" Columns="30">4</asp:TextBox>
			<asp:CompareValidator id="valPadding" runat="server" CssClass="NormalRed" resourcekey="valPadding.ErrorMessage"
				Display="Dynamic" ControlToValidate="txtPadding" Operator="DataTypeCheck" Type="Integer"></asp:CompareValidator></TD>
	</TR>
	<tr valign="bottom">
		<td class="SubHead" width="125" vAlign="top"><scp:label id="plRowHeight" runat="server" controlname="txtRowHeight" suffix=":"></scp:label></td>
		<td vAlign="top">
			<asp:TextBox id="txtRowHeight" Runat="server" CssClass="NormalTextBox" Columns="30" Width="250px"></asp:TextBox>
			<asp:RegularExpressionValidator id="valRowHeight" ControlToValidate="txtRowHeight" ValidationExpression="^[0-9]*$"
				Display="Dynamic" resourcekey="valRowHeight.ErrorMessage" runat="server" CssClass="NormalRed" />
		</td>
	</tr>
	<tr valign="bottom">
		<td class="SubHead" width="125" vAlign="top"><scp:label id="plColWidth" runat="server" controlname="txtColWidth" suffix=":"></scp:label></td>
		<td vAlign="top">
			<asp:TextBox id="txtColWidth" Runat="server" CssClass="NormalTextBox" Columns="30" Width="250px"></asp:TextBox>
			<asp:RegularExpressionValidator id="valColWidth" ControlToValidate="txtColWidth" ValidationExpression="^[0-9]*$"
				Display="Dynamic" resourcekey="valColWidth.ErrorMessage" runat="server" CssClass="NormalRed" />
		</td>
	</tr>
</table>
<p>
	<asp:LinkButton id="cmdUpdate" Text="Update" resourcekey="cmdUpdate" runat="server" class="CommandButton"
		BorderStyle="none" OnClick="cmdUpdate_Click" />
	&nbsp;
	<asp:LinkButton id="cmdCancel" Text="Cancel" resourcekey="cmdCancel" CausesValidation="False" runat="server"
		class="CommandButton" BorderStyle="none" OnClick="cmdCancel_Click" />
</p>
