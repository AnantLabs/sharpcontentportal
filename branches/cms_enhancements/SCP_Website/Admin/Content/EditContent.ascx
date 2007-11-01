<%@ Control Language="C#" Inherits="SharpContent.Modules.Content.EditContent" CodeFile="EditContent.ascx.cs"
    AutoEventWireup="true" %>
<%@ Register Assembly="WebCtrls" Namespace="WebCtrls" TagPrefix="aspCtrls" %>
<%@ Register TagPrefix="scp" TagName="TextEditor" Src="~/controls/TextEditor.ascx" %>
<%@ Register TagPrefix="scp" TagName="Label" Src="~/controls/LabelControl.ascx" %>
<%@ Register TagPrefix="scp" TagName="SectionHead" Src="~/controls/SectionHeadControl.ascx" %>
<%@ Register TagPrefix="scp" Namespace="SharpContent.UI.WebControls" Assembly="Sharpcontent" %>
<table cellspacing="2" cellpadding="2" summary="Edit Content Design Table" border="0">
    <tr>
        <td valign="top">
            <scp:SectionHead ID="dshHistory" runat="server" CssClass="SubHead" IncludeRule="true"
                ResourceKey="VersionHistory" Section="tblHistory" Text="Version History" Visible="true" />
            <table id="tblHistory" runat="server" border="0" cellpadding="2" cellspacing="0"
                summary="Content Version History" width="100%">
                <tr>
                    <td>
                        <asp:GridView ID="grdContent" runat="server" AutoGenerateColumns="false" Width="100%"
                            CellPadding="2" GridLines="None" CssClass="DataGrid_Container" DataKeyNames="ContentId"
                            OnRowEditing="grdContent_RowEditing">
                            <HeaderStyle CssClass="NormalBold" VerticalAlign="Top" HorizontalAlign="Left" />
                            <RowStyle CssClass="Normal" HorizontalAlign="Left" />
                            <AlternatingRowStyle CssClass="DataGrid_AlternatingItem" />
                            <EditRowStyle CssClass="NormalTextBox" />
                            <SelectedRowStyle BackColor="Gray" Font-Bold="True" ForeColor="White" />
                            <FooterStyle CssClass="DataGrid_Footer" />
                            <PagerStyle CssClass="DataGrid_Pager" />
                            <EmptyDataRowStyle CssClass="Normal" />
                            <Columns>
                                <asp:ButtonField CommandName="Edit" ButtonType="Image" ImageUrl="~/Images/content-select.gif"
                                    DataTextField="ContentId">
                                    <ItemStyle Width="25px" />
                                </asp:ButtonField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <table cellpadding="0" cellspacing="0" border="0">
                                            <tr>
                                                <td width="16px">
                                                    <asp:Image runat="server" ID="imgPublished" ImageUrl="~/images/content-publish.gif"
                                                        Visible="<%# Convert.ToBoolean(((SharpContent.Modules.Content.ContentInfo)Container.DataItem).Publish.ToString()) %>" /></td>
                                                <td width="16px">
                                                    <asp:Image runat="server" ID="Image1" ImageUrl="<%# CommentFlagURL(((SharpContent.Modules.Content.ContentInfo)Container.DataItem).CommentFlag) %>" /></td>
                                                <td width="16px">
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                    <ItemStyle Width="48px" />
                                </asp:TemplateField>
                                <scp:textfield datafield="ContentVersion" headertext="Version" width="" />
                                <scp:textfield datafield="CreatedDate" headertext="Created Date" width="" />
                                <scp:textfield datafield="CreatedByUsername" headertext="Created By" width="" />
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
            &nbsp;
        </td>
    </tr>
    <tr valign="top">
        <td colspan="2">
            <span class="CommandButton">
                <aspCtrls:TabContainer ID="tcContentEditor" runat="server" Items-Capacity="4" OnClick="tcContentEditor_Click"
                    TabIndent="5" TabOverlap="10">
                    <aspCtrls:Tab Name="Edit" Text="Edit" />
                    <aspCtrls:Tab Name="Preview" Text="Preview" />
                    <aspCtrls:Tab Name="Comments" Text="Comments" />
                </aspCtrls:TabContainer>
            </span>
            <div align="center" style="border-right: #7f9db9 1px solid; border-left: #7f9db9 1px solid;
                border-bottom: #7f9db9 1px solid; float: left; width: 100%;">
                <asp:MultiView ID="mvContentEditor" runat="server" ActiveViewIndex="0">
                    <asp:View ID="vwEditor" runat="server">
                        <asp:Panel ID="pnlContentEditor" runat="server">
                            <scp:TextEditor ID="teContent" runat="server" Height="400" Width="650"></scp:TextEditor>
                        </asp:Panel>
                    </asp:View>
                    <asp:View ID="vwPreview" runat="server">
                        <asp:Panel ID="pnlPreview" runat="server" Height="400px" Width="650px" ScrollBars="Auto"
                            HorizontalAlign="Left">
                            <asp:Label ID="lblPreview" CssClass="Normal" runat="server"></asp:Label></asp:Panel>
                    </asp:View>
                    <asp:View ID="vwComments" runat="server">
                        <table cellpadding="5" cellspacing="0" border="0">
                            <tr>
                                <td colspan="2">
                                    <asp:Label ID="lblCommentsHistory" runat="server" resourcekey="lblCommentsHistory"
                                        CssClass="SubHead" /><br />
                                    <asp:Panel ID="pnlComments" runat="server" BorderColor="Black" BorderStyle="Solid"
                                        BorderWidth="1px" Height="200px" Width="625px" HorizontalAlign="Left" ScrollBars="Auto">
                                        <asp:Label ID="lblComments" CssClass="Normal" runat="server"></asp:Label>
                                    </asp:Panel>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <scp:Label ID="lblComment" ControlName="txtComment" runat="server" ResourceKey="lblComment" />
                                    <asp:TextBox ID="txtComment" runat="server" Height="75px" TextMode="MultiLine" Width="625px" CssClass="Normal"></asp:TextBox><br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Panel ID="pnlCommentFlags" runat="server" Width="425px" CssClass="Normal">
                                        <asp:Label ID="lblCommentFlags" runat="server" resourcekey="lblCommentFlags" CssClass="SubHead" /><br />
                                        <asp:RadioButtonList ID="rdolCommentFlags" runat="server" RepeatDirection="Horizontal"
                                            TextAlign="Left" Width="375px">
                                        </asp:RadioButtonList></asp:Panel>
                                </td>
                                <td>
                                    <scp:CommandButton ID="cmdUpdateComments" runat="server" ResourceKey="cmdUpdateComments"
                                        ImageUrl="~/images/save.gif" CausesValidation="False" />
                                </td>
                            </tr>
                        </table>
                    </asp:View>
                </asp:MultiView>
            </div>
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
                Width="660px" Columns="75" CssClass="NormalTextBox"></asp:TextBox></td>
    </tr>
</table>
<p>
    <asp:LinkButton CssClass="CommandButton" ID="cmdSave" resourcekey="cmdSave" runat="server"
        BorderStyle="none" Text="Save" OnClick="cmdSave_Click"></asp:LinkButton>&nbsp;
    <asp:LinkButton CssClass="CommandButton" ID="cmdPublish" resourcekey="cmdPublish"
        runat="server" BorderStyle="none" Text="Publish" CausesValidation="False" OnClick="cmdPublish_Click"></asp:LinkButton>&nbsp;
    <asp:LinkButton CssClass="CommandButton" ID="cmdCancel" resourcekey="cmdCancel" runat="server"
        BorderStyle="none" Text="Cancel" CausesValidation="False" OnClick="cmdCancel_Click"></asp:LinkButton>&nbsp;
</p>
<table cellspacing="0" cellpadding="0" width="660">
    <tr valign="top">
        <td>
        </td>
    </tr>
</table>
