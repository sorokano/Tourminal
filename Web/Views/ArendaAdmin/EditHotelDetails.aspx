<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Администрирование: Редактирование доп. информацию отеля
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#divEditSuccess").hide();

            $("#btnSaveServices").click(function (e) {
                var parameters = "";
                $(".row-itemlist-servicetype").each(function (r) {
                    $(this).find('input').each(function (d) {
                        //if ($(this).attr('checked') == true) {
                        //alert($(this).attr('id'));
                        parameters += $(this).attr('id') + "=" + $(this).attr('checked') + "|";
                        //}
                    });
                });
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/UpdateHotelServices",
                    data: "parameters=" + parameters,
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                            alert(msg);
                        } else {
                            $("#divEditSuccess").show();
                            alert("Запись сохранена.");
                        }
                    }
                });
            });

            $("#btnSaveAmenities").click(function (e) {
                var parameters = "";
                $(".row-itemlist-amenitytype").each(function (r) {
                    $(this).find('input').each(function (d) {
                        parameters += $(this).attr('id') + "=" + $(this).attr('checked') + "|";
                    });
                });
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/UpdateHotelAmenities",
                    data: "parameters=" + parameters,
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                            alert(msg);
                        } else {
                            $("#divEditSuccess").show();
                            alert("Запись сохранена.");
                        }
                    }
                });
            });

            $("#btnSaveGoodFor").click(function (e) {
                var parameters = "";
                $(".row-itemlist-goodfortype").each(function (r) {
                    $(this).find('input').each(function (d) {
                        parameters += $(this).attr('id') + "=" + $(this).attr('checked') + "|";
                    });
                });
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/UpdateHotelGoodFor",
                    data: "parameters=" + parameters,
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                            alert(msg);
                        } else {
                            $("#divEditSuccess").show();
                            alert("Запись сохранена.");
                        }
                    }
                });
            });

            //
            $("#btnHealth").click(function (e) {
                var parameters = "";
                $(".row-itemlist-healthstype").each(function (r) {
                    $(this).find('input').each(function (d) {
                        parameters += $(this).attr('id') + "=" + $(this).attr('checked') + "|";
                    });
                });
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/UpdateHotelHealth",
                    data: "parameters=" + parameters,
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                            alert(msg);
                        } else {
                            $("#divEditSuccess").show();
                            alert("Запись сохранена.");
                        }
                    }
                });
            });

            $("#btnSport").click(function (e) {
                var parameters = "";
                $(".row-itemlist-sportsstype").each(function (r) {
                    $(this).find('input').each(function (d) {
                        parameters += $(this).attr('id') + "=" + $(this).attr('checked') + "|";
                    });
                });
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/UpdateHotelSport",
                    data: "parameters=" + parameters,
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                            alert(msg);
                        } else {
                            $("#divEditSuccess").show();
                            alert("Запись сохранена.");
                        }
                    }
                });
            });

            $("#btnRest").click(function (e) {
                var parameters = "";
                $(".row-itemlist-restaurtype").each(function (r) {
                    $(this).find('input').each(function (d) {
                        parameters += $(this).attr('id') + "=" + $(this).attr('checked') + "|";
                    });
                });
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/UpdateHotelRestaurants",
                    data: "parameters=" + parameters,
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                            alert(msg);
                        } else {
                            $("#divEditSuccess").show();
                            alert("Запись сохранена.");
                        }
                    }
                });
            });

            $("#btnForKids").click(function (e) {
                var parameters = "";
                $(".row-itemlist-forkidstype").each(function (r) {
                    $(this).find('input').each(function (d) {
                        parameters += $(this).attr('id') + "=" + $(this).attr('checked') + "|";
                    });
                });
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/UpdateHotelForKids",
                    data: "parameters=" + parameters,
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                            alert(msg);
                        } else {
                            $("#divEditSuccess").show();
                            location.reload();
                        }
                    }
                });
            });
        });
    </script>
    <div id="divEditSuccess">
        <span class="message-green">Изменения успешно сохранены.</span>
    </div>
    <a href="/ArendaAdmin/Index">Главное меню</a> > <a href="/ArendaAdmin/HotelList">Список отелей</a> > <a href="/ArendaAdmin/EditHotel?HotelId=<%= Request.QueryString["HotelId"] %>">Редактирование отеля</a>
    <br />
    <h2>Администрирование: Редактирование доп. информацию отеля</h2>
    <h3>Серивисы</h3> <a href="/ArendaAdmin/HotelServicesList">Редактировать сервисы</a>
    <%= ViewData["GridHotelServices"] %>
    <p><input type="button" value="Сохранить" id="btnSaveServices" /></p>

    <h3>Удобства</h3> <a href="/ArendaAdmin/HotelAmenitiesList">Редактировать удобства</a>
    <%= ViewData["GridHotelAmenities"] %>
    <p><input type="button" value="Сохранить" id="btnSaveAmenities" /></p>


    <h3>Идеально подходит для...</h3> <a href="/ArendaAdmin/GoodForList">Редактировать "Подходит для"</a>
    <%= ViewData["GridHotelGoodFor"] %>
    <p><input type="button" value="Сохранить" id="btnSaveGoodFor" /></p>

    <h3>Для детей</h3> <a href="/ArendaAdmin/DictForKidsList">Редактировать Для детей</a>
    <%= ViewData["GridHotelForKids"]%>
    <p><input type="button" value="Сохранить" id="btnForKids" /></p>

    <h3>Рестораны</h3> <a href="/ArendaAdmin/DictRestaurantList">Редактировать рестораны</a>
    <%= ViewData["GridHotelRestaurant"]%>
    <p><input type="button" value="Сохранить" id="btnRest" /></p>

    <h3>Спорт</h3> <a href="/ArendaAdmin/DictSportList">Редактировать спорт</a>
    <%= ViewData["GridHotelSport"]%>
    <p><input type="button" value="Сохранить" id="btnSport" /></p>

    <h3>Медицина и здоровье</h3> <a href="/ArendaAdmin/HotelAmenitiesList">Редактировать Медицина и здоровье</a>
    <%= ViewData["GridHotelHealth"]%>
    <p><input type="button" value="Сохранить" id="btnHealth" /></p>
    <br /><br />
    <a href="/ArendaAdmin/Index">Главное меню</a> > <a href="/ArendaAdmin/HotelList">Список отелей</a> > <a href="/ArendaAdmin/EditHotel?HotelId=<%= Request.QueryString["HotelId"] %>">Редактирование отеля</a>
</asp:Content>
