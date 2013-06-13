<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Администрирование: Авиабилеты
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <link href="/ckeditor/_Sample/sample.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        window.onload = function () {
            var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
            var oFCKeditor = new FCKeditor('content');
            oFCKeditor.Config.Enabled = true;
            oFCKeditor.Config.UserFilesPath = '/Content/UserImages';
            oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';

            oFCKeditor.Height = '400';
            oFCKeditor.BasePath = sBasePath;
            oFCKeditor.ReplaceTextarea();

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


        $(function () {
            $("#btnSubmit").click(function (e) {
                //ShowContent();
            });

            $("#tabs").tabs();
        });
    </script>

    <h2>Авиабилеты</h2>
    <div id="tabs">
        <ul class="avia">
            <li><a href="#tabs-1">Чартерные билеты</a></li>
            <li><a href="#tabs-2">Регулярные билеты</a></li>
            <li><a href="#tabs-3">Полезная информация</a></li>
        </ul>
        <br />
        <br />
        <div id="tabs-1">
        tab1
        </div>
        <div id="tabs-2">
        t2
        </div>
        <div id="tabs-3">
            <%= Html.TextArea("content", "<p>Простой html</p>")%>
        </div>
    </div>
   
    <input type="button" id="btnSubmit" name="btn1" value="Сохранить">
</asp:Content>
