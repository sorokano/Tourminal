<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Администрирование: Чартеры: Список рейсов для <%= ViewData["RouteName"]%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
     <script type="text/javascript">
        $(document).ready(function () {   
            $(".img-delete").click(function (e) {
                if (confirm("Удалить? Внимание! После удаления данные не могут быть восстановлены.")) {
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
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../AviaAdmin/RouteList">Список Направлений</a>
    
    <h2>Чартеры: Список рейсов для <%= ViewData["RouteName"] %></h2>
    
    <table>
        <tr>
            <td><img src="../../Content/images/grid-add.png" alt="" /><a href="../../AviaAdmin/AddFlight?isBack=False&routeid=<%= ViewData["RouteId"] %>" id="hrefAddItemThere">Добавить Рейс </a></td>
        </tr>
        <tr>
            <td>
                <%= ViewData["GridFlights"]%>        
            </td>
        </tr>
    </table>
    
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
