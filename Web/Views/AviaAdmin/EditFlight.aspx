<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Администрирование: Чартеры: Редактирование рейса <%= ViewData["FlightNumber"] %> <%= ViewData["FlightDate"]%> для <%= ViewData["RouteName"]%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#flightdateThere").datepicker($.datepicker.regional['ru']);
            $("#flightdateBack").datepicker($.datepicker.regional['ru']);
            var OWstatus = '<%= ViewData["OWTypeId"] %>';
            $.getJSON('http://tourminal.ru/ElcondorWCF.svc/GetFlightOWStatusListJS?method=?&', function (response) {
                var result = "";
                var items = eval('(' + response + ')');
                for (var i = 0; i < items.length; i++) {
                    result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
                }
                $("select#ddlOWType").html(result);
                $("select#ddlOWType").val(OWstatus);
            });
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../AviaAdmin/RouteList">Список Направлений</a> > <a href="../../AviaAdmin/FlightList?id=<%= ViewData["RouteId"] %>">Список Рейсов <%= ViewData["RouteName"] %></a>
    
    <h2>Редактирование рейса <%= ViewData["FlightNumber"] %> <%= ViewData["FlightDate"]%> для <%= ViewData["RouteName"]%></h2>
    Внимание! Для переноса текста в итоговой таблице на другую строку, необходимо вставить сочетание "<b> <<span class="keyword"></span>BR <span class="keyword"></span> /> </b>" - символ новой строки.
    <br />Пример: " FV 6701<<span class="keyword"></span>BR <span class="keyword"></span> />(Boeing 767) "
    <% using (Html.BeginForm("EditFlight", "AviaAdmin", FormMethod.Post)) { %>
        <%: Html.ValidationSummary(false, "Не удалось сохранить рейс. Исправьте ошибки и повторите попытку.") %>
        <input type="text" visible="false" style="display: none;" id="Text1" name="txtId" value="<%= ViewData["FlightId"] %>" />
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
                <div class="ui-icon ui-icon-calendar" style="display:inline-block;"></div><%= Html.TextBox("flightdateThere", ViewData["FlightDateThere"], new { style = "width:100px" })%>
            </td>
        </tr>        
        <tr>
            <td>
                Номер рейса вылета:
            </td>
            <td>
                <%= Html.TextBox("txtFlightNumberThere", ViewData["FlightNumberThere"], new { style = "width:350px" })%>
            </td>
        </tr>        
        <tr>
            <td>
                Расписание вылета:
            </td>
            <td>
                <%= Html.TextBox("txtFlightTimeThere", ViewData["FlightTimeThere"], new { style = "width:350px" })%>
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
                <div class="ui-icon ui-icon-calendar" style="display:inline-block;"></div><%= Html.TextBox("flightdateBack", ViewData["FlightDateBack"], new { style = "width:100px" })%>
            </td>
        </tr>
        <tr>
            <td>
                Название компании:
            </td>
            <td>
                <%= Html.TextBox("txtCompanyName", ViewData["FlightCompanyName"], new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                Номер рейса прилета:
            </td>
            <td>
                <%= Html.TextBox("txtFlightNumberBack", ViewData["FlightNumberBack"], new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                Расписание прилета:
            </td>
            <td>
                <%= Html.TextBox("txtFlightTimeBack", ViewData["FlightTimeBack"], new { style = "width:350px" })%>
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
                <%= Html.TextBox("txtLength", ViewData["FlightLength"], new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                Есть в наличии:
            </td>
            <td>
                <%= Html.CheckBox("chkIsInStock", ViewData["IsInStock"] != null ? Convert.ToBoolean(ViewData["IsInStock"].ToString()) : false)%>
            </td>
        </tr>
        <tr>
            <td>
                Цена:
            </td>
            <td>
                <%= Html.TextBox("txtPrice", ViewData["FlightPrice"], new { style = "width:350px" })%>
            </td>
        </tr>
        <tr>
            <td>
                Лучшее предложение:
            </td>
            <td>
                <%= Html.CheckBox("chkIsHot", Convert.ToBoolean(ViewData["IsHot"].ToString()))%>
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
