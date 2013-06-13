<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Словари: Редактирование стран
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#hrefAddItem").click(function (e) {
                $('#txtItemId').val("null");
                $('#txtItemValue').val("");
                $('#txtItemType').val("<%= ViewData["DictionaryItemType"] %>");
                $("#hrefRegionEdit").hide();
                $('#dialog-edititem').dialog('open');
            });

            $(".img-edit").click(function (e) {
                var itemId = $(this).attr("id");
                var itemValue = $(this).attr("name");
                $("#hrefRegionEdit").show();
                var regionEditUrl = $("#hrefRegionEdit").attr('href') + itemId;
                $("#hrefRegionEdit").attr('href', regionEditUrl);
                $('#txtItemValue').val(itemValue);
                $('#txtItemId').val(itemId);
                $('#txtItemType').val("<%= ViewData["DictionaryItemType"] %>");
                $('#dialog-edititem').dialog('open');
            });

            $(".img-delete").click(function (e) {
                if (confirm("Удалить? Внимание! Все объекты, связанные с этим будут удалены!")) {
                    var itemIdImgAlt = $(this).attr("alt");
                    var itemId = itemIdImgAlt.substring(8, itemIdImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/Admin/DeleteDictionaryItem",
                        data: "parameters=" + itemId + "|" + "<%= ViewData["DictionaryItemType"] %>",
                        success: function (msg) {
                            if (msg == '"error"') {
                                msg = msg + " - произошла ошибка. Попробуйте снова.";
                            }
                            location.reload();
                        }
                    });
                }
            });

            $("#dialog-edititem").dialog({
                autoOpen: false,
                height: 300,
                width: 400,
                modal: true,
                buttons: {
                    'Закрыть': function () {
                        $(this).dialog('close');
                        return false;
                    }
                },
                close: function () {
                    $('#txtItemId').val("");
                    $('#txtItemValue').val("");
                    location.reload();
                }
            });
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../Admin/DictionaryList">Словари</a>
    <br />
    <h2>Словари: Редактирование стран</h2>
    (Для добавления/изменение Регионов и Городов, необходимо нажать кнопку 
    <img style="vertical-align:middle" src="../../Content/images/grid-edit.gif"> напротив Страны)
    <br />
    <img src="../../Content/images/grid-add.png" alt="" /><a href="#" id="hrefAddItem">Добавить</a>
    <%= ViewData["GridCountryList"] %>
    <div id="dialog-edititem">
        <h2>Добавить страну</h2>
        <% using (Html.BeginForm("EditDictionaryItem", "Admin", FormMethod.Post, new { autocomplete = "off" })) { %>
            <%= Html.TextBox("txtItemValue", string.Empty, new { style = "width:100px" })%>
            <%= Html.TextBox("txtItemId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtItemType", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <input type="submit" value="Сохранить" id="btnSave" name="btnEditItem" value="edititem" />
        <% } %>
        <br />
        <a href="../../Admin/RegionListEdit?countryId=" id="hrefRegionEdit">
            <img style="vertical-align:middle" src="../../Content/images/grid-edit.gif"> Список регионов страны
        </a>
    </div>
</asp:Content>
