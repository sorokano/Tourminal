<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Администрирование: Чартеры: Список направлений
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#hrefAddItem").click(function (e) {
                $('#txtItemId').val("null");
                $('#txtItemValue').val("");
                $('#txtItemType').val("<%= ViewData["DictionaryItemType"] %>");
                $("#hrefRouteEdit").hide();
                $('#dialog-edititem').dialog('open');
            });

            $(".img-edit").click(function (e) {
                var itemId = $(this).attr("id");
                var itemValue = $(this).attr("name");
                $("#hrefRouteEdit").show();
                $("#hrefRouteEdit").attr('href', "../../AviaAdmin/FlightList?id=" + itemId);
                if (itemValue.substring(0, 3) == "<b>") {
                    var value = itemValue.substring(12, itemValue.length - 4);
                    $('#txtItemValue').val(value);
                } else {
                    $('#txtItemValue').val(itemValue);
                }
                $('#txtItemId').val(itemId);
                $('#txtItemType').val("<%= ViewData["DictionaryItemType"] %>");
                $('#dialog-edititem').dialog('open');
            });

            $(".img-delete").click(function (e) {
                if (confirm("Удалить? Внимание! Все объекты (фото, статьи и тд), связанные с этим будут удалены!")) {
                    var itemIdImgAlt = $(this).attr("alt");
                    var itemId = itemIdImgAlt.substring(8, itemIdImgAlt.length);
                    $.ajax({
                        type: "POST",
                        url: "/AviaAdmin/DeleteDictionaryItem",
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
    <a href="../../Admin/Index">Главное меню</a>
    <h2>Чартеры: Список направлений</h2>
    <img src="../../Content/images/grid-add.png" alt="" /><a href="#" id="hrefAddItem">Добавить</a>
    <%= ViewData["GridDictionary"]%>

    <div id="dialog-edititem">
        <% using (Html.BeginForm("EditDictionaryItem", "AviaAdmin", FormMethod.Post, new { autocomplete = "off" })) { %>
            Направление(напр. Москва-Бангкок-Москва): <%= Html.TextBox("txtItemValue", string.Empty, new { style = "width:250px" })%>
            <%= Html.TextBox("txtItemId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtParentItemId", ViewData["RegionId"], new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtItemType", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <input type="submit" value="Сохранить" id="btnSave" name="btnEditItem" value="edititem" />
        <% } %>
        <br />
        <a href="#" id="hrefRouteEdit"><img style="vertical-align:middle" src="../../Content/images/grid-edit.gif"> Редактировать рейсы: Даты, цены</a>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
