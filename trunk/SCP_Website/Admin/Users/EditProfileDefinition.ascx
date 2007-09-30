<%@ Control Inherits="SharpContent.Modules.Admin.Users.EditProfileDefinition" CodeFile="EditProfileDefinition.ascx.cs" Language="C#" AutoEventWireup="true" %>
<%@ Register TagPrefix="scp" Assembly="SharpContent" Namespace="SharpContent.UI.WebControls"%>

<scp:propertyeditorcontrol id="Properties" runat="Server"
    SortMode="SortOrderAttribute"
	labelstyle-cssclass="SubHead" 
	helpstyle-cssclass="Help" 
	editcontrolstyle-cssclass="NormalTextBox" 
	labelwidth="200px" 
	editcontrolwidth="250px" 
	width="450px"/>
<p>
	<scp:commandbutton cssclass="CommandButton" id="cmdUpdate" imageUrl="~/images/save.gif" resourcekey="cmdUpdate" runat="server" text="Update" />&nbsp;
	<scp:commandbutton cssclass="CommandButton" id="cmdCancel" imageUrl="~/images/lt.gif" resourcekey="cmdCancel" runat="server" text="Cancel" causesvalidation="False"  />&nbsp;
	<scp:commandbutton cssclass="CommandButton" id="cmdDelete" imageUrl="~/images/delete.gif" resourcekey="cmdDelete" runat="server" text="Delete" causesvalidation="False"  />
</p>
