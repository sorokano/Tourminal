<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Добавление Новости
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
            var oFCKeditor = new FCKeditor('txtDescr');
            oFCKeditor.Config.Enabled = true;
            oFCKeditor.Config.UserFilesPath = '/Content/UserImages';
            oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';
            oFCKeditor.ToolbarSet = 'DefaultNoSave';

            oFCKeditor.Height = '500';
            oFCKeditor.Width = '600';
            oFCKeditor.BasePath = sBasePath;
            oFCKeditor.ReplaceTextarea();
        }
    </script>
    <h2>Добавление Новости</h2>
    <% using (Html.BeginForm("AddNews", "Admin", FormMethod.Post)) { %>
        <%: Html.ValidationSummary(false, "Не удалось сохранить запись. Исправьте ошибки и повторите попытку.") %>
    <table>
        <tr>
            <td>
                Заголовок:
            </td>
            <td>
                <%= Html.TextBox("txtTitle", string.Empty, new { style = "width:550px" })%>
            </td>
        </tr>        
        <tr>
            <td>
                Содержание:
            </td>
            <td>
                <%= Html.TextArea("txtDescr", string.Empty, 3, 1, new { name = "txtDescr" })%>
            </td>
        </tr>
        <tr>
            <td>
                Фотография:
            </td>
            <td>
                Фото новости можно добавить после сохранения Новости.
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <p>
                    <input type="submit" value="Сохранить" />
                </p>             
            </td>
        </tr>
    </table>
    <%} %>
    
</asp:Content>
