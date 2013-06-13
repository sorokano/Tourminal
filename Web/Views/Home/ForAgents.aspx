<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Page.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - туристическая компания: Для агентов
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
	    $(document).ready(function () {
            selectTopMenuItem(<%= Elcondor.UI.Utilities.Constants.PageForAgentsId %>);
        });
    </script>
    <span class="mainTitle">
        <h1>Для агентов</h1>
    </span>
    <p>
        <%= ViewData["PageContent"] %>
    </p>
</asp:Content>
