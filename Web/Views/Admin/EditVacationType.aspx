<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Редактирование Вид отдыха <%= ViewData["NewsTitle"] %>
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
    <a href="/Admin/Index">Главная</a> > <a href="/Admin/VacationTypeList">Список Видов отдыха</a> > Редактировать Вид отдыха <%= ViewData["NewsTitle"] %>
    <h2>Редактирование Вида отдыха <%= ViewData["NewsTitle"] %></h2>
    <% using (Html.BeginForm()) { %>
        <input type="text" visible="false" style="display: none;" id="txtRouteId" name="txtId" value="<%= ViewData["NewsId"] %>" />
        <%: Html.ValidationSummary(false, "Не удалось сохранить запись. Исправьте ошибки и повторите попытку.") %>
    <table>
        <tr>
            <td>
                Заголовок:
            </td>
            <td>
                <%= Html.TextBox("txtTitle", ViewData["NewsTitle"], new { style = "width:550px" })%>
            </td>
        </tr>    
        <tr>
            <td>
                Коротрое описание:
            </td>
            <td>
                <%= Html.TextBox("txtShortDesc", ViewData["NewsShortDesc"], new { style = "width:550px" })%>
            </td>
        </tr>        
        <tr>
            <td>
                Содержание:
            </td>
            <td>
                <%= Html.TextArea("txtDescr", ViewData["NewsDesc"].ToString(), 3, 1, new { name = "txtDescr" })%>
            </td>
        </tr>
        <tr>
            <td>
                Фотография: 
            </td>
            <td>
                <a href="../../Admin/EditNewsPhoto?id=<%= ViewData["NewsId"].ToString() %>">Редактировать фотографии (<%= Convert.ToBoolean(ViewData["NewsHasLargeImage"].ToString()) ? "загружена" : "не загружена"%>)</a>
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
    <a href="/Admin/Index">Главная</a> > <a href="/Admin/VacationTypeList">Список Вид отдыха</a> > Редактировать Вид отдыха <%= ViewData["NewsTitle"] %>
</asp:Content>
