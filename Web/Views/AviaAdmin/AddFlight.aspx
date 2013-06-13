<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Добавление нового рейса <%--<%=ViewData["IsBackText"] %>--%>для направления <%= ViewData["RouteName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#flightdateThere").datepicker($.datepicker.regional['ru']);
            $("#flightdateBack").datepicker($.datepicker.regional['ru']);

            $.getJSON('http://tourminal.ru/ElcondorWCF.svc/GetFlightOWStatusListJS?method=?&', function (response) {
                var result = "";
                var items = eval('(' + response + ')');
                for (var i = 0; i < items.length; i++) {
                    result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
                }
                $("select#ddlOWType").html(result);
            });
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../AviaAdmin/RouteList">Список Направлений</a> > <a href="../../AviaAdmin/FlightList?id=<%= ViewData["RouteId"] %>">Список Рейсов <%= ViewData["RouteName"] %></a>
    <h2>Добавление нового рейса <u><%=ViewData["IsBackText"] %></u> для направления <%= ViewData["RouteName"] %></h2>
    <% using (Html.BeginForm("AddFlight", "AviaAdmin", FormMethod.Post)) { %>
        <%: Html.ValidationSummary(false, "Не удалось сохранить рейс. Исправьте ошибки и повторите попытку.") %>
        <input type="text" visible="false" style="display: none;" id="txtRouteId" name="txtRouteId" value="<%= ViewData["RouteId"] %>" />
         <%= Html.CheckBox("chkIsBack", bool.Parse(ViewData["IsBack"].ToString()), new { style = "visibility:hidden" })%>
    <table>
        <tr>
            <td>
                Направление:
            </td>
            <td>
                <%= Html.DropDownList("ddlOWType", new List<SelectListItem>())%> 
            </td>
        </tr>
        <tr>
            <td>
                Дата вылета:
            </td>
            <td>
                <div class="ui-icon ui-icon-calendar" style="display:inline-block;"></div><%= Html.TextBox("flightdateThere", string.Empty, new { style = "width:100px" })%>
            </td>
        </tr>        
        <tr>
            <td>
                Номер рейса вылета:
            </td>
            <td>
                <%= Html.TextBox("txtFlightNumberThere", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>        
        <tr>
            <td>
                Расписание вылета:
            </td>
            <td>
                <%= Html.TextBox("txtFlightTimeThere", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td colspan=2><hr /></td>
        </tr>
        <tr>
            <td>
                Дата прилета обратно:
            </td>
            <td>
                <div class="ui-icon ui-icon-calendar" style="display:inline-block;"></div><%= Html.TextBox("flightdateBack", string.Empty, new { style = "width:100px" })%>
            </td>
        </tr>
        <tr>
            <td>
                Название компании:
            </td>
            <td>
                <%= Html.TextBox("txtCompanyName", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                Номер рейса прилета:
            </td>
            <td>
                <%= Html.TextBox("txtFlightNumberBack", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                Расписание прилета:
            </td>
            <td>
                <%= Html.TextBox("txtFlightTimeBack", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td colspan=2><hr /></td>
        </tr>
        <tr>
            <td>
                Длительность пребывания:
            </td>
            <td>
                <%= Html.TextBox("txtLength", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                Есть в наличии:
            </td>
            <td>
                <%= Html.CheckBox("chkIsInStock", true)%>
            </td>
        </tr>
        <tr>
            <td>
                Цена:
            </td>
            <td>
                <%= Html.TextBox("txtPrice", string.Empty, new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                Лучшее предложение:
            </td>
            <td>
                <%= Html.CheckBox("chkIsHot", true)%>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <p>
                    <input type="submit" value="Сохранить" />
                </p>             
            </td>
        </tr>
    </table>
    <%} %>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
