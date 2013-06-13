<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Администрирование: Редактирование отеля
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
            var oFCKeditor = new FCKeditor('txtDescr');
            oFCKeditor.Config.Enabled = true;
            oFCKeditor.Config.UserFilesPath = '/Content/UserImages';
            oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';
            oFCKeditor.ToolbarSet = 'DefaultNoSave';

            oFCKeditor.Height = '500';
            oFCKeditor.Width = '800';
            oFCKeditor.BasePath = sBasePath;
            oFCKeditor.ReplaceTextarea();
       
            var sBasePath2 = '<%= ResolveUrl("~/Scripts/fck/") %>';
            var oFCKeditor2 = new FCKeditor('txtAddDescr');
            oFCKeditor2.Config.Enabled = true;
            oFCKeditor2.Config.UserFilesPath = '/Content/UserImages';
            oFCKeditor2.Config.UserFilesAbsolutePath = '/Content/UserImages';
            oFCKeditor2.ToolbarSet = 'DefaultNoSave';

            oFCKeditor2.Height = '500';
            oFCKeditor2.Width = '800';
            oFCKeditor2.BasePath = sBasePath2;
            oFCKeditor2.ReplaceTextarea();
        }
        $(document).ready(function () {
            $("#txtRoomPeriodStart").datepicker($.datepicker.regional['ru']);
            $("#txtRoomPeriodEnd").datepicker($.datepicker.regional['ru']);

            $("[id^='hrefShowRoomPrices_']").click(function (e) {
                var id = $(this).attr('id');
                $("#txtHotelRoomId").val(id.substring(19, id.length));
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/GetHotelRoomPriceListHTML",
                    data: "hotelRoomId=" + id.substring(19, id.length),
                    success: function (data) {
                        var jEl = $("#divRoomPeriods").html(data);
                        $('#dialog-editroomprices').dialog('open');
                    },
                    error: function (e) {
                        $("#tab-content-main").html("Сервер временно недоступен.");
                    }
                });
            });

            $("#dialog-editroomprices").dialog("destroy");

            $("#dialog-editroomprices").dialog({
                autoOpen: false,
                height: 450,
                width: 600,
                modal: true,
                buttons: {
                    'Закрыть': function() {
                        $(this).dialog('close');
                    }
                },
                close: function() {
                    $("#txtRoomPeriodStart").val("");
                    $("#txtRoomPeriodEnd").val("");
                    $("#txtRoomPrice").val("");
                    $("#txtHotelRoomId").val("");
                }
            });

            $("#dialog-editperiods").dialog("destroy");

            $("#dialog-editperiods").dialog({
                autoOpen: false,
                height: 450,
                width: 800,
                modal: true,
                buttons: {
                    'Закрыть': function() {
                        $(this).dialog('close');
                    }
                },
                close: function() {
                    $("#txtPeriodStart").val("");
                    $("#txtPeriodEnd").val("");                    
                }
            });

            $("#hrefEditPeriods").click(function (e) {
                $('#dialog-editperiods').dialog('open');
            });

            $("#ddlCountryEdt").change(function (e) {
                if ($(this).val() != -1) {
                    $(".spanDistrict").show();
                    var param="countryId="+$(this).val();
                    populateCombobox('ddlDistrictEdt', '../../TaratripWCF.svc/GetDistrictList', true, param);
                } else {
                    $(".spanDistrict").hide();
                    $(".spanCity").hide();
                }
            });

            $("#ddlDistrictEdt").change(function (e) {
                if ($(this).val() != -1) {
                    $(".spanCity").show();
                    var param="districtId="+$(this).val();
                    populateCombobox('ddlCityEdt', '../../TaratripWCF.svc/GetCityListByDistrict', true, param);
                }
            });

            $(".img-delete").click(function (e) {
                if (confirm("Удалить запись?")) {
                    var hotelImgAlt = $(this).attr("alt");
                    var hotelRoomId = hotelImgAlt.substring(8, hotelImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/ArendaAdmin/RemoveHotelRoom",
                        data: "HotelRoomId=" + hotelRoomId,
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
                                    
            $("#hrefAddRoomPrice").click(function (e) {
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/AddHotelRoomPrice",
                    data: "pricedata=" + $("#txtRoomPrice").val() + "," + $("#txtRoomPeriodStart").val() + "," + $("#txtRoomPeriodEnd").val() + "," + $("#txtHotelRoomId").val(),
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                            alert(msg);
                        }
                        location.reload();
                    }
                });                
            });

            $(".img-edit").click(function (e) {
                var hotelImgAlt = $(this).attr("alt");
                var hotelRoomId = hotelImgAlt.substring(14, hotelImgAlt.length);
                document.location = "EditHotelRoom?HotelRoomId=" + hotelRoomId + "&HotelId=" + <%=ViewData["HotelId"]%>;
            });
        });
                
        function deleteHotelRoomPrice(item) {
            if (confirm("Удалить запись?")) {
                $.ajax({
                    type: "POST",
                    url: "/ArendaAdmin/RemoveHotelRoomPrice",
                    data: "HotelRoomId=" + item.id,
                    success: function (msg) {
                        if (msg == '"error"') {
                            msg = msg + " - произошла ошибка. Попробуйте снова.";
                            alert(msg);
                        }
                        location.reload();
                    }
                });
            }
        }
    </script>
    <div id="dialog-editroomprices">
        <h2>Цены на комнаты в даты <%= ViewData["txtRoomType"]%></h2>
        Цена: <%= Html.TextBox("txtRoomPrice", string.Empty, new { style = "width:50px" })%>
        с <%= Html.TextBox("txtRoomPeriodStart", string.Empty, new { style = "width:50px" })%>
        по <%= Html.TextBox("txtRoomPeriodEnd", string.Empty, new { style = "width:50px" })%>
        <img src="/Content/images/grid-add.png" alt="" /><a href="#" id="hrefAddRoomPrice">Добавить</a>
        <%= Html.TextBox("txtHotelRoomId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
        <div id="divRoomPeriods"></div>
    </div>
    <div id="dialog-editperiods">
        <h2>Периоды доступности отеля <%= ViewData["txtName"]%> <%=ViewData["HotelId"]%></h2>
        <%= Html.TextBox("txtPeriodStart", string.Empty, new { style = "width:50px" })%>
        <%= Html.TextBox("txtPeriodEnd", string.Empty, new { style = "width:50px" })%>
        <img src="/Content/images/grid-add.png" alt="" /><a href="#" id="hrefAddPeriod">Добавить</a>
        <%= ViewData["GridHotelAvailablePeriods"] %>
    </div>
    <a href="/ArendaAdmin/Index">Главное меню</a> > <a href="/ArendaAdmin/HotelList">Список отелей</a>
    <br />
    <h2>Редактирование отеля <%= ViewData["txtName"]%> <%=ViewData["HotelId"]%></h2>
    <%= Html.ValidationSummary("Не удалось сохранить изменения. Проверьте данные и попробуйте снова.") %>
    <% using (Html.BeginForm()) { %>
    <table>
        <tr>
            <td>
                <span style="color:red">*</span> Название
            </td>
            <td>
                <%= Html.TextBox("txtHotelName", ViewData["txtName"], new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Описание
            </td>
            <td>
                <%= Html.TextArea("txtDescr", ViewData["txtDesc"].ToString(), 3, 1, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Страна
            </td>
            <td>
                <%= Html.DropDownList("ddlCountryEdt", (IEnumerable<SelectListItem>)ViewData["ddlCountry"])%> 
                <a href="/ArendaAdmin/CountryList">Редактировать страны/города</a>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> <span class="spanDistrict">Регион</span>
            </td>
            <td>
                <%= Html.DropDownList("ddlDistrictEdt", (IEnumerable<SelectListItem>)ViewData["ddlDistrict"])%> 
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> <span class="spanCity">Город</span>
            </td>
            <td>
                <%= Html.DropDownList("ddlCityEdt", (IEnumerable<SelectListItem>)ViewData["ddlCity"])%> 
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Статус
            </td>
            <td>
                <%= Html.DropDownList("ddlStatusEdt", (IEnumerable<SelectListItem>)ViewData["ddlStatus"])%> 
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Мин.цена за номер на 2х человек
            </td>
            <td>
                <%= Html.TextBox("txtMinPrice", ViewData["txtMinPrice"], new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Адрес
            </td>
            <td>
                <%= Html.TextBox("txtAddress", ViewData["txtAddress"], new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Широта (координата)
            </td>
            <td>
                <%= Html.TextBox("txtLongitude", ViewData["txtLongitude"], new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Долгота (координата)
            </td>
            <td>
                <%= Html.TextBox("txtLatitude", ViewData["txtLatitude"], new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Тип отеля
            </td>
            <td>
                <%= Html.DropDownList("ddlHotelAccomodationTypeEdt", (IEnumerable<SelectListItem>)ViewData["ddlHotelAccomodationType"])%> 
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Расстояние до моря
            </td>
            <td>
                <%= Html.DropDownList("ddlDistanceToSeaEdt", (IEnumerable<SelectListItem>)ViewData["ddlDistanceToSea"])%> 
               </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Макс.кол-во человек
            </td>
            <td>
                <%= Html.TextBox("txtMaxPersons", ViewData["txtMaxPeople"], new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Кол-во звезд (1-5)
            </td>
            <td>
                <%= Html.DropDownList("ddlStarRatingEdt", (IEnumerable<SelectListItem>)ViewData["ddlStarRating"])%> 
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span>Доп. описание
            </td>
            <td>
                <%= Html.TextArea("txtAddDescr", ViewData["txtAddDesc"] == null ? string.Empty : ViewData["txtAddDesc"].ToString(), 3, 1, new { style = "width:350px" })%>
            </td>
        </tr>
    </table>
    <p>
        <input type="submit" value="Сохранить" />
    </p> 
    <% } %>
    <br />
    <b>Комнаты отеля:</b>
    Редактировать комнаты &nbsp;
    <a href="/ArendaAdmin/AddHotelRoom?HotelId=<%= ViewData["HotelId"] %>">
        <img src="/Content/images/grid-add.png" alt="" /> Добавить комнату
    </a>
    <br />
    <%= ViewData["GridHotelRoomList"] %>
    <br />
    <a href="/ArendaAdmin/EditHotelPhoto?HotelId=<%= ViewData["HotelId"] %>">Редактировать фото</a> (<%= ViewData["HotelImgUploadCount"] %> загружено)
    <br /><br />
    <a href="/ArendaAdmin/EditHotelDetails?HotelId=<%= ViewData["HotelId"] %>">Редактировать доп. информацию</a>
    <%--<br /><br />
    <a href="#" id="hrefEditPeriods">Редактировать периоды доступности</a><br />--%>
    <br /><br />
    <a href="/ArendaAdmin/Index">Главное меню</a> > <a href="/ArendaAdmin/HotelList">Список отелей</a>
</asp:Content>
