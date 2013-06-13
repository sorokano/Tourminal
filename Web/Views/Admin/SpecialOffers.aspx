<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Список спецпредложений
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            if ($.query.get("filterCountry") != -1)
                $("#ddlCountry").val($.query.get("filterCountry"));

            $("#btntour").addClass("selected");

            $("#ddlCountry").change(function () {
                var newQuery = $.query.set("filterCountry", $('option:selected', this).val()).toString();
                newQuery = newQuery.replace("pageNumber=", "");
                document.location = ((document.location.toString()).split('?'))[0] + newQuery;
            });

            $("#btn-pagechange").click(function (e) {
                newQuery = $.query.set("pageNumber", $('#txtPageChange').val()).toString();
                document.location = ((document.location.toString()).split('?'))[0] + newQuery;
            });

            $(".img-delete-tour").click(function (e) {
                if (confirm("Удалить запись?")) {
                    var tourImgAlt = $(this).attr("alt");
                    var tourId = tourImgAlt.substring(8, tourImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/RemoveTour",
                        data: "id=" + tourId,
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
            $(".img-delete-specoffer").click(function (e) {
                if (confirm("Удалить запись?")) {
                    var tourImgAlt = $(this).attr("alt");
                    var tourId = tourImgAlt.substring(8, tourImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/RemoveSpecialOffer",
                        data: "id=" + tourId,
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
                var tourImgAlt = $(this).attr("alt");
                var tourId = tourImgAlt.substring(14, tourImgAlt.length);
                document.location = "TourEdit?id=" + tourId;
            });
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a>
    <h2>Список туров</h2>
    Внимание! Чтобы ГЛАВНОЕ СПЕЦПРЕДЛОЖЕНИЕ появилось вверху Главной страницы сайта, необходимо убедиться, что оно единственное в списке!
    <br />
    Страна: <%= Html.DropDownList("ddlCountry", (IEnumerable<SelectListItem>)ViewData["ddlCountry"])%> 
    <br />
    <br />
    <img src="../../Content/images/grid-add.png" alt="" /><a href="/Admin/AddTour" id="hrefAddItem">Добавить тур</a>
    <img src="../../Content/images/grid-add.png" alt="" /><a href="/Admin/AddExcurs" id="A1">Добавить экскурсию</a>
    <img src="../../Content/images/grid-add.png" alt="" /><a href="/Admin/AddSpecialOffer" id="A2">Добавить независимое предложение</a>
    <br />
    <%= ViewData["GridTourList"] %>
    <br /><br />
    <a href="../../Admin/Index">Главное меню</a>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
