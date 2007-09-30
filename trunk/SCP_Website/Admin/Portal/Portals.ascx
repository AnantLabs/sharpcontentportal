<%@ Control Language="C#" AutoEventWireup="true"  Inherits="SharpContent.Modules.Admin.Portals.Portals" CodeFile="Portals.ascx.cs" %>
<%@ Register Assembly="SharpContent" Namespace="SharpContent.UI.WebControls" TagPrefix="scp" %>
<asp:Panel ID="plLetterSearch" runat="server" HorizontalAlign="Center">
    <asp:Repeater ID="rptLetterSearch" runat="server">
        <ItemTemplate>
            <asp:HyperLink ID="HyperLink1" runat="server" CssClass="CommandButton" NavigateUrl='<%# FilterURL((string)Container.DataItem,"1") %>' Text='<%# Container.DataItem %>'>
            </asp:HyperLink>&nbsp;&nbsp;
        </ItemTemplate>
    </asp:Repeater>
</asp:Panel>
<asp:DataGrid ID="grdPortals" runat="server" AutoGenerateColumns="false" CellPadding="2" CssClass="DataGrid_Container" GridLines="None" Width="100%" OnDeleteCommand="grdPortals_DeleteCommand">
    <HeaderStyle CssClass="NormalBold" HorizontalAlign="Center" VerticalAlign="Top" />
    <ItemStyle CssClass="Normal" HorizontalAlign="Center" />
    <AlternatingItemStyle CssClass="DataGrid_AlternatingItem" />
    <EditItemStyle CssClass="NormalTextBox" />
    <SelectedItemStyle CssClass="NormalRed" />
    <FooterStyle CssClass="DataGrid_Footer" />
    <PagerStyle CssClass="DataGrid_Pager" />
    <Columns>
        <scp:imagecommandcolumn commandname="Edit" editmode="URL" imageurl="~/images/edit.gif" keyfield="PortalID">
</scp:imagecommandcolumn>
        <scp:imagecommandcolumn commandname="Delete" imageurl="~/images/delete.gif" keyfield="PortalID">
</scp:imagecommandcolumn>
        <asp:TemplateColumn HeaderText="Title">
            <ItemStyle HorizontalAlign="Left" />
            <ItemTemplate>
                <asp:Label ID="lblPortal" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "PortalName") %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Portal Aliases">
            <ItemStyle HorizontalAlign="Left" />
            <ItemTemplate>
                <asp:Label ID="lblPortalAliases" runat="server" Text='<%# FormatPortalAliases(Convert.ToInt32(DataBinder.Eval(Container.DataItem, "PortalID"))) %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateColumn>
        <scp:textcolumn datafield="Users" headertext="Users">
</scp:textcolumn>
        <scp:textcolumn datafield="Pages" headertext="Pages">
</scp:textcolumn>
        <scp:textcolumn datafield="HostSpace" headertext="DiskSpace">
</scp:textcolumn>
        <asp:BoundColumn DataField="HostFee" DataFormatString="{0:0.00}" HeaderText="HostingFee"></asp:BoundColumn>
        <asp:TemplateColumn HeaderText="Expires">
            <HeaderStyle CssClass="NormalBold" />
            <ItemTemplate>
                <asp:Label ID="Label1" runat="server" CssClass="Normal" Text='<%#FormatExpiryDate(Convert.ToDateTime( DataBinder.Eval(Container.DataItem, "ExpiryDate"))) %>'></asp:Label>
            </ItemTemplate>
        </asp:TemplateColumn>
    </Columns>
</asp:DataGrid>
<br>
<br>
<scp:pagingcontrol id="ctlPagingControl" runat="server"></scp:pagingcontrol>
