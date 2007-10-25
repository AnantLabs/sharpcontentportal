<%@ Control Language="C#" Inherits="SharpContent.Modules.Content.EditContent" CodeFile="EditContent.ascx.cs"
    AutoEventWireup="true" %>
<%@ Register TagPrefix="scp" TagName="TextEditor" Src="~/controls/TextEditor.ascx" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="SectionHead" Src="~/controls/SectionHeadControl.ascx" %>
<%@ Register TagPrefix="scp" Namespace="SharpContent.UI.WebControls" Assembly="Sharpcontent" %>
<table cellspacing="2" cellpadding="2" summary="Edit Content Design Table" border="0">
    <tr>
        <td valign="top">
            <scp:SectionHead ID="dshHistory" runat="server" CssClass="Head" IncludeRule="True"
                ResourceKey="VersionHistory" Section="tblHistory" Text="Version History" />
            <table id="tblHistory" runat="server" border="0" cellpadding="2" cellspacing="0"
                summary="Content Version History" width="100%">
                <tr>
                    <td>                    
                        <asp:GridView ID="grdContent" runat="server" AutoGenerateColumns="false" Width="100%"
                            CellPadding="2" GridLines="None" CssClass="DataGrid_Container" DataKeyNames="ContentId" OnRowEditing="grdContent_RowEditing">
                            <HeaderStyle CssClass="NormalBold" VerticalAlign="Top" HorizontalAlign="Left" />
                            <RowStyle CssClass="Normal" HorizontalAlign="Left" />
                            <AlternatingRowStyle CssClass="DataGrid_AlternatingItem" />
                            <EditRowStyle CssClass="NormalTextBox" />
                            <SelectedRowStyle CssClass="NormalRed" />
                            <FooterStyle CssClass="DataGrid_Footer" />
                            <PagerStyle CssClass="DataGrid_Pager" />
                            <EmptyDataRowStyle CssClass="Normal" />
                            <Columns>
                                <asp:ButtonField CommandName="Edit" ButtonType="Image" ImageUrl="~/Images/edit.gif" DataTextField="ContentId" />
                                <scp:textfield datafield="ContentVersion" headertext="Version" width="" />
                                <scp:textfield datafield="CreatedDate" headertext="Created Date" width="" />
                                <scp:textfield datafield="CreatedByUsername" headertext="Created By" width="" />
                                <asp:TemplateField HeaderText="Published">
                                    <ItemTemplate>
                                        <asp:Image runat="server" ID="imgPublished" ImageUrl="~/images/authorized.gif" Visible="<%# Convert.ToBoolean(((SharpContent.Modules.Content.ContentInfo)Container.DataItem).Publish.ToString()) %>" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                No data found!
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td height="10">
        </td>
    </tr>
    <tr valign="top">
        <td colspan="2">
        <asp:LinkButton CssClass="CommandButton" ID="lbtnEditor" resourcekey="lbtnEditor"
        runat="server" BorderStyle="none" Text="Edit" CausesValidation="False" OnClick="lbtnEditor_Click"></asp:LinkButton> | 
        <asp:LinkButton CssClass="CommandButton" ID="cmdPreview" resourcekey="cmdPreview"
        runat="server" BorderStyle="none" Text="Preview" CausesValidation="False" OnClick="cmdPreview_Click"></asp:LinkButton>
            <asp:MultiView ID="mvContentEditor" runat="server" ActiveViewIndex="0">
                <asp:View ID="vwEditor" runat="server">
                    <scp:TextEditor ID="teContent" runat="server" Height="400" Width="660"></scp:TextEditor>
                </asp:View>
                <asp:View ID="vwPreview" runat="server">
                    <asp:Panel ID="pnlPreview" runat="server" Height="400px" Width="660px" ScrollBars="Auto">
                    <asp:Label ID="lblPreview" CssClass="Normal" runat="server"></asp:Label></asp:Panel>
                </asp:View>
            </asp:MultiView>            
        </td>
    </tr>
    <tr>
        <td height="10">
        </td>
    </tr>
    <tr>
        <td class="SubHead">
            <scp:Label ID="plDesktopSummary" runat="server" ControlName="txtDesktopSummary" Suffix=":">
            </scp:Label>
        </td>
    </tr>
    <tr>
        <td>
            <asp:TextBox ID="txtDesktopSummary" runat="server" TextMode="multiline" Rows="5"
                Width="660px" Columns="75" CssClass="NormalTextBox"></asp:TextBox>
        </td>
    </tr>
</table>
<p>
    <asp:LinkButton CssClass="CommandButton" ID="cmdSave" resourcekey="cmdSave" runat="server"
        BorderStyle="none" Text="Save" OnClick="cmdSave_Click"></asp:LinkButton>&nbsp;
    <asp:LinkButton CssClass="CommandButton" ID="cmdCancel" resourcekey="cmdCancel" runat="server"
        BorderStyle="none" Text="Cancel" CausesValidation="False" OnClick="cmdCancel_Click"></asp:LinkButton>&nbsp;
    <asp:LinkButton CssClass="CommandButton" ID="cmdPublish" resourcekey="cmdPublish" runat="server"
        BorderStyle="none" Text="Publish" CausesValidation="False" OnClick="cmdPublish_Click"></asp:LinkButton>&nbsp;
</p>
<table cellspacing="0" cellpadding="0" width="660">
    <tr valign="top">
        <td>
            </td>
    </tr>
</table>
