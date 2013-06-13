<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Admin.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Словари
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btndictlist").addClass("selected");
        });
    </script>
    <h2>Словари</h2>
    <br />
    <ul>
        <li><a href="/Admin/CountryListEdit">Страны, города, регионы</a></li>
        <li><a href="/Admin/SightseeingTypeList">Типы достопримечательностей</a></li>
        <br />
        <hr />
    </ul>
    <br /><br />
    <a href="/Admin/Index">Вернуться назад</a>
</asp:Content>
