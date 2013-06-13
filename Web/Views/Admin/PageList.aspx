<%@ Page Title="" Language="C#" ValidateRequest="false" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Статичные страницы сайта
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            if ($.query.get("id") != '') {
                var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
                var oFCKeditor = new FCKeditor('content');
                oFCKeditor.Config.Enabled = true;
                oFCKeditor.Config.UserFilesPath = '/Content/UserImages';
                oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';

                oFCKeditor.Height = '600';
                oFCKeditor.BasePath = sBasePath;
                oFCKeditor.ReplaceTextarea();
            }
        }

        function InsertContent() {
            var oEditor = FCKeditorAPI.GetInstance('content');
            var sample = document.getElementById("sample").value;
            oEditor.InsertHtml(sample);
        }

        function ShowContent() {
            var oEditor = FCKeditorAPI.GetInstance('content');
            alert(oEditor.GetHTML());
        }

        function ClearContent() {
            var oEditor = FCKeditorAPI.GetInstance('content');
            oEditor.SetHTML("");
        }
        $(document).ready(function () {
            $("#btnstatic").addClass("selected");
        });
    </script>
    <a href="/Admin/Index">Вернуться назад</a>    
    <h2>Статичные страницы сайта</h2>
    <%= Html.ValidationSummary("Не удалось сохранить. Проверьте данные и попробуйте снова.") %>
    <%= ViewData["PageList"] %>
    <br /><br />
    <form method="post" action="../../Admin/PageList">
    <%= ViewData["EditField"] %>
    <%= Html.TextBox("pageId", ViewData["PageId"], new { style = "visibility:hidden; width:50px" })%>
    </form>
    <br /><br />
    <a href="/Admin/Index">Вернуться назад</a>    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
