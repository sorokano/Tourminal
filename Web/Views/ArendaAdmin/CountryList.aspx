<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Администрирование: Страны, регионы, города
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".spanDistrict").hide();
            $(".spanCity").hide();

            populateCombobox('ddlCountryEdt', '../../TaratripWS.asmx/GetCountryList', true);

            $("#ddlCountryEdt").change(function (e) {
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
                            $("select#ddlDistrictEdt").html(result);
                            if (items.length == 0)
                                $(".spanCity").hide();
                        },
                        error: function (e) {
                            $("#divResultPanel").html("Сервер временно недоступен.");
                        }
                    });
                } else {
                    $(".spanDistrict").hide();
                    $(".spanCity").hide();
                }
            });

            $("#ddlDistrictEdt").change(function (e) {
                if ($(this).val() != -1 || $(this).val() != '') {
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
                            //result += '<option value="-1"></option>';
                            for (var i = 0; i < items.length; i++) {
                                result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
                            }
                            $("select#ddlCityEdt").html(result);
                        },
                        error: function (e) {
                            $("#divResultPanel").html("Сервер временно недоступен.");
                        }
                    });
                } else {
                    $(".spanCity").hide();
                }
            });

            $("#hrefEditCountry").click(function (e) {
                if ($("#ddlCountryEdt").val() == -1 || $("#ddlCountryEdt").val() == '') {
                    alert('Выберите значение');
                    return false;
                }
                $("#txtItemValue").val($("#ddlCountryEdt").find('option').filter(':selected').text());
                $("#txtItemId").val($("#ddlCountryEdt").val());
                $("#txtItemType").val("country");
                $('#dialog-edititem').dialog('open');
            });

            $("#hrefEditDistrict").click(function (e) {
                if ($("#ddlDistrictEdt").val() == -1 || $("#ddlDistrictEdt").val() == '') {
                    alert('Выберите значение');
                    return false;
                }
                $("#txtItemValue").val($("#ddlDistrictEdt").find('option').filter(':selected').text());
                $("#txtItemId").val($("#ddlDistrictEdt").val());
                $("#txtItemType").val("district");
                $('#dialog-edititem').dialog('open');
            });

            $("#hrefEditCity").click(function (e) {
                if ($("#ddlCityEdt").val() == -1 || $("#ddlCityEdt").val() == '') {
                    alert('Выберите значение');
                    return false;
                }
                $("#txtItemValue").val($("#ddlCityEdt").find('option').filter(':selected').text());
                $("#txtItemId").val($("#ddlCityEdt").val());
                $("#txtItemType").val("city");
                $('#dialog-edititem').dialog('open');
            });

            $("#dialog-edititem").dialog({
                autoOpen: false,
                height: 300,
                width: 400,
                modal: true,
                buttons: {
                    'Закрыть': function () {
                        $(this).dialog('close');
                    }
                },
                close: function () { }
            });
        });
    </script>
    <a href="/ArendaAdmin/Index">Главное меню</a> > <a href="/ArendaAdmin/DictionaryList">Словари</a>
    <br />
    <h2>Словари: Страны, регионы, города</h2>
    <% using (Html.BeginForm("CountryList", "ArendaAdmin", FormMethod.Post, new { autocomplete = "off" })) { %>
    <table>
        <tr>
            <td>
                <table><tr><td>Страна:</td></tr><tr><td><%= Html.DropDownList("ddlCountryEdt", (IEnumerable<SelectListItem>)ViewData["ddlCountry"])%> </td></tr></table>
            </td>    
            <td>
                <span class="spanDistrict">
                    <table><tr><td>Регион:</td></tr><tr><td><%= Html.DropDownList("ddlDistrictEdt", (IEnumerable<SelectListItem>)ViewData["ddlDistrict"])%> </td></tr></table>
                </span>
            </td>
            <td>
                <span class="spanCity">
                    <table><tr><td>Город:</td></tr><tr><td><%= Html.DropDownList("ddlCityEdt", (IEnumerable<SelectListItem>)ViewData["ddlCity"])%> </td></tr></table>
                </span>
            </td>
        </tr>
        <tr>
            <td>
                <a href="#" id="hrefEditCountry">Редактировать выбранное</a><br /><br />
                <input type="submit" value="Удалить выбранное" id="btnDeleteCountry" name="btnDeleteCountry" value="delcountry" />
                <br />
                <%= Html.TextBox("txtCountryName", string.Empty, new { style = "width:100px" })%>
                <input type="submit" value="Добавить" id="btnAddCountry" name="btnAddCountry" value="addcountry" />
            </td>
            <td>
                <span class="spanDistrict">
                    <a href="#" id="hrefEditDistrict">Редактировать выбранное</a><br /><br />
                    <input type="submit" value="Удалить выбранное" id="btnDeleteDistrict" name="btnDeleteDistrict" value="deldistrict" />
                    <br />
                    <%= Html.TextBox("txtDistrictName", string.Empty, new { style = "width:100px" })%>
                    <input type="submit" value="Добавить" id="btnAddDistrict" name="btnAddDistrict" value="adddistrict" />
                </span>
            </td>
            <td>
                <span class="spanCity">
                    <a href="#" id="hrefEditCity">Редактировать выбранное</a><br /><br />
                    <input type="submit" value="Удалить выбранное" id="btnDeleteCity" name="btnDeleteCity" value="delcity" />
                    <br />
                    <%= Html.TextBox("txtCityName", string.Empty, new { style = "width:100px" })%>
                    <input type="submit" value="Добавить" id="btnAddCity" name="btnAddCity" value="addcity" />
                </span>
            </td>
        </tr>
    </table>
    <% } %>
    <br /><br />
    <a href="/ArendaAdmin/Index">Главное меню</a> > <a href="/ArendaAdmin/DictionaryList">Словари</a>
    <div id="dialog-edititem">
        <% using (Html.BeginForm("EditCountryListItem", "ArendaAdmin", FormMethod.Post, new { autocomplete = "off" })) { %>
            <%= Html.TextBox("txtItemValue", string.Empty, new { style = "width:100px" })%>
            <%= Html.TextBox("txtItemId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtItemType", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <input type="submit" value="Сохранить" id="btnSave" name="btnEditItem" value="edititem" />
        <% } %>
    </div>
</asp:Content>
