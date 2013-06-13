<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Администрирование: Список отелей
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {

            if ($.query.get("filterCountry") != -1)
                $("#ddlCountry").val($.query.get("filterCountry"));

            $("#ddlCountry").change(function () {
                var newQuery = $.query.set("filterCountry", $('option:selected', this).val()).toString();
                newQuery = newQuery.replace("pageNumber=", "");
                document.location = ((document.location.toString()).split('?'))[0] + newQuery;
            });

            if ($("#hdnIsNewHotel").val() == "False" || $("#hdnIsNewHotel").val() == "")
                $("#addhotel-success").hide();
            else
                $("#addhotel-success").show();

            $("a.sort-column").click(function (e) {
                var sortByVal = $.urlParam('sortBy', this);
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/SortHotelsGrid",
                    data: "sortBy=" + sortByVal,
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                        }
                    }
                });
                setTimeout($.urlParam('sortBy', this), 50000);
            });

            $(".img-delete").click(function (e) {
                if (confirm("Удалить запись?")) {
                    var hotelImgAlt = $(this).attr("alt");
                    var hotelId = hotelImgAlt.substring(8, hotelImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/ArendaAdmin/RemoveHotel",
                        data: "hotelId=" + hotelId,
                        success: function (msg) {
                            if (msg == '"error"') {
                                msg = msg + " - произошла ошибка. Попробуйте снова.";
                            }
                            location.reload();
                        }
                    });
                    
                }
            });

            $(".img-edit").click(function (e) {
                var hotelImgAlt = $(this).attr("alt");
                var hotelId = hotelImgAlt.substring(14, hotelImgAlt.length);
                document.location = "EditHotel?HotelId=" + hotelId;
            });

            $("#btn-pagechange").click(function (e) {
                newQuery = $.query.set("pageNumber", $('#txtPageChange').val()).toString();
                document.location = ((document.location.toString()).split('?'))[0] + newQuery;
            });
        });  
    </script>
    <a href="/ArendaAdmin/Index">Главное меню</a>
    <br />
    <input type="hidden" id="hdnIsNewHotel" value="<%= ViewData["IsNewHotel"] %>" />
    <h2>Список отелей</h2>
    <div id="addhotel-success">
        <span class="message-green">Запись успешно сохранена.</span>
    </div>
    Страна: <%= Html.DropDownList("ddlCountry", (IEnumerable<SelectListItem>)ViewData["ddlCountry"])%> 
    <br />
    <img src="/Content/images/grid-add.png" alt="" /><%= Html.ActionLink("Добавить отель", "AddHotel", "ArendaAdmin")%>
    <br />
    <%= ViewData["GridHotelList"]%> 
    <br /><br />
    <a href="/ArendaAdmin/Index">Главное меню</a>
</asp:Content>
