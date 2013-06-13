<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content3" ContentPlaceHolderID="TitleContent" runat="server">
	Список круизов
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btncruise").addClass("selected");

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
                    var cruiseImgAlt = $(this).attr("alt");
                    var cruiseId = cruiseImgAlt.substring(8, cruiseImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/RemoveTour",
                        data: "id=" + cruiseId,
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
                var cruiseImgAlt = $(this).attr("alt");
                var cruiseId = cruiseImgAlt.substring(14, cruiseImgAlt.length);
                document.location = "CruiseEdit?id=" + cruiseId;
            });
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a>
    <h2>Список круизов</h2>
    Страна: <%= Html.DropDownList("ddlCountry", (IEnumerable<SelectListItem>)ViewData["ddlCountry"])%> 
    <br />
    <br />
    <img src="../../Content/images/grid-add.png" alt="" /><a href="../../Admin/AddCruise" id="hrefAddItem">Добавить</a>
    <br />
    <%= ViewData["GridCruiseList"]%>
    <br /><br />
    <a href="../../Admin/Index">Главное меню</a>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
