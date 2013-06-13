<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Редактировать спец.предложение
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("select#ddlCountry").val(<%= ViewData["CountryId"].ToString() %>);
        });
    </script>
    <a href="/Admin/Index">Главная</a> > <a href="/Admin/SpecialOffers">Список спец.предложений</a>
    <h2>Редактировать спец.предложение</h2>
    <%= Html.ValidationSummary("Не удалось сохранить. Проверьте данные и попробуйте снова.") %>
    <br />
    <form method="post" action="../../Admin/EditSpecialOffer">
    <%= Html.TextBox("txtId", ViewData["SpecialOfferId"], new { style = "visibility:hidden; width:50px" })%>
    <table><tr><td>Страна:</td></tr><tr><td><%= Html.DropDownList("ddlCountry", (IEnumerable<SelectListItem>)ViewData["ddlCountry"])%> </td></tr></table>
    <table><tr><td><span style="color:red">*</span> Название</td><td><%= Html.TextBox("txtTitle", ViewData["Title"], new { style = "width:500px" })%></td></tr></table>
    <table><tr><td><span style="color:red">*</span> Краткое описание</td><td><%= Html.TextBox("txtShortDescription", ViewData["ShortDescription"], new { style = "width:500px" })%></td></tr></table>
    <table><tr><td><span style="color:red">*</span> Цена</td><td><%= Html.TextBox("txtPrice", ViewData["Price"], new { style = "width:200px" })%></td></tr></table>
    <table><tr><td><span style="color:red">*</span> Порядковый номер</td><td><%= Html.TextBox("txtOrder", ViewData["txtOrder"], new { style = "width:200px" })%></td></tr></table>
    <table><tr><td><span style="color:red">*</span> Ссылка на страницу</td><td><%= Html.TextBox("txtLinkUrl", ViewData["LinkUrl"], new { style = "width:500px" })%></td></tr></table>
    <table><tr><td>Главное(отображать в шапке):</td><td><%= Html.CheckBox("chkIsOnTop", Boolean.Parse(ViewData["IsOnTop"].ToString()))%></td></tr></table>
    <table><tr><td>Является спецпредложением:</td><td><%= Html.CheckBox("chkIsSpecOffer", Boolean.Parse(ViewData["IsSpecOffer"].ToString()))%></td></tr></table>
    <table><tr><td>Является Готовым Туром:</td><td><%= Html.CheckBox("chkIsReadyTour", Boolean.Parse(ViewData["IsReadyTour"].ToString()))%></td></tr></table>
    <%--<%= Html.TextArea("content", string.Empty, 5, 1, new { name = "content" })%>--%>
     <input type="submit" value="Сохранить спец.предложение" />
    </form>
    <div style="position: relative; float: right; width: 400px; height: 110px; margin-top: -100px;" id="divPhotoArea">
        <% if (ElcondorBiz.BizSpecialOffer.GetImage(int.Parse(ViewData["SpecialOfferId"].ToString())) != null) { %>
            Основное фото: <img src="/Content/UserImages/specialoffer_th_<%=ViewData["SpecialOfferId"].ToString()%>.jpg" alt="" style="width: 75px;vertical-align:middle;" />
        <% } %>
        <br />
        <a href="/Admin/EditSpecialOfferPhoto?id=<%= ViewData["SpecialOfferId"].ToString() %>">Редактировать фото</a>
    </div>
    <br /><br />
    <a href="/Admin/Index">Главная</a> > <a href="/Admin/SpecialOffers">Список спец.предложений</a>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
