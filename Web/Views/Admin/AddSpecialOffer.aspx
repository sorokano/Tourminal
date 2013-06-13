<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Добавить спец.предложение
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            populateComboboxNameId('ddlCountry', 'http://tourminal.ru/ElcondorWCF.svc/GetCountryListJS', false);
        });
//        window.onload = function () {
//            var sBasePath = '<%= ResolveUrl("~/Scripts/fck/") %>';
//            var oFCKeditor = new FCKeditor('content');
//            oFCKeditor.Config.Enabled = true;
//            oFCKeditor.Config.UserFilesPath = '/Content/UserImages';
//            oFCKeditor.Config.UserFilesAbsolutePath = '/Content/UserImages';

//            oFCKeditor.Height = '600';
//            oFCKeditor.BasePath = sBasePath;
//            oFCKeditor.ReplaceTextarea();
//        }
    </script>
    <a href="/Admin/Index">Главная</a> > <a href="/Admin/SpecialOffers">Список спец.предложений</a>
    <h2>Добавить спец.предложение</h2>
    <%= Html.ValidationSummary("Не удалось сохранить. Проверьте данные и попробуйте снова.") %>
    <br />
    <form method="post" action="../../Admin/AddSpecialOffer">
    <table><tr><td>Страна:</td></tr><tr><td><%= Html.DropDownList("ddlCountry", new List<SelectListItem>())%> </td></tr></table>
    <table><tr><td><span style="color:red">*</span> Название</td><td><%= Html.TextBox("txtTitle", string.Empty, new { style = "width:500px" })%></td></tr></table>
    <table><tr><td><span style="color:red">*</span> Краткое описание</td><td><%= Html.TextBox("txtShortDescription", string.Empty, new { style = "width:500px" })%></td></tr></table>
    <table><tr><td><span style="color:red">*</span> Цена</td><td><%= Html.TextBox("txtPrice", string.Empty, new { style = "width:200px" })%></td></tr></table>
    <table><tr><td><span style="color:red">*</span> Ссылка на страницу</td><td><%= Html.TextBox("txtLinkUrl", string.Empty, new { style = "width:500px" })%></td></tr></table>
    <table><tr><td>Главное(отображать в шапке):</td><td><%= Html.CheckBox("chkIsOnTop", false)%></td></tr></table>
    <table><tr><td>Является спецпредложением:</td><td><%= Html.CheckBox("chkIsSpecOffer", false)%></td></tr></table>
    <table><tr><td>Является Готовым Туром:</td><td><%= Html.CheckBox("chkIsReadyTour", false)%></td></tr></table>
    <%--<%= Html.TextArea("content", string.Empty, 5, 1, new { name = "content" })%>--%>
     <input type="submit" value="Добавить спец.предложение" />
    </form>
    <br /><br />
    <a href="/Admin/Index">Главная</a> > <a href="/Admin/SpecialOffers">Список спец.предложений</a>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
</asp:Content>
