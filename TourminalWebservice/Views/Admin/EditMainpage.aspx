<%@ Page Title="" Language="C#" ValidateRequest="false" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	EditMainpage
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
            var oFCKeditor = new FCKeditor('content');
            oFCKeditor.Config.Enabled = true;
            oFCKeditor.Config.UserFilesPath = 'http://webservices.tourminal.ru/Content/UserImages';
            oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';

            oFCKeditor.Height = '600';
            oFCKeditor.BasePath = sBasePath;
            oFCKeditor.ReplaceTextarea();
        }
    </script>
    <a href="http://tourminal.ru/Admin/Index">Вернуться назад</a>   <br />
    <h2>Редактировать блок главной странцы</h2>
    <form method="post" action="../../Admin/EditMainpage">
    <%= ViewData["EditField"] %>
    <%= Html.TextBox("id", ViewData["VariableId"], new { style = "visibility:hidden; width:50px" })%>
    </form>
    <br /><br />
    <a href="http://tourminal.ru/Admin/Index">Вернуться назад</a>    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
