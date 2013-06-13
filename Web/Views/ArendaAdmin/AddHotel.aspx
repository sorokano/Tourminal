<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Администрирование: Добавление отеля
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
            $(".spanDistrict").hide();
            $(".spanCity").hide();
            $("#ddlCountry").prepend(new Option(" ", "-1"));
            $("#ddlCountry").val(-1);
            
            $("#ddlCountry").change(function (e) {
                if ($(this).val() != -1) {
                    $(".spanDistrict").show();
                    var param = '{ "countryId" : "' + $(this).val() + '" }';
                    $.ajax({
                        type: "POST",
                        data: param,
                        url: "../../TaratripWS.asmx/GetDistrictList",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            var result = "";
                            var items = eval('(' + response.d + ')');
                            result += '<option value="-1"></option>';
                            for (var i = 0; i < items.length; i++) {
                                result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
                            }
                            $("select#ddlDistrict").html(result);
                            if (items.length == 0)
                                $(".spanCity").hide();
                        },
                        error: function (e) {
                            $("#divResultPanel").html("Сервер временно недоступен.");
                        }
                    });
                    $(".spanCity").hide();
                } else {
                    $(".spanDistrict").hide();
                    $(".spanCity").hide();
                }
            });

            $("#ddlDistrict").change(function (e) {
                if ($(this).val() != -1) {
                    $(".spanCity").show();
                    var param = '{ "districtId" : "' + $(this).val() + '" }';
                    $.ajax({
                        type: "POST",
                        data: param,
                        url: "../../TaratripWS.asmx/GetCityListByDistrict",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            var result = "";
                            var items = eval('(' + response.d + ')');
                            result += '<option value="-1"></option>';
                            for (var i = 0; i < items.length; i++) {
                                result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
                            }
                            $("select#ddlCity").html(result);
                            if (items.length == 0)
                                $(".spanCity").hide();
                        },
                        error: function (e) {
                            $("#divResultPanel").html("Сервер временно недоступен.");
                        }
                    });
                } else {
                    $(".spanCity").hide();
                }
            });

        });
    </script>
    <a href="/ArendaAdmin/Index">Главное меню</a> > <a href="/ArendaAdmin/HotelList">Список отелей</a>
    <br />
    <h2>Добавление отеля</h2>
    <%= Html.ValidationSummary("Не удалось добавить новый отель. Проверьте данные и попробуйте снова.") %>
    <% using (Html.BeginForm("AddHotel", "ArendaAdmin", FormMethod.Post, new { autocomplete = "off" })) { %>
    <table>
        <tr>
            <td>
                <span style="color:red">*</span> Название
            </td>
            <td>
                <%= Html.TextBox("txtHotelName", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Описание
            </td>
            <td>
                <%= Html.TextArea("txtDescr", string.Empty, 3, 1, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Страна
            </td>
            <td>
                <%= Html.DropDownList("ddlCountry", (IEnumerable<SelectListItem>)ViewData["ddlCountry"])%> 
            </td>
        </tr>
        <tr>
            <td>
                <span class="spanDistrict"><span style="color:red">*</span> Регион</span>
            </td>
            <td>
                <span class="spanDistrict"><%= Html.DropDownList("ddlDistrict", string.Empty)%> </span>
            </td>
        </tr>
        <tr>
            <td>
                <span class="spanCity"><span style="color:red">*</span> Район</span></span>
            </td>
            <td>
                <span class="spanCity"><%= Html.DropDownList("ddlCity", string.Empty)%> </span>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Статус
            </td>
            <td>
                <%= Html.DropDownList("ddlStatus", (IEnumerable<SelectListItem>)ViewData["ddlStatus"])%> 
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Мин.цена за номер на 2х человек(рую)
            </td>
            <td>
                <%= Html.TextBox("txtMinPrice", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Адрес
            </td>
            <td>
                <%= Html.TextBox("txtAddress", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>Координаты на карте (можно узнать на сайте <a href="http://itouchmap.com/latlong.html" target="_blank">http://itouchmap.com/latlong.html</a>)</td>
            <td></td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Широта (координата)
            </td>
            <td>
                <%= Html.TextBox("txtLongitude", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Долгота (координата)
            </td>
            <td>
                <%= Html.TextBox("txtLatitude", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Тип отеля
            </td>
            <td>
                <%= Html.DropDownList("ddlHotelAccomodationType", (IEnumerable<SelectListItem>)ViewData["ddlHotelAccomodationType"])%> 
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Расстояние до моря
            </td>
            <td>
                <%= Html.DropDownList("ddlDistanceToSea", (IEnumerable<SelectListItem>)ViewData["ddlDistanceToSea"])%> 
               </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Макс.кол-во человек
            </td>
            <td>
                <%= Html.TextBox("txtMaxPersons", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                <span style="color:red">*</span> Кол-во звезд (1-5)
            </td>
            <td>
                <%= Html.DropDownList("ddlStarRating", (IEnumerable<SelectListItem>)ViewData["ddlStarRating"])%> 
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
    <br /><br />
    <a href="/ArendaAdmin/Index">Главное меню</a> > <a href="/ArendaAdmin/HotelList">Список отелей</a>
</asp:Content>
