<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Словари: Редактирование регионов страны <%= ViewData["CountryName"]%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#hrefAddItem").click(function (e) {
                $('#txtItemId').val("null");
                $('#txtItemValue').val("");
                $('#txtItemType').val("<%= ViewData["DictionaryItemType"] %>");
                $("#hrefCityEdit").hide();
                $('#dialog-edititem').dialog('open');
            });

            $(".img-edit").click(function (e) {
                var itemId = $(this).attr("id");
                var itemValue = $(this).attr("name");
                $("#hrefCityEdit").show();
                $("#hrefCityEdit").attr('href', "../../Admin/CityListEdit?regionId=" + itemId);
                $('#txtItemValue').val(itemValue);
                $('#txtItemId').val(itemId);
                $('#txtItemType').val("<%= ViewData["DictionaryItemType"] %>");
                $('#dialog-edititem').dialog('open');
            });

            $(".img-delete").click(function (e) {
                if (confirm("Удалить? Внимание! Все объекты (города, фото, статьи, и тд), связанные с этим будут удалены!")) {
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
    <a href="/Admin/Index">Главное меню</a> > <a href="/Admin/DictionaryList">Словари</a> > <a href="../../Admin/CountryListEdit">Список всех стран</a>
    <br />
    <h2>
        Словари: Редактирование регионов страны <a href="../../Admin/CountryListEdit"><%= ViewData["CountryName"] %> </a>
        <span style="font-size: 12px">(<a href="../../Admin/CountryEdit?id=<%= ViewData["CountryId"] %>">Редактировать описание страны <%= ViewData["CountryName"] %></a>)</span>
    </h2>
    (Для добавления/изменение Городов, необходимо нажать кнопку 
    <img style="vertical-align:middle" src="../../Content/images/grid-edit.gif"> напротив Региона и выбрать "Список городов региона")
    <br />
    Внимание! Для Столицы страны должен быть создан СВОЙ одноименный Регион! (напр. КАРАКАС: Каракас)
    <br />
    <img src="../../Content/images/grid-add.png" alt="" /><a href="#" id="hrefAddItem">Добавить</a>
    <%= ViewData["GridList"] %>
    <div id="dialog-edititem">
        <% using (Html.BeginForm("EditDictionaryItem", "Admin", FormMethod.Post, new { autocomplete = "off" })) { %>
            <%= Html.TextBox("txtItemValue", string.Empty, new { style = "width:100px" })%>
            <%= Html.TextBox("txtItemId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtParentItemId", ViewData["CountryId"], new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtItemType", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <input type="submit" value="Сохранить" id="btnSave" name="btnEditItem" value="edititem" />
        <% } %>
        <br />
        <a href="#" id="hrefCityEdit"><img style="vertical-align:middle" src="../../Content/images/grid-edit.gif"> Список городов региона</a>
    </div>
</asp:Content>
