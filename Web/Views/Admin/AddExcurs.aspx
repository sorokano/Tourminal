<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Добавление новой экскурсии
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
            $(".spanDistrict").hide();

            $("#btncancel").click(function (e) {
                location.href = '/Admin/ExcursList';
            });

            populateComboboxNameId('ddlCountry', 'http://tourminal.ru/ElcondorWCF.svc/GetCountryListJS', true);
            var paramDistr = "countryId=" + $("select#ddlCountry").val();
            populateComboboxNameId('ddlDistrict', 'http://tourminal.ru/ElcondorWCF.svc/GetDistrictListJS', true, paramDistr);
            $.getJSON('http://tourminal.ru/ElcondorWCF.svc/GetExcursTypeListJS?method=?&', function (response) {
                var result = "";
                var items = eval('(' + response + ')');
                for (var i = 0; i < items.length; i++) {
                    result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
                }
            });

            $("#ddlCountry").change(function (e) {
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
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../Admin/ExcursList">Вернуться к списку экскурсий</a>
    <h2>Добавление новой экскурсии</h2>
    <%= Html.ValidationSummary("Не удалось сохранить. Проверьте данные и попробуйте снова.") %>
    <% using (Html.BeginForm("AddExcurs", "Admin", FormMethod.Post)) { %>
    <table>
        <tr>
            <td>
                <table><tr><td>Страна:</td></tr><tr><td><%= Html.DropDownList("ddlCountry", (IEnumerable<SelectListItem>)ViewData["ddlCountry"])%> </td></tr></table>
            </td>    
            <td>
                <span class="spanDistrict">
                    <table>
                        <tr><td>Регион:</td></tr>
                        <tr>
                            <td>
                                <div class="holder">
                                    <%= Html.ListBox("ddlDistrict", (IEnumerable<SelectListItem>)ViewData["ddlDistrict"] as MultiSelectList)%> 
                                    <a href="#" id="add">добавить >></a>
                                </div>
                                <div class="holder">
                                    <%= Html.ListBox("ddlDistrict2", new MultiSelectList(new List<SelectListItem>()) as MultiSelectList)%>
                                    <a href="#" id="remove"><< удалить </a>
                                </div>
                            </td>
                        </tr>
                    </table>
                </span>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <table><td><span style="color:red">*</span> Название</td><td><%= Html.TextBox("txtExcursName", ViewData["Name"], new { style = "width:500px" })%></td></table>
            </td>
        </tr>
    </table>
    <div style="position: relative; float: right; width: 400px; height: 110px; margin-top: -100px;color:#333333;" id="divPhotoAreaNotice">
        Фотографию можно добавлять только после создания экскурсии (кнопка "Добавить экскурсию").
    </div>
    Содержание статьи:
    <br />
    <%= Html.TextArea("content", ViewData["Description"] == null ? string.Empty : ViewData["Description"].ToString(), 3, 1, new { name = "content" })%>
    <p>
        <input type="submit" value="Добавить экскурсию" />
        <input type="button" value="Отмена" id="btncancel" />
    </p> 
    <% } %>
    <br /><br />
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../Admin/ExcursList">Вернуться к списку экскурсий</a>
</asp:Content>