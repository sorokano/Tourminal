<%@ Page Title="" Language="C#" ValidateRequest="false" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Добавление/редактирование статьи
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
            var oFCKeditor = new FCKeditor('content');
            oFCKeditor.Config.Enabled = true;
            oFCKeditor.Config.UserFilesPath = '/Content/UserImages';
            oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';
            oFCKeditor.ToolbarSet = 'DefaultNoSave';

            oFCKeditor.Height = '500';
            oFCKeditor.BasePath = sBasePath;
            oFCKeditor.ReplaceTextarea();
        }

        $(document).ready(function () {
            $('#txtDlgCountryId').val("<%= ViewData["CountryId"] %>");
            $('#txtDlgItemType').val("<%= ViewData["DictionaryItemType"] %>");
            $('#txtDlgCurrentItemId').val("<%= ViewData["Id"] %>");

            $("#btncancel").click(function (e) {
                location.href = '/Admin/SightseeingList';
            });

            $.getJSON('http://tourminal.ru/ElcondorWCF.svc/GetCountryListJS' + "?method=?&", function (response) {
                var result = "";
                var items = eval('(' + response + ')');
                for (var i = 0; i < items.length; i++) {
                    result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
                }
                $("select#" + 'ddlCountry').html(result);
                $("select#ddlCountry").val($.query.get("countryid"));
            });

            var paramDistr = "countryId=" + $.query.get("countryid");

            populateComboboxNameId('ddlDistrict', 'http://tourminal.ru/ElcondorWCF.svc/GetDistrictListJS', true, paramDistr);
            $.getJSON('http://tourminal.ru/ElcondorWCF.svc/GetSightseeingTypeListJS?method=?&', function (response) {
                var result = "";
                var items = eval('(' + response + ')');
                for (var i = 0; i < items.length; i++) {
                    result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
                }
                $("select#ddlSightseeingType").html(result);
                $("select#ddlSightseeingType").val($.query.get("typeid"));
                $("#divPhotoArea").hide();
                $("#divPhotoAreaNotice").show();                
                if ($.query.get("id") != '') {
                    $("#divPhotoArea").show();
                    $("#divPhotoAreaNotice").hide();
                    $(".spanDistrict").hide();
                    $(".spanCountry").hide();
                    $("#edit-tags").show();
                    $("select#ddlSightseeingType").val(<%= ViewData["TypeId"] %>);
                    $("select#ddlCountry").val(<%= ViewData["CountryId"] %>);
                } else {
                    $("#edit-tags").hide();
                }
                if ($.query.get("countryid") != '') {
                    var param = '{ "countryId" : "' + $.query.get("countryid") + '" }';
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
                            $("select#ddlDistrict").html(result);
                            if ($.query.get("regionid") != '0' && $.query.get("regionid") != '') {
                                $("select#ddlDistrict").val($.query.get("regionid"));
                            }
                            if($.query.get("regionid") != '' && $.query.get("regionid") != '-1') {
                                var regs = $.query.get("regionid") .split(',');
                                regs.forEach(function (e) {
                                    $('#ddlDistrict option').each(function (el) {
                                        if ($(this).val() == e) {
                                            $(this).appendTo('#ddlDistrict2');
                                        }
                                    });
                                })
                            }
                        },
                        error: function (e) {
                            $("#divResultPanel").html("Сервер временно недоступен.");
                        }
                    });
                    if ($.query.get("regionid") != '' && $.query.get("regionid") != '-1')
                        $("select#ddlDistrict").val($.query.get("regionid"));
                }                
            });

            $('#add').click(function () {
                $('#ddlDistrict option:selected').each(function (el) {
                    if ($('#ddlDistrict2 option').length < 4) {
                        $(this).appendTo('#ddlDistrict2');
                    } else alert("Больше четырех значений вводить нельзя.").end();
                });
            });

            $('#remove').click(function () {
                $('#ddlDistrict2 option:selected').each(function (el) {
                    $(this).appendTo('#ddlDistrict');
                });
            });

            $("#ddlCountry").change(function (e) {
                if ($(this).val() != -1) {
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
                            $("select#ddlDistrict").html(result);
                            if ($.query.get("regionid") != '0' && $.query.get("regionid") != '') {
                                $("select#ddlDistrict").val($.query.get("regionid"));
                            }
                        },
                        error: function (e) {
                            $("#divResultPanel").html("Сервер временно недоступен.");
                        }
                    });
                } else {
                    $(".spanDistrict").hide();
                }
            });
            
            $("#dialog-edititem").dialog({
                autoOpen: false,
                height: 300,
                width: 600,
                modal: true,
                buttons: {
                    'Закрыть': function () {
                        $(this).dialog('close');
                    }
                },
                close: function () {
                    $('#txtDlgItemId').val("");
                    $('#txtDlgTagSize').val("");
                    location.reload();
                }
            });

            $("#hrefAddItem").click(function (e) {
                $('#txtDlgItemId').val("null");
                $('#txtDlgItemName').val("");
                $('#txtDlgCountryId').val("<%= ViewData["CountryId"] %>");
                $('#txtDlgTagSize').val("");
                $('#dialog-edititem').dialog('open');
            });

            $(".img-edit").click(function (e) { 
                var itemId = $(this).attr("id");
                var itemValue = $(this).attr("name");
                
                $('#txtDlgItemId').val(itemId);
                $('#txtDlgItemName').val(itemValue);
                $('#dialog-edititem').dialog('open');
            });

            $(".img-delete").click(function (e) {
                if (confirm("Удалить? Внимание! Все объекты (фото, статьи и тд), связанные с этим будут удалены!")) {
                    var itemIdImgAlt = $(this).attr("alt");
                    var itemId = itemIdImgAlt.substring(8, itemIdImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/DeleteTagItem",
                        data: "id=" + itemId,
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
    <a href="/Admin/SightseeingList">Вернуться к списку статей</a>
    <br /><br />
    <h2><%= ViewData["PageTitle"] %> <%= ViewData["SightseeingRegionNames"]  %></h2>
    <%= Html.ValidationSummary("Не удалось сохранить. Проверьте данные и попробуйте снова.") %>
    <% using (Html.BeginForm("AddSightseeing", "Admin", FormMethod.Post)) { %>
    <input type="text" visible="false" style="display: none;" id="txtId" name="txtId" value="<%= ViewData["Id"] %>" />
    <table>
        <tr>
            <td>
                <table><tr><td>Тип статьи:</td></tr><tr><td><%= Html.DropDownList("ddlSightseeingType", new List<SelectListItem>())%> </td></tr></table>
            </td>
            <td>
                <span class="spanCountry">
                    <table><tr><td>Страна:</td></tr><tr><td><%= Html.DropDownList("ddlCountry", (IEnumerable<SelectListItem>)ViewData["ddlCountry"])%> </td></tr></table>
                </span>
            </td>    
            <td>
                <span class="spanDistrict">
                    <%--<table><tr><td>Регион:</td></tr><tr><td><%= Html.DropDownList("ddlDistrict", (IEnumerable<SelectListItem>)ViewData["ddlDistrict"])%> </td></tr></table>--%>
                    <div class="holder">
                        <%= Html.ListBox("ddlDistrict", (IEnumerable<SelectListItem>)ViewData["ddlDistrict"] as MultiSelectList)%> 
                                   
                        <a href="#" id="add">добавить >></a>
                    </div>
                    <div class="holder">
                        <%--<select multiple="multiple" id="ddlDistrict2" style="min-width:200px;">  </select>--%>
                        <%= Html.ListBox("ddlDistrict2", new MultiSelectList(new List<SelectListItem>()) as MultiSelectList)%>
                        <a href="#" id="remove"><< удалить </a>
                    </div>
                </span>
            </td>
            <td>
               <%-- <span class="spanCity">
                    <table><tr><td>Город:</td></tr><tr><td><%= Html.DropDownList("ddlCity", new List<SelectListItem>())%> </td></tr></table>
                </span>--%>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <table><tr><td><span style="color:red">*</span> Название</td><td><%= Html.TextBox("txtSightseeingName", ViewData["Name"], new { style = "width:500px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <table><tr><td><span style="color:red">*</span> Краткое описание(на главной стр.):</td><td><%= Html.TextBox("txtSightseeingShortDesc", ViewData["ShortDescription"], new { style = "width:500px" })%></td></tr></table>
            </td>
        </tr>
    </table>
    <div style="position: relative; float: right; width: 400px; height: 110px; margin-top: -100px;color:#333333;" id="divPhotoAreaNotice">
        Фотографии можно добавлять только после создания статьи (кнопка "Добавить статью").
    </div>
    <div style="position: relative; float: right; width: 400px; height: 110px; margin-top: -100px;" id="divPhotoArea">
        <% if(ElcondorBiz.BizSightseeing.GetImage(int.Parse(ViewData["Id"].ToString())) != null) { %>
            Основное фото: <img src="/Content/UserImages/sightseeing_th_<%=Session["SightseeingId"].ToString()%>.jpg" alt="" style="width: 75px;vertical-align:middle;" />
        <% } %>
        <br />
        <a href="/Admin/EditSightseeingPhoto?id=<%= ViewData["Id"].ToString() %>">Редактировать фото</a> (<%= ViewData["SightseeingImgUploadCount"] %> загружено)
    </div>
    Содержание статьи:
    <br />
    <%= Html.TextArea("content", ViewData["Description"] == null ? string.Empty : ViewData["Description"].ToString(), 3, 1, new { style = "width:350px", name = "content" })%>
    <p>
        <input type="submit" value="<%=ViewData["PageButtonTitle"] %>" />
        <input type="button" value="Отмена" id="btncancel" />
    </p> 
    <% } %>
    <br /><br />
    <span id="edit-tags">
        <h2>Тэги для этой статьи:</h2>
        <img src="../../Content/images/grid-add.png" alt="" /><a href="#" id="hrefAddItem">Добавить</a>
        <%= ViewData["GridTags"] %>
        <br /><br />
    </span>
    <a href="/Admin/SightseeingList">Вернуться к списку статей</a>
    <div id="dialog-edititem">
        <% using (Html.BeginForm("EditTagItem", "Admin", FormMethod.Post, new { autocomplete = "off" })) { %>
            Описание тэга:<br />
            Название: <%= Html.TextBox("txtDlgItemName", string.Empty, new { style = "width:250px" })%>
            Размер текста (от 1 до 10): <%= Html.TextBox("txtDlgTagSize", string.Empty, new { style = "width:15px" })%>
            <%= Html.TextBox("txtDlgItemId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtDlgCountryId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtDlgItemType", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtDlgCurrentItemId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <br /><br />
            <input type="submit" value="Сохранить" id="btnSave" name="btnEditItem" value="edititem" />
        <% } %>
    </div>
</asp:Content>

