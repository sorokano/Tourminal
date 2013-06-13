<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - Виды отдыха
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".img-delete").click(function (e) {
                if (confirm("Удалить? Внимание! Данные будут удалены без возможности восстановления!")) {
                    var itemIdImgAlt = $(this).attr("alt");
                    var itemId = itemIdImgAlt.substring(8, itemIdImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/DeleteNews",
                        data: "imageId=" + itemId,
                        success: function (msg) {
                            if (msg == '"error"') {
                                msg = msg + " - произошла ошибка. Попробуйте снова.";
                            }
                            location.reload();
                        }
                    });
                }
            });
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a><br />
    <h2>Список Видов отдыха</h2>
    <img src="../../Content/images/grid-add.png" alt="" /><a href="/Admin/AddVacationType" id="hrefAddItem">Добавить Вид отдыха</a>
    <%= ViewData["GridPageList"] %>
    <br /><br />
    <a href="../../Admin/Index">Главное меню</a>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
