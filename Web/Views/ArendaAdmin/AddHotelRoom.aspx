<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Администрирование: Добавление комнаты отеля
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Администрирование: Добавление комнаты отеля</h2>
    <%= Html.ValidationSummary("Не удалось сохранить изменения. Проверьте данные и попробуйте снова.") %>
    <% using (Html.BeginForm()) { %>
    <table>
        <tr>
            <td>
                <span class="spanDistrict">Тип комнаты: </span>
            </td>
            <td>
                <%= Html.DropDownList("ddlRoomTypeEdt", (IEnumerable<SelectListItem>)ViewData["ddlRoomType"])%> <a href="/ArendaAdmin/RoomTypeList">Редактировать типы комнат</a>
            </td>
        </tr>
        <tr>
            <td>
                Есть кондиционер: 
            </td>
            <td>
                <%= Html.CheckBox("chkIsConditionerEdt", bool.Parse(ViewData["chkIsConditioner"].ToString()))%>
            </td>
        </tr>
        <tr>
            <td>
                Есть кухня: 
            </td>
            <td>
                <%= Html.CheckBox("chkIsKitchenEdt", bool.Parse(ViewData["chkIsKitchen"].ToString()))%>
            </td>
        </tr>
        <tr>
            <td>
                Есть гостиная: 
            </td>
            <td>
                <%= Html.CheckBox("chkIsLivingroomEdt", bool.Parse(ViewData["chkIsLivingroom"].ToString()))%>
            </td>
        </tr>
        <tr>
            <td>
                Есть балкон: 
            </td>
            <td>
                <%= Html.CheckBox("chkIsBalconyEdt", bool.Parse(ViewData["chkIsBalcony"].ToString()))%>
            </td>
        </tr>
        <tr>
            <td>
                Есть шкаф: 
            </td>
            <td>
                <%= Html.CheckBox("chkIsCupboardEdt", bool.Parse(ViewData["chkIsCupboard"].ToString()))%>
            </td>
        </tr>
        <tr>
            <td>
                Есть сейф: 
            </td>
            <td>
                <%= Html.CheckBox("chkIsSafeboxEdt", bool.Parse(ViewData["chkIsSafebox"].ToString()))%>
            </td>
        </tr>
        <tr>
            <td>
                Есть холодильник: 
            </td>
            <td>
                <%= Html.CheckBox("chkIsFridgeEdt", bool.Parse(ViewData["chkIsFridge"].ToString()))%>
            </td>
        </tr>
        <tr>
            <td>
                Есть телевизор: 
            </td>
            <td>
                <%= Html.CheckBox("chkIsTVEdt", bool.Parse(ViewData["chkIsTV"].ToString()))%>
            </td>
        </tr>
        <tr>
            <td>
                Есть горячая вода: 
            </td>
            <td>
                <%= Html.CheckBox("chkIsHotWaterEdt", bool.Parse(ViewData["chkIsHotWater"].ToString()))%>
            </td>
        </tr>
        <tr>
            <td>
                Есть вид на море: 
            </td>
            <td>
                <%= Html.CheckBox("chkIsSeaViewEdt", bool.Parse(ViewData["chkIsSeaView"].ToString()))%>
            </td>
        </tr>
    </table>
    <p>
        <input type="submit" value="Сохранить" />
    </p> 
    <% } %>
</asp:Content>
