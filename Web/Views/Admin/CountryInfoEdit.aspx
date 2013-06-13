<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Редактирование главы информация о стране "<%= ViewData["CountryName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
            var oFCKeditor = new FCKeditor('content');
            oFCKeditor.Config.Enabled = true;
            oFCKeditor.Config.UserFilesPath = '/Content/UserImages';
            oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';
            oFCKeditor.ToolbarSet = 'DefaultNoSave';

            oFCKeditor.Height = '400';
            oFCKeditor.Width = '600';
            oFCKeditor.BasePath = sBasePath;
            oFCKeditor.ReplaceTextarea();
        }

        $(document).ready(function () {
            $("#btncancel").click(function (e) {
                location.href = '../../Admin/CountryEdit?id=<%= ViewData["CountryId"] %>';
            });
        });
    </script>
    <h2>Редактирование главы информация о стране "<%= ViewData["CountryName"] %></h2>
    <%= Html.ValidationSummary("Не удалось сохранить. Проверьте данные и попробуйте снова.") %>
    <% using (Html.BeginForm("CountryInfoEdit", "Admin", FormMethod.Post)) { %>
    <input type="text" visible="false" style="display: none;" id="txtId" name="txtId" value="<%= ViewData["CountryInfoId"] %>" />
    <table>
        <tr><td><table><tr><td><span style="color:red">*</span> Название главы</td><td><%= Html.TextBox("txtTitle", ViewData["Title"], new { style = "width:400px" })%></tr></td></table></td></tr>
        <tr><td><span style="color:red">*</span> Содержание:</td></tr>
        <tr><td><%= Html.TextArea("content", ViewData["ContentInfoDescription"] == null ? string.Empty : ViewData["ContentInfoDescription"].ToString(), 3, 1, new { style = "width:600px", name = "content" })%></td></tr>
        <tr><td><table><tr><td><span style="color:red">*</span> Порядок в списке</td><td><%= Html.TextBox("txtPageOrder", ViewData["PageOrder"], new { style = "width:40px" })%></tr></td></table></td></tr>
    </table>
    <p>
        <input type="submit" value="Сохранить" />
        <input type="button" value="Отмена" id="btncancel" />
    </p>
    <% } %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
