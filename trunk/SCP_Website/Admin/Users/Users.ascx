<%@ Register TagPrefix="scp" Namespace="SharpContent.UI.WebControls" Assembly="SharpContent" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Control Inherits="SharpContent.Modules.Admin.Users.UserAccounts" CodeFile="Users.ascx.cs" Language="C#" AutoEventWireup="true" %>
<table width="675" cellpadding="2" cellspacing="1" border="0">
    <tr>        
        <td align="right" class="SubHead">
            <scp:label id="plSearch" runat="server" controlname="ddlSearchType" text="Search:" />
        </td>
        <td class="Normal" align="left" width="*" style="width: 392px">
            <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
            <asp:DropDownList ID="ddlSearchType" runat="server" />
            <asp:ImageButton ID="btnSearch" runat="server" ImageUrl="~/images/icon_search_16px.gif" OnClick="btnSearch_Click">
            </asp:ImageButton>
        </td>        
        <td align="right">
            <asp:DropDownList ID="ddlRecordsPerPage" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlRecordsPerPage_SelectedIndexChanged">
                <asp:ListItem Value="10">10</asp:ListItem>
                <asp:ListItem Value="20">20</asp:ListItem>
                <asp:ListItem Value="30">30</asp:ListItem>
                <asp:ListItem Value="40">40</asp:ListItem>
                <asp:ListItem Value="50">50</asp:ListItem>
            </asp:DropDownList>
        </td>
        <td align="left">
            <asp:Label ID="lblRecordsPage" CssClass="SubHead" resourceKey="lblRecordsPage" runat="server">Records Per Page</asp:Label>
        </td>
    </tr>
    <tr>
        <td colspan="3" height="15">
        </td>
    </tr>
</table>
<asp:Panel ID="plLetterSearch" runat="server" HorizontalAlign="Center">
    <asp:Repeater ID="rptLetterSearch" runat="server">
        <ItemTemplate>
            <asp:LinkButton runat="server" CssClass="CommandButton" CommandArgument='<%# FilterArgs(Container.DataItem.ToString(),"1") %>' Text='<%# Container.DataItem %>' OnCommand="lnkFilter_Command" />
            &nbsp;&nbsp;
        </ItemTemplate>
    </asp:Repeater>
</asp:Panel>
<asp:DataGrid ID="grdUsers" AutoGenerateColumns="False" Width="100%" CellPadding="2"
    GridLines="None" CssClass="DataGrid_Container" runat="server" OnDeleteCommand="grdUsers_DeleteCommand" OnItemDataBound="grdUsers_ItemDataBound">
    <HeaderStyle CssClass="NormalBold" VerticalAlign="Top" HorizontalAlign="Left" />
    <ItemStyle CssClass="Normal" HorizontalAlign="Left" />
    <AlternatingItemStyle CssClass="DataGrid_AlternatingItem" />
    <EditItemStyle CssClass="NormalTextBox" />
    <SelectedItemStyle CssClass="NormalRed" />
    <FooterStyle CssClass="DataGrid_Footer" />
    <PagerStyle CssClass="DataGrid_Pager" />
    <Columns>
        <scp:imagecommandcolumn CommandName="Edit" ImageUrl="~/images/edit.gif" EditMode="URL" KeyField="UserID" ShowImage="True" />
        <scp:imagecommandcolumn Commandname="Delete" Imageurl="~/images/delete.gif" Keyfield="UserID" EditMode="Command" ShowImage="True" />
        <scp:imagecommandcolumn CommandName="UserRoles" ImageUrl="~/images/icon_securityroles_16px.gif" EditMode="URL" KeyField="UserID" ShowImage="True" />
        <asp:TemplateColumn>
            <ItemTemplate>
                <asp:Image ID="imgOnline" runat="Server" ImageUrl="~/images/userOnline.gif" />
            </ItemTemplate>
        </asp:TemplateColumn>
        <scp:textcolumn datafield="AccountNumber" headertext="AccountNumber" Width="" />
        <scp:textcolumn datafield="UserName" headertext="Username" Width="" />
        <scp:textcolumn datafield="FirstName" headertext="FirstName" Width="" />
        <scp:textcolumn datafield="LastName" headertext="LastName" Width="" />
        <scp:textcolumn datafield="DisplayName" headertext="DisplayName" Width="" />
        <asp:TemplateColumn HeaderText="Address">
            <ItemTemplate>
                <asp:Label ID="lblAddress" runat="server" Text='<%# DisplayAddress(((UserInfo)Container.DataItem).Profile.Unit, 
                ((UserInfo)Container.DataItem).Profile.Street, 
                ((UserInfo)Container.DataItem).Profile.City, 
                ((UserInfo)Container.DataItem).Profile.Region, 
                ((UserInfo)Container.DataItem).Profile.Country, 
                ((UserInfo)Container.DataItem).Profile.PostalCode) %>'>
                </asp:Label>
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Telephone">
            <ItemTemplate>
                <asp:Label ID="Label4" runat="server" Text='<%# DisplayEmail(((UserInfo)Container.DataItem).Profile.Telephone) %>'>
                </asp:Label>
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Email">
            <ItemTemplate>
                <asp:Label ID="lblEmail" runat="server" Text='<%# DisplayEmail(((UserInfo)Container.DataItem).Membership.Email) %>'>
                </asp:Label>
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="CreatedDate">
            <ItemTemplate>
                <asp:Label ID="lblLastLogin" runat="server" Text='<%# DisplayDate(((UserInfo)Container.DataItem).Membership.CreatedDate) %>'>
                </asp:Label>
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="LastLogin">
            <ItemTemplate>
                <asp:Label ID="Label7" runat="server" Text='<%# DisplayDate(((UserInfo)Container.DataItem).Membership.LastLoginDate) %>'>
                </asp:Label>
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Authorized">
            <ItemTemplate>
                <asp:Image runat="server" ID="imgApproved" ImageUrl="~/images/authorized.gif" Visible="<%# ((UserInfo)Container.DataItem).Membership.Approved==true%>" />
                <asp:Image runat="server" ID="imgNotApproved" ImageUrl="~/images/unauthorized.gif" Visible="<%# ((UserInfo)Container.DataItem).Membership.Approved==false%>" />
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="LockedOut">
            <ItemTemplate>
                <asp:Image runat="server" ID="imgLockedOut" ImageUrl="~/images/icon_lock_16px.gif" Visible="<%# ((UserInfo)Container.DataItem).Membership.LockedOut==true%>" />
            </ItemTemplate>
        </asp:TemplateColumn>
    </Columns>
</asp:DataGrid>
<br/>
<br/>
<scp:PagingControl ID="ctlPagingControl" runat="server"></scp:PagingControl>
