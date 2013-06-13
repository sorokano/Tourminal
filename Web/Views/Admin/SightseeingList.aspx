<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Список статей
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

            //            $('#add').click(function () {
            //                $('#ddlDlgDistrict option:selected').each(function (el) {
            //                    if ($('#ddlDlgDistrict2 option').length < 4) {
            //                        $(this).appendTo('#ddlDlgDistrict2');
            //                    } else alert("Больше четырех значений вводить нельзя.").end();
            //                });
            //            });

            //            $('#remove').click(function () {
            //                $('#ddlDlgDistrict2 option:selected').each(function (el) {
            //                    $(this).appendTo('#ddlDlgDistrict');
            //                });
            //            });
            // $("a.sort-column").click(function (e) {
            //                var sortByVal = $.urlParam('sortBy', this);
            //                $.ajax({
            //                    type: "POST",
            //                    url: "/Admin/SortSightseeingGrid",
            //                    data: "sortBy=" + sortByVal,
            //                    success: function (msg) {
            //                        if (msg == '"error"') {
            //                            msg = msg + " - произошла ошибка. Попробуйте снова.";
            //                        }
            //                    }
            //                });
            //                setTimeout($.urlParam('sortBy', this), 50000);
            //  });

            $("#btn-pagechange").click(function (e) {
                newQuery = $.query.set("pageNumber", $('#txtPageChange').val()).toString();
                document.location = ((document.location.toString()).split('?'))[0] + newQuery;
            });

            $(".spanDistrict").hide();
            $("#btnAdd").click(function (e) {
                location.href = '/Admin/AddSightseeing?typeid=' + $('#ddlDlgSightseeingType').val() + '&countryid=' + $('#ddlDlgCountry').val() + '&regionid=' + 0;// $('#ddlDlgDistrict2').val();
            });

            $("#hrefAddItem").click(function (e) {
                populateComboboxNameId('ddlDlgCountry', 'http://tourminal.ru/ElcondorWCF.svc/GetCountryListJS', false);
                populateCombobox('ddlDlgSightseeingType', 'http://tourminal.ru/ElcondorWCF.svc/GetSightseeingTypeListJS', false);
                $('#dialog-additemopts').dialog('open');
            });

            $("#dialog-additemopts").dialog({
                autoOpen: false,
                height: 400,
                width: 800,
                modal: true,
                buttons: {
                    'Закрыть': function () {
                        $(this).dialog('close');
                    }
                },
                close: function () {
                    $('#ddlDlgSightseeingType').val("");
                    $('#ddlDlgCountry').val("");
                    //$('#ddlDlgDistrict').val("");
                    location.reload();
                }
            });

            $("#ddlDlgCountry").change(function (e) {
                if ($(this).val() != -1) {
                    $(".spanDistrict").show();
                    var param = '{ "countryId" : "' + $(this).val() + '" }';
                    $.ajax({
                        type: "POST",
                        data: param,
                        url: "../../ElcondorWS.asmx/GetDistrictListJS",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            var result = "";
                            var items = eval('(' + response.d + ')');
                            result += '<option value="-1">Для всех регионов</option>';
                            for (var i = 0; i < items.length; i++) {
                                result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
                            }
                            //                            $("select#ddlDlgDistrict").html(result);
                            //                            if ($.query.get("regionid") != '0' && $.query.get("regionid") != '') {
                            //                                $("select#ddlDlgDistrict").val($.query.get("regionid"));
                            //                            }
                        },
                        error: function (e) {
                            $("#divResultPanel").html("Сервер временно недоступен.");
                        }
                    });
                } else {
                    $(".spanDistrict").hide();
                }
            });

            $(".img-delete").click(function (e) {
                if (confirm("Удалить запись?")) {
                    var sightseeingImgAlt = $(this).attr("alt");
                    var sightseeingId = sightseeingImgAlt.substring(8, sightseeingImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/RemoveSightseeing",
                        data: "SightseeingId=" + sightseeingId,
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
                var sightseeingImgAlt = $(this).attr("alt");
                var sightseeingId = sightseeingImgAlt.substring(14, sightseeingImgAlt.length);
                document.location = "AddSightseeing?id=" + sightseeingId;
            });
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a>
    <h2>Список статей</h2>
    Страна: <%= Html.DropDownList("ddlCountry", (IEnumerable<SelectListItem>)ViewData["ddlCountry"])%> 
    <br />
    <br />
    <img src="../../Content/images/grid-add.png" alt="" /><a href="#" id="hrefAddItem">Добавить</a>
    <br />
    <%= ViewData["GridSightseeingList"] %>
    
    <div id="dialog-additemopts">
            Введите параметры статьи:
            <br /><br />
             <table>
                <tr>
                    <td>
                        <table><tr><td>Тип статьи:</td></tr><tr><td><%= Html.DropDownList("ddlDlgSightseeingType", new List<SelectListItem>())%> </td></tr></table>
                    </td>
                    <td>
                        <table><tr><td>Страна:</td></tr><tr><td><%= Html.DropDownList("ddlDlgCountry", new List<SelectListItem>())%> </td></tr></table>
                    </td>    
                    <%--<td>
                        <span class="spanDistrict">
                            <div class="holder">
                                <%= Html.ListBox("ddlDlgDistrict", (IEnumerable<SelectListItem>)ViewData["ddlDlgDistrict"] as MultiSelectList)%> 
                                   
                                <a href="#" id="add">добавить >></a>
                            </div>
                            <div class="holder">
                                <%--<select multiple="multiple" id="ddlDlgDistrict2" style="min-width:200px;">  </select>--%>
                                <%--<%= Html.ListBox("ddlDlgDistrict2", new MultiSelectList(new List<SelectListItem>()) as MultiSelectList)%>
                                <a href="#" id="remove"><< удалить </a>
                            </div>
                        </span>
                    </td>--%>
                </tr>
            </table>
            <br /><br />
            <input type="button" value="Сохранить и перейти к редактированию" id="btnAdd" name="btnAddItem" value="additem" />
    </div>
    <br /><br />
    <a href="../../Admin/Index">Главное меню</a>
</asp:Content>

    