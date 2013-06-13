<%@ Page Title="" Language="C#" ValidateRequest="false" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content2" ContentPlaceHolderID="TitleContent" runat="server">
	Панель администрирования - Список независимых страниц
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
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

        //
        $(document).ready(function () {
            $(".btndelete").click(function (e) {
                if (confirm("Удалить? Внимание! Данные будут удалены без возможности восстановления!")) {
                    var itemIdHref = $(this).attr("href");
                    var itemId = itemIdHref.substring(1, itemIdHref.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/DeleteFreePage",
                        data: "id=" + itemId,
                        success: function (msg) {
                            if (msg == '"error"') {
                                msg = msg + " - произошла ошибка. Попробуйте снова.";
                            }
                            //location.reload();
							document.location = "../../Admin/FreePageList";
                        }
                    });
                }
            });
        });
    </script>
    <a href="/Admin/Index">Вернуться назад</a>    
    <h2>Список независимых страниц</h2>
    <img src="../../Content/images/grid-add.png" alt="" /><a href="/Admin/AddPage" id="hrefAddItem">Добавить страницу</a>
    <%= Html.ValidationSummary("Не удалось сохранить. Проверьте данные и попробуйте снова.") %>
    <!--<%= ViewData["PageList"] %>-->
	<%
		StringBuilder sb = new StringBuilder();
            sb.Append("<ul>");
            foreach (LinqToElcondor.TblPage item in ElcondorBiz.BizDictionary.GetPageList(true)) {
                sb.Append(
                    string.Format(
                            "<li style=\"margin-left:30px;\"><a href=\"../../Admin/{2}?id={0}\">{1}</a> <a href=\"#{0}\" class=\"btndelete\" >(X)</a></li>"
                                    , item.Id, item.Title, "FreePageList"));
            }
            sb.Append("</ul>");
            
	%>
	<%= sb.ToString() %>
    <br /><br />
    <form method="post" action="../../Admin/FreePageList">
    <h2>ССЫЛКА НА ЭТУ СТРАНИЦУ: <%= ViewData["PageUrl"] %></h2>
    <%= ViewData["EditField"] %>
    <%= Html.TextBox("pageId", ViewData["PageId"], new { style = "visibility:hidden; width:50px" })%>
    </form>
    <br /><br />
    <a href="/Admin/Index">Вернуться назад</a>    
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
