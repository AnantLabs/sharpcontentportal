<%@ Control Language="C#" AutoEventWireup="true"  Inherits="SharpContent.Modules.Admin.Security.EditRoles" CodeFile="EditRoles.ascx.cs" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="SectionHead" Src="~/controls/SectionHeadControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="Url" Src="~/controls/UrlControl.ascx" %>
<%@ Register TagPrefix="scp" Assembly="SharpContent" Namespace="SharpContent.UI.WebControls"%>
<table class="Settings" cellspacing="2" cellpadding="2" summary="Edit Roles Design Table" border="0">
	<tr>
		<td width="560" valign="top">
			<asp:panel id="pnlBasic" runat="server" cssclass="WorkPanel" visible="True"><scp:sectionhead id=dshBasic cssclass="Head" runat="server" text="Basic Settings" section="tblBasic" resourcekey="BasicSettings" includerule="True"></scp:sectionhead>
      <table id=tblBasic cellspacing=0 cellpadding=2 width=525 
      summary="Basic Settings Design Table" border=0 runat="server">
        <tr>
          <td colspan=2><asp:label id=lblBasicSettingsHelp cssclass="Normal" runat="server" resourcekey="BasicSettingsDescription" enableviewstate="False"></asp:label></td></tr>
        <tr valign=top>
          <td class=SubHead width=150><scp:label id=plRoleName runat="server" resourcekey="RoleName" suffix=":" controlname="txtRoleName"></scp:label></td>
          <td align=left width=325 nowrap><asp:textbox id=txtRoleName cssclass="NormalTextBox" runat="server" maxlength="50" columns="30" width="300"></asp:textbox><asp:Image ID="Image1" runat="server" BorderStyle="None" ImageUrl="~/images/required.gif" /><asp:label id=lblRoleName Visible="False" Runat="server" CssClass="Normal"></asp:label><asp:requiredfieldvalidator id=valRoleName cssclass="NormalRed" runat="server" resourcekey="valRoleName" controltovalidate="txtRoleName" errormessage="<br>You Must Enter a Valid Name" display="Dynamic"></asp:requiredfieldvalidator></td></tr>
        <tr valign=top>
          <td class=SubHead width=150><scp:label id=plDescription runat="server" resourcekey="Description" suffix=":" controlname="txtDescription"></scp:label></td>
          <td width=325 nowrap><asp:textbox id=txtDescription cssclass="NormalTextBox" runat="server" maxlength="1000" columns="30" width="300" textmode="MultiLine" height="84px"></asp:textbox></td></tr>
        <tr>
          <td class=SubHead width=150><scp:label id=plRoleGroups runat="server" suffix="" controlname="cboRoleGroups"></scp:label></td>
          <td width=325><asp:dropdownlist id=cboRoleGroups cssclass="NormalTextBox" Runat="server"></asp:dropdownlist></td></tr>
        <tr>
          <td class=SubHead width=150><scp:label id=plIsPublic runat="server" resourcekey="PublicRole" controlname="chkIsPublic"></scp:label></td>
          <td width=325><asp:checkbox id=chkIsPublic runat="server"></asp:checkbox></td></tr>
        <tr>
          <td class=SubHead width=150><scp:label id=plAutoAssignment runat="server" resourcekey="AutoAssignment" controlname="chkAutoAssignment"></scp:label></td>
          <td width=325><asp:checkbox id=chkAutoAssignment runat="server"></asp:checkbox></td></tr></table><br><scp:sectionhead id=dshAdvanced cssclass="Head" runat="server" text="Advanced Settings" section="tblAdvanced" resourcekey="AdvancedSettings" includerule="True" isexpanded="False"></scp:sectionhead>
      <table id=tblAdvanced cellspacing=0 cellpadding=2 width=525 
      summary="Advanced Settings Design Table" border=0 runat="server">
        <tr>
          <td colspan=2><asp:label id=lblAdvancedSettingsHelp cssclass="Normal" runat="server" resourcekey="AdvancedSettingsHelp" enableviewstate="False"></asp:label></td></tr>
        <tr valign=top>
          <td class=SubHead width=150><scp:label id=plServiceFee runat="server" resourcekey="ServiceFee" suffix=":" controlname="txtServiceFee"></scp:label></td>
          <td width=325><asp:textbox id=txtServiceFee cssclass="NormalTextBox" runat="server" maxlength="50" columns="30" width="100"></asp:textbox><asp:comparevalidator id=valServiceFee1 cssclass="NormalRed" runat="server" resourcekey="valServiceFee1" controltovalidate="txtServiceFee" errormessage="<br>Service Fee Value Entered Is Not Valid" display="Dynamic" type="Currency" operator="DataTypeCheck"></asp:comparevalidator><asp:comparevalidator id=valServiceFee2 cssclass="NormalRed" runat="server" resourcekey="valServiceFee2" controltovalidate="txtServiceFee" errormessage="<br>Service Fee Must Be Greater Than or Equal to Zero" display="Dynamic" operator="GreaterThanEqual" valuetocompare="0"></asp:comparevalidator></td></tr>
        <tr valign=top>
          <td class=SubHead width=150><scp:label id=plBillingPeriod runat="server" resourcekey="BillingPeriod" suffix=":" controlname="txtBillingPeriod"></scp:label></td>
          <td width=325><asp:textbox id=txtBillingPeriod cssclass="NormalTextBox" runat="server" maxlength="50" columns="30" width="100"></asp:textbox>&nbsp;&nbsp; 
<asp:dropdownlist id=cboBillingFrequency cssclass="NormalTextBox" runat="server" width="100px" datavaluefield="value" datatextfield="text"></asp:dropdownlist><asp:comparevalidator id=valBillingPeriod1 cssclass="NormalRed" runat="server" resourcekey="valBillingPeriod1" controltovalidate="txtBillingPeriod" errormessage="<br>Billing Period Value Entered Is Not Valid" display="Dynamic" type="Integer" operator="DataTypeCheck"></asp:comparevalidator><asp:comparevalidator id=valBillingPeriod2 cssclass="NormalRed" runat="server" resourcekey="valBillingPeriod2" controltovalidate="txtBillingPeriod" errormessage="<br>Billing Period Must Be Greater Than or Equal to Zero" display="Dynamic" operator="GreaterThan" valuetocompare="0"></asp:comparevalidator></td></tr>
        <tr valign=top>
          <td class=SubHead width=150><scp:label id=plTrialFee runat="server" resourcekey="TrialFee" suffix=":" controlname="txtTrialFee"></scp:label></td>
          <td width=325><asp:textbox id=txtTrialFee cssclass="NormalTextBox" runat="server" maxlength="50" columns="30" width="100"></asp:textbox><asp:comparevalidator id=valTrialFee1 cssclass="NormalRed" runat="server" resourcekey="valTrialFee1" controltovalidate="txtTrialFee" errormessage="<br>Trial Fee Value Entered Is Not Valid" display="Dynamic" type="Currency" operator="DataTypeCheck"></asp:comparevalidator><asp:comparevalidator id=valTrialFee2 cssclass="NormalRed" runat="server" resourcekey="valTrialFee2" controltovalidate="txtTrialFee" errormessage="<br>Trial Fee Must Be Greater Than Zero" display="Dynamic" operator="GreaterThanEqual" valuetocompare="0"></asp:comparevalidator></td></tr>
        <tr valign=top>
          <td class=SubHead width=150><scp:label id=plTrialPeriod runat="server" resourcekey="TrialPeriod" suffix=":" controlname="txtTrialPeriod"></scp:label></td>
          <td width=325><asp:textbox id=txtTrialPeriod cssclass="NormalTextBox" runat="server" maxlength="50" columns="30" width="100"></asp:textbox>&nbsp;&nbsp; 
<asp:dropdownlist id=cboTrialFrequency cssclass="NormalTextBox" runat="server" width="100px" datavaluefield="value" datatextfield="text"></asp:dropdownlist><asp:comparevalidator id=valTrialPeriod1 cssclass="NormalRed" runat="server" resourcekey="valTrialPeriod1" controltovalidate="txtTrialPeriod" errormessage="<br>Trial Period Value Entered Is Not Valid" display="Dynamic" type="Integer" operator="DataTypeCheck"></asp:comparevalidator><asp:comparevalidator id=valTrialPeriod2 cssclass="NormalRed" runat="server" resourcekey="valTrialPeriod2" controltovalidate="txtTrialPeriod" errormessage="<br>Trial Period Must Be Greater Than Zero" display="Dynamic" operator="GreaterThan" valuetocompare="0"></asp:comparevalidator></td></tr>
        <tr valign=top>
          <td class=SubHead width=150><scp:label id=plRSVPCode runat="server" controlname="txtRSVPCode"></scp:label></td>
          <td width=325><asp:textbox id=txtRSVPCode cssclass="NormalTextBox" runat="server" maxlength="50" columns="30" width="100"></asp:textbox></td>
         </tr>
		<tr>
		  <td class="SubHead" width="150" valign="top"><scp:label id="plIcon" text="Icon:" runat="server" controlname="ctlIcon"></scp:label></td>
		  <td width="325"><scp:url id="ctlIcon" runat="server" width="325" showurls="False" showtabs="False" showlog="False" showtrack="False" required="False" /></td>
		</tr>
        </table>
		</asp:panel>
		</td>
	</tr>
</table>
<p>
    <scp:commandbutton cssclass="CommandButton" id="cmdUpdate" runat="server" resourcekey="cmdUpdate" imageurl="~/images/save.gif" />
	&nbsp;
	<scp:commandbutton cssclass="CommandButton" id="cmdCancel" runat="server" resourcekey="cmdCancel" imageurl="~/images/lt.gif" CausesValidation="False" />
	&nbsp
	<scp:commandbutton cssclass="CommandButton" id="cmdDelete" runat="server" resourcekey="cmdDelete" imageurl="~/images/delete.gif" CausesValidation="False" />
	&nbsp;
	<scp:commandbutton cssclass="CommandButton" id="cmdManage" runat="server" resourcekey="cmdManage" imageurl="~/images/icon_users_16px.gif" CausesValidation="False" />
</p>
