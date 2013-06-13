<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content3" ContentPlaceHolderID="TitleContent" runat="server">
	Список экскурсий
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnexcurs").addClass("selected");

            $("#ddlCountry").change(function () {
                var newQuery = $.query.set("filterCountry", $('option:selected', this).val()).toString();
                newQuery = newQuery.replace("pageNumber=", "");
                document.location = ((document.location.toString()).split('?'))[0] + newQuery;
            });

            $("#btn-pagechange").click(function (e) {
                newQuery = $.query.set("pageNumber", $('#txtPageChange').val()).toString();
                document.location = ((document.location.toString()).split('?'))[0] + newQuery;
            });

            $(".img-delete").click(function (e) {
                if (confirm("Удалить запись?")) {
                    var excursImgAlt = $(this).attr("alt");
                    var excursId = excursImgAlt.substring(8, excursImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/RemoveTour",
                        data: "id=" + excursId,
                        success: function (msg) {
                            if (msg == '"error"') {
                                msg = msg + " - произошла ошибка. Попробуйте снова.";
                                alert(msg);
                            }
                            location.reload();
                        }
                    });
                }
            });

            $(".img-edit").click(function (e) {
                var excursImgAlt = $(this).attr("alt");
                var excursId = excursImgAlt.substring(14, excursImgAlt.length);
                document.location = "ExcursEdit?id=" + excursId;
            });
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a>
    <h2>Список экскурсий</h2>
    Страна: <%= Html.DropDownList("ddlCountry", (IEnumerable<SelectListItem>)ViewData["ddlCountry"])%> 
    <br />
    <br />
    <img src="../../Content/images/grid-add.png" alt="" /><a href="../../Admin/AddExcurs" id="hrefAddItem">Добавить</a>
    <br />
    <%= ViewData["GridExcursList"] %>
    <br /><br />
    <a href="../../Admin/Index">Главное меню</a>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
