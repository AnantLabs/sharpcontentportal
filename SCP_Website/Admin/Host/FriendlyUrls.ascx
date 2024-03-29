<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FriendlyUrls.ascx.cs" Inherits="SharpContent.Modules.Admin.Host.FriendlyUrls" %>
<%@ Register TagPrefix="scp" Namespace="SharpContent.UI.WebControls" Assembly="SharpContent" %>
<asp:DataGrid ID="grdRules" AutoGenerateColumns="false" width="580px" 
    CellPadding="2" GridLines="None" cssclass="DataGrid_Container" Runat="server" OnDeleteCommand="DeleteRule" OnEditCommand="EditRule">
    <headerstyle cssclass="NormalBold" verticalalign="Top" horizontalalign="Center"/>
    <itemstyle cssclass="Normal" horizontalalign="Left" />
    <alternatingitemstyle cssclass="Normal" />
    <edititemstyle cssclass="NormalTextBox" />
    <selecteditemstyle cssclass="NormalRed" />
    <footerstyle cssclass="DataGrid_Footer" />
    <Columns>
		<scp:imagecommandcolumn commandname="Edit" imageurl="~/images/edit.gif"/>
		<scp:imagecommandcolumn commandname="Delete" imageurl="~/images/delete.gif" />
		<asp:TemplateColumn HeaderText="Match">
		    <HeaderStyle  Width="250px" HorizontalAlign="Left" />
		    <ItemStyle  Width="250px" HorizontalAlign="Left" />
		    <ItemTemplate>
                <asp:label runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "LookFor") %>' CssClass="Normal" ID="lblMatch" Width="250px"/>
		    </ItemTemplate>
		    <EditItemTemplate>
                <asp:textbox runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "LookFor") %>' CssClass="NormalTextBox" ID="txtMatch" Width="250px"/>
		    </EditItemTemplate>
		</asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="ReplaceWith">
		    <HeaderStyle  Width="250px" HorizontalAlign="Left" />
		    <ItemStyle  Width="250px" HorizontalAlign="Left" />
		    <ItemTemplate>
                <asp:label runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "SendTo") %>' CssClass="Normal" ID="lblReplace" Width="250px"/>
		    </ItemTemplate>
		    <EditItemTemplate>
                <asp:textbox runat="server" Text='<%#DataBinder.Eval(Container.DataItem, "SendTo") %>' CssClass="NormalTextBox" ID="txtReplace" Width="250px"/>
		    </EditItemTemplate>
		</asp:TemplateColumn>
        <asp:TemplateColumn>
            <ItemStyle HorizontalAlign="Right"  width="20px"></ItemStyle>
            <EditItemTemplate>
	            <asp:ImageButton Runat="server" ID="lnkSave" resourcekey="saveRule" OnCommand="SaveRule" ImageUrl="~/images/save.gif" />
            </EditItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn>
            <ItemStyle HorizontalAlign="Right"  width="20px"></ItemStyle>
            <EditItemTemplate>
	            <asp:ImageButton Runat="server" ID="lnkCancelEdit" resourcekey="cmdCancel" OnCommand="CancelEdit" ImageUrl="~/images/delete.gif" />
            </EditItemTemplate>
        </asp:TemplateColumn>
    </Columns>
</asp:DataGrid>
<br />
<scp:CommandButton ID="cmdAddRule" runat="server" ResourceKey="cmdAdd" ImageUrl="~/images/add.gif" />
