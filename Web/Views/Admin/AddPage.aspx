<%@ Page Title="" Language="C#" ValidateRequest="false" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="TitleContent" runat="server">
	Панель администрирования - Добавление новой независимой страницы
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        window.onload = function () {
                var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
                var oFCKeditor = new FCKeditor('content');
                oFCKeditor.Config.Enabled = true;
                oFCKeditor.Config.UserFilesPath = '/Content/UserImages';
                oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';

                oFCKeditor.Height = '600';
                oFCKeditor.BasePath = sBasePath;
                oFCKeditor.ReplaceTextarea();
        }
    </script>
    <a href="/Admin/Index">Главная</a> > <a href="/Admin/FreePageList">Список независимых страниц</a>
    <h2>Создание независимую страницу</h2>
    <%= Html.ValidationSummary("Не удалось сохранить. Проверьте данные и попробуйте снова.") %>
    <br />
    <form method="post" action="../../Admin/AddPage">
    <table><td><span style="color:red">*</span> Название</td><td><%= Html.TextBox("txtTitle", string.Empty, new { style = "width:500px" })%></td></table>
    <%= Html.TextArea("content", string.Empty, 5, 1, new { name = "content" })%>
    </form>
    <br /><br />
    <a href="/Admin/Index">Вернуться назад</a>    
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
