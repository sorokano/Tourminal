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
                $("#hrefCityEdit").attr('href', "../../Admin/CityEdit?id=" + itemId);
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
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../Admin/DictionaryList">Словари</a> > <a href="../../Admin/CountryListEdit">Список всех стран</a> > <a href="../../Admin/RegionListEdit?countryId=<%= ViewData["CountryId"] %>">Редактировать регион <%=ViewData["RegionName"] %></a>
    <h2>
        Словари: Регион <a href="../../Admin/RegionListEdit?countryId=<%= ViewData["CountryId"] %>"><%= ViewData["RegionName"] %>, <%= ViewData["CountryName"] %></a>: Редактирование городов
        <span style="font-size: 12px">(<a href="../../Admin/RegionEdit?id=<%= ViewData["RegionId"] %>">Редактировать описание региона <%= ViewData["RegionName"]%></a>)</span>
    </h2>
    (Для редактирования описания и фото Города, необходимо нажать кнопку 
    <img style="vertical-align:middle" src="../../Content/images/grid-edit.gif"> напротив Названия и выбрать "Редактировать город: Описание, фото")
    <br />
    Внимание! Для Столицы страны должен быть создан СВОЙ одноименный Регион! (напр. КАРАКАС: Каракас)
    <br />
    <img src="../../Content/images/grid-add.png" alt="" /><a href="#" id="hrefAddItem">Добавить</a>
    <%= ViewData["GridList"] %>
    <div id="dialog-edititem">
        <% using (Html.BeginForm("EditDictionaryItem", "Admin", FormMethod.Post, new { autocomplete = "off" })) { %>
            <%= Html.TextBox("txtItemValue", string.Empty, new { style = "width:100px" })%>
            <%= Html.TextBox("txtItemId", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtParentItemId", ViewData["RegionId"], new { style = "visibility:hidden; width:50px" })%>
            <%= Html.TextBox("txtItemType", string.Empty, new { style = "visibility:hidden; width:50px" })%>
            <input type="submit" value="Сохранить" id="btnSave" name="btnEditItem" value="edititem" />
        <% } %>
        <br />
        <a href="#" id="hrefCityEdit"><img style="vertical-align:middle" src="../../Content/images/grid-edit.gif"> Редактировать город: Описание, фото</a>
    </div>
</asp:Content>
