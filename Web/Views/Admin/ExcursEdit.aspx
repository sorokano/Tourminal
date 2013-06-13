<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Редактирование экскурсии "<%= ViewData["TourName"] + "\", " + ViewData["RegionName"] + " (" + ViewData["CountryName"] + ")" %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        window.onload = function () {
            var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
            var oFCKeditor = new FCKeditor('txtDescription');
            oFCKeditor.Config.Enabled = true;
            oFCKeditor.Config.UserFilesPath = '/Content/UserImages';
            oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';
            oFCKeditor.ToolbarSet = 'DefaultNoSave';

            oFCKeditor.Height = '500';
            oFCKeditor.BasePath = sBasePath;
            oFCKeditor.ReplaceTextarea();

            var sBasePath2 = '<%= ResolveUrl("~/Scripts/fck/") %>';
            var oFCKeditor2 = new FCKeditor('txtProgram');
            oFCKeditor2.Config.Enabled = true;
            oFCKeditor2.Config.UserFilesPath = '/Content/UserImages';
            oFCKeditor2.Config.UserFilesAbsolutePath = '/Content/UserImages';
            oFCKeditor2.ToolbarSet = 'DefaultNoSave';

            oFCKeditor2.Height = '500';
            oFCKeditor2.BasePath = sBasePath;
            oFCKeditor2.ReplaceTextarea();
        }

        $(document).ready(function () {
            $("#btncancel").click(function (e) {
                location.href = '../../Admin/ExcursList';
            });
        });
    </script>
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../Admin/ExcursList">Вернуться к списку экскурсий</a>
    <br /><br />
    <h2>Редактирование экскурсии "<%= ViewData["TourName"] + "\", " + ViewData["TourRegionNames"] + " (" + ViewData["CountryName"] + ")"%></h2>
    <%= Html.ValidationSummary("Не удалось сохранить. Проверьте данные и попробуйте снова.") %>

    <% using (Html.BeginForm("ExcursEdit", "Admin", FormMethod.Post)) { %>
    <input type="text" visible="false" style="display: none;" id="txtId" name="txtId" value="<%= ViewData["TourId"] %>" />
    <table>
        <tr>
            <td colspan="3">
                <table><tr><td><span style="color:red">*</span> Название</td><td><%= Html.TextBox("txtName", ViewData["TourName"], new { style = "width:500px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <table><tr><td><span style="color:red">*</span> Цена</td><td><%= Html.TextBox("txtPrice", ViewData["TourPrice"] != null ? ViewData["TourPrice"].ToString() : string.Empty
                                                                                                , new { style = "width:500px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <table><tr><td>Кол-во дней:</td><td><%= Html.TextBox("txtTourDays", ViewData["TourDays"] != null ? ViewData["TourDays"].ToString() : string.Empty
                                                                                                , new { style = "width:500px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <table><tr><td>Кол-во часов:</td><td><%= Html.TextBox("txtTourHours", ViewData["TourHours"] != null ? ViewData["TourHours"].ToString() : string.Empty
                                                                                                , new { style = "width:500px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <table><tr><td>Популярность:</td><td><%= Html.TextBox("txtTourPopularity", ViewData["TourPopularity"] != null ? ViewData["TourPopularity"].ToString() : string.Empty
                                                                                                , new { style = "width:500px" })%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <table><tr><td>СПЕЦПРЕДЛОЖЕНИЕ:</td><td><%= Html.CheckBox("chkIsSpecialOffer", bool.Parse(ViewData["TourIsSpecialOffer"].ToString()))%></td></tr></table>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <table><td>ГОТОВЫЙ ТУР:</td><td><%= Html.CheckBox("chkIsReadyTour", Boolean.Parse(ViewData["IsReadyTour"].ToString()))%></td></table>
            </td>
        </tr>    
        <tr>
            <td colspan="3">
                <table><tr><td>КОРПОРАТИВНЫЙ ТУР:</td><td><%= Html.CheckBox("chkIsCorpTour", Boolean.Parse(ViewData["IsCorpTour"].ToString()))%></td></tr></table>
            </td>
        </tr> 
    </table>
    <div style="position: relative; float: right; width: 400px; height: 110px; margin-top: -100px;" id="divPhotoArea">
        <% if (ElcondorBiz.BizTour.GetImage(int.Parse(ViewData["TourId"].ToString())) != null) { %>
            Фото (обложка): <img src="/Content/UserImages/tour_th_<%=ViewData["TourId"].ToString()%>.jpg" alt="" style="width: 75px;vertical-align:middle;" />
        <% } %>
        <br />
        <a href="/Admin/EditExcursPhoto?id=<%= ViewData["TourId"].ToString() %>">Редактировать фото</a>
    </div>
    Описание маршрута:
    <br />
    <%= Html.TextArea("txtDescription", ViewData["TourDescription"] == null ? string.Empty : ViewData["TourDescription"].ToString(), 3, 1, new { name = "txtDescription" })%>
    <br /><br />
    Программа экскурсии:
    <br /><br />
    <%= Html.TextArea("txtProgram", ViewData["TourProgram"] == null ? string.Empty : ViewData["TourProgram"].ToString(), 3, 1, new { name = "txtProgram" })%>
    
    <p>
        <input type="submit" value="Сохранить" />
        <input type="button" value="Отмена" id="btncancel" />
    </p> 
    <% } %>

    <br /><br />
    <a href="../../Admin/Index">Главное меню</a> > <a href="../../Admin/ExcursList">Вернуться к списку экскурсий</a>
</asp:Content>
